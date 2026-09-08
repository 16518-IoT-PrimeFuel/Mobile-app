part of 'login_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
  bool _obscurePassword = true;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authControllerProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated && context.mounted) {
        context.go('/home');
      }
    });

    final authState = ref.watch(authControllerProvider);
    final loading = authState.status == AuthStatus.loading;
    final failure = authState.status == AuthStatus.failure
        ? authState.failure
        : null;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  children: [
                    const _HeroHeader(),
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: Container(
                        width: double.infinity,
                        color: Colors.white,
                        padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
                        child: _LoginContent(
                          emailController: _emailController,
                          passwordController: _passwordController,
                          onEmailChanged: (_) => setState(() {}),
                          onPasswordChanged: (_) => setState(() {}),
                          emailError: _emailError,
                          passwordError: _passwordError,
                          failure: failure,
                          loading: loading,
                          rememberMe: _rememberMe,
                          obscurePassword: _obscurePassword,
                          onRememberChanged: (value) => setState(() {
                            _rememberMe = value;
                          }),
                          onTogglePassword: () => setState(() {
                            _obscurePassword = !_obscurePassword;
                          }),
                          onSubmit: loading ? null : _submit,
                          onGuest: loading ? null : _continueAsGuest,
                          onForgot: () => context.push('/recover'),
                          onCreateAccount: () => context.push('/signup'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String? get _emailError {
    if (!_submitted) return null;
    final value = _emailController.text.trim();
    if (value.isEmpty) return 'Ingresa tu email corporativo';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) {
      return 'Ingresa un email válido';
    }
    return null;
  }

  String? get _passwordError {
    if (!_submitted || _passwordController.text.isNotEmpty) return null;
    return 'Este campo es obligatorio';
  }

  Future<void> _submit() async {
    setState(() => _submitted = true);
    if (_emailError != null || _passwordError != null) return;
    await ref
        .read(authControllerProvider.notifier)
        .signIn(
          username: _emailController.text.trim(),
          password: _passwordController.text,
          rememberMe: _rememberMe,
        );
  }

  void _continueAsGuest() {
    ref.read(authControllerProvider.notifier).continueAsGuest();
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/hero-truck.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x551A202C), Color(0xAA1A202C), Colors.white],
                stops: [0, 0.7, 1],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginContent extends StatelessWidget {
  const _LoginContent({
    required this.emailController,
    required this.passwordController,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.emailError,
    required this.passwordError,
    required this.failure,
    required this.loading,
    required this.rememberMe,
    required this.obscurePassword,
    required this.onRememberChanged,
    required this.onTogglePassword,
    required this.onSubmit,
    required this.onGuest,
    required this.onForgot,
    required this.onCreateAccount,
  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final String? emailError;
  final String? passwordError;
  final AuthFailure? failure;
  final bool loading;
  final bool rememberMe;
  final bool obscurePassword;
  final ValueChanged<bool> onRememberChanged;
  final VoidCallback onTogglePassword;
  final VoidCallback? onSubmit;
  final VoidCallback? onGuest;
  final VoidCallback onForgot;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bienvenido de vuelta',
          style: TextStyle(
            color: FullTankColors.navy,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.7,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Accede a tu red de suministro y gestiona operaciones en tiempo real.',
          style: TextStyle(
            color: FullTankColors.inkMid,
            fontSize: 13.5,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 22),
        AuthTextField(
          label: 'Email corporativo',
          controller: emailController,
          hintText: 'tu@empresa.com',
          icon: Icons.mail_outline,
          keyboardType: TextInputType.emailAddress,
          onChanged: onEmailChanged,
          errorText: emailError,
        ),
        const SizedBox(height: 14),
        AuthTextField(
          label: 'Contraseña',
          controller: passwordController,
          hintText: '••••••••',
          icon: Icons.lock_outline,
          obscureText: obscurePassword,
          onToggleObscure: onTogglePassword,
          onChanged: onPasswordChanged,
          errorText: passwordError,
        ),
        if (failure != null) ...[
          const SizedBox(height: 12),
          _FailureBanner(message: failure!.message),
        ],
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _RememberMe(value: rememberMe, onChanged: onRememberChanged),
            TextButton(
              onPressed: onForgot,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 36),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                '¿Olvidaste tu contraseña?',
                style: TextStyle(
                  color: FullTankColors.blue,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        PrimaryAuthButton(
          label: 'Iniciar sesión',
          loading: loading,
          onPressed: onSubmit,
        ),
        const SizedBox(height: 16),
        const _DividerLabel('NUEVO EN FULLTANK'),
        const SizedBox(height: 4),
        SecondaryAuthButton(
          label: 'Crear cuenta empresarial',
          onPressed: onCreateAccount,
        ),
        const SizedBox(height: 10),
        SecondaryAuthButton(
          label: 'Ingresar como invitado',
          onPressed: onGuest,
        ),
        const SizedBox(height: 10),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shield_outlined,
              size: 13,
              color: FullTankColors.inkSoft,
            ),
            SizedBox(width: 6),
            Flexible(
              child: Text(
                'Encriptación de extremo a extremo · SOC 2 Type II',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: FullTankColors.inkSoft,
                  fontSize: 11,
                  letterSpacing: 0.15,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
