import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  const TokenStorage(this._storage);

  static const _tokenKey = 'fulltank.access_token';
  static const _usernameKey = 'fulltank.username';
  static const _userIdKey = 'fulltank.user_id';

  final FlutterSecureStorage _storage;

  Future<void> save({
    required String token,
    required String username,
    int? userId,
  }) async {
    await _storage.write(key: _tokenKey, value: token);
    await _storage.write(key: _usernameKey, value: username);
    if (userId != null) {
      await _storage.write(key: _userIdKey, value: '$userId');
    }
  }

  Future<({String token, String username, int? userId})?> read() async {
    final token = await _storage.read(key: _tokenKey);
    final username = await _storage.read(key: _usernameKey);
    if (token == null || username == null) return null;
    final rawId = await _storage.read(key: _userIdKey);
    return (
      token: token,
      username: username,
      userId: rawId == null ? null : int.tryParse(rawId),
    );
  }

  Future<void> clear() async {
    await Future.wait([
      _storage.delete(key: _tokenKey),
      _storage.delete(key: _usernameKey),
      _storage.delete(key: _userIdKey),
    ]);
  }
}
