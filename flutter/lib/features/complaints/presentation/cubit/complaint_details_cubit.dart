import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../domain/repositories/complaint_repository.dart';
import 'complaint_details_state.dart';

final class ComplaintDetailsCubit extends Cubit<ComplaintDetailsState> {
  ComplaintDetailsCubit(this._repository, this._authRepository, this._secureStorage)
      : super(const ComplaintDetailsLoading());

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
        commentsResult.fold(
          (failure) => emit(ComplaintDetailsError(failure.message)),
          (comments) => emit(
            ComplaintDetailsLoaded(complaint: complaint, comments: comments, isLiked: false),
          ),
        );
      },
    );
  }

  Future<void> toggleLike() async {
    final current = state;
    if (current is! ComplaintDetailsLoaded) return;

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
          complaint: current.complaint.copyWithLikes(newLikeCount),
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
    final authorName = userResult.fold((_) => 'ساكن القاع', (user) => user.displayName);

    final result = await _repository.addComment(
      complaintId: current.complaint.id,
      text: text.trim(),
      authorName: authorName,
    );

    result.fold(
      (failure) => emit(current.copyWith(isPostingComment: false)),
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
}
