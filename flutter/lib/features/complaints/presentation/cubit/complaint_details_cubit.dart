import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/entities/category.dart';
import '../../domain/repositories/complaint_repository.dart';
import 'complaint_details_state.dart';

final class ComplaintDetailsCubit extends Cubit<ComplaintDetailsState> {
  ComplaintDetailsCubit(
    this._repository,
    this._authRepository,
    this._secureStorage,
  ) : super(const ComplaintDetailsLoading());

  final ComplaintRepository _repository;
  final AuthRepository _authRepository;
  final SecureStorageService _secureStorage;

  /// Remembered so [retry] can reload without the widget needing to hold onto the id separately.
  String? _lastComplaintId;

  Future<void> load(String complaintId) async {
    _lastComplaintId = complaintId;
    emit(const ComplaintDetailsLoading());

    final complaintResult = await _repository.getComplaintById(complaintId);
    await complaintResult.fold(
      (failure) async => emit(ComplaintDetailsError(failure.message)),
      (complaint) async {
        final commentsResult = await _repository.getComments(complaintId);
        await commentsResult.fold(
          (failure) async => emit(ComplaintDetailsError(failure.message)),
          (comments) async {
            // The category name is fetched here rather than blocking `load()` on it, since a
            // failure here shouldn't take down the whole page the way a failed complaint/comments
            // fetch does (the pill falls back to the bare id, see [ComplaintDetailsLoaded.category]).
            final categoriesResult = await _repository.getCategories();
            final category = categoriesResult.fold(
              (_) => null,
              (categories) => _findCategory(categories, complaint.categoryId),
            );
            emit(
              ComplaintDetailsLoaded(
                complaint: complaint,
                comments: comments,
                isLiked: false,
                category: category,
              ),
            );
          },
        );
      },
    );
  }

  Future<void> toggleLike() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

    await _toggleReaction(
      current,
      isActive: current.isLiked,
      onAction: () => _repository.like(current.complaint.id),
      offAction: () => _repository.unlike(current.complaint.id),
      // Mutual exclusivity with dislike, mirroring a standard up/down-vote pattern.
      clearOpposite: current.isDisliked
          ? () => _repository.undislike(current.complaint.id)
          : null,
      applyUpdate: (newCount, turningOn) => current.copyWith(
        isLiked: !current.isLiked,
        isDisliked: turningOn ? false : current.isDisliked,
        complaint: current.complaint.copyWithReactions(
          likes: newCount,
          dislikes: turningOn && current.isDisliked
              ? current.complaint.dislikes - 1
              : current.complaint.dislikes,
        ),
      ),
    );
  }

  Future<void> toggleDislike() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

    await _toggleReaction(
      current,
      isActive: current.isDisliked,
      onAction: () => _repository.dislike(current.complaint.id),
      offAction: () => _repository.undislike(current.complaint.id),
      clearOpposite: current.isLiked
          ? () => _repository.unlike(current.complaint.id)
          : null,
      applyUpdate: (newCount, turningOn) => current.copyWith(
        isDisliked: !current.isDisliked,
        isLiked: turningOn ? false : current.isLiked,
        complaint: current.complaint.copyWithReactions(
          dislikes: newCount,
          likes: turningOn && current.isLiked
              ? current.complaint.likes - 1
              : current.complaint.likes,
        ),
      ),
    );
  }

  /// Reporting is independent of like/dislike — flagging something as serious and reacting to it
  /// aren't mutually exclusive — so there's no [clearOpposite] here, unlike [toggleLike]/[toggleDislike].
  Future<void> toggleReport() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

    await _toggleReaction(
      current,
      isActive: current.isReported,
      onAction: () => _repository.report(current.complaint.id),
      offAction: () => _repository.unreport(current.complaint.id),
      applyUpdate: (newCount, _) => current.copyWith(
        isReported: !current.isReported,
        complaint: current.complaint.copyWithReactions(reports: newCount),
      ),
    );
  }

  /// Shared shape behind [toggleLike]/[toggleDislike]/[toggleReport]: flip an on/off reaction,
  /// best-effort clear a mutually-exclusive one first, and fold the server's new count into state.
  /// A failed toggle is silently ignored rather than surfacing a full-screen error — it's a secondary
  /// action on an already-loaded page, not a reason to lose the user's place.
  Future<void> _toggleReaction(
    ComplaintDetailsLoaded current, {
    required bool isActive,
    required Future<Either<Failure, int>> Function() onAction,
    required Future<Either<Failure, int>> Function() offAction,
    required ComplaintDetailsLoaded Function(int newCount, bool turningOn)
        applyUpdate,
    Future<Either<Failure, int>> Function()? clearOpposite,
  }) async {
    final turningOn = !isActive;
    if (turningOn && clearOpposite != null) {
      await clearOpposite();
    }

    final result = isActive ? await offAction() : await onAction();

    result.fold(
      (failure) {},
      (newCount) => emit(applyUpdate(newCount, turningOn)),
    );
  }

  /// Resolves the current user's display name itself (via [AuthRepository.currentUser]) instead of
  /// asking the page to supply it, so posting a comment stays a single call from the UI.
  Future<void> postComment(String text) async {
    final current = state;
    if (current is! ComplaintDetailsLoaded || text.trim().isEmpty) return;

    emit(current.copyWith(isPostingComment: true));

    final userResult = await _authRepository.currentUser();
    final authorName =
        userResult.fold((_) => 'ساكن القاع', (user) => user.displayName);

    final result = await _repository.addComment(
      complaintId: current.complaint.id,
      text: text.trim(),
      authorName: authorName,
    );

    result.fold(
      (failure) => emit(
        current.copyWith(
          isPostingComment: false,
          commentErrorMessageKey: failure.message,
        ),
      ),
      (comment) => emit(
        current.copyWith(
          isPostingComment: false,
          comments: [...current.comments, comment],
        ),
      ),
    );
  }

  Future<String?> currentUserId() => _secureStorage.readUserId();

  Future<void> retry() async {
    final id = _lastComplaintId;
    if (id != null) await load(id);
  }

  Category? _findCategory(List<Category> categories, String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }
}
