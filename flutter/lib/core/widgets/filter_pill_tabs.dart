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
  });

  /// نصوص الخيارات بالترتيب — النصوص نفسها (ومعناها) بتتحدد بالكامل من
  /// الـfeature المستخدم، الـwidget ده مسؤول عن الشكل البصري فقط.
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

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
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

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
          color: isSelected
              ? AppColors.headerBackground
              : AppColors.surfaceOffWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: isSelected
                ? AppColors.headerBorder
                : AppColors.borderNeutral,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: isSelected
                ? AppColors.textOnBrand
                : AppColors.textSecondaryGrey,
          ),
        ),
      ),
    );
  }
}
