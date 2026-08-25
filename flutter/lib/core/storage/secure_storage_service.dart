import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive session data only (access/refresh tokens); simple flags belong in shared_preferences, not here (PLAN.md section 1.8).
abstract interface class SecureStorageService {
  Future<void> saveAccessToken(String token);
  Future<String?> readAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> readRefreshToken();

  /// Called on logout or auto-logout after a 401 (PLAN.md sections 1.6/1.7).
  Future<void> clearSession();
}

final class SecureStorageServiceImpl implements SecureStorageService {
  const SecureStorageServiceImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';

  @override
  Future<void> saveAccessToken(String token) =>
      _storage.write(key: _accessTokenKey, value: token);

  @override
  Future<String?> readAccessToken() => _storage.read(key: _accessTokenKey);

  @override
  Future<void> saveRefreshToken(String token) =>
      _storage.write(key: _refreshTokenKey, value: token);

  @override
  Future<String?> readRefreshToken() => _storage.read(key: _refreshTokenKey);

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }
}
