import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// One cell of the Profile page's 3-cell stats grid — meant to sit inside [ProfileStatsGridCard]'s
/// shared card/border/shadow, not to carry its own border.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.value,
    required this.label,
    super.key,
    this.isHighlighted = false,
  });

  final String value;
  final String label;

  /// The points cell only — gets a translucent gold tint instead of the plain background.
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.space12,
        ),
        decoration: BoxDecoration(
          color: isHighlighted
              ? AppColors.statCardHighlightBackground
              : AppColors.statCardPlainBackground,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: isHighlighted
              ? Border.all(color: AppColors.statCardHighlightBorder)
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: AppTypography.chipLabel.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                height: 28 / 20,
                color: isHighlighted
                    ? AppColors.statCardHighlightText
                    : AppColors.textFigmaPrimary,
              ),
            ),
            Text(
              label,
              style: AppTypography.metaText
                  .copyWith(color: AppColors.textFigmaSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

/// The shared card the 3 [StatCard] cells sit inside — one bordered wrapper with gaps between
/// them, not 3 independently-carded pills side by side.
class ProfileStatsGridCard extends StatelessWidget {
  const ProfileStatsGridCard({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.locationPillBorder),
      ),
      child: Row(
        children: [
          for (var i = 0; i < children.length; i++) ...[
            if (i > 0) const SizedBox(width: AppSpacing.sm),
            children[i],
          ],
        ],
      ),
    );
  }
}
