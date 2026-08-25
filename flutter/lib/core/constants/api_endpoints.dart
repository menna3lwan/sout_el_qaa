/// Proposed API contract (PLAN.md section 16, P2) — only file expected to change if the real backend's paths differ.
abstract final class ApiEndpoints {
  /// Points at the local mock server (backend/mock-server/) by default; overridden via --dart-define=API_BASE_URL.
  static const String apiVersionPrefix = '/api/v1';

  // Auth
  static const String register = '$apiVersionPrefix/auth/register';
  static const String login = '$apiVersionPrefix/auth/login';
  static const String refresh = '$apiVersionPrefix/auth/refresh';
  static const String logout = '$apiVersionPrefix/auth/logout';
  static const String me = '$apiVersionPrefix/auth/me';

  // Home
  static const String categories = '$apiVersionPrefix/categories';
  static const String trendingComplaints = '$apiVersionPrefix/complaints/trending';
  static const String recentActivity = '$apiVersionPrefix/users/me/recent-activity';

  // Complaints
  static const String complaints = '$apiVersionPrefix/complaints';
  static String complaintById(String id) => '$apiVersionPrefix/complaints/$id';
  static const String media = '$apiVersionPrefix/media';
  static String complaintStatus(String id) => '$apiVersionPrefix/complaints/$id/status';

  // Comments & Reactions
  static String comments(String complaintId) =>
      '$apiVersionPrefix/complaints/$complaintId/comments';
  static String comment(String commentId) => '$apiVersionPrefix/comments/$commentId';
  static String reactions(String complaintId) =>
      '$apiVersionPrefix/complaints/$complaintId/reactions';

  // Map
  static const String complaintsMap = '$apiVersionPrefix/complaints/map';

  // Notifications
  static const String notifications = '$apiVersionPrefix/notifications';
  static String notificationRead(String id) => '$apiVersionPrefix/notifications/$id/read';
  static const String notificationsReadAll = '$apiVersionPrefix/notifications/read-all';
  static const String devices = '$apiVersionPrefix/devices';

  // Profile
  static const String myStats = '$apiVersionPrefix/users/me/stats';
  static const String myProfile = '$apiVersionPrefix/users/me';
}
