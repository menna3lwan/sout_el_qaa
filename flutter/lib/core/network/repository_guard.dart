import 'package:fpdart/fpdart.dart';

import '../errors/error_mapper.dart';
import '../errors/failures.dart';
import 'network_info.dart';

/// Shared "check connectivity, run the call, map any error" shape for repository
/// implementations — the only thing distinguishing one repository method from another is
/// *what* it fetches, not *how* connectivity/errors are handled, so that "how" lives here once
/// instead of being re-implemented per repository.
Future<Either<Failure, T>> guardNetworkCall<T>(
  NetworkInfo networkInfo,
  Future<T> Function() call,
) async {
  if (!await networkInfo.isConnected) {
    return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
  }
  try {
    return Right(await call());
  } catch (error) {
    return Left(ErrorMapper.map(error));
  }
}
