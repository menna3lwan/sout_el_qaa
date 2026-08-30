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
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      extendBody: true,
      body: navigationShell,
      bottomNavigationBar: Material(
        color: Colors.transparent,
        child: SizedBox(
          height: AppSpacing.fabOverlap +
              AppSpacing.bottomNavHeight +
              bottomInset,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: AppSpacing.fabOverlap,
                bottom: 0,
                child: const _BarSurface(),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 0,
                bottom: bottomInset,
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

/// Light-grey plate, 32px top corners, 4px gold edge that follows the curve.
class _BarSurface extends StatelessWidget {
  const _BarSurface();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.navyBarAccentBorder,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
        boxShadow: AppShadows.bottomNav,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: AppSpacing.bottomNavGoldBorder),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: AppColors.surfaceLightGrey,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(
                AppSpacing.radiusXl - AppSpacing.bottomNavGoldBorder,
              ),
            ),
          ),
        ),
      ),
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
        ? AppColors.fabBackground
        : AppColors.textSecondaryGrey.withValues(alpha: 0.7);

    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.headerBackground.withValues(alpha: 0.08),
        highlightColor: AppColors.headerBackground.withValues(alpha: 0.04),
        child: Semantics(
          button: true,
          selected: isSelected,
          label: label,
          child: Padding(
            padding: const EdgeInsets.only(top: AppSpacing.fabOverlap),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: AppSpacing.navIconSlot,
                  height: AppSpacing.navIconSlot,
                  child: Center(
                    child: AnimatedScale(
                      scale: isSelected ? 1.05 : 1,
                      duration: AppMotion.fast,
                      curve: AppMotion.standard,
                      child: Icon(
                        isSelected ? selectedIcon : icon,
                        color: color,
                        size: AppSpacing.navIconSize,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                  child: Text(
                    label,
                    style: AppTypography.navLabel.copyWith(
                      color: color,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Raised center Add control — navy circle + white plus, overlapping the gold edge.
class _AddNavItem extends StatelessWidget {
  const _AddNavItem({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: label,
        child: InkWell(
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Column(
            children: [
              SizedBox(
                height: AppSpacing.fabOverlap + AppSpacing.navIconSlot,
                child: OverflowBox(
                  maxWidth: AppSpacing.fabSize,
                  maxHeight: AppSpacing.fabSize,
                  child: Container(
                    width: AppSpacing.fabSize,
                    height: AppSpacing.fabSize,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.fabBackground,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.surfaceWhite,
                        width: 3,
                      ),
                      boxShadow: AppShadows.fab,
                    ),
                    child: const Icon(
                      Icons.add_rounded,
                      color: AppColors.textOnBrand,
                      size: AppSpacing.fabIconSize,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: Text(
                  label,
                  style: AppTypography.navLabel.copyWith(
                    color: AppColors.headerBackground,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
