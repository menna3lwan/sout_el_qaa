/// Runtime env config set via --dart-define (no .env in the repo, to avoid leaking secrets); e.g. flutter run --dart-define=API_BASE_URL=http://localhost:3000
abstract final class AppConfig {
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000',
  );

  static const bool isProduction = bool.fromEnvironment('dart.vm.product');
}
