import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/recover_page.dart';

const _sendLabel = 'Enviar enlace de recuperación';

void main() {
  testWidgets('renders the recovery form in Spanish', (tester) async {
    await tester.pumpWidget(_TestApp(_FakeRepository()));

    expect(find.text('RECUPERACIÓN SEGURA'), findsOneWidget);
    expect(find.text('Recuperar contraseña'), findsOneWidget);
    expect(find.text(_sendLabel), findsOneWidget);
    expect(find.text('Contactar soporte 24/7'), findsOneWidget);
  });

  testWidgets('shows the empty email validation state without calling', (
    tester,
  ) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(_TestApp(repository));
    await _tapSend(tester);

    expect(find.text('Ingresa tu email corporativo'), findsOneWidget);
    expect(repository.requestedEmails, isEmpty);
  });

  testWidgets('calls the repository with the typed email and shows sent', (
    tester,
  ) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(_TestApp(repository));
    await tester.enterText(find.byType(TextField), 'operador@empresa.com');
    await _tapSend(tester);

    expect(repository.requestedEmails, ['operador@empresa.com']);
    expect(find.text('Revisa tu bandeja'), findsOneWidget);
    expect(find.text('Abrir mi correo'), findsOneWidget);
    expect(find.text('ENVIADO A'), findsOneWidget);
  });

  testWidgets('shows sent for an unknown account because the API answers 202', (
    tester,
  ) async {
    // The backend never reveals whether the account exists, so the repository
    // completes normally for any address.
    final repository = _FakeRepository();
    await tester.pumpWidget(_TestApp(repository));
    await tester.enterText(find.byType(TextField), 'noexiste@empresa.com');
    await _tapSend(tester);

    expect(repository.requestedEmails, ['noexiste@empresa.com']);
    expect(find.text('Revisa tu bandeja'), findsOneWidget);
    expect(
      find.text('No encontramos ninguna cuenta con este email'),
      findsNothing,
    );
  });

  testWidgets('shows a generic error on transport failure and stays on form', (
    tester,
  ) async {
    final repository = _FakeRepository(failure: Exception('offline'));
    await tester.pumpWidget(_TestApp(repository));
    await tester.enterText(find.byType(TextField), 'operador@empresa.com');
    await _tapSend(tester);

    expect(
      find.text('No pudimos enviar el enlace. Intenta de nuevo.'),
      findsOneWidget,
    );
    expect(find.text('Revisa tu bandeja'), findsNothing);
  });

  testWidgets('resend calls the repository again', (tester) async {
    final repository = _FakeRepository();
    await tester.pumpWidget(_TestApp(repository));
    await tester.enterText(find.byType(TextField), 'operador@empresa.com');
    await _tapSend(tester);

    await tester.tap(find.text('Reenviar enlace'));
    await tester.pumpAndSettle();

    expect(repository.requestedEmails, [
      'operador@empresa.com',
      'operador@empresa.com',
    ]);
    expect(find.text('Revisa tu bandeja'), findsOneWidget);
  });
}

Future<void> _tapSend(WidgetTester tester) async {
  await tester.ensureVisible(find.text(_sendLabel));
  await tester.tap(find.text(_sendLabel));
  await tester.pumpAndSettle();
}

class _TestApp extends StatelessWidget {
  const _TestApp(this.repository);

  final AuthRepository repository;

  @override
  Widget build(BuildContext context) => ProviderScope(
    overrides: [authRepositoryProvider.overrideWithValue(repository)],
    child: const MaterialApp(home: RecoverPage()),
  );
}

class _FakeRepository implements AuthRepository {
  _FakeRepository({this.failure});

  final Object? failure;
  final requestedEmails = <String>[];

  @override
  Future<void> requestPasswordReset(String email) async {
    requestedEmails.add(email);
    if (failure != null) throw failure!;
  }

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
