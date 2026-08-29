import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_paths.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../utils/extensions/context_extensions.dart';

/// الـShell البصري لـBottomNavBar — 5 تابات مؤكدة من الـFigma في كل شاشة
/// (القسم 1.5 من الـplan): الرئيسية / الخريطة / إضافة / شكاوي / الملف الشخصي.
///
/// **[P14] قرار تنفيذي اتاخد أثناء بناء الـfoundation، مش موجود صراحة في
/// الـplan الأصلي:** التابات الأربعة (Home/Map/Complaints/Profile) بس هي
/// [StatefulShellRoute] branches حقيقية (بتحافظ على الـstate بتاعها). تاب
/// "إضافة" اتعامل معاه كـaction button بيعمل `push` لـ`/create-complaint`
/// فوق الشاشة الحالية، مش branch خامس — لأن flow تقديم شكوى مفروض يبدأ من
/// جديد كل مرة (زي أي "+" flow)، مش يحافظ على "آخر حالة" كتاب متصفح عادي.
/// ده قرار Proposed جديد محتاج تأكيدك، موثّق في تقرير الـbranch.
///
/// [Icon audit, Figma Sync pass, 29 Aug 2026] The 5 real icon SVGs actually exported off this bar's
/// two Figma layers (the visible one at `bottom:0` and a leftover off-screen duplicate at
/// `bottom:-165px`) are standard Material Design glyphs (home/map/add-circle/assignment/person) —
/// not custom art — confirming [Icons.home]/[Icons.map]/[Icons.add]/[Icons.report]/[Icons.person]
/// below are the *intentional* equivalents already, not a placeholder needing a real asset export.
/// The two layers' per-tab icon/label pairings actively disagree with each other on 2 of 5 tabs
/// (e.g. one layer's "الخريطة" exports as a settings-chevron shape, not a map) — a real authoring
/// inconsistency in the source file between a stale duplicate and the live layer, not something a
/// pixel-exact re-export could resolve, so this documents the finding rather than importing either.
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
      // [Updated, Full Audit & Sync pass, 27 Aug 2026] A fresh fetch of every screen's Figma export
      // (Home, Complaints List, Complaint Details, Profile, Notifications) consistently shows the same
      // stylized bar — rounded top corners, a light-gray fill, and a 4px gold top border — not the
      // theme-default flat bar this held before this pass. All three values were already real,
      // correctly-documented tokens in app_colors.dart/app_spacing.dart (surfaceLightGrey,
      // navyBarAccentBorder, radiusXl) that this widget simply never applied.
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
                // [Fixed, Figma Sync pass, 29 Aug 2026] The real exported SVG for this tab (the
                // clean, non-corrupted layer — see this file's class-level doc comment) is a
                // clipboard/checklist glyph, not [Icons.report]'s warning-shield — [Icons.assignment]
                // is the much closer Material equivalent for a "شكاوي"/complaints-list tab anyway.
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
      index,
      // الرجوع لنفس التاب تاني بيرجّعه لأول صفحة فيه (initialLocation),
      // مش يحافظ على أعمق navigation state لو المستخدم كان عامل push جواه.
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

/// التاب الأوسط المرتفع بصريًا (نمط FAB مدمج) — [A1] افتراض مبني على
/// الـstyling المتكرر (`Group 2` / `Background+Border`) في كل الشاشات.
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
            // [Updated, Full Audit & Sync pass, 27 Aug 2026] Every screen's Figma export shows this
            // circle filled with [AppColors.fabBackground] (a token that already existed, documented
            // as "Background of the raised center FAB", but was never actually wired in here — the
            // theme's `colorScheme.primary` was used instead) plus a 2px surfaceIconCircle border and a
            // drop shadow.
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
