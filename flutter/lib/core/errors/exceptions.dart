/// Exceptions تقنية تتقفل جوه الـData layer بس، وتتحوّل فورًا لـ[Failure]
/// (انظر [error_mapper.dart]). ممنوع تتسرب لأي طبقة تانية.
library;

/// خطأ راجع من السيرفر (REST — مقترح القسم 16) بـstatus code واضح.
final class ServerException implements Exception {
  const ServerException({required this.message, this.statusCode});

  final String message;
  final int? statusCode;
}

/// فشل قراءة/كتابة محلية (Hive/SecureStorage).
final class CacheException implements Exception {
  const CacheException({required this.message});

  final String message;
}

/// مفيش اتصال بالإنترنت (بيتفحص عن طريق [NetworkInfo] قبل أي remote call).
final class NoInternetException implements Exception {
  const NoInternetException();
}
