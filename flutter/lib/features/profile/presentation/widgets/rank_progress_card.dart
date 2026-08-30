import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/profile_rank.dart';
import 'profile_rank_visuals.dart';

/// Small navy pill badge overlapping the Profile avatar's bottom-*end* corner, showing the
/// resident's current rank with a small icon.
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
        border: Border.all(color: AppColors.surfaceCardBackground),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            profileRankLabel(context, rank),
            style: AppTypography.chipLabel.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
              color: AppColors.rankBadgeText,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(
            profileRankIcon(rank),
            size: 12,
            color: AppColors.rankBadgeText,
          ),
        ],
      ),
    );
  }
}

/// Profile page's "current level" progress card: rank + percent-to-next on one row, a progress
/// bar, then a caption naming the next rank and how many bubbles remain — or a max-rank message
/// once there's no next rank.
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
      padding: const EdgeInsets.all(AppSpacing.space18),
      decoration: BoxDecoration(
        color: AppColors.surfaceCardBackground,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(color: AppColors.locationPillBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Under this app's RTL Directionality, the far-end item must be the FIRST child
              // (Flutter lays out Row children start-to-end, and "start" is the right edge in RTL).
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.l10n.profileCurrentLevelLabel,
                    style: AppTypography.metaText
                        .copyWith(color: AppColors.textFigmaSecondary),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Icon(
                        profileRankIcon(rank),
                        size: 18,
                        color: AppColors.brandSecondaryDark,
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Text(
                        profileRankLabel(context, rank),
                        style: AppTypography.chipLabel.copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.profileAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${(progress * 100).round()}%',
                    style: AppTypography.chipLabel.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.profileAccent,
                    ),
                  ),
                  Text(
                    context.l10n.profileProgressToNextLabel,
                    style: AppTypography.metaText
                        .copyWith(color: AppColors.textFigmaSecondary),
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
              minHeight: 16,
              backgroundColor: AppColors.rankProgressTrack,
              color: AppColors.rankProgressFill,
            ),
          ),
          const SizedBox(height: AppSpacing.space12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.rankCaptionBackground,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            ),
            child: Center(
              child: Text(
                nextRank == null
                    ? context.l10n.profileMaxRankCaption
                    : context.l10n.profileNextRankCaption(
                        pointsToNext,
                        profileRankLabel(context, nextRank),
                      ),
                style: AppTypography.metaText.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textFigmaTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
