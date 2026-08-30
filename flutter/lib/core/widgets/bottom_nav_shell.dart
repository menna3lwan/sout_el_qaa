import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_paths.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/context_extensions.dart';

/// The bottom nav bar shell — 5 tabs: Home / Map / Add / Complaints / Profile.
///
/// Only Home/Map/Complaints/Profile are real [StatefulShellRoute] branches (each keeps its own
/// state). "Add" is an action button that pushes `/create-complaint` on top of the current screen
/// rather than a 5th branch, since starting a new complaint should always begin fresh, not resume
/// a stale in-progress state like a normal browsed tab would.
class BottomNavShell extends StatelessWidget {
  const BottomNavShell({
    required this.navigationShell,
    super.key,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Container(
          height: AppSpacing.bottomNavHeight,
          decoration: const BoxDecoration(
            color: AppColors.surfaceLightGrey,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusXl),
              topRight: Radius.circular(AppSpacing.radiusXl),
            ),
            border: Border(
              top: BorderSide(color: AppColors.navyBarAccentBorder, width: 4),
            ),
          ),
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                selectedIcon: Icons.home,
                label: context.l10n.navHome,
                isSelected: navigationShell.currentIndex == 0,
                onTap: () => _goToBranch(0),
              ),
              _NavItem(
                icon: Icons.map_outlined,
                selectedIcon: Icons.map,
                label: context.l10n.navMap,
                isSelected: navigationShell.currentIndex == 1,
                onTap: () => _goToBranch(1),
              ),
              _AddNavItem(
                label: context.l10n.navAdd,
                onTap: () => context.push(RoutePaths.createComplaint),
              ),
              _NavItem(
                icon: Icons.assignment_outlined,
                selectedIcon: Icons.assignment,
                label: context.l10n.navComplaints,
                isSelected: navigationShell.currentIndex == 2,
                onTap: () => _goToBranch(2),
              ),
              _NavItem(
                icon: Icons.person_outline,
                selectedIcon: Icons.person,
                label: context.l10n.navProfile,
                isSelected: navigationShell.currentIndex == 3,
                onTap: () => _goToBranch(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToBranch(int index) {
    navigationShell.goBranch(
      // Re-tapping the current tab resets it to its initial location instead of keeping whatever
      // was pushed on top of it.
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? context.colorScheme.primary
        : context.colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(isSelected ? selectedIcon : icon, color: color, size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

/// The visually-raised center tab (an embedded-FAB look).
class _AddNavItem extends StatelessWidget {
  const _AddNavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.fabBackground,
                shape: BoxShape.circle,
                border:
                    Border.all(color: AppColors.surfaceIconCircle, width: 2),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x1A000000), // rgba(0,0,0,0.1), matches Figma
                    offset: Offset(0, 2),
                    blurRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.textOnBrand,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: context.textTheme.labelSmall?.copyWith(
                color: context.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
