import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_notification.dart';

abstract interface class NotificationRepository {
  Future<Either<Failure, List<AppNotification>>> getNotifications(
      {required String userId});

  Future<Either<Failure, void>> markRead(String id);

  Future<Either<Failure, void>> markAllRead();
}
