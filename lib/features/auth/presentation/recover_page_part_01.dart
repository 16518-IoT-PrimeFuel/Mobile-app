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
  bool _loading = false;
  String? _requestError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: _buildFormState(context),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFormState(BuildContext context) {
    final errorText = switch (_stage) {
      _RecoverStage.sent => null,
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
                    if (_stage != _RecoverStage.form) {
                      setState(() {
                        _stage = _RecoverStage.form;
                        _submitted = false;
                      });
                    }
                  },
                ),
                const SizedBox(height: 14),
                if (_stage == _RecoverStage.sent)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: Text(
                      'Si la cuenta existe, recibirás instrucciones en tu correo.',
                      style: TextStyle(color: FullTankColors.blue),
                    ),
                  )
                else
                  const _InboxInfoCard(),
                if (_requestError != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      _requestError!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                const SizedBox(height: 8),
                PrimaryAuthButton(
                  label: _loading ? 'Enviando…' : 'Enviar instrucciones',
                  onPressed: _loading ? null : _submit,
                  loading: _loading,
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

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    setState(() => _submitted = true);
    if (email.isEmpty || !_isValidEmail(email)) return;
    setState(() {
      _loading = true;
      _requestError = null;
    });
    try {
      await ref.read(authRepositoryProvider).requestPasswordReset(email);
      if (mounted) setState(() => _stage = _RecoverStage.sent);
    } catch (_) {
      if (mounted) {
        setState(
          () => _requestError =
              'No se pudo enviar la solicitud. Intenta nuevamente.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  bool _isValidEmail(String value) =>
      RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value);
}
