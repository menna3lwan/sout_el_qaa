import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// One cell of the Profile page's 3-cell stats grid ("12 شكوى / 8 مغلقة / 245 فقاعة", Figma node
/// 33:794's "Section - Stats Grid") — meant to sit inside that grid's own shared card/border/shadow
/// (see [ProfileStatsGridCard]), not to carry its own border the way an earlier pass assumed.
class StatCard extends StatelessWidget {
  const StatCard({
    required this.value,
    required this.label,
    super.key,
    this.isHighlighted = false,
  });

  final String value;
  final String label;

  /// [Updated, Figma Sync pass, 29 Aug 2026] The points cell (only) gets a translucent gold tint —
  /// a real fetch of node `61:1715` confirms this, correcting a prior pass's solid-orange guess.
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
              // Figma node `61:1717`/`61:1722` is Cairo Bold, not [AppTypography.displayLarge]'s
              // Baloo Bhaijaan 2 — that style is for headings elsewhere, wrong family for this cell.
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

/// [New, Figma Sync pass, 29 Aug 2026] The shared card the 3 [StatCard] cells sit inside (Figma node
/// `61:1713`, "Section - Stats Grid") — extracted once the real fetch showed the cells share one
/// bordered/shadowed wrapper with gaps between them, not 3 independently-carded pills side by side.
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
