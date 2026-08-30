import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_shadows.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/bidi_aware_text.dart';
import '../../../../core/widgets/character_avatar_assets.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/complaint.dart';
import '../cubit/complaint_details_cubit.dart';
import '../cubit/complaint_details_state.dart';
import '../widgets/category_visuals.dart';
import '../widgets/complaint_scene_assets.dart';
import '../widgets/severity_visuals.dart';
import '../widgets/status_badge.dart';

class ComplaintDetailsPage extends StatelessWidget {
  const ComplaintDetailsPage({required this.complaintId, super.key});

  final String complaintId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ComplaintDetailsCubit>()..load(complaintId),
      child: const _ComplaintDetailsView(),
    );
  }
}

class _ComplaintDetailsView extends StatefulWidget {
  const _ComplaintDetailsView();

  @override
  State<_ComplaintDetailsView> createState() => _ComplaintDetailsViewState();
}

class _ComplaintDetailsViewState extends State<_ComplaintDetailsView> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.complaintDetailsAppBarTitle),
        actions: const [
          // This app has a single demo resident (SpongeBob), so the header avatar is the same
          // bundled asset used everywhere else, not a per-user lookup.
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: QaaAvatar(
              assetPath: 'assets/images/characters/spongebob_avatar.jpg',
              size: 36,
            ),
          ),
        ],
      ),
      // BlocConsumer (not BlocBuilder) so a failed comment post can surface the SnackBar below as a
      // side effect without touching the builder logic.
      body: BlocConsumer<ComplaintDetailsCubit, ComplaintDetailsState>(
        listener: (context, state) {
          if (state is ComplaintDetailsLoaded &&
              state.commentErrorMessageKey != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  resolveMessageKey(context, state.commentErrorMessageKey!),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            ComplaintDetailsLoading() => const LoadingView(),
            ComplaintDetailsError(:final messageKey) => ErrorView(
                message: resolveMessageKey(context, messageKey),
                onRetry: () => context.read<ComplaintDetailsCubit>().retry(),
              ),
            ComplaintDetailsLoaded() => _DetailsBody(
                state: state,
                commentController: _commentController,
              ),
          };
        },
      ),
    );
  }
}

class _DetailsBody extends StatelessWidget {
  const _DetailsBody({required this.state, required this.commentController});

  final ComplaintDetailsLoaded state;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    final complaint = state.complaint;
    // A real resident-uploaded photo (complaint.mediaUrls) always takes precedence; the bundled
    // Figma-sourced hero photo only fills in for complaints that have one and no upload yet.
    final heroAsset = complaintHeroAsset(complaint.id);
    final hasMedia = complaint.mediaUrls.isNotEmpty;
    final showPhoto = hasMedia || heroAsset != null;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // High-severity complaints get an urgent badge above the title (same signal as
        // [ComplaintListCard.showUrgentBadge]); status itself is communicated by the stepper below.
        if (complaint.severity == ComplaintSeverity.high) ...[
          _DetailsUrgentBadge(label: context.l10n.homeUrgentBadge),
          const SizedBox(height: AppSpacing.xs),
        ],
        BidiAwareText(complaint.title, style: AppTypography.complaintTitle),
        const SizedBox(height: AppSpacing.sm),
        _InfoPillRow(complaint: complaint, category: state.category),
        const SizedBox(height: AppSpacing.md),
        if (showPhoto) ...[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: hasMedia
                  ? CachedNetworkImage(
                      imageUrl: complaint.mediaUrls.first,
                      fit: BoxFit.cover,
                      errorWidget: (_, __, ___) => const ColoredBox(
                        color: AppColors.surfaceIconCircle,
                        child: Icon(Icons.image_not_supported_outlined),
                      ),
                    )
                  : Image.asset(
                      heroAsset!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: AppColors.surfaceIconCircle,
                        child: Icon(Icons.image_not_supported_outlined),
                      ),
                    ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        _EngagementCountersRow(
          complaint: complaint,
          isLiked: state.isLiked,
          isDisliked: state.isDisliked,
          isReported: state.isReported,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.detailsTitle, style: AppTypography.cardTitle),
        const SizedBox(height: AppSpacing.sm),
        ComplaintStatusStepper(
          currentStatus: complaint.status,
          receivedLabel: context.l10n.statusReceivedLabel,
          inReviewLabel: context.l10n.statusInReviewLabel,
          resolvedLabel: context.l10n.statusResolvedLabel,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          context.l10n.detailsSectionHeading,
          style: AppTypography.cardTitle,
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceWhite,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            border: Border.all(color: AppColors.cardBorder),
            boxShadow: AppShadows.hairline,
          ),
          child: BidiAwareText(
            complaint.description,
            style: AppTypography.bodyDefault,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            const Icon(
              Icons.remove_red_eye_outlined,
              size: 16,
              color: AppColors.textMutedGrey,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              context.l10n.homeViewsCount(complaint.views),
              style: AppTypography.metaText,
            ),
            const Spacer(),
            Text(
              DateFormatter.relative(complaint.createdAt, l10n: context.l10n),
              style: AppTypography.metaText,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.commentsHeading, style: AppTypography.sectionLabel),
        const SizedBox(height: AppSpacing.sm),
        if (state.comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(
              context.l10n.commentsEmptyMessage,
              style: AppTypography.metaText,
            ),
          )
        else
          ...state.comments.map((comment) => _CommentTile(comment: comment)),
        const SizedBox(height: AppSpacing.md),
        _CommentInput(
          controller: commentController,
          isPosting: state.isPostingComment,
        ),
      ],
    );
  }
}

/// The urgent pill above the Complaint Details title — deliberately local rather than reusing
/// [ComplaintListCard]'s private `_UrgentBadge`, since the two use different colors/text styles and
/// neither is a shared/exported component.
class _DetailsUrgentBadge extends StatelessWidget {
  const _DetailsUrgentBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.space12,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: AppColors.urgentBadgeAltDetailPage,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      ),
      child: Text(
        label,
        style: AppTypography.fieldLabel.copyWith(color: AppColors.textOnBrand),
      ),
    );
  }
}

/// Severity-flavor / category / location 3-pill row — local to this page since this exact
/// combination has only one real use so far; not worth promoting to a shared widget yet.
class _InfoPillRow extends StatelessWidget {
  const _InfoPillRow({required this.complaint, required this.category});

  final Complaint complaint;
  final Category? category;

  @override
  Widget build(BuildContext context) {
    final severityColors = severityFlavorPillColors(complaint.severity);
    // Under RTL, a Wrap's first child renders at the right (start) edge same as Row, so the
    // rightmost/first-read pill (location) is listed first here, not last.
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: [
        _InfoPill(
          label: complaint.location,
          icon: Icons.location_on_outlined,
          backgroundColor: AppColors.locationPillBackground,
          borderColor: AppColors.locationPillBorder,
          textColor: AppColors.locationPillText,
        ),
        _InfoPill(
          label: category?.name ?? complaint.categoryId,
          icon: categoryIcon(complaint.categoryId),
          backgroundColor: AppColors.categoryPillBackground,
          borderColor: AppColors.categoryPillBorder,
          textColor: AppColors.categoryPillText,
        ),
        _InfoPill(
          label: severityFlavorLabel(context, complaint.severity),
          icon: severityFlavorIcon(complaint.severity),
          backgroundColor: severityColors.background,
          borderColor: severityColors.border,
          textColor: severityColors.text,
        ),
      ],
    );
  }
}

/// Smaller than [AppTypography.statusChipLabel]'s other use (10px), so this builds its own
/// [TextStyle] rather than reusing it.
class _InfoPill extends StatelessWidget {
  const _InfoPill({
    required this.label,
    required this.icon,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });

  final String label;
  final IconData icon;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: AppTypography.statusChipLabel.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: AppSpacing.xs),
          Icon(icon, size: 12, color: textColor),
        ],
      ),
    );
  }
}

/// The details page's 3-counter reaction row — local to this page for the same reason as
/// [_InfoPillRow]. All 3 pills share the same text/icon color regardless of state; only the icon
/// glyph switches outline/filled to show "did I react".
class _EngagementCountersRow extends StatelessWidget {
  const _EngagementCountersRow({
    required this.complaint,
    required this.isLiked,
    required this.isDisliked,
    required this.isReported,
  });

  final Complaint complaint;
  final bool isLiked;
  final bool isDisliked;
  final bool isReported;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ComplaintDetailsCubit>();
    // Under this app's RTL Directionality, a Row's first child renders at the right (start) edge,
    // so the rightmost/first-read pill (like) is listed first here, not last.
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _CounterPill(
          count: complaint.likes,
          icon: Icons.thumb_up_outlined,
          activeIcon: Icons.thumb_up,
          isActive: isLiked,
          textColor: AppColors.headerBackground,
          fontWeight: FontWeight.w500,
          semanticLabel: context.l10n.homeLikesCount(complaint.likes),
          onTap: cubit.toggleLike,
        ),
        _CounterPill(
          count: complaint.dislikes,
          icon: Icons.thumb_down_outlined,
          activeIcon: Icons.thumb_down,
          isActive: isDisliked,
          textColor: AppColors.headerBackground,
          fontWeight: FontWeight.w500,
          semanticLabel:
              context.l10n.complaintDislikesCount(complaint.dislikes),
          onTap: cubit.toggleDislike,
        ),
        _CounterPill(
          count: complaint.reports,
          icon: Icons.flag_outlined,
          activeIcon: Icons.flag,
          isActive: isReported,
          textColor: AppColors.textFigmaPrimary,
          fontWeight: FontWeight.w600,
          semanticLabel: context.l10n.complaintReportsCount(complaint.reports),
          onTap: cubit.toggleReport,
        ),
      ],
    );
  }
}

class _CounterPill extends StatelessWidget {
  const _CounterPill({
    required this.count,
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.textColor,
    required this.fontWeight,
    required this.semanticLabel,
    required this.onTap,
  });

  final int count;
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final Color textColor;
  final FontWeight fontWeight;
  final String semanticLabel;
  final VoidCallback onTap;

  /// Figma's example caps large counts at "99+" rather than showing the raw number.
  String get _displayCount => count > 99 ? '99+' : '$count';

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.space18,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceOffWhite,
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _displayCount,
                style: AppTypography.chipLabel.copyWith(
                  color: textColor,
                  fontSize: 14,
                  fontWeight: fontWeight,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(isActive ? activeIcon : icon, size: 18, color: textColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _CommentTile extends StatelessWidget {
  const _CommentTile({required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          QaaAvatar(
            assetPath: characterAvatarAsset(comment.authorName),
            displayName: comment.authorName,
            size: 32,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      comment.authorName,
                      style: AppTypography.fieldLabel
                          .copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Text(
                      DateFormatter.relative(
                        comment.createdAt,
                        l10n: context.l10n,
                      ),
                      style: AppTypography.metaText,
                    ),
                  ],
                ),
                BidiAwareText(comment.text, style: AppTypography.bodyDefault),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${comment.likes}',
                      style: AppTypography.metaText,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Icon(
                      Icons.thumb_up_outlined,
                      size: 14,
                      color: AppColors.textMutedGrey,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentInput extends StatelessWidget {
  const _CommentInput({required this.controller, required this.isPosting});

  final TextEditingController controller;
  final bool isPosting;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            decoration:
                InputDecoration(hintText: context.l10n.commentInputHint),
            enabled: !isPosting,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        IconButton(
          icon: isPosting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(
                  Icons.send,
                  color: AppColors.headerBackground,
                ),
          onPressed: isPosting
              ? null
              : () {
                  final text = controller.text;
                  if (text.trim().isEmpty) return;
                  context.read<ComplaintDetailsCubit>().postComment(text);
                  controller.clear();
                },
        ),
      ],
    );
  }
}
