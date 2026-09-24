import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/recover_page.dart';

void main() {
  testWidgets('renders the recovery form in Spanish', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeAuthRepository()));

    expect(find.text('RECUPERACIÓN POR CORREO'), findsOneWidget);
    expect(find.text('Recuperar contraseña'), findsOneWidget);
    expect(find.text('Enviar instrucciones'), findsOneWidget);
    expect(find.text('Contactar soporte 24/7'), findsOneWidget);
  });

  testWidgets('shows the empty email validation state', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeAuthRepository()));
    await tester.tap(find.text('Enviar instrucciones'));
    await tester.pump();

    expect(find.text('Ingresa tu email corporativo'), findsOneWidget);
  });

  testWidgets('shows the generic successful request response', (tester) async {
    await tester.pumpWidget(_TestApp(repository: _FakeAuthRepository()));
    await tester.enterText(find.byType(TextField), 'operador@empresa.com');
    await tester.tap(find.text('Enviar instrucciones'));
    await tester.pumpAndSettle();

    expect(
      find.text('Si la cuenta existe, recibirás instrucciones en tu correo.'),
      findsOneWidget,
    );
  });
}

class _TestApp extends StatelessWidget {
  const _TestApp({required this.repository});

  final AuthRepository repository;

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      child: const MaterialApp(home: RecoverPage()),
    );
  }
}

class _FakeAuthRepository implements AuthRepository {
  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<void> signUp(SignUpRequest request) async {}

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(username: username, token: 'token');

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signOut() async {}
}
