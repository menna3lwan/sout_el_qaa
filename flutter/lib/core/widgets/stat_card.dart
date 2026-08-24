import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// كارت إحصائية زجاجي صغير — مطابق لكروت "12 منقذ بحري / 8 شكاوى مؤيدة /
/// 245 شكاوى" في صفحة الملف الشخصي (Profile). مستخرج من الـFigma الحقيقي؛
/// [Requires Confirmation] المحتوى النصي نفسه ("منقذ بحري" كلقب/badge؟)
/// يبان محتوى تجريبي مش نصوص منتج نهائية — راجعي تقرير الجلسة.
class StatCard extends StatelessWidget {
  const StatCard({required this.value, required this.label, super.key});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: AppColors.glassOverlayTrending,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        border: Border.all(color: AppColors.profileAccent),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: AppTypography.displayLarge.copyWith(fontSize: 24),
          ),
          Text(label, style: AppTypography.metaText),
        ],
      ),
    );
  }
}
