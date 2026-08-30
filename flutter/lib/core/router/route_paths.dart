/// Single source of truth for navigation paths, instead of repeating string literals like
/// context.go('/home') everywhere.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String map = '/map';
  static const String complaints = '/complaints';
  static const String profile = '/profile';

  /// Push route, not a shell branch (see [BottomNavShell]'s doc comment).
  static const String createComplaint = '/create-complaint';

  static const String complaintDetailsPattern = '/complaints/:id';
  static String complaintDetails(String id) => '/complaints/$id';

  static const String notifications = '/notifications';

  static const String myComplaints = '/profile/my-complaints';
}
