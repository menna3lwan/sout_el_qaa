import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/complaint_status.dart';

/// The one place [ComplaintStatus] maps to localized text — [StatusBadge], [ComplaintStatusStepper],
/// [ComplaintListCard], the details page, and the map's marker sheet all show the same 3 labels, so
/// they all call this instead of five separate switch statements drifting apart.
String complaintStatusLabel(BuildContext context, ComplaintStatus status) =>
    switch (status) {
      ComplaintStatus.received => context.l10n.statusReceivedLabel,
      ComplaintStatus.inReview => context.l10n.statusInReviewLabel,
      ComplaintStatus.resolved => context.l10n.statusResolvedLabel,
    };

/// [StatusBadge] and the Map tab's markers (features/map) both color-code by status — shared here
/// instead of each owning its own switch.
Color complaintStatusColor(ComplaintStatus status) => switch (status) {
      ComplaintStatus.received => AppColors.statusReceivedChip,
      ComplaintStatus.inReview => AppColors.statusInProgressChip,
      ComplaintStatus.resolved => AppColors.statusResolvedChip,
    };

/// Solid-color chip for complaint status: solid background + white text.
class StatusBadge extends StatelessWidget {
  const StatusBadge({required this.status, required this.label, super.key});

  final ComplaintStatus status;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: complaintStatusColor(status),
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000), // rgba(0,0,0,0.05), matches Figma
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Text(label, style: AppTypography.statusChipLabel),
    );
  }
}

/// Horizontal stepper used on Complaint Details instead of the chip used in the list —
/// deliberately distinct from [StatusBadge] since the two screens show status differently.
/// Shape: a gray connecting line with a gold-filled portion for reached steps, and 3 circles
/// (reached = gold, pending = gray) — no per-status color variation, unlike [StatusBadge].
class ComplaintStatusStepper extends StatelessWidget {
  const ComplaintStatusStepper({
    required this.currentStatus,
    required this.receivedLabel,
    required this.inReviewLabel,
    required this.resolvedLabel,
    super.key,
  });

  final ComplaintStatus currentStatus;
  final String receivedLabel;
  final String inReviewLabel;
  final String resolvedLabel;

  int get _reachedStepCount => switch (currentStatus) {
        ComplaintStatus.received => 1,
        ComplaintStatus.inReview => 2,
        ComplaintStatus.resolved => 3,
      };

  @override
  Widget build(BuildContext context) {
    final labels = [receivedLabel, inReviewLabel, resolvedLabel];

    return Column(
      children: [
        Row(
          children: List.generate(3, (index) {
            final isReached = index < _reachedStepCount;
            return Expanded(
              child: Container(
                margin: EdgeInsetsDirectional.only(
                  start: index == 0 ? 0 : AppSpacing.xs,
                ),
                height: AppSpacing.sm,
                decoration: BoxDecoration(
                  color: isReached
                      ? AppColors.statusStepReached
                      : AppColors.statusStepPending,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(3, (index) {
            final isReached = index < _reachedStepCount;
            return Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isReached
                        ? AppColors.statusStepReached
                        : AppColors.statusStepPending,
                    border: Border.all(
                      color: AppColors.statusStepBorder,
                      width: 2,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  labels[index],
                  style: AppTypography.stepLabel.copyWith(
                    color: isReached
                        ? AppColors.headerBackground
                        : AppColors.textSecondaryGrey,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
