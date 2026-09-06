import 'auth_session.dart';

abstract interface class AuthRepository {
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  });

  Future<AuthSession?> restoreSession();

  Future<void> signOut();
}
