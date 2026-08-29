import 'package:equatable/equatable.dart';

/// Confirmed from db.json's seeded notifications: a status change on one of your complaints, a new
/// comment on one of your complaints, a reaction, or a general/system message with no linked complaint.
enum NotificationType { statusUpdate, newComment, reaction, general }

base class AppNotification extends Equatable {
  const AppNotification({
    required this.id,
    required this.userId,
    required this.type,
    required this.title,
    required this.complaintId,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String userId;
  final NotificationType type;
  final String title;

  /// Null for [NotificationType.general] — nothing to deep-link to (PLAN.md section 3.9: Notification
  /// -> Related Complaint only applies when one exists).
  final String? complaintId;
  final bool isRead;
  final DateTime createdAt;

  AppNotification copyWithRead(bool isRead) => AppNotification(
        id: id,
        userId: userId,
        type: type,
        title: title,
        complaintId: complaintId,
        isRead: isRead,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props =>
      [id, userId, type, title, complaintId, isRead, createdAt];
}
