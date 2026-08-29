import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// شريط فلاتر بشكل pills أفقية — **component مشترك حقيقي**، ظهر بنفس
/// الفكرة (خيار مختار بلون مختلف + باقي الخيارات بحدود رمادية) في شاشتين
/// منفصلتين تمامًا: تابات "كل الشكاوى/شكوائي/تم حلها" (Complaints List)
/// وفلاتر "الكل/شكاوى/تفاعلات/عام" (Notifications). بنوهما كـwidget واحد
/// بدل نسخهم في كل feature — ده بالظبط النوع اللي التاسك طلب نتجنبه من
/// "Different styling لنفس component بين screens".
///
/// الفروق الصغيرة بين الشاشتين (سمك الحدود 1px مقابل 2px، حجم الـpadding)
/// اتوحدت هنا على القيمة الأكتر شيوعًا؛ التفاصيل الدقيقة لكل استخدام قابلة
/// للتعديل وقت تنفيذ الـfeature الفعلي لو لزم.
class FilterPillTabs extends StatelessWidget {
  const FilterPillTabs({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
    this.selectedBackgroundColor = AppColors.headerBackground,
    this.selectedBorderColor = AppColors.headerBorder,
    this.selectedTextColor = AppColors.textOnBrand,
    this.unselectedBackgroundColor = AppColors.surfaceOffWhite,
    this.unselectedBorderColor = AppColors.borderNeutral,
    this.unselectedTextColor = AppColors.textSecondaryGrey,
  });

  /// نصوص الخيارات بالترتيب — النصوص نفسها (ومعناها) بتتحدد بالكامل من
  /// الـfeature المستخدم، الـwidget ده مسؤول عن الشكل البصري فقط.
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Notifications' filter bar (unaudited this pass) and
  /// Complaints List's filter bar (Figma node 33:663, re-fetched fresh) turn out to use genuinely
  /// different selected-pill colors — navy bg/white text/navy border vs. gold bg/dark text/no border —
  /// not the "minor difference, unify on the common value" case this widget's own doc comment above
  /// already flags for border width/padding. These three optional overrides default to the pre-existing
  /// navy scheme (Notifications' presumed-correct, unaudited behavior is untouched unless it's revisited
  /// and found to need its own override), so only Complaints List's call site opts into the new colors.
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;

  /// [New, Full Audit & Sync pass, 27 Aug 2026] A fresh fetch of Notifications' own filter bar (Figma
  /// node 33:936, previously unaudited) shows its UNSELECTED pills also differ from this widget's
  /// default (translucent white bg + dark teal border + a different gray text, not the Complaints
  /// List-matching surfaceOffWhite/borderNeutral/textSecondaryGrey defaults below) — so the "presumed
  /// correct, untouched" assumption in [selectedBackgroundColor]'s doc comment above turned out to be
  /// wrong for the unselected state too. Defaults preserve Complaints List's already-confirmed-correct
  /// look; Notifications' call site overrides all six colors.
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(options.length, (index) {
        final isSelected = index == selectedIndex;
        return _Pill(
          label: options[index],
          isSelected: isSelected,
          onTap: () => onSelected(index),
          selectedBackgroundColor: selectedBackgroundColor,
          selectedBorderColor: selectedBorderColor,
          selectedTextColor: selectedTextColor,
          unselectedBackgroundColor: unselectedBackgroundColor,
          unselectedBorderColor: unselectedBorderColor,
          unselectedTextColor: unselectedTextColor,
        );
      }),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.selectedBackgroundColor,
    required this.selectedBorderColor,
    required this.selectedTextColor,
    required this.unselectedBackgroundColor,
    required this.unselectedBorderColor,
    required this.unselectedTextColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color:
              isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: isSelected ? selectedTextColor : unselectedTextColor,
          ),
        ),
      ),
    );
  }
}
