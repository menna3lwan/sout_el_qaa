import '../../domain/entities/app_notification.dart';

final class NotificationModel extends AppNotification {
  const NotificationModel({
    required super.id,
    required super.userId,
    required super.type,
    required super.title,
    required super.complaintId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        id: json['id'] as String,
        userId: json['userId'] as String,
        type: _typeFromSlug(json['type'] as String),
        title: json['title'] as String,
        complaintId: json['complaintId'] as String?,
        isRead: json['isRead'] as bool? ?? false,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  static NotificationType _typeFromSlug(String slug) => NotificationType.values.firstWhere(
        (value) => value.name == slug,
        orElse: () => NotificationType.general,
      );
}
