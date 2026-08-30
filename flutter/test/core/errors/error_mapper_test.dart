import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sout_el_qaa/core/errors/error_mapper.dart';
import 'package:sout_el_qaa/core/errors/exceptions.dart';
import 'package:sout_el_qaa/core/errors/failures.dart';

/// Extra test (not explicitly required in the foundation DoD, but ErrorMapper is a core pillar of the accepted architecture [C6], PLAN.md section 7, and any bug in it silently affects every future feature branch); added as a low-cost safety net, not a scope expansion.
void main() {
  group('ErrorMapper.map', () {
    test('maps NoInternetException to NetworkFailure', () {
      final failure = ErrorMapper.map(const NoInternetException());
      expect(failure, isA<NetworkFailure>());
    });

    test('maps ServerException with 401 to UnauthorizedFailure', () {
      final failure = ErrorMapper.map(
        const ServerException(message: 'unauthorized', statusCode: 401),
      );
      expect(failure, isA<UnauthorizedFailure>());
    });

    test('maps ServerException with non-401 status to ServerFailure', () {
      final failure = ErrorMapper.map(
        const ServerException(message: 'not found', statusCode: 404),
      );
      expect(failure, isA<ServerFailure>());
      expect((failure as ServerFailure).statusCode, 404);
    });

    test('maps CacheException to CacheFailure', () {
      final failure =
          ErrorMapper.map(const CacheException(message: 'hive error'));
      expect(failure, isA<CacheFailure>());
    });

    test('maps DioException connection error to NetworkFailure', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/complaints'),
        type: DioExceptionType.connectionError,
      );
      final failure = ErrorMapper.map(dioError);
      expect(failure, isA<NetworkFailure>());
    });

    test('maps DioException with 401 response to UnauthorizedFailure', () {
      final dioError = DioException(
        requestOptions: RequestOptions(path: '/complaints'),
        response: Response(
          requestOptions: RequestOptions(path: '/complaints'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
      final failure = ErrorMapper.map(dioError);
      expect(failure, isA<UnauthorizedFailure>());
    });

    test('maps an unrecognized error type to UnknownFailure', () {
      final failure = ErrorMapper.map(StateError('unexpected'));
      expect(failure, isA<UnknownFailure>());
    });
  });
}
