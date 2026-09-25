part of 'missing_pages.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: _ink,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: _orange,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.local_gas_station, size: 42, color: _ink),
          ),
          const SizedBox(height: 16),
          const Text(
            'FullTank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 43.5,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Energía que mueve tu operación',
            style: TextStyle(color: Color(0xFFCBD5E1), fontSize: 19.575),
          ),
          const SizedBox(height: 32),
          OutlinedButton(
            onPressed: () => context.go('/login'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Color(0xFF64748B)),
              minimumSize: const Size.fromHeight(52),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 20.3),
            ),
            child: const Text('Continuar'),
          ),
        ],
      ),
    ),
  );
}

enum SignupRole { requester, provider }

class SignupPage extends StatefulWidget {
  const SignupPage({required this.role, super.key});
  final SignupRole role;

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _password = TextEditingController();
  bool _accepted = false;
  bool _submitted = false;

  @override
  void dispose() {
    for (final controller in [_company, _name, _email, _phone, _password]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.role == SignupRole.provider
        ? 'Registra tu empresa proveedora'
        : 'Crea tu cuenta empresarial';
    if (_submitted) {
      return MissingPageShell(
        title: 'Solicitud enviada',
        child: _Panel(
          color: _greenSoft,
          child: Column(
            children: [
              const Icon(
                Icons.mark_email_read_outlined,
                color: _green,
                size: 48,
              ),
              const SizedBox(height: 10),
              const Text(
                'Revisaremos tus datos y te avisaremos por correo cuando tu cuenta esté lista.',
                textAlign: TextAlign.center,
                style: TextStyle(color: _ink, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 14),
              _PrimaryButton(
                label: 'Volver al inicio de sesión',
                onPressed: () => context.go('/login'),
              ),
            ],
          ),
        ),
      );
    }
    return MissingPageShell(
      title: title,
      subtitle: 'Completa la información para comenzar',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Panel(
              child: Column(
                children: [
                  _FormField(label: 'Empresa', controller: _company),
                  _FormField(label: 'Nombre completo', controller: _name),
                  _FormField(
                    label: 'Correo corporativo',
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) => value != null && value.contains('@')
                        ? null
                        : 'Ingresa un correo válido',
                  ),
                  _FormField(
                    label: 'Teléfono',
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                  ),
                  _FormField(
                    label: 'Contraseña',
                    controller: _password,
                    obscureText: true,
                    validator: (value) => value != null && value.length >= 8
                        ? null
                        : 'Usa al menos 8 caracteres',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              value: _accepted,
              onChanged: (value) => setState(() => _accepted = value ?? false),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text(
                'Acepto los términos y la política de privacidad',
              ),
            ),
            _PrimaryButton(label: 'Enviar solicitud', onPressed: _submit),
            Center(
              child: TextButton(
                onPressed: () => context.go('/login'),
                child: const Text('Ya tengo una cuenta'),
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () => context.go(
                  widget.role == SignupRole.provider
                      ? '/signup/requester'
                      : '/signup/provider',
                ),
                child: Text(
                  widget.role == SignupRole.provider
                      ? '¿Solicitas combustible? Regístrate como cliente'
                      : '¿Provees combustible? Regístrate como proveedor',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submit() {
    final valid = _formKey.currentState?.validate() ?? false;
    if (!_accepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Acepta los términos para continuar.')),
      );
      return;
    }
    if (valid) {
      setState(() => _submitted = true);
    }
  }
}

class _FormField extends StatelessWidget {
  const _FormField({
    required this.label,
    required this.controller,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
  });
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 11),
    child: TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator:
          validator ??
          (value) => value == null || value.trim().isEmpty
              ? 'Este campo es obligatorio'
              : null,
      decoration: InputDecoration(
        labelText: label,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 15,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    ),
  );
}
