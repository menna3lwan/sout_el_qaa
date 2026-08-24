import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../constants/app_config.dart';
import 'interceptors/auth_interceptor.dart';

/// نقطة إنشاء واحدة لـ[Dio] مضبوطة بالـinterceptors المطلوبة. الـbaseUrl
/// مش hardcoded — بييجي من [AppConfig.apiBaseUrl] عشان يقدر يتغيّر بين
/// الـmock server المحلي والـbackend الحقيقي بدون تعديل كود (القسم 16).
final class DioClientFactory {
  const DioClientFactory(this._authInterceptor);

  final AuthInterceptor _authInterceptor;

  Dio create() {
    final dio = Dio(
      BaseOptions(
        baseUrl: AppConfig.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 30), // أطول شوية لرفع الوسائط
        headers: {'Accept': 'application/json'},
      ),
    );

    dio.interceptors.add(_authInterceptor);

    if (!AppConfig.isProduction) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: false,
          requestBody: true,
          responseBody: true,
          error: true,
          compact: true,
        ),
      );
    }

    return dio;
  }
}
