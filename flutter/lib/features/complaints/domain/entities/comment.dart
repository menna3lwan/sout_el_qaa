import 'package:equatable/equatable.dart';

/// A comment on a complaint (Complaint Details screen only — PLAN.md section 3.8).
final class Comment extends Equatable {
  const Comment({
    required this.id,
    required this.complaintId,
    required this.authorId,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });

  final String id;
  final String complaintId;
  final String authorId;
  final String authorName;
  final String text;
  final DateTime createdAt;

  @override
  List<Object?> get props => [id, complaintId, authorId, authorName, text, createdAt];
}
