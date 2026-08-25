import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/complaint.dart';
import 'status_badge.dart';

/// The complaint card repeated on Home (trending/recent), Complaints List, and Profile/My Complaints
/// (PLAN.md section 18) — built once here instead of duplicated per screen, since all three show the
/// same fields (title, location + relative time, category, status, views/likes) in the same layout.
class ComplaintListCard extends StatelessWidget {
  const ComplaintListCard({
    required this.complaint,
    required this.onTap,
    super.key,
    this.showUrgentBadge = false,
  });

  final Complaint complaint;
  final VoidCallback onTap;

  /// Home's trending card highlights `severity == high` as "عاجل" (PLAN.md section 3.3); the
  /// Complaints List / My Complaints cards don't, so this stays opt-in per call site rather than an
  /// always-on rule baked into the card itself.
  final bool showUrgentBadge;

  @override
  Widget build(BuildContext context) {
    final isUrgent = showUrgentBadge && complaint.severity == ComplaintSeverity.high;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.profileAccent, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    complaint.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.cardTitle,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                if (isUrgent) _UrgentBadge(label: context.l10n.homeUrgentBadge),
                StatusBadge(
                  status: complaint.status,
                  label: complaintStatusLabel(context, complaint.status),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              complaint.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.bodyDefault,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textMutedGrey),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Text(
                    complaint.location,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.metaText,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(DateFormatter.relative(complaint.createdAt), style: AppTypography.metaText),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            Row(
              children: [
                const Icon(Icons.remove_red_eye_outlined, size: 14, color: AppColors.textMutedGrey),
                const SizedBox(width: AppSpacing.xs),
                Text(context.l10n.homeViewsCount(complaint.views), style: AppTypography.metaText),
                const SizedBox(width: AppSpacing.md),
                const Icon(Icons.favorite_outline, size: 14, color: AppColors.textMutedGrey),
                const SizedBox(width: AppSpacing.xs),
                Text(context.l10n.homeLikesCount(complaint.likes), style: AppTypography.metaText),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgentBadge extends StatelessWidget {
  const _UrgentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.urgentDestructive,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.urgentBadgeBorder, width: 1),
      ),
      child: Text(label, style: AppTypography.statusChipLabel),
    );
  }
}
