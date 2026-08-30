import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Session/account operations; the Presentation layer (AuthCubit) only ever talks to this
/// interface, never to Dio or SecureStorage directly.
abstract interface class AuthRepository {
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> register({
    required String username,
    required String email,
    required String password,
  });

  /// Clears the local session; always succeeds locally even if the (best-effort) backend call
  /// fails.
  Future<Either<Failure, void>> logout();

  Future<Either<Failure, User>> currentUser();
}
