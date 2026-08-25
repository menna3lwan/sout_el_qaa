/// Technical exceptions confined to the Data layer, always mapped to a [Failure] immediately (see error_mapper.dart) — never leaks to another layer.
library;

/// Server error (REST, PLAN.md section 16) with an explicit status code.
final class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;
}

/// Local read/write failure (Hive/SecureStorage).
final class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;
}

/// No internet connection (checked via [NetworkInfo] before any remote call).
final class NoInternetException implements Exception {
  const NoInternetException();
}
