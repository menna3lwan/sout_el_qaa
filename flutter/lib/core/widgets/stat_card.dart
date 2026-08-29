import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Small glass-style stat card matching "12 منقذ بحري / 8 شكاوى مؤيدة / 245 شكاوى" on the Profile page, extracted from the real Figma; [Requires Confirmation] the text itself ("منقذ بحري" as a title/badge?) looks like placeholder content rather than final copy — see branch report.
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
