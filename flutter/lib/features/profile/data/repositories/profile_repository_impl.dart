import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/profile_stats.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

final class ProfileRepositoryImpl implements ProfileRepository {
  const ProfileRepositoryImpl(this._remote, this._networkInfo);

  final ProfileRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, ProfileStats>> getStats() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      return Right(await _remote.getStats());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
