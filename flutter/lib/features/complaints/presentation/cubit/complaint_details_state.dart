import 'package:equatable/equatable.dart';

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
    this.isPostingComment = false,
    this.commentErrorMessageKey,
  });

  final Complaint complaint;
  final List<Comment> comments;

  /// [Assumption A#] The mock server tracks only a raw like counter, not per-user reactions
  /// (PLAN.md section 16 has no "did I react" field) — "have I personally liked this" is tracked
  /// client-side only, in-memory, for this session; a real backend would return this from the API.
  final bool isLiked;
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
    bool? isPostingComment,
    String? commentErrorMessageKey,
  }) {
    return ComplaintDetailsLoaded(
      complaint: complaint ?? this.complaint,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isPostingComment: isPostingComment ?? this.isPostingComment,
      commentErrorMessageKey: commentErrorMessageKey,
    );
  }

  @override
  List<Object?> get props =>
      [complaint, comments, isLiked, isPostingComment, commentErrorMessageKey];
}

final class ComplaintDetailsError extends ComplaintDetailsState {
  const ComplaintDetailsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
