import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/user_model.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remote,
    this._networkInfo,
    this._secureStorage,
  );

  final AuthRemoteDataSource _remote;
  final NetworkInfo _networkInfo;
  final SecureStorageService _secureStorage;

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  }) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      final response = await _remote.login(email: email, password: password);
      await _secureStorage.saveAccessToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUserId(response.user.id);
      return Right(response.user);
    } on ServerException catch (error) {
      // [Proposed] Deliberately bypasses ErrorMapper's blanket "401 -> session expired" rule here:
      // for the login endpoint specifically, a 401 means "wrong credentials" (there was never a
      // session to expire), so the mock server's own message is shown instead of the misleading
      // "sign in again, your session ended" copy. Every other 401 in the app (an authenticated
      // request rejected mid-session) still goes through ErrorMapper as session-expired, unchanged.
      return Left(
        ServerFailure(message: error.message, statusCode: error.statusCode),
      );
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
  }) =>
      _runAuth(
        () => _remote.register(
          username: username,
          email: email,
          password: password,
        ),
      );

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _remote.logout();
    } catch (_) {
      // Best-effort: the mock endpoint doesn't really invalidate anything server-side, so a failed
      // logout call must never block the user from actually leaving their account on this device.
    }
    await _secureStorage.clearSession();
    return const Right(null);
  }

  @override
  Future<Either<Failure, User>> currentUser() async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      final user = await _remote.getCurrentUser();
      return Right(user);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }

  Future<Either<Failure, User>> _runAuth(
    Future<AuthResponseModel> Function() call,
  ) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      final response = await call();
      await _secureStorage.saveAccessToken(response.accessToken);
      await _secureStorage.saveRefreshToken(response.refreshToken);
      await _secureStorage.saveUserId(response.user.id);
      return Right(response.user);
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
