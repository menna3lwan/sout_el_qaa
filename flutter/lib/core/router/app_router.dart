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

/// Creates the [GoRouter]: 5-tab shell + auth guard; only splash/login, the 4 tabs, and create-complaint (push route, P14 in bottom_nav_shell.dart) are registered here — other routes register with their owning feature branch (P12).
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

  /// Redirects to /login when no access token is stored; "Checking Auth → Redirect" deliberately lives here (core/router), not in SplashPage — see splash_page.dart. Real session lifecycle (login, refresh, auto-logout) lands with feature/patrick-auth.
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
