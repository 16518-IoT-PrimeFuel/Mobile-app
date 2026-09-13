import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../application/auth_providers.dart';

class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key, required this.token});

  final String token;

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _error;
  bool _loading = false;
  bool _complete = false;

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Nueva contraseña')),
    body: SafeArea(
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            _complete ? 'Contraseña actualizada' : 'Crea una nueva contraseña',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          if (_complete)
            const Text('Ya puedes iniciar sesión con tu nueva contraseña.')
          else ...[
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Nueva contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _confirm,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 20),
            FilledButton(
              onPressed: _loading ? null : _submit,
              child: Text(_loading ? 'Guardando…' : 'Actualizar contraseña'),
            ),
          ],
          if (_complete)
            TextButton(
              onPressed: () => context.go('/login'),
              child: const Text('Volver a iniciar sesión'),
            ),
        ],
      ),
    ),
  );

  Future<void> _submit() async {
    final password = _password.text;
    if (widget.token.isEmpty) {
      setState(() => _error = 'El enlace no es válido o ya venció.');
      return;
    }
    if (password.length < 8 || password != _confirm.text) {
      setState(
        () => _error =
            'Verifica que ambas contraseñas coincidan y tengan 8 caracteres.',
      );
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authRepositoryProvider)
          .resetPassword(widget.token, password);
      if (mounted) setState(() => _complete = true);
    } catch (_) {
      if (mounted)
        setState(() => _error = 'El enlace no es válido o ya venció.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }
}
