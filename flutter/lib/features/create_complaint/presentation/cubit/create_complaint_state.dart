import 'package:equatable/equatable.dart';

import '../../../complaints/domain/entities/category.dart';
import '../../../complaints/domain/entities/complaint.dart';

/// Steps confirmed by the flow in the brief: Fill -> Category -> Location -> Severity -> Submit ->
/// Success (Figma node 33:210 only shows step 1 in detail — the rest are [Assumption A5], see report).
enum CreateComplaintStep { fill, category, location, severity }

/// [Initial]=[Editing] here (a fresh form and an in-progress one are the same shape, just empty) —
/// the brief's "Initial/Editing/ValidationError/Submitting/Success/Failure" list maps onto one status
/// enum instead of 6 state subclasses, since every step shares the same underlying draft fields.
enum CreateComplaintStatus { editing, validationError, submitting, success, failure }

final class CreateComplaintState extends Equatable {
  const CreateComplaintState({
    this.step = CreateComplaintStep.fill,
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
