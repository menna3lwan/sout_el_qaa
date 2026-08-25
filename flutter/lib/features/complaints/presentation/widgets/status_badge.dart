import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Unified complaint lifecycle (3 stages confirmed from Figma, PLAN.md sections 3.5/3.8); an enum rather than a String to prevent typos/invalid states — mapping to the backend's slug happens in each feature's own data layer (Mapper), not here.
enum ComplaintStatus { received, inReview, resolved }

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

/// Solid-color chip for complaint status — corrected after the real Figma review (24 Aug 2026): solid background + white text (not the previously assumed soft-tint), with different colors than before ("in progress" is orange #F77F00, "resolved" is navy #002960, previously wrongly assumed green); [Requires Confirmation] no real "received" chip example was found in the reviewed sample (placeholder gray for now), and the final ARB wording for [label] is still open since Figma itself uses two different phrasings for "in review" across screens.
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

/// Horizontal stepper — the second Figma representation of complaint status, used on Complaint Details instead of the chip used in the list; deliberately distinct from [StatusBadge] since Figma itself uses two different visuals for the same concept on two different screens, so one widget shouldn't be forced to cover both.
///
/// Real shape: a gray connecting line with a gold-filled portion for reached steps, and 3 circles (reached = gold, pending = gray) — no per-status color variation, unlike [StatusBadge].
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
                margin: EdgeInsets.only(left: index == 0 ? 0 : AppSpacing.xs),
                height: AppSpacing.xs,
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
