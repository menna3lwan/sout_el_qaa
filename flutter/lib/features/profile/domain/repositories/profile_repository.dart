import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/profile_stats.dart';

abstract interface class ProfileRepository {
  Future<Either<Failure, ProfileStats>> getStats();
}
