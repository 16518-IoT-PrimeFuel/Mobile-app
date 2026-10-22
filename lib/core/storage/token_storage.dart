import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  static const _tokenKey = 'fulltank.access_token';
  static const _usernameKey = 'fulltank.username';
  static const _userIdKey = 'fulltank.user_id';
  static const _companyIdKey = 'fulltank.company_id';
  static const _providerIdKey = 'fulltank.provider_id';
  static const _rolesKey = 'fulltank.roles';
  static const _membershipsKey = 'fulltank.memberships';

  final FlutterSecureStorage _storage;

  Future<void> save({
    required String token,
    required String username,
    int? userId,
    int? companyId,
    int? providerId,
    List<String> roles = const [],
    List<Map<String, Object?>> memberships = const [],
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _usernameKey, value: username);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: '$userId');
    }
    await _writeOptional(_companyIdKey, companyId?.toString());
    await _writeOptional(_providerIdKey, providerId?.toString());
    await _storage.write(key: _rolesKey, value: jsonEncode(roles));
    await _storage.write(key: _membershipsKey, value: jsonEncode(memberships));
  }

  Future<
    ({
      String token,
      String username,
      int? userId,
      int? companyId,
      int? providerId,
      List<String> roles,
      List<Map<String, Object?>> memberships,
    })?
  >
  read() async {
    final token = await _storage.read(key: _tokenKey);
    final username = await _storage.read(key: _usernameKey);
    if (token == null || username == null) return null;
    final rawId = await _storage.read(key: _userIdKey);
    final rawRoles = await _storage.read(key: _rolesKey);
    final rawMemberships = await _storage.read(key: _membershipsKey);
    return (
      token: token,
      username: username,
      userId: rawId == null ? null : int.tryParse(rawId),
      companyId: int.tryParse(await _storage.read(key: _companyIdKey) ?? ''),
      providerId: int.tryParse(await _storage.read(key: _providerIdKey) ?? ''),
      roles: rawRoles == null
          ? const <String>[]
          : List<String>.from(jsonDecode(rawRoles) as List),
      memberships: rawMemberships == null
          ? const <Map<String, Object?>>[]
          : (jsonDecode(rawMemberships) as List)
                .cast<Map>()
                .map((item) => Map<String, Object?>.from(item))
                .toList(),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _usernameKey),
      _storage.delete(key: _userIdKey),
      _storage.delete(key: _companyIdKey),
      _storage.delete(key: _providerIdKey),
      _storage.delete(key: _rolesKey),
      _storage.delete(key: _membershipsKey),
    ]);
  }

  Future<void> _writeOptional(String key, String? value) async {
    if (value == null) {
      await _storage.delete(key: key);
    } else {
      await _storage.write(key: key, value: value);
    }
  }
}
