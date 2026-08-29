import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/profile_rank.dart';
import 'profile_rank_visuals.dart';

/// [New, Figma Sync pass, 29 Aug 2026] Small navy pill badge under the Profile avatar showing the
/// resident's current rank (Figma node 33:794: "منقذ بحري" with a small medal icon, overlapping the
/// avatar's bottom edge).
class RankBadge extends StatelessWidget {
  const RankBadge({required this.rank, super.key});

  final ProfileRank rank;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.rankBadgeBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.avatarBorder, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            profileRankLabel(context, rank),
            style: AppTypography.chipLabel
                .copyWith(fontSize: 13, color: AppColors.textOnBrand),
          ),
          const SizedBox(width: AppSpacing.xs),
          const Icon(
            Icons.military_tech,
            size: 16,
            color: AppColors.avatarBorder,
          ),
        ],
      ),
    );
  }
}

/// [New, Figma Sync pass, 29 Aug 2026] Profile page's "المستوى الحالي" progress card (Figma node
/// 33:794): current rank + percent-to-next on one row, a progress bar, then a caption naming the
/// next rank and how many bubbles remain — or a max-rank message once there's no next rank.
class RankProgressCard extends StatelessWidget {
  const RankProgressCard({required this.points, super.key});

  final int points;

  @override
  Widget build(BuildContext context) {
    final rank = ProfileRankLadder.rankFor(points);
    final nextRank = ProfileRankLadder.nextRankFor(points);
    final progress = ProfileRankLadder.progressToNextRank(points);
    final pointsToNext = ProfileRankLadder.pointsToNextRank(points);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: AppColors.borderFigmaDefault),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n
                    .profileProgressToNextLabel((progress * 100).round()),
                style: AppTypography.metaText,
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    context.l10n.profileCurrentLevelLabel,
                    style: AppTypography.metaText,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      const Icon(
                        Icons.military_tech,
                        size: 18,
                        color: AppColors.brandSecondaryDark,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        profileRankLabel(context, rank),
                        style: AppTypography.chipLabel
                            .copyWith(color: AppColors.profileAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: AppColors.rankProgressTrack,
              color: AppColors.brandSecondaryDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            nextRank == null
                ? context.l10n.profileMaxRankCaption
                : context.l10n.profileNextRankCaption(
                    pointsToNext,
                    profileRankLabel(context, nextRank),
                  ),
            style: AppTypography.metaText
                .copyWith(color: AppColors.textFigmaSecondary),
          ),
        ],
      ),
    );
  }
}
