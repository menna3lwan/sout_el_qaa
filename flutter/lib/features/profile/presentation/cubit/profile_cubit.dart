import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';

final class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._authRepository, this._profileRepository) : super(const ProfileLoading());

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  Future<void> load() async {
    emit(const ProfileLoading());

    final userFuture = _authRepository.currentUser();
    final statsFuture = _profileRepository.getStats();
    final userResult = await userFuture;
    final statsResult = await statsFuture;

    final failure = userResult.fold((f) => f, (_) => null) ??
        statsResult.fold((f) => f, (_) => null);
    if (failure != null) {
      emit(ProfileError(failure.message));
      return;
    }

    emit(
      ProfileLoaded(
        user: userResult.getOrElse((_) => throw StateError('unreachable — checked above')),
        stats: statsResult.getOrElse((_) => throw StateError('unreachable — checked above')),
      ),
    );
  }

  /// Returns true on success so the page can navigate to /login only once the session is actually
  /// cleared — navigation itself stays the widget's job, not the Cubit's (PLAN.md section 1.2).
  Future<bool> logout() async {
    final result = await _authRepository.logout();
    return result.isRight();
  }
}
