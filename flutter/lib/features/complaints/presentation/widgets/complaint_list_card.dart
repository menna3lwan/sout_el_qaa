import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/complaint.dart';
import 'complaint_scene_assets.dart';
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
    this.showSameProblemAction = false,
    this.showEngagementStats = false,
  });

  final Complaint complaint;
  final VoidCallback onTap;

  /// Home's trending card highlights `severity == high` as "عاجل" (PLAN.md section 3.3); the
  /// Complaints List / My Complaints cards don't, so this stays opt-in per call site rather than an
  /// always-on rule baked into the card itself.
  final bool showUrgentBadge;

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Home's trending card only (Figma node 33:21) adds a
  /// reaction row (thumbs + "N others reported this" count) and a full-width "عندي نفس المشكله"
  /// button — same opt-in-per-call-site pattern as [showUrgentBadge], not an always-on card feature.
  /// The button reuses [onTap] (pushes to Complaint Details) rather than mutating like/reaction state
  /// from the list card directly — that state already has one real owner, [ComplaintDetailsCubit], and
  /// duplicating it here would put business logic in a widget (see the "reusable component" note on
  /// [ComplaintListCard] itself).
  final bool showSameProblemAction;

  /// [Updated, Full Audit & Sync pass, 27 Aug 2026] Was unconditionally rendered before this pass —
  /// re-verified against both the redesigned Complaints List (node 33:744) and Home's trending card
  /// (node 33:21) and neither shows a views/likes row anymore, only the opt-in "same problem" reaction
  /// row above. Defaults to `false` everywhere (no confirmed call site needs it yet); kept as a real
  /// field rather than deleted outright since [Complaint.views] is still real domain data and a not-yet
  /// -audited screen (Profile/My Complaints) may still need it — see the audit report's Remaining
  /// Issues for this open question, per Important Rule #10 (document rather than silently invent).
  final bool showEngagementStats;

  @override
  Widget build(BuildContext context) {
    final isUrgent =
        showUrgentBadge && complaint.severity == ComplaintSeverity.high;
    final thumbnailAsset = complaintThumbnailAsset(complaint.id);

    final content = Column(
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
            const Icon(Icons.location_on_outlined,
                size: 14, color: AppColors.textMutedGrey),
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
            Text(DateFormatter.relative(complaint.createdAt),
                style: AppTypography.stepLabel
                    .copyWith(color: AppColors.textMutedGrey)),
          ],
        ),
        if (showEngagementStats) ...[
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              const Icon(Icons.remove_red_eye_outlined,
                  size: 14, color: AppColors.textMutedGrey),
              const SizedBox(width: AppSpacing.xs),
              Text(context.l10n.homeViewsCount(complaint.views),
                  style: AppTypography.metaText),
              const SizedBox(width: AppSpacing.md),
              const Icon(Icons.favorite_outline,
                  size: 14, color: AppColors.textMutedGrey),
              const SizedBox(width: AppSpacing.xs),
              Text(context.l10n.homeLikesCount(complaint.likes),
                  style: AppTypography.metaText),
            ],
          ),
        ],
        if (showSameProblemAction) ...[
          const SizedBox(height: AppSpacing.sm),
          const Divider(height: 1, color: AppColors.borderNeutral),
          const SizedBox(height: AppSpacing.sm),
          _SameProblemRow(complaint: complaint, onTap: onTap),
        ],
      ],
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.profileAccent, width: 2),
        ),
        // Only complaints with a real Figma-sourced scene photo (see complaint_scene_assets.dart)
        // get a thumbnail — everyone else keeps the original text-only layout unchanged.
        child: thumbnailAsset == null
            ? content
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: content),
                  const SizedBox(width: AppSpacing.sm),
                  Container(
                    width: 80,
                    height: 84,
                    decoration: BoxDecoration(
                      // Figma node 33:760/33:776/33:792 (the thumbnail frame) uses an 8px corner
                      // radius, not the 12px [AppSpacing.radiusMd] this previously (wrongly) used —
                      // that's [AppSpacing.radiusSm], shared with the image-upload/location boxes.
                      borderRadius:
                          BorderRadius.circular(AppSpacing.radiusSm),
                      border: Border.all(
                          color: AppColors.borderNeutral, width: 1),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Image.asset(
                      thumbnailAsset,
                      width: 80,
                      height: 84,
                      fit: BoxFit.cover,
                    ),
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
      margin: const EdgeInsetsDirectional.only(start: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.urgentDestructive,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.urgentBadgeBorder, width: 1),
      ),
      child: Text(label, style: AppTypography.statusChipLabel),
    );
  }
}

/// [New, Full Audit & Sync pass, 27 Aug 2026] Figma node 33:21's trending-card reaction row: a
/// thumbs-up/thumbs-down pair, a "+N others reported this" count, and a full-width "عندي نفس المشكله"
/// button below a divider. Opt-in via [ComplaintListCard.showSameProblemAction] — see that field's doc
/// comment for why the button reuses [onTap] instead of owning its own reaction state.
class _SameProblemRow extends StatelessWidget {
  const _SameProblemRow({required this.complaint, required this.onTap});

  final Complaint complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            _ReactionIconCircle(icon: Icons.thumb_up_outlined),
            const SizedBox(width: AppSpacing.xs),
            _ReactionIconCircle(icon: Icons.thumb_down_outlined),
            const Spacer(),
            Text(
              context.l10n.homeSameProblemCount(complaint.likes),
              style: AppTypography.metaText,
            ),
            const SizedBox(width: AppSpacing.xs),
            const _ReporterAvatarStack(),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          child: Container(
            height: 35,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.brandSecondary,
              borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
              border: Border.all(color: const Color(0x33002431)),
            ),
            child: Text(
              context.l10n.homeSameProblemCta,
              style: AppTypography.pillButtonLabel
                  .copyWith(color: AppColors.textFigmaPrimary),
            ),
          ),
        ),
      ],
    );
  }
}

class _ReactionIconCircle extends StatelessWidget {
  const _ReactionIconCircle({required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.brandAccent.withValues(alpha: 0.35),
        border: Border.all(color: const Color(0x33002431)),
      ),
      child: Icon(icon, size: 15, color: AppColors.profileAccent),
    );
  }
}

/// Simplified stand-in for Figma's 3 overlapping reporter-avatar photos — no dedicated backend field
/// carries "who else reported this" yet, so this shows 3 generic overlapping circles rather than
/// fabricating specific people; see the report's Remaining Issues for the real fix (a backend field +
/// reusing [QaaAvatar]).
class _ReporterAvatarStack extends StatelessWidget {
  const _ReporterAvatarStack();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 24,
      child: Stack(
        children: List.generate(3, (index) {
          return PositionedDirectional(
            start: index * 10.0,
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.categoryElectricityBackground,
                border: Border.all(color: AppColors.textFigmaPrimary),
              ),
            ),
          );
        }),
      ),
    );
  }
}
