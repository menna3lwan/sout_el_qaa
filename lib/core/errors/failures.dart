import 'package:equatable/equatable.dart';

/// تصنيف الأخطاء الموحّد على مستوى الـDomain/Presentation — القسم 7 من الـplan.
///
/// أي exception تقني (DioException, SocketException, HiveError...) لازم
/// يتحوّل لـ[Failure] داخل الـData layer فقط (DataSource/RepositoryImpl).
/// الـPresentation layer ميشوفش أي exception خام إطلاقًا — انظر [core/errors/error_mapper.dart].
sealed class Failure extends Equatable {
  const Failure({required this.message});

  /// رسالة جاهزة للعرض للمستخدم — لازم تكون بروح قاع الهامور (القسم 19 من
  /// الـplan)، مش رسالة تقنية عامة. الترجمة الفعلية بتتحدد وقت الإنشاء عبر
  /// [core/l10n] في الـCubit، مش هنا.
  final String message;

  @override
  List<Object?> get props => [message];
}

/// مفيش اتصال بالإنترنت خالص.
final class NetworkFailure extends Failure {
  const NetworkFailure({required super.message});
}

/// خطأ راجع من الـbackend نفسه (أو الـmock server أثناء التطوير).
final class ServerFailure extends Failure {
  const ServerFailure({required super.message, this.statusCode});

  final int? statusCode;

  @override
  List<Object?> get props => [message, statusCode];
}

/// فشل قراءة/كتابة محلية (Hive/SecureStorage/SharedPreferences).
final class CacheFailure extends Failure {
  const CacheFailure({required super.message});
}

/// أخطاء فورم — بتتعرض inline جنب كل حقل، مش snackbar عام.
final class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    this.fieldErrors = const {},
  });

  final Map<String, String> fieldErrors;

  @override
  List<Object?> get props => [message, fieldErrors];
}

/// كاميرا/موقع/إشعارات مرفوضة.
final class PermissionFailure extends Failure {
  const PermissionFailure({required super.message, required this.permissionType});

  final PermissionFailureType permissionType;

  @override
  List<Object?> get props => [message, permissionType];
}

enum PermissionFailureType { camera, gallery, location, notifications }

/// الـtoken منتهي/غير صالح. بيتعالج مركزيًا في [core/network] interceptor
/// (auto-logout + redirect لـLogin) — مش متكرر يدويًا في كل feature.
final class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({required super.message});
}

/// أي حاجة تانية غير متوقعة.
final class UnknownFailure extends Failure {
  const UnknownFailure({required super.message});
}
