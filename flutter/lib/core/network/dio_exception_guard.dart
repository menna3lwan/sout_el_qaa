import 'package:dio/dio.dart';

import '../errors/exceptions.dart';

/// Runs a Dio call and normalizes any [DioException] into a [ServerException] carrying the
/// backend's own `{ message }` body (PLAN.md section 16), so every remote data source has one
/// exception shape to let propagate to its Repository instead of a raw DioException. Shared here
/// (not copy-pasted per data source) once a third data source needed the same six lines.
Future<Response<T>> guardDioCall<T>(Future<Response<T>> Function() call) async {
  try {
    return await call();
  } on DioException catch (error) {
    final data = error.response?.data;
    final message = data is Map && data['message'] is String
        ? data['message'] as String
        : (error.message ?? 'genericErrorMessage');
    throw ServerException(
      message: message,
      statusCode: error.response?.statusCode,
    );
  }
}
