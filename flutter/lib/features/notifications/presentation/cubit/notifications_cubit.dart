import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/repositories/notification_repository.dart';
import 'notifications_state.dart';

final class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository, this._secureStorage)
      : super(const NotificationsLoading());

  final NotificationRepository _repository;
  final SecureStorageService _secureStorage;

  Future<void> load() async {
    emit(const NotificationsLoading());

    final userId = await _secureStorage.readUserId();
    if (userId == null) {
      emit(const NotificationsError('unauthorizedMessage'));
      return;
    }

    final result = await _repository.getNotifications(userId: userId);
    result.fold(
      (failure) => emit(NotificationsError(failure.message)),
      (notifications) =>
          emit(NotificationsLoaded(notifications: notifications)),
    );
  }

  void setFilter(NotificationsFilter filter) {
    final current = state;
    if (current is NotificationsLoaded) emit(current.copyWith(filter: filter));
  }

  Future<void> markRead(String notificationId) async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    // Optimistic: flips the dot instantly, then reconciles with the server in the background — a
    // failed mark-as-read is a low-stakes, invisible retry-later concern, not worth blocking on.
    emit(
      current.copyWith(
        notifications: [
          for (final n in current.notifications)
            if (n.id == notificationId) n.copyWithRead(true) else n,
        ],
      ),
    );
    await _repository.markRead(notificationId);
  }

  Future<void> markAllRead() async {
    final current = state;
    if (current is! NotificationsLoaded) return;

    emit(
      current.copyWith(
        notifications: [
          for (final n in current.notifications) n.copyWithRead(true),
        ],
      ),
    );
    await _repository.markAllRead();
  }
}
