import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  static const _tokenKey = 'fulltank.access_token';
  static const _usernameKey = 'fulltank.username';
  static const _userIdKey = 'fulltank.user_id';
  static const _rolesKey = 'fulltank.roles';
  static const _companyIdKey = 'fulltank.company_id';
  static const _providerIdKey = 'fulltank.provider_id';

  final FlutterSecureStorage _storage;

  Future<void> save({
    required String token,
    required String username,
    int? userId,
    List<String> roles = const [],
    int? companyId,
    int? providerId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _usernameKey, value: username);
    await _writeNullable(_userIdKey, userId);
    await _storage.write(key: _rolesKey, value: roles.join(','));
    await _writeNullable(_companyIdKey, companyId);
    await _writeNullable(_providerIdKey, providerId);
  }

  Future<
    ({
      String token,
      String username,
      int? userId,
      List<String> roles,
      int? companyId,
      int? providerId,
    })?
  >
  read() async {
    final token = await _storage.read(key: _tokenKey);
    final username = await _storage.read(key: _usernameKey);
    if (token == null || username == null) return null;
    final rawId = await _storage.read(key: _userIdKey);
    final rawRoles = await _storage.read(key: _rolesKey);
    return (
      token: token,
      username: username,
      userId: rawId == null ? null : int.tryParse(rawId),
      roles: rawRoles == null || rawRoles.isEmpty
          ? const <String>[]
          : rawRoles.split(','),
      companyId: int.tryParse((await _storage.read(key: _companyIdKey)) ?? ''),
      providerId: int.tryParse(
        (await _storage.read(key: _providerIdKey)) ?? '',
      ),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _usernameKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _rolesKey),
      _storage.delete(key: _companyIdKey),
      _storage.delete(key: _providerIdKey),
    ]);
  }

  Future<void> _writeNullable(String key, int? value) => value == null
      ? _storage.delete(key: key)
      : _storage.write(key: key, value: '$value');
}
