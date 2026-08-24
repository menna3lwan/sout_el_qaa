import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../router/route_paths.dart';
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
        child: SizedBox(
          height: AppSpacing.bottomNavHeight,
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
                icon: Icons.report_outlined,
                selectedIcon: Icons.report,
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.colorScheme.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                color: context.colorScheme.onPrimary,
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
