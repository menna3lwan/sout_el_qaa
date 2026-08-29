import 'package:equatable/equatable.dart';

/// Unified error classification for the Domain/Presentation layers (PLAN.md section 7).
sealed class Failure extends Equatable {
  const Failure({required this.message});

  /// User-facing message in the app's own voice (PLAN.md section 19); actual translation is resolved via [core/l10n] in the Cubit, not here.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// No internet connection at all.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// Error returned by the backend itself (or the mock server during development).
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// Local read/write failure (Hive/SecureStorage/SharedPreferences).
final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// Form errors, shown inline next to each field rather than as a generic snackbar.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// Camera/location/notifications permission denied.
final class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    required this.permissionType,
  });

  final PermissionFailureType permissionType;

  @override
  List<Object?> get props => [message, permissionType];
}

enum PermissionFailureType { camera, gallery, location, notifications }

/// Token expired or invalid; handled centrally by the [core/network] interceptor (auto-logout + redirect to Login) rather than per feature.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

/// Any other unexpected error.
final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
