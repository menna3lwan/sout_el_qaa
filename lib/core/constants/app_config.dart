/// إعدادات بيئة التشغيل — بتتحدد وقت الـbuild عبر `--dart-define`، مش
/// hardcoded ومش .env داخل الـrepo (تجنبًا لأي secret يتسرب بالغلط).
///
/// مثال تشغيل ضد الـmock server المحلي (القسم 16 + dev/mock-server/):
/// ```
/// flutter run --dart-define=API_BASE_URL=http://localhost:3000
/// ```
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
}
