import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../../../core/utils/validators.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/domain/repositories/complaint_repository.dart';
import 'create_complaint_state.dart';

/// Drives the whole multi-step wizard from one Cubit (not one per step) — the steps share a single
/// draft and must validate against each other's fields at submit time regardless of which step the
/// user is currently viewing, which a per-step Cubit would make awkward.
final class CreateComplaintCubit extends Cubit<CreateComplaintState> {
  CreateComplaintCubit(this._repository, this._secureStorage)
      : super(const CreateComplaintState());

  final ComplaintRepository _repository;
  final SecureStorageService _secureStorage;

  Future<void> loadCategories() async {
    final result = await _repository.getCategories();
    result.fold(
      // A failed category fetch just leaves the picker empty rather than blocking the whole wizard —
      // the user can still fill in title/description while retrying is one pull-to-refresh-less tap away.
      (failure) {},
      (categories) => emit(state.copyWith(categories: categories)),
    );
  }

  void updateTitle(String value) =>
      emit(state.copyWith(title: value, status: CreateComplaintStatus.editing));

  void updateDescription(String value) => emit(
        state.copyWith(
          description: value,
          status: CreateComplaintStatus.editing,
        ),
      );

  void selectCategory(String categoryId) => emit(
        state.copyWith(
          categoryId: categoryId,
          status: CreateComplaintStatus.editing,
        ),
      );

  /// Sets the label only — lat/lng are untouched (omitted, so [CreateComplaintState.copyWith] keeps
  /// whatever was already picked, or stays null). Typing the label before tapping "pick on map" must
  /// never silently fabricate a (0, 0) coordinate that would pass [hasLocation]'s null-check.
  void updateLocationLabel(String value) => emit(
        state.copyWith(location: value, status: CreateComplaintStatus.editing),
      );

  void selectLocation({
    required double lat,
    required double lng,
    required String location,
  }) =>
      emit(
        state.copyWith(
          lat: lat,
          lng: lng,
          location: location,
          status: CreateComplaintStatus.editing,
        ),
      );

  void selectSeverity(ComplaintSeverity severity) => emit(
        state.copyWith(
          severity: severity,
          status: CreateComplaintStatus.editing,
        ),
      );

  Future<void> attachPhoto(String filePath) async {
    emit(state.copyWith(isUploadingMedia: true));
    final result = await _repository.uploadMedia(filePath);
    result.fold(
      (failure) => emit(
        state.copyWith(
          isUploadingMedia: false,
          failureMessageKey: failure.message,
        ),
      ),
      (url) => emit(
        state.copyWith(
          isUploadingMedia: false,
          mediaUrls: [...state.mediaUrls, url],
        ),
      ),
    );
  }

  void removePhoto(String url) => emit(
        state.copyWith(
          mediaUrls: state.mediaUrls.where((u) => u != url).toList(),
        ),
      );

  /// [Updated, Full Audit & Sync pass, 27 Aug 2026] The redesigned Figma merged all 4 field groups
  /// onto one `form` screen, so "advance past the form" now validates every field at once instead of
  /// one group at a time — same validators, same required fields as before, just checked together
  /// (the old per-step partial validation no longer maps onto a single-screen form). From `review`
  /// there's nothing further to validate here; that step's own action is [submit], not [nextStep].
  void nextStep() {
    if (state.step != CreateComplaintStep.form) return;

    final errors = _validateAll();
    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.validationError,
          fieldErrors: errors,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        step: CreateComplaintStep.review,
        status: CreateComplaintStatus.editing,
        fieldErrors: const {},
      ),
    );
  }

  /// Used by the review step's "تعديل الشكوى" (Edit) action to go back to the form — same intent as
  /// the old per-step Back button, just between 2 steps instead of 4 now.
  void previousStep() {
    if (state.step == CreateComplaintStep.review) {
      emit(
        state.copyWith(
          step: CreateComplaintStep.form,
          status: CreateComplaintStatus.editing,
        ),
      );
    }
  }

  Map<String, String> _validateAll() {
    final errors = <String, String>{};

    final titleError = Validators.required(state.title);
    final descriptionError = Validators.complaintDescription(state.description);
    if (titleError != null) errors['title'] = titleError;
    if (descriptionError != null) errors['description'] = descriptionError;

    if (state.categoryId == null) errors['category'] = 'validationRequired';
    if (!state.hasLocation) errors['location'] = 'validationRequired';
    if (state.severity == null) errors['severity'] = 'validationRequired';

    return errors;
  }

  Future<void> submit() async {
    final errors = _validateAll();
    if (errors.isNotEmpty) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.validationError,
          fieldErrors: errors,
        ),
      );
      return;
    }

    emit(state.copyWith(status: CreateComplaintStatus.submitting));

    final authorId = await _secureStorage.readUserId();
    if (authorId == null) {
      emit(
        state.copyWith(
          status: CreateComplaintStatus.failure,
          failureMessageKey: 'unauthorizedMessage',
        ),
      );
      return;
    }

    final result = await _repository.createComplaint(
      title: state.title.trim(),
      description: state.description.trim(),
      categoryId: state.categoryId!,
      severity: state.severity!,
      location: state.location,
      lat: state.lat!,
      lng: state.lng!,
      mediaUrls: state.mediaUrls,
      authorId: authorId,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: CreateComplaintStatus.failure,
          failureMessageKey: failure.message,
        ),
      ),
      (complaint) => emit(
        state.copyWith(
          status: CreateComplaintStatus.success,
          createdComplaint: complaint,
        ),
      ),
    );
  }
}
