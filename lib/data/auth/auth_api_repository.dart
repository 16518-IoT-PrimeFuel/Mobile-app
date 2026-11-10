import 'dart:async';
import 'dart:convert';

import '../../core/storage/token_storage.dart';
import '../../domain/auth/auth_failure.dart';
import '../../domain/auth/auth_repository.dart';
import '../../domain/auth/auth_session.dart';
import '../../domain/auth/sign_up_request.dart';
import '../api_client.dart';
import '../fulltank_api.dart';

class AuthApiRepository implements AuthRepository {
  AuthApiRepository({
    required this.api,
    required this.storage,
    this.onSessionExpired,
  }) {
    api.client.onUnauthorized = _expireSession;
  }

  final void Function(String token)? onSessionExpired;
  Future<void> _storageWork = Future.value();
  int _sessionOperation = 0;

  Future<void> _persist(Future<void> Function() operation) {
    return _storageWork = _storageWork.then(
      (_) => operation(),
      onError: (_) => operation(),
    );
  }

  Future<void> _expireSession(String expectedToken) async {
    if (api.client.token != expectedToken) return;
    api.client.token = null;
    onSessionExpired?.call(expectedToken);
    await _persist(storage.clear);
  }

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
    final operation = ++_sessionOperation;
    try {
      final raw = await api.signIn(username, password, rememberMe: rememberMe);
      if (operation != _sessionOperation) throw AuthFailure.unknown();
      final data = raw is Map ? raw : const <String, dynamic>{};
      final token = data['token'] as String?;
      if (token == null || token.isEmpty) throw AuthFailure.unknown();

      final session = AuthSession(
        userId: _intValue(data['id']),
        username: data['username'] as String? ?? username,
        token: token,
        companyId: _intValue(data['companyId']),
        providerId: _intValue(data['providerId']),
        roles: (data['roles'] as List? ?? const [])
            .whereType<String>()
            .toList(),
        memberships: (data['memberships'] as List? ?? const [])
            .whereType<Map>()
            .map((membership) => Map<String, Object?>.from(membership))
            .toList(),
      );
      api.client.token = session.token;
      if (rememberMe) {
        await _persist(
          () => storage.save(
            token: session.token,
            username: session.username,
            userId: session.userId,
            companyId: session.companyId,
            providerId: session.providerId,
            roles: session.roles,
            memberships: session.memberships,
          ),
        );
      } else {
        await _persist(storage.clear);
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
    final operation = _sessionOperation;
    final saved = await storage.read();
    if (saved == null || operation != _sessionOperation) return null;
    if (_tokenExpired(saved.token)) {
      await _persist(storage.clear);
      return null;
    }
    api.client.token = saved.token;
    return AuthSession(
      userId: saved.userId,
      username: saved.username,
      token: saved.token,
      companyId: saved.companyId,
      providerId: saved.providerId,
      roles: saved.roles,
      memberships: saved.memberships,
    );
  }

  @override
  Future<void> signOut() async {
    _sessionOperation++;
    final signingOutToken = api.client.token;
    try {
      if (signingOutToken != null) {
        await api.signOut().timeout(const Duration(seconds: 10));
      }
    } catch (_) {
      // Offline/server failure must not prevent local logout.
    } finally {
      if (api.client.token == signingOutToken) {
        api.client.token = null;
        await _persist(storage.clear);
      }
    }
  }

  bool _tokenExpired(String token) {
    try {
      final payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))),
      );
      final exp = payload is Map ? payload['exp'] : null;
      return exp is num && exp * 1000 <= DateTime.now().millisecondsSinceEpoch;
    } catch (_) {
      return false; // The API remains responsible for validating opaque/legacy tokens.
    }
  }

  int? _intValue(Object? value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse('$value');
  }
}
