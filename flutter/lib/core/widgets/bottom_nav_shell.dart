import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_paths.dart';
import '../theme/app_colors.dart';
import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
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
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(AppSpacing.radiusXl),
              topRight: Radius.circular(AppSpacing.radiusXl),
            ),
            border: Border(
              top: BorderSide(color: AppColors.navyBarAccentBorder, width: 3),
            ),
            boxShadow: AppShadows.hairline,
          ),
          child: Row(
            children: [
              _NavItem(
                // Figma Home glyph is an anchor, not a house — keeps the nautical Qaa El Hamour tab.
                icon: Icons.anchor,
                selectedIcon: Icons.anchor,
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
        ? AppColors.headerBackground
        : AppColors.textSecondaryGrey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Semantics(
          button: true,
          selected: isSelected,
          label: label,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: isSelected ? 1.08 : 1,
                duration: AppMotion.fast,
                child: Icon(
                  isSelected ? selectedIcon : icon,
                  color: color,
                  size: AppSpacing.iconLg,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: AppTypography.navLabel.copyWith(
                  color: color,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
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
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.fabBackground,
                shape: BoxShape.circle,
                boxShadow: AppShadows.fab,
              ),
              child: const Icon(
                Icons.add,
                color: AppColors.textOnBrand,
                size: AppSpacing.iconLg,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.navLabel.copyWith(
                color: AppColors.headerBackground,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
