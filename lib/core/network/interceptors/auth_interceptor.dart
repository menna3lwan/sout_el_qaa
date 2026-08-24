import 'package:dio/dio.dart';

import '../../storage/secure_storage_service.dart';

/// بيحقن الـaccess token في كل request محمي، ومسؤول عن معالجة الـ401
/// مركزيًا (بدل ما كل Repository يتعامل مع session expiry بنفسه — القسم 7
/// من الـplan). التعامل الفعلي مع الـ401 (auto-logout + navigation لـLogin)
/// هيتضاف مع `feature/patrick-auth` لما session management نفسه يتنفذ؛ هنا
/// بس الـhook جاهز عشان الـDioClient يبقى كامل من الأساس.
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
    // TODO(patrick-auth): auto-logout + redirect لـLogin لما 401 يوصل هنا.
    // مش متنفذ في foundation branch عشان `auth` feature (session/token
    // lifecycle) لسه ما بدأتش — انظر Remaining Issues في تقرير هذا الـbranch.
    handler.next(err);
  }
}
