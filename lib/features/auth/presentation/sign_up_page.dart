import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/auth/sign_up_request.dart';
import '../application/auth_providers.dart';

class SignUpPage extends ConsumerStatefulWidget {
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _name = TextEditingController();
  final _ruc = TextEditingController();
  final _sector = TextEditingController();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  final _description = TextEditingController();
  BusinessRole _role = BusinessRole.buyer;
  String _fuelType = 'DIESEL';
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    for (final controller in [
      _email,
      _password,
      _name,
      _ruc,
      _sector,
      _address,
      _phone,
      _description,
    ]) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    appBar: AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
        tooltip: 'Volver al inicio de sesión',
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back),
      ),
      title: const Text('Crear cuenta empresarial'),
    ),
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          children: [
            Text(
              'Registra tu empresa',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              'La cuenta y su empresa se crean juntas. El RUC no puede estar registrado.',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<BusinessRole>(
              initialValue: _role,
              decoration: const InputDecoration(
                labelText: 'Tipo de cuenta',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(
                  value: BusinessRole.buyer,
                  child: Text('Empresa compradora'),
                ),
                DropdownMenuItem(
                  value: BusinessRole.provider,
                  child: Text('Empresa proveedora'),
                ),
              ],
              onChanged: _loading
                  ? null
                  : (value) => setState(() => _role = value ?? _role),
            ),
            const SizedBox(height: 14),
            _field(
              _email,
              'Correo corporativo',
              keyboardType: TextInputType.emailAddress,
              validator: _validateEmail,
            ),
            const SizedBox(height: 12),
            _field(
              _password,
              'Contraseña',
              obscure: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 20),
            Text(
              'Datos de la empresa',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            _field(_name, 'Razón social'),
            const SizedBox(height: 12),
            _field(
              _ruc,
              'RUC (11 dígitos)',
              keyboardType: TextInputType.number,
              validator: (value) =>
                  RegExp(r'^\d{11}$').hasMatch(value?.trim() ?? '')
                  ? null
                  : 'Ingresa un RUC de 11 dígitos',
            ),
            if (_role == BusinessRole.buyer) ...[
              const SizedBox(height: 12),
              _field(_sector, 'Sector'),
            ],
            const SizedBox(height: 12),
            _field(_address, 'Dirección'),
            const SizedBox(height: 12),
            _field(_phone, 'Teléfono', keyboardType: TextInputType.phone),
            if (_role == BusinessRole.provider) ...[
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _fuelType,
                decoration: const InputDecoration(
                  labelText: 'Combustible principal',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'DIESEL', child: Text('Diésel')),
                  DropdownMenuItem(value: 'GASOLINE', child: Text('Gasolina')),
                  DropdownMenuItem(value: 'GLP', child: Text('GLP')),
                  DropdownMenuItem(value: 'GNV', child: Text('GNV')),
                ],
                onChanged: _loading
                    ? null
                    : (value) => setState(() => _fuelType = value ?? _fuelType),
              ),
              const SizedBox(height: 12),
              _field(
                _description,
                'Descripción (opcional)',
                maxLines: 3,
                required: false,
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : _submit,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              child: _loading
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Crear cuenta'),
            ),
          ],
        ),
      ),
    ),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType? keyboardType,
    bool obscure = false,
    int maxLines = 1,
    bool required = true,
    String? Function(String?)? validator,
  }) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    obscureText: obscure,
    maxLines: obscure ? 1 : maxLines,
    enabled: !_loading,
    textInputAction: maxLines > 1
        ? TextInputAction.newline
        : TextInputAction.next,
    decoration: InputDecoration(
      labelText: label,
      border: const OutlineInputBorder(),
    ),
    validator:
        validator ??
        (required
            ? (value) => value == null || value.trim().isEmpty
                  ? 'Campo obligatorio'
                  : null
            : null),
  );

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)
        ? null
        : 'Ingresa un correo válido';
  }

  String? _validatePassword(String? value) =>
      (value?.length ?? 0) >= 8 ? null : 'Usa al menos 8 caracteres';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .signUp(
            SignUpRequest(
              username: _email.text.trim(),
              password: _password.text,
              role: _role,
              businessName: _name.text.trim(),
              ruc: _ruc.text.trim(),
              address: _address.text.trim(),
              phone: _phone.text.trim(),
              sector: _role == BusinessRole.buyer ? _sector.text.trim() : null,
              contactEmail: _role == BusinessRole.buyer
                  ? _email.text.trim()
                  : null,
              fuelTypesOffered: [_fuelType],
              description: _description.text.trim(),
            ),
          );
      if (!mounted) return;
      context.go('/login');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cuenta creada. Inicia sesión.')),
      );
    } catch (error) {
      if (mounted)
        setState(() => _error = 'No se pudo crear la cuenta: $error');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
