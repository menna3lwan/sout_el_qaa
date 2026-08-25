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
  });

  final Complaint complaint;
  final List<Comment> comments;

  /// [Assumption A#] The mock server tracks only a raw like counter, not per-user reactions
  /// (PLAN.md section 16 has no "did I react" field) — "have I personally liked this" is tracked
  /// client-side only, in-memory, for this session; a real backend would return this from the API.
  final bool isLiked;
  final bool isPostingComment;

  ComplaintDetailsLoaded copyWith({
    Complaint? complaint,
    List<Comment>? comments,
    bool? isLiked,
    bool? isPostingComment,
  }) {
    return ComplaintDetailsLoaded(
      complaint: complaint ?? this.complaint,
      comments: comments ?? this.comments,
      isLiked: isLiked ?? this.isLiked,
      isPostingComment: isPostingComment ?? this.isPostingComment,
    );
  }

  @override
  List<Object?> get props => [complaint, comments, isLiked, isPostingComment];
}

final class ComplaintDetailsError extends ComplaintDetailsState {
  const ComplaintDetailsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
