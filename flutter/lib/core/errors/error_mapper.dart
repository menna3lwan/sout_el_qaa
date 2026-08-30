import 'package:dio/dio.dart';

import 'exceptions.dart';
import 'failures.dart';

/// Converts any technical exception into a [Failure] the Presentation layer understands — call
/// [ErrorMapper.map] instead of mapping ad hoc.
abstract final class ErrorMapper {
  static Failure map(Object error, {String? fallbackMessage}) {
    return switch (error) {
      NoInternetException() => const NetworkFailure(
          message:
              'noInternetConnectionMessage', // ARB key, resolved to text in the Cubit
        ),
      ServerException(:final statusCode, :final message) => statusCode == 401
          ? const UnauthorizedFailure(message: 'unauthorizedMessage')
          : ServerFailure(message: message, statusCode: statusCode),
      CacheException(:final message) => CacheFailure(message: message),
      DioException() => _mapDioException(error),
      _ => UnknownFailure(
          message: fallbackMessage ?? 'genericErrorMessage', // ARB key
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
