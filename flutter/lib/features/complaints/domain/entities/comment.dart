import 'package:equatable/equatable.dart';

/// A comment on a complaint (Complaint Details screen only).
base class Comment extends Equatable {
  const Comment({
    required this.id,
    required this.complaintId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
    this.likes = 0,
  });

  final String id;
  final String complaintId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  /// Display-only for now — no toggle UI/endpoint exists yet, unlike the complaint-level reactions.
  final int likes;

  @override
  List<Object?> get props =>
      [id, complaintId, authorId, authorName, text, createdAt, likes];
}
