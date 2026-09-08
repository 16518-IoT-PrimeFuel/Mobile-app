part of 'recover_page.dart';

class RecoverPage extends StatefulWidget {
  const RecoverPage({super.key});

  @override
  State<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends State<RecoverPage> {
  final _emailController = TextEditingController();
  _RecoverStage _stage = _RecoverStage.form;
  bool _submitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sent = _stage == _RecoverStage.sent;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: sent ? SystemUiOverlayStyle.dark : SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: sent ? _buildSentState(context) : _buildFormState(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    final errorText = switch (_stage) {
      _RecoverStage.notFound => 'No encontramos ninguna cuenta con este email',
      _ => !_submitted
          ? null
          : _emailController.text.trim().isEmpty
              ? 'Ingresa tu email corporativo'
              : !_isValidEmail(_emailController.text.trim())
                  ? 'Ingresa un email válido'
                  : null,
    };

    return Column(
      children: [
        const _RecoverHero(),
        Transform.translate(
          offset: const Offset(0, -8),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _RecoveryPill(),
                const SizedBox(height: 10),
                const Text(
                  'Recuperar contraseña',
                  style: TextStyle(
                    color: FullTankColors.navy,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tu email corporativo para recibir instrucciones de recuperación.',
                  style: TextStyle(
                    color: FullTankColors.inkMid,
                    fontSize: 13.5,
                    height: 1.55,
                  ),
                ),
                const SizedBox(height: 22),
                AuthTextField(
                  label: 'Email corporativo',
                  controller: _emailController,
                  hintText: 'tu@empresa.com',
                  icon: Icons.mail_outline,
                  keyboardType: TextInputType.emailAddress,
                  errorText: errorText,
                  onChanged: (_) {
                    if (_stage != _RecoverStage.form || _submitted) {
                      setState(() {
                        _stage = _RecoverStage.form;
                        _submitted = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),
                const _InboxInfoCard(),
                const SizedBox(height: 8),
                PrimaryAuthButton(
                  label: 'Enviar enlace de recuperación',
                  onPressed: _submit,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: FullTankColors.blue,
                      textStyle: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    child: const Text('← Volver a iniciar sesión'),
                  ),
                ),
                const SizedBox(height: 4),
                const _SupportCard(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSentState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
      child: Column(
        children: [
          Row(
            children: [
              _LightBackButton(onPressed: () => context.pop()),
              const SizedBox(width: 14),
              Image.asset(
                'assets/fulltank-logo.png',
                height: 22,
                fit: BoxFit.contain,
              ),
            ],
          ),
          const SizedBox(height: 72),
          const _SentEnvelope(),
          const SizedBox(height: 24),
          const Text(
            'Revisa tu bandeja',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: FullTankColors.navy,
              fontSize: 23,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 8),
          _SentCopy(email: _emailController.text.trim()),
          const SizedBox(height: 22),
          _SentEmailCard(email: _emailController.text.trim()),
          const SizedBox(height: 16),
          PrimaryAuthButton(
            label: 'Abrir mi correo',
            onPressed: () {},
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: FullTankColors.blue,
              minimumSize: const Size(double.infinity, 44),
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Reenviar en 60s'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final email = _emailController.text.trim();
    setState(() => _submitted = true);
    if (email.isEmpty || !_isValidEmail(email)) return;

    setState(() {
      _stage = email.toLowerCase() == 'noexiste@empresa.com'
          ? _RecoverStage.notFound
          : _RecoverStage.sent;
    });
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
}

