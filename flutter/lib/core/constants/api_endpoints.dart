/// مسارات الـAPI — مبنية على الـ**Proposed API Contract** (القسم 16 من
/// الـplan). العقد ده مقترح مبدئي مش نهائي [P2] — لما الـbackend الحقيقي
/// يتبنى، الملف ده هو المكان الوحيد المتوقع يتغيّر فيه شكل المسارات لو
/// اختلفت عن المقترح.
abstract final class ApiEndpoints {
  /// أثناء التطوير: mock server محلي (json-server) — انظر backend/mock-server/.
  /// القيمة دي بتتحدد فعليًا وقت التشغيل عبر `--dart-define=API_BASE_URL=...`
  /// (انظر core/constants/app_config.dart) مش hardcoded هنا.
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
