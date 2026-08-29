import '../../domain/entities/comment.dart';

final class CommentModel extends Comment {
  const CommentModel({
    required super.id,
    required super.complaintId,
    required super.authorId,
    required super.authorName,
    required super.text,
    required super.createdAt,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        id: json['id'] as String,
        complaintId: json['complaintId'] as String,
        authorId: json['authorId'] as String,
        authorName: json['authorName'] as String,
        text: json['text'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );
}
