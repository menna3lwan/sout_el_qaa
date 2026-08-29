import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/complaints/presentation/pages/complaint_details_page.dart';
import '../../features/complaints/presentation/pages/complaints_page.dart';
import '../../features/create_complaint/presentation/pages/create_complaint_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/map/presentation/pages/map_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/profile/presentation/pages/my_complaints_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../storage/secure_storage_service.dart';
import '../widgets/bottom_nav_shell.dart';
import 'route_paths.dart';

/// Creates the [GoRouter]: 5-tab shell + auth guard, plus every push route the Demo App's 5 named
/// flows need (complaint details, notifications, register, My Complaints) — all registered here now
/// rather than "per owning feature branch" (the old [P12] scope note), since the combined pass builds
/// every feature in one session instead of one branch at a time.
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
          path: RoutePaths.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: RoutePaths.createComplaint,
          builder: (context, state) => const CreateComplaintPage(),
        ),
        GoRoute(
          path: RoutePaths.complaintDetailsPattern,
          builder: (context, state) =>
              ComplaintDetailsPage(complaintId: state.pathParameters['id']!),
        ),
        GoRoute(
          path: RoutePaths.notifications,
          builder: (context, state) => const NotificationsPage(),
        ),
        GoRoute(
          path: RoutePaths.myComplaints,
          builder: (context, state) => const MyComplaintsPage(),
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
    final isGoingToRegister = state.matchedLocation == RoutePaths.register;
    final isGoingToSplash = state.matchedLocation == RoutePaths.splash;
    final isGoingToPublicRoute = isGoingToLogin || isGoingToRegister;

    final token = await _secureStorage.readAccessToken();
    final isAuthenticated = token != null;

    if (isGoingToSplash) {
      return isAuthenticated ? RoutePaths.home : RoutePaths.login;
    }

    if (!isAuthenticated && !isGoingToPublicRoute) {
      return RoutePaths.login;
    }

    if (isAuthenticated && isGoingToPublicRoute) {
      return RoutePaths.home;
    }

    return null;
  }
}
