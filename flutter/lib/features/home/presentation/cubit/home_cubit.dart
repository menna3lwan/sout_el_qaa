import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../complaints/domain/repositories/complaint_repository.dart';
import 'home_state.dart';

/// Combines 4 independent reads (user, categories, trending, recent activity) into one screen state —
/// deliberately not 4 separate BlocProviders, since Home shows all 4 together and a single Loading/
/// Error is simpler to reason about than 4 partially-loaded regions (PLAN.md section 6).
final class HomeCubit extends Cubit<HomeState> {
  HomeCubit(this._authRepository, this._complaintRepository)
      : super(const HomeLoading());

  final AuthRepository _authRepository;
  final ComplaintRepository _complaintRepository;

  Future<void> load() async {
    emit(const HomeLoading());

    // Started together (a Future begins running as soon as it's created, not when it's awaited) and
    // only awaited individually below, so the 4 reads run concurrently while each keeps its own
    // precise Either<Failure, T> type — Future.wait would collapse the differing T's to their common
    // supertype and lose that.
    final userFuture = _authRepository.currentUser();
    final categoriesFuture = _complaintRepository.getCategories();
    final trendingFuture = _complaintRepository.getTrending();
    final recentFuture = _complaintRepository.getRecentActivity();

    final userResult = await userFuture;
    final categoriesResult = await categoriesFuture;
    final trendingResult = await trendingFuture;
    final recentResult = await recentFuture;

    final firstFailure = userResult.fold((f) => f, (_) => null) ??
        categoriesResult.fold((f) => f, (_) => null) ??
        trendingResult.fold((f) => f, (_) => null) ??
        recentResult.fold((f) => f, (_) => null);
    if (firstFailure != null) {
      emit(HomeError(firstFailure.message));
      return;
    }

    emit(
      HomeLoaded(
        user: userResult
            .getOrElse((_) => throw StateError('unreachable — checked above')),
        categories: categoriesResult.getOrElse((_) => const []),
        trending: trendingResult.getOrElse((_) => const []),
        recentActivity: recentResult.getOrElse((_) => const []),
      ),
    );
  }
}
