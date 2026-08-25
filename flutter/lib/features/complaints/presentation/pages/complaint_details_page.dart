import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../../domain/entities/comment.dart';
import '../cubit/complaint_details_cubit.dart';
import '../cubit/complaint_details_state.dart';
import '../widgets/status_badge.dart';

/// New screen (not present as a stub anywhere before this pass) implementing Figma node 33:518 —
/// PLAN.md section 18's original split (List owns the list, Details lands later in gary-interactions)
/// no longer applies once the combined Demo App pass builds both in one session.
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
      appBar: AppBar(title: Text(context.l10n.detailsTitle)),
      body: BlocBuilder<ComplaintDetailsCubit, ComplaintDetailsState>(
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
    final hasMedia = complaint.mediaUrls.isNotEmpty;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        if (hasMedia)
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: CachedNetworkImage(
                imageUrl: complaint.mediaUrls.first,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => const ColoredBox(
                  color: AppColors.surfaceIconCircle,
                  child: Icon(Icons.image_not_supported_outlined),
                ),
              ),
            ),
          ),
        if (hasMedia) const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: Text(complaint.title, style: AppTypography.complaintTitle),
            ),
            StatusBadge(
              status: complaint.status,
              label: complaintStatusLabel(context, complaint.status),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xs),
        Row(
          children: [
            const Icon(Icons.location_on_outlined,
                size: 16, color: AppColors.textMutedGrey),
            const SizedBox(width: AppSpacing.xs),
            Expanded(
                child: Text(complaint.location, style: AppTypography.metaText)),
            Text(DateFormatter.relative(complaint.createdAt),
                style: AppTypography.metaText),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        ComplaintStatusStepper(
          currentStatus: complaint.status,
          receivedLabel: context.l10n.statusReceivedLabel,
          inReviewLabel: context.l10n.statusInReviewLabel,
          resolvedLabel: context.l10n.statusResolvedLabel,
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.detailsSectionHeading,
            style: AppTypography.sectionLabel),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.surfaceOffWhite,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Text(complaint.description, style: AppTypography.bodyDefault),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            _ReactionButton(
              icon: state.isLiked ? Icons.favorite : Icons.favorite_outline,
              label: context.l10n.homeLikesCount(complaint.likes),
              isActive: state.isLiked,
              onTap: () => context.read<ComplaintDetailsCubit>().toggleLike(),
            ),
            const SizedBox(width: AppSpacing.md),
            Icon(Icons.remove_red_eye_outlined,
                size: 16, color: AppColors.textMutedGrey),
            const SizedBox(width: AppSpacing.xs),
            Text(context.l10n.homeViewsCount(complaint.views),
                style: AppTypography.metaText),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(context.l10n.commentsHeading, style: AppTypography.sectionLabel),
        const SizedBox(height: AppSpacing.sm),
        if (state.comments.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            child: Text(context.l10n.commentsEmptyMessage,
                style: AppTypography.metaText),
          )
        else
          ...state.comments.map((comment) => _CommentTile(comment: comment)),
        const SizedBox(height: AppSpacing.md),
        _CommentInput(
            controller: commentController, isPosting: state.isPostingComment),
      ],
    );
  }
}

class _ReactionButton extends StatelessWidget {
  const _ReactionButton({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color =
        isActive ? AppColors.urgentDestructive : AppColors.textMutedGrey;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(label, style: AppTypography.metaText.copyWith(color: color)),
        ],
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
          QaaAvatar(displayName: comment.authorName, size: 32),
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
                      DateFormatter.relative(comment.createdAt),
                      style: AppTypography.metaText,
                    ),
                  ],
                ),
                Text(comment.text, style: AppTypography.bodyDefault),
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
              : const Icon(Icons.send),
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
