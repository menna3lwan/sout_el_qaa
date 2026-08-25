/// Single source of truth for navigation paths, instead of repeating string literals like context.go('/home') everywhere.
///
/// [P12] Foundation branch scope: only the paths the shell needs (splash/login + the 5 tabs) are registered here — routes like /notifications or /complaints/:id register with their owning feature branch to avoid speculative scope.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';

  static const String home = '/home';
  static const String map = '/map';
  static const String complaints = '/complaints';
  static const String profile = '/profile';

  /// Push route, not a shell branch (see [P14] in core/router/app_router.dart).
  static const String createComplaint = '/create-complaint';
}
