import '../../core/storage/token_storage.dart';
import '../../domain/auth/auth_failure.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/auth_session.dart';
import '../api_client.dart';
import '../fulltank_api.dart';

class AuthApiRepository implements AuthRepository {
  const AuthApiRepository({required this.api, required this.storage});

  final FullTankApi api;
  final TokenStorage storage;

  @override
  Future<AuthSession> signIn(
    String username,
    String password, {
    required bool rememberMe,
  }) async {
    try {
      final raw = await api.signIn(username, password);
      final data = raw is Map ? raw : const <String, dynamic>{};
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) throw AuthFailure.unknown();

      final session = AuthSession(
        userId: _intValue(data['id']),
        username: data['username'] as String? ?? username,
        token: token,
      );
      api.client.token = session.token;
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
    } on AuthFailure {
      rethrow;
    } on ApiException catch (error) {
      if (error.statusCode == 400 ||
          error.statusCode == 401 ||
          error.statusCode == 404 ||
          error.statusCode == 422) {
        throw AuthFailure.invalidCredentials();
      }
      throw AuthFailure.network();
    } catch (_) {
      throw AuthFailure.network();
    }
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final saved = await storage.read();
    if (saved == null) return null;
    api.client.token = saved.token;
    return AuthSession(
      userId: saved.userId,
      username: saved.username,
      token: saved.token,
    );
  }

  @override
  Future<void> signOut() async {
    api.client.token = null;
    await storage.clear();
  }

  int? _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}
