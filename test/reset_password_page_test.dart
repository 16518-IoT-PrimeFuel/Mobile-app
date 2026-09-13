import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_app/domain/auth/auth_repository.dart';
import 'package:mobile_app/domain/auth/auth_session.dart';
import 'package:mobile_app/domain/auth/sign_up_request.dart';
import 'package:mobile_app/features/auth/application/auth_providers.dart';
import 'package:mobile_app/features/auth/presentation/reset_password_page.dart';

void main() {
  testWidgets('submits the reset token and new password', (tester) async {
    final repository = _RecoveryRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(
          home: ResetPasswordPage(token: 'one-time-token'),
        ),
      ),
    );

    await tester.enterText(find.byType(TextField).at(0), 'NewPass123!');
    await tester.enterText(find.byType(TextField).at(1), 'NewPass123!');
    await tester.tap(find.byType(FilledButton));
    await tester.pumpAndSettle();

    expect(repository.token, 'one-time-token');
    expect(repository.password, 'NewPass123!');
    expect(find.text('Contraseña actualizada'), findsOneWidget);
  });
}

class _RecoveryRepository implements AuthRepository {
  String? token;
  String? password;

  @override
  Future<void> requestPasswordReset(String email) async {}

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    this.token = token;
    password = newPassword;
  }

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
