import 'package:flutter_bloc/flutter_bloc.dart';

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
            // [New, Figma Sync pass, 29 Aug 2026] The severity/category/location pill row needs the
            // category's real name — fetched here rather than blocking `load()` on it, since a
            // failure here shouldn't take down the whole page the way a failed complaint/comments
            // fetch does (the pill just falls back to the bare id, see [ComplaintDetailsLoaded.category]).
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

    final turningOn = !current.isLiked;
    // Mutual exclusivity with dislike, mirroring a standard up/down-vote pattern — best-effort, same
    // "silently ignored" convention as the primary reaction call below (no per-user vote state exists
    // server-side to reconcile against, see [ComplaintDetailsLoaded.isLiked]'s doc comment).
    if (turningOn && current.isDisliked) {
      await _repository.undislike(current.complaint.id);
    }

    final result = current.isLiked
        ? await _repository.unlike(current.complaint.id)
        : await _repository.like(current.complaint.id);

    result.fold(
      // A failed like/unlike is silently ignored rather than surfacing a full-screen error — it's a
      // secondary action on an already-loaded page, not a reason to lose the user's place (contrast
      // with `load()`, where a failure legitimately blocks the whole screen).
      (failure) {},
      (newLikeCount) => emit(
        current.copyWith(
          isLiked: !current.isLiked,
          isDisliked: turningOn ? false : current.isDisliked,
          complaint: current.complaint.copyWithReactions(
            likes: newLikeCount,
            dislikes: turningOn && current.isDisliked
                ? current.complaint.dislikes - 1
                : current.complaint.dislikes,
          ),
        ),
      ),
    );
  }

  /// [New, Figma Sync pass, 29 Aug 2026] Mirrors [toggleLike] for the details page's "dislike" pill —
  /// see that method's doc comments for the shared conventions (mutual exclusivity, silent failure).
  Future<void> toggleDislike() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

    final turningOn = !current.isDisliked;
    if (turningOn && current.isLiked) {
      await _repository.unlike(current.complaint.id);
    }

    final result = current.isDisliked
        ? await _repository.undislike(current.complaint.id)
        : await _repository.dislike(current.complaint.id);

    result.fold(
      (failure) {},
      (newDislikeCount) => emit(
        current.copyWith(
          isDisliked: !current.isDisliked,
          isLiked: turningOn ? false : current.isLiked,
          complaint: current.complaint.copyWithReactions(
            dislikes: newDislikeCount,
            likes: turningOn && current.isLiked
                ? current.complaint.likes - 1
                : current.complaint.likes,
          ),
        ),
      ),
    );
  }

  /// [New, Figma Sync pass, 29 Aug 2026] The details page's "report" pill — fully independent of
  /// like/dislike (reporting something as serious and reacting to it aren't mutually exclusive), same
  /// toggle/silent-failure shape as [toggleLike] otherwise.
  Future<void> toggleReport() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

    final result = current.isReported
        ? await _repository.unreport(current.complaint.id)
        : await _repository.report(current.complaint.id);

    result.fold(
      (failure) {},
      (newReportCount) => emit(
        current.copyWith(
          isReported: !current.isReported,
          complaint: current.complaint.copyWithReactions(
            reports: newReportCount,
          ),
        ),
      ),
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
