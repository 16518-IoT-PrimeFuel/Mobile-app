import '../../core/storage/token_storage.dart';
import '../../domain/auth/auth_failure.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/auth_session.dart';
import '../../domain/auth/sign_up_request.dart';
import '../api_client.dart';
import '../fulltank_api.dart';

class AuthApiRepository implements AuthRepository {
  const AuthApiRepository({required this.api, required this.storage});

  final FullTankApi api;
  final TokenStorage storage;

  @override
  Future<void> signUp(SignUpRequest request) async {
    final isBuyer = request.role == BusinessRole.buyer;
    await api.signUp({
      'username': request.username,
      'password': request.password,
      'roles': [isBuyer ? 'ROLE_BUYER' : 'ROLE_PROVIDER'],
      'buyerCompany': isBuyer
          ? {
              'name': request.businessName,
              'ruc': request.ruc,
              'sector': request.sector,
              'address': request.address,
              'contactEmail': request.contactEmail,
              'phone': request.phone,
            }
          : null,
      'providerCompany': isBuyer
          ? null
          : {
              'name': request.businessName,
              'ruc': request.ruc,
              'address': request.address,
              'phone': request.phone,
              'fuelTypesOffered': request.fuelTypesOffered,
              'description': request.description,
            },
    });
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    await api.requestPasswordReset(email);
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await api.resetPassword(token, newPassword);
  }

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
