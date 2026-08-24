import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// نقطة تحويل واحدة من أي exception تقني لـ[Failure] مفهوم للـPresentation.
/// كل RepositoryImpl لازم يلف استدعاء الـDataSource بـtry/catch وينادي
/// [ErrorMapper.map] بدل ما يعمل mapping يدوي متكرر في كل مكان (DRY).
///
/// انظر القسم 7 من الـplan لتصنيف الأخطاء الكامل.
abstract final class ErrorMapper {
  static Failure map(Object error, {String? fallbackMessage}) {
    return switch (error) {
      NoInternetException() => const NetworkFailure(
          message: 'noInternetConnectionMessage', // مفتاح ARB، يتترجم في الـCubit
        ),
      ServerException(:final statusCode, :final message) =>
        statusCode == 401
            ? const UnauthorizedFailure(message: 'unauthorizedMessage')
            : ServerFailure(message: message, statusCode: statusCode),
      CacheException(:final message) => CacheFailure(message: message),
      DioException() => _mapDioException(error),
      _ => UnknownFailure(
          message: fallbackMessage ?? 'genericErrorMessage', // مفتاح ARB
        ),
    };
  }

  static Failure _mapDioException(DioException error) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkFailure(message: 'noInternetConnectionMessage');
    }

    final statusCode = error.response?.statusCode;
    if (statusCode == 401) {
      return const UnauthorizedFailure(message: 'unauthorizedMessage');
    }

    return ServerFailure(
      message: 'genericErrorMessage',
      statusCode: statusCode,
    );
  }
}
