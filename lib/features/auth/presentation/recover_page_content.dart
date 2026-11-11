part of 'recover_page.dart';

class RecoverPage extends ConsumerStatefulWidget {
  const RecoverPage({super.key});

  @override
  ConsumerState<RecoverPage> createState() => _RecoverPageState();
}

class _RecoverPageState extends ConsumerState<RecoverPage> {
  final _emailController = TextEditingController();
  _RecoverStage _stage = _RecoverStage.form;
  bool _submitted = false;
  bool _sending = false;

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
                child: sent
                    ? _buildSentState(context)
                    : _buildFormState(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    final errorText = switch (_stage) {
      _RecoverStage.failed => 'No pudimos enviar el enlace. Intenta de nuevo.',
      _ =>
        !_submitted
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
                    color: FullTankColors.text,
                    fontSize: 40.6,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.7,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Ingresa tu email corporativo para recibir instrucciones de recuperación.',
                  style: TextStyle(
                    color: FullTankColors.textSecondary,
                    fontSize: 19.575,
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
                  largeText: true,
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
                  onPressed: _sending ? null : _submit,
                  largeText: true,
                ),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextButton(
                    onPressed: () => context.pop(),
                    style: TextButton.styleFrom(
                      foregroundColor: FullTankColors.primary,
                      textStyle: const TextStyle(
                        fontSize: 18.85,
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
              color: FullTankColors.text,
              fontSize: 33.35,
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
            largeText: true,
          ),
          TextButton(
            onPressed: _sending ? null : _send,
            style: TextButton.styleFrom(
              foregroundColor: FullTankColors.primary,
              minimumSize: const Size(double.infinity, 44),
              textStyle: const TextStyle(
                fontSize: 17.4,
                fontWeight: FontWeight.w600,
              ),
            ),
            child: const Text('Reenviar enlace'),
          ),
        ],
      ),
    );
  }

  void _submit() {
    final email = _emailController.text.trim();
    setState(() => _submitted = true);
    if (email.isEmpty || !_isValidEmail(email)) return;
    _send();
  }

  /// The API answers 202 whether or not the account exists, so every
  /// completed request shows the sent stage; only transport failures differ.
  Future<void> _send() async {
    setState(() => _sending = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .requestPasswordReset(_emailController.text.trim());
      if (mounted) setState(() => _stage = _RecoverStage.sent);
    } catch (_) {
      if (mounted) {
        setState(() {
          _stage = _RecoverStage.failed;
          _submitted = false;
        });
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
}
