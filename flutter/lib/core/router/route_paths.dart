/// Single source of truth for navigation paths, instead of repeating string literals like context.go('/home') everywhere.
///
/// [P12] Foundation branch scope covered only the shell paths; the Demo App pass adds every route
/// each of the 5 named flows in the brief actually needs to be pushable — register, a complaint's own
/// details, notifications, and My Complaints.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';

  static const String home = '/home';
  static const String map = '/map';
  static const String complaints = '/complaints';
  static const String profile = '/profile';

  /// Push route, not a shell branch (see [P14] in core/router/app_router.dart).
  static const String createComplaint = '/create-complaint';

  static const String complaintDetailsPattern = '/complaints/:id';
  static String complaintDetails(String id) => '/complaints/$id';

  static const String notifications = '/notifications';

  static const String myComplaints = '/profile/my-complaints';
}
