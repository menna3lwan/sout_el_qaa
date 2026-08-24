/// مسارات التنقل — مصدر واحد لكل الـpaths، بدل ما string literals تتكرر
/// في كل مكان (`context.go('/home')` منتشرة في الكود).
///
/// [P12] **نطاق foundation branch متعمّد:** المسارات المسجّلة هنا دلوقتي هي
/// بس اللي محتاجاها الـshell (splash/login + الـ5 تابات). مسارات زي
/// `/notifications` أو `/complaints/:id` هتتسجل مع الـfeature branch اللي
/// بتملكها (`krabs-notifications`, `mrkrabs-complaints`) مش هنا، عشان نتجنب
/// speculative scope زيادة عن الحاجة.
abstract final class RoutePaths {
  static const String splash = '/splash';
  static const String login = '/login';

  static const String home = '/home';
  static const String map = '/map';
  static const String complaints = '/complaints';
  static const String profile = '/profile';

  /// دي **push route** مش شيل branch (انظر [P14] في core/router/app_router.dart).
  static const String createComplaint = '/create-complaint';
}
