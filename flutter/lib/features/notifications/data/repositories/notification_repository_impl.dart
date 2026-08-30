import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/repository_guard.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remote, this._networkInfo);

  final NotificationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications({
    required String userId,
  }) =>
      guardNetworkCall(_networkInfo, () => _remote.getNotifications(userId));

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      guardNetworkCall(_networkInfo, () => _remote.markRead(id));

  @override
  Future<Either<Failure, void>> markAllRead() =>
      guardNetworkCall(_networkInfo, () => _remote.markAllRead());
}
