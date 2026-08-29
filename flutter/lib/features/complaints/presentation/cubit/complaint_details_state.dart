import 'package:equatable/equatable.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/complaint.dart';

sealed class ComplaintDetailsState extends Equatable {
  const ComplaintDetailsState();

  @override
  List<Object?> get props => [];
}

final class ComplaintDetailsLoading extends ComplaintDetailsState {
  const ComplaintDetailsLoading();
}

final class ComplaintDetailsLoaded extends ComplaintDetailsState {
  const ComplaintDetailsLoaded({
    required this.complaint,
    required this.comments,
    required this.isLiked,
    this.isDisliked = false,
    this.isReported = false,
    this.category,
    this.isPostingComment = false,
    this.commentErrorMessageKey,
  });

  final Complaint complaint;
  final List<Comment> comments;

  /// [Assumption A#] The mock server tracks only raw like/dislike/report counters, not per-user
  /// reactions (PLAN.md section 16 has no "did I react" field) — "have I personally reacted" is
  /// tracked client-side only, in-memory, for this session; a real backend would return this from the
  /// API. Mirrored by [isDisliked]/[isReported] below (added for the 3-counter reaction row, Figma
  /// node 33:518, Figma Sync pass 29 Aug 2026).
  final bool isLiked;
  final bool isDisliked;
  final bool isReported;

  /// [New, Figma Sync pass, 29 Aug 2026] The severity/category/location pill row (Figma node 33:518)
  /// needs the category's real display name, not just its id — resolved once at load time via
  /// [ComplaintRepository.getCategories] (same data source Home/Create Complaint already use for
  /// category names) rather than duplicating a second, ARB-based name list. Null only while the
  /// categories call is still in flight or if it failed; the pill falls back to the bare id then.
  final Category? category;
  final bool isPostingComment;

  /// [Fixed, Full Application Review pass, 28 Aug 2026] `postComment` used to swallow a failed post
  /// entirely — `isPostingComment` just went back to false with no signal to the user that nothing
  /// was actually saved ("Never silently ignore errors"). One-shot like [AuthState.failureMessageKey]:
  /// deliberately NOT defaulted to `this.commentErrorMessageKey` in [copyWith], so it naturally clears
  /// itself on the next state change (a retry, a successful post) instead of re-showing a stale error.
  final String? commentErrorMessageKey;

  ComplaintDetailsLoaded copyWith({
    Complaint? complaint,
    List<Comment>? comments,
    bool? isLiked,
    bool? isDisliked,
    bool? isReported,
    Category? category,
    bool? isPostingComment,
    String? commentErrorMessageKey,
  }) {
    return ComplaintDetailsLoaded(
      complaint: complaint ?? this.complaint,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isDisliked: isDisliked ?? this.isDisliked,
      isReported: isReported ?? this.isReported,
      category: category ?? this.category,
      isPostingComment: isPostingComment ?? this.isPostingComment,
      commentErrorMessageKey: commentErrorMessageKey,
    );
  }

  @override
  List<Object?> get props => [
        complaint,
        comments,
        isLiked,
        isDisliked,
        isReported,
        category,
        isPostingComment,
        commentErrorMessageKey,
      ];
}

final class ComplaintDetailsError extends ComplaintDetailsState {
  const ComplaintDetailsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
