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

  /// The mock server tracks only raw like/dislike/report counters, not per-user reactions — "have I
  /// personally reacted" is tracked client-side only, in-memory, for this session.
  final bool isLiked;
  final bool isDisliked;
  final bool isReported;

  /// The category's real display name, resolved once at load time via
  /// [ComplaintRepository.getCategories] rather than duplicating a second name list. Null only while
  /// that call is still in flight or failed; the pill falls back to the bare id then.
  final Category? category;
  final bool isPostingComment;

  /// One-shot like [AuthState.failureMessageKey]: deliberately not defaulted to
  /// `this.commentErrorMessageKey` in [copyWith], so it naturally clears on the next state change
  /// instead of re-showing a stale error.
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
