import 'auth_session.dart';
import 'sign_up_request.dart';

abstract interface class AuthRepository {
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  });

  Future<void> signUp(SignUpRequest request);

  Future<void> requestPasswordReset(String email);

  Future<void> resetPassword(String token, String newPassword);

  Future<AuthSession?> restoreSession();

  Future<void> signOut();
}
