import 'package:equatable/equatable.dart';

/// A comment on a complaint (Complaint Details screen only — PLAN.md section 3.8).
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

  /// [New, Figma Sync pass, 29 Aug 2026] Per-comment like count shown on Complaint Details (node
  /// 33:518) — display-only for now (no toggle UI/endpoint exists yet, unlike the complaint-level
  /// like/dislike/report reactions), defaults to 0 for comments posted client-side this session.
  final int likes;

  @override
  List<Object?> get props =>
      [id, complaintId, authorId, authorName, text, createdAt, likes];
}
