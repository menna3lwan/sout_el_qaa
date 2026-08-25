import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/app_notification.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

final class NotificationRepositoryImpl implements NotificationRepository {
  const NotificationRepositoryImpl(this._remote, this._networkInfo);

  final NotificationRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<AppNotification>>> getNotifications(
          {required String userId}) =>
      _run(() => _remote.getNotifications(userId));

  @override
  Future<Either<Failure, void>> markRead(String id) =>
      _run(() => _remote.markRead(id));

  @override
  Future<Either<Failure, void>> markAllRead() =>
      _run(() => _remote.markAllRead());

  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      return Right(await call());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
