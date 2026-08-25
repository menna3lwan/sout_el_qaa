import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

/// Injects the access token into protected requests; centralized 401 handling arrives with feature/patrick-auth once session management exists — this just leaves the hook in place.
final class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._secureStorage);

  final SecureStorageService _secureStorage;

  static const _publicPaths = <String>[
    '/auth/login',
    '/auth/register',
    '/auth/refresh',
  ];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final isPublic = _publicPaths.any(options.path.contains);
    if (!isPublic) {
      final token = await _secureStorage.readAccessToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // TODO(patrick-auth): auto-logout + redirect to Login once session/token lifecycle lands.
    handler.next(err);
  }
}
