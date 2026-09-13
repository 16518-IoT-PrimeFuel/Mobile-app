import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/sign_up_page.dart';

void main() {
  testWidgets('registers a buyer using the atomic backend signup request', (
    tester,
  ) async {
    final repository = _RecordingAuthRepository();
    final router = GoRouter(
      initialLocation: '/signup',
      routes: [
        GoRoute(path: '/signup', builder: (_, _) => const SignUpPage()),
        GoRoute(
          path: '/login',
          builder: (_, _) => const Scaffold(body: Text('Iniciar sesión')),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    await _enter(tester, 'Correo corporativo', 'buyer@example.test');
    await _enter(tester, 'Contraseña', 'StrongPass1!');
    await _enter(tester, 'Razón social', 'Buyer LLC');
    await _enter(tester, 'RUC (11 dígitos)', '20999111223');
    await _enter(tester, 'Sector', 'Fuel');
    await _enter(tester, 'Dirección', 'Lima');
    await _enter(tester, 'Teléfono', '999111222');
    tester.testTextInput.hide();
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -220));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byType(FilledButton));
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(repository.request?.role, BusinessRole.buyer);
    expect(repository.request?.username, 'buyer@example.test');
    expect(repository.request?.contactEmail, 'buyer@example.test');
    expect(find.text('Iniciar sesión'), findsOneWidget);
    router.dispose();
  });
}

Future<void> _enter(WidgetTester tester, String label, String value) async {
  final field = find.widgetWithText(TextFormField, label);
  await tester.ensureVisible(field);
  await tester.enterText(field, value);
}

class _RecordingAuthRepository implements AuthRepository {
  SignUpRequest? request;

  @override
  Future<void> signUp(SignUpRequest request) async => this.request = request;

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

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
