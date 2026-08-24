import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// تخزين آمن لبيانات الجلسة الحساسة فقط (access/refresh tokens). أي بيانات
/// تانية (flags بسيطة) تروح لـ[shared_preferences]، مش هنا — القسم 1.8.
abstract interface class SecureStorageService {
  Future<void> saveAccessToken(String token);
  Future<String?> readAccessToken();

  Future<void> saveRefreshToken(String token);
  Future<String?> readRefreshToken();

  /// بتتنادى عند logout أو auto-logout بعد 401 — القسم 1.6/1.7.
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
