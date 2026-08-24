import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/complaints/presentation/pages/complaints_page.dart';
import '../../features/create_complaint/presentation/pages/create_complaint_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/secure_storage_service.dart';
import '../widgets/bottom_nav_shell.dart';
import 'route_paths.dart';

/// نقطة إنشاء الـ[GoRouter] — الـshell بتاع الـ5 تابات + auth guard.
///
/// **نطاق foundation المتعمّد [P12]:** المسارات المسجّلة هنا بس هي
/// splash/login + الـ4 تابات الرئيسية + create-complaint كـpush route
/// (انظر [P14] في core/widgets/bottom_nav_shell.dart). أي مسار تاني
/// (`/notifications`, `/complaints/:id`) بيتسجل مع الـfeature branch اللي
/// بتملكه.
final class AppRouterFactory {
  const AppRouterFactory(this._secureStorage);

  final SecureStorageService _secureStorage;

  GoRouter create() {
    return GoRouter(
      initialLocation: RoutePaths.splash,
      redirect: _redirect,
      routes: [
        GoRoute(
          path: RoutePaths.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: RoutePaths.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: RoutePaths.createComplaint,
          builder: (context, state) => const CreateComplaintPage(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) =>
              BottomNavShell(navigationShell: navigationShell),
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.home,
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.map,
                  builder: (context, state) => const MapPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.complaints,
                  builder: (context, state) => const ComplaintsPage(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RoutePaths.profile,
                  builder: (context, state) => const ProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Guard بسيط: لو مفيش access token محفوظ، أي محاولة دخول لأي تاب من
  /// الـ5 تابات (أو create-complaint) بترجّع لـ/login. القسم 3.1: منطق
  /// "Checking Auth → Redirect" اتحط هنا مقصودًا (core/router) بدل جوه
  /// widget الـSplash نفسه — انظر التعليق في splash_page.dart.
  ///
  /// **ملحوظة نطاق:** الـsession الحقيقية (تسجيل دخول فعلي، refresh token،
  /// auto-logout) لسه مش متنفذة — هتتضاف مع `feature/patrick-auth`. دلوقتي
  /// الـguard بيتأكد بس من وجود token محفوظ محليًا.
  Future<String?> _redirect(BuildContext context, GoRouterState state) async {
    final isGoingToLogin = state.matchedLocation == RoutePaths.login;
    final isGoingToSplash = state.matchedLocation == RoutePaths.splash;

    final token = await _secureStorage.readAccessToken();
    final isAuthenticated = token != null;

    if (isGoingToSplash) {
      return isAuthenticated ? RoutePaths.home : RoutePaths.login;
    }

    if (!isAuthenticated && !isGoingToLogin) {
      return RoutePaths.login;
    }

    if (isAuthenticated && isGoingToLogin) {
      return RoutePaths.home;
    }

    return null;
  }
}
