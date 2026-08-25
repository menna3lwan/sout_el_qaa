import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Secure storage for sensitive session data only (access/refresh tokens, the signed-in user's id); simple flags belong in shared_preferences, not here (PLAN.md section 1.8).
///
/// [saveUserId]/[readUserId] are a [Proposed] Demo App addition: several screens (Complaints List's
/// "Mine" filter, Create Complaint's authorId, Comment's authorName lookup) need to know "who is
/// currently signed in" synchronously with no extra network round-trip; storing the id alongside the
/// tokens it's issued with is simpler and cheaper than an extra GET /auth/me call on every screen.
abstract interface class SecureStorageService {
  Future<void> saveAccessToken(String token);
  Future<String?> readAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> readRefreshToken();

  Future<void> saveUserId(String userId);
  Future<String?> readUserId();

  /// Called on logout or auto-logout after a 401 (PLAN.md sections 1.6/1.7).
  Future<void> clearSession();
}

final class SecureStorageServiceImpl implements SecureStorageService {
  const SecureStorageServiceImpl(this._storage);

  final FlutterSecureStorage _storage;

  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';

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
  Future<void> saveUserId(String userId) => _storage.write(key: _userIdKey, value: userId);

  @override
  Future<String?> readUserId() => _storage.read(key: _userIdKey);

  @override
  Future<void> clearSession() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }
}
