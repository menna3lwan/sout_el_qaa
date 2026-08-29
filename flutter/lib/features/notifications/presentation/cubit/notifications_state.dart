import 'package:equatable/equatable.dart';

import '../../domain/entities/app_notification.dart';

/// The 4 tabs confirmed from Figma's Notifications screen (PLAN.md section 3.9): "الكل"/"الشكاوى"/
/// "التفاعلات"/"عام". [complaints] covers both statusUpdate and newComment notification types — the
/// UI groups them under one tab even though the domain models them as two distinct [NotificationType]s.
enum NotificationsFilter { all, complaints, reactions, general }

sealed class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

final class NotificationsLoading extends NotificationsState {
  const NotificationsLoading();
}

final class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({
    required this.notifications,
    this.filter = NotificationsFilter.all,
  });

  final List<AppNotification> notifications;
  final NotificationsFilter filter;

  List<AppNotification> get visibleNotifications => switch (filter) {
        NotificationsFilter.all => notifications,
        NotificationsFilter.complaints => notifications
            .where(
              (n) =>
                  n.type == NotificationType.statusUpdate ||
                  n.type == NotificationType.newComment,
            )
            .toList(),
        NotificationsFilter.reactions => notifications
            .where((n) => n.type == NotificationType.reaction)
            .toList(),
        NotificationsFilter.general => notifications
            .where((n) => n.type == NotificationType.general)
            .toList(),
      };

  NotificationsLoaded copyWith({
    List<AppNotification>? notifications,
    NotificationsFilter? filter,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      filter: filter ?? this.filter,
    );
  }

  @override
  List<Object?> get props => [notifications, filter];
}

final class NotificationsError extends NotificationsState {
  const NotificationsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
