/// Reusable validators for any form in the app (Login, Register, Create Complaint...); each returns null when valid or an ARB message key (translated in the widget) when invalid, instead of hardcoding English/Arabic messages here.
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

  /// Minimum 8 characters with at least one letter and one digit — can be tightened once real security requirements are confirmed with feature/patrick-auth.
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

  /// Complaint description — max 300 characters, confirmed from Figma (PLAN.md section 3.6).
  static String? complaintDescription(String? value, {int maxLength = 300}) {
    if (value == null || value.trim().isEmpty) return 'validationRequired';
    if (value.length > maxLength) return 'validationTooLong';
    return null;
  }
}
