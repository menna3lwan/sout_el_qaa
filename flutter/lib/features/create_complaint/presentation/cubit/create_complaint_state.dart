import 'package:equatable/equatable.dart';

import '../../../complaints/domain/entities/category.dart';
import '../../../complaints/domain/entities/complaint.dart';

/// [Updated, Full Audit & Sync pass, 27 Aug 2026] The redesigned Figma (nodes 33:210, 59:1207,
/// 59:1389) replaced the old 4 field-group steps (Fill/Category/Location/Severity, each its own
/// screen) with a 3-numbered-step flow whose UI is actually 2 pre-submission screens: (1) `form` —
/// every field together on one screen — then (2) `review` — a read-only summary card with
/// Edit/Cancel/Submit actions. The 3rd numbered step is Success, already modeled separately via
/// [CreateComplaintStatus.success] below (unchanged) rather than as a third [CreateComplaintStep].
/// Was 4 field-group values; the fields themselves (title/description/category/location/severity) and
/// their validation rules are unchanged — only how they're grouped into screens changed (see
/// [CreateComplaintCubit] in create_complaint_cubit.dart).
enum CreateComplaintStep { form, review }

/// [Initial]=[Editing] here (a fresh form and an in-progress one are the same shape, just empty) —
/// the brief's "Initial/Editing/ValidationError/Submitting/Success/Failure" list maps onto one status
/// enum instead of 6 state subclasses, since every step shares the same underlying draft fields.
enum CreateComplaintStatus {
  editing,
  validationError,
  submitting,
  success,
  failure
}

final class CreateComplaintState extends Equatable {
  const CreateComplaintState({
    this.step = CreateComplaintStep.form,
    this.status = CreateComplaintStatus.editing,
    this.title = '',
    this.description = '',
    this.categories = const [],
    this.categoryId,
    this.location = '',
    this.lat,
    this.lng,
    this.severity,
    this.mediaUrls = const [],
    this.isUploadingMedia = false,
    this.fieldErrors = const {},
    this.failureMessageKey,
    this.createdComplaint,
  });

  final CreateComplaintStep step;
  final CreateComplaintStatus status;
  final String title;
  final String description;
  final List<Category> categories;
  final String? categoryId;
  final String location;
  final double? lat;
  final double? lng;
  final ComplaintSeverity? severity;
  final List<String> mediaUrls;
  final bool isUploadingMedia;
  final Map<String, String> fieldErrors;
  final String? failureMessageKey;
  final Complaint? createdComplaint;

  bool get hasLocation => lat != null && lng != null;

  /// The selected [Category] entity, when [categories] has loaded and [categoryId] points at one of
  /// them — used by the review step's preview card, which shows the category's display name/icon
  /// rather than its raw id.
  Category? get selectedCategory {
    if (categoryId == null) return null;
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  CreateComplaintState copyWith({
    CreateComplaintStep? step,
    CreateComplaintStatus? status,
    String? title,
    String? description,
    List<Category>? categories,
    String? categoryId,
    String? location,
    double? lat,
    double? lng,
    ComplaintSeverity? severity,
    List<String>? mediaUrls,
    bool? isUploadingMedia,
    Map<String, String>? fieldErrors,
    String? failureMessageKey,
    Complaint? createdComplaint,
  }) {
    return CreateComplaintState(
      step: step ?? this.step,
      status: status ?? this.status,
      title: title ?? this.title,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      categoryId: categoryId ?? this.categoryId,
      location: location ?? this.location,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      severity: severity ?? this.severity,
      mediaUrls: mediaUrls ?? this.mediaUrls,
      isUploadingMedia: isUploadingMedia ?? this.isUploadingMedia,
      fieldErrors: fieldErrors ?? const {},
      failureMessageKey: failureMessageKey,
      createdComplaint: createdComplaint ?? this.createdComplaint,
    );
  }

  @override
  List<Object?> get props => [
        step,
        status,
        title,
        description,
        categories,
        categoryId,
        location,
        lat,
        lng,
        severity,
        mediaUrls,
        isUploadingMedia,
        fieldErrors,
        failureMessageKey,
        createdComplaint,
      ];
}
