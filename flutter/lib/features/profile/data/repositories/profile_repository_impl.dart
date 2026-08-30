import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/repository_guard.dart';
import '../../domain/entities/profile_stats.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote, this._networkInfo);

  final ProfileRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ProfileStats>> getStats() =>
      guardNetworkCall(_networkInfo, () => _remote.getStats());
}
