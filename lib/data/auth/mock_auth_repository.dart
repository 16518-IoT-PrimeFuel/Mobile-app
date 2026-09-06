import '../../core/storage/token_storage.dart';
import '../../domain/auth/auth_failure.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/auth_session.dart';

class MockAuthRepository implements AuthRepository {
  const MockAuthRepository(this.storage);

  static const demoUsername = 'operador@combustibles.mx';
  static const demoPassword = 'FullTank123!';

  final TokenStorage storage;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (username != demoUsername || password != demoPassword) {
      throw AuthFailure.invalidCredentials();
    }
    const session = AuthSession(
      userId: 1,
      username: demoUsername,
      token: 'mock-fulltank-jwt',
    );
    if (rememberMe) {
      await storage.save(
        token: session.token,
        username: session.username,
        userId: session.userId,
      );
    } else {
      await storage.clear();
    }
    return session;
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final saved = await storage.read();
    if (saved == null) return null;
    return AuthSession(
      userId: saved.userId,
      username: saved.username,
      token: saved.token,
    );
  }

  @override
  Future<void> signOut() => storage.clear();
}
