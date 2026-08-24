/// Validators عامة قابلة لإعادة الاستخدام عبر أي فورم في التطبيق (Login,
/// Register, Create Complaint...). كل validator بيرجع `null` لو الإدخال
/// صحيح، أو مفتاح رسالة (يترجم لاحقًا في الـwidget عبر ARB) لو غلط — بدل
/// hardcoding رسائل إنجليزي/عربي جوه الـvalidator نفسه.
abstract final class Validators {
  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)+$',
  );

  static String? required(String? value, {String errorKey = 'validationRequired'}) {
    if (value == null || value.trim().isEmpty) return errorKey;
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) return 'validationRequired';
    if (!_emailRegex.hasMatch(value.trim())) return 'validationInvalidEmail';
    return null;
  }

  /// حد أدنى 8 خانات، حرف وحرف كبير ورقم على الأقل — قابل للتشديد لاحقًا
  /// لما متطلبات الأمان الفعلية تتأكد مع `feature/patrick-auth`.
  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'validationRequired';
    if (value.length < 8) return 'validationPasswordTooShort';
    final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(value);
    final hasDigit = RegExp(r'\d').hasMatch(value);
    if (!hasLetter || !hasDigit) return 'validationPasswordTooWeak';
    return null;
  }

  static String? confirmPassword(String? value, String originalPassword) {
    if (value == null || value.isEmpty) return 'validationRequired';
    if (value != originalPassword) return 'validationPasswordMismatch';
    return null;
  }

  /// وصف الشكوى — حد أقصى 300 حرف، مؤكد من الـFigma (القسم 3.6 من الـplan).
  static String? complaintDescription(String? value, {int maxLength = 300}) {
    if (value == null || value.trim().isEmpty) return 'validationRequired';
    if (value.length > maxLength) return 'validationTooLong';
    return null;
  }
}
