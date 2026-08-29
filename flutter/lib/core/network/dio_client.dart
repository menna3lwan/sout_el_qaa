import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_config.dart';
import 'interceptors/auth_interceptor.dart';

/// Single [Dio] instance wired with the required interceptors; baseUrl comes from [AppConfig.apiBaseUrl] so it can switch between the mock server and the real backend without code changes (PLAN.md section 16).
final class DioClientFactory {
  const DioClientFactory(this._authInterceptor);

  final AuthInterceptor _authInterceptor;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout:
            const Duration(seconds: 30), // Longer, to allow for media uploads
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(_authInterceptor);

    if (!AppConfig.isProduction) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
        ),
      );
    }

    return dio;
  }
}
