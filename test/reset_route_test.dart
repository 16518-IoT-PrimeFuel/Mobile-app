import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/app/app_router.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/recover_page.dart';
import 'package:mobile_app/features/auth/presentation/reset_password_page.dart';

void main() {
  testWidgets('/reset-password?token=abc renders ResetPasswordPage with it', (
    tester,
  ) async {
    final router = await _pump(tester, authenticated: false);
    router.go('/reset-password?token=abc');
    await tester.pumpAndSettle();

    final page = tester.widget<ResetPasswordPage>(
      find.byType(ResetPasswordPage),
    );
    expect(page.token, 'abc');
    expect(find.text('Crea una nueva contraseña'), findsOneWidget);
  });

  testWidgets('an empty token shows a message with a way back to /recover', (
    tester,
  ) async {
    final router = await _pump(tester, authenticated: false);
    router.go('/reset-password');
    await tester.pumpAndSettle();

    expect(find.text('El enlace no es válido o ya venció.'), findsOneWidget);
    expect(find.byType(TextField), findsNothing);
    await tester.tap(find.text('Solicitar un nuevo enlace'));
    await tester.pumpAndSettle();
    expect(find.byType(RecoverPage), findsOneWidget);
  });

  testWidgets('reset route stays reachable when a session already exists', (
    tester,
  ) async {
    final router = await _pump(tester, authenticated: true);
    router.go('/reset-password?token=abc');
    await tester.pumpAndSettle();

    expect(find.byType(ResetPasswordPage), findsOneWidget);
  });
}

Future<dynamic> _pump(
  WidgetTester tester, {
  required bool authenticated,
}) async {
  final container = ProviderContainer(
    overrides: [authRepositoryProvider.overrideWithValue(_Repo())],
  );
  addTearDown(container.dispose);
  if (authenticated) {
    container.read(authControllerProvider.notifier).continueAsGuest();
  }
  final router = container.read(appRouterProvider);
  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: router),
    ),
  );
  await tester.pump();
  return router;
}

class _Repo implements AuthRepository {
  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async => AuthSession(username: username, token: 't');

  @override
  Future<AuthSession?> restoreSession() async => null;

  @override
  Future<void> signUp(SignUpRequest request) async {}

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {}

  @override
  Future<void> signOut() async {}
}
