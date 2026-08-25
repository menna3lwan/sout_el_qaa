import 'package:equatable/equatable.dart';

import '../../presentation/widgets/status_badge.dart' show ComplaintStatus;

/// Severity confirmed from the Create Complaint form (PLAN.md section 3.6) — a distinct axis from [ComplaintStatus] (severity is set once by the reporter, status changes over the complaint's lifecycle).
enum ComplaintSeverity { high, medium, low }

/// A single complaint against Qaa El Hamour's infrastructure — the entity shared by Home (trending/recent), Complaints List, Complaint Details, Map, and Profile/My Complaints (PLAN.md section 18: these screens are different views over one domain concept, not five separate ones).
base class Complaint extends Equatable {
  const Complaint({
    required this.id,
    required this.title,
    required this.description,
    required this.categoryId,
    required this.severity,
    required this.status,
    required this.location,
    required this.lat,
    required this.lng,
    required this.views,
    required this.likes,
    required this.mediaUrls,
    required this.authorId,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String description;
  final String categoryId;
  final ComplaintSeverity severity;
  final ComplaintStatus status;
  final String location;
  final double lat;
  final double lng;
  final int views;
  final int likes;
  final List<String> mediaUrls;
  final String authorId;
  final DateTime createdAt;

  /// Only [likes] is ever patched client-side (after a reaction toggle, ComplaintDetailsCubit) — the
  /// rest of the entity is always replaced wholesale via a fresh fetch, so this is deliberately not a
  /// full copyWith with every field optional.
  Complaint copyWithLikes(int likes) => Complaint(
        id: id,
        title: title,
        description: description,
        categoryId: categoryId,
        severity: severity,
        status: status,
        location: location,
        lat: lat,
        lng: lng,
        views: views,
        likes: likes,
        mediaUrls: mediaUrls,
        authorId: authorId,
        createdAt: createdAt,
      );

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        categoryId,
        severity,
        status,
        location,
        lat,
        lng,
        views,
        likes,
        mediaUrls,
        authorId,
        createdAt,
      ];
}

/// Lightweight projection returned by GET /complaints/map (id/lat/lng/categoryId/status only, PLAN.md section 16) — a distinct entity rather than reusing [Complaint] with fake defaults, since the server deliberately doesn't send the other fields for this endpoint.
base class ComplaintMapPin extends Equatable {
  const ComplaintMapPin({
    required this.id,
    required this.lat,
    required this.lng,
    required this.categoryId,
    required this.status,
  });

  final String id;
  final double lat;
  final double lng;
  final String categoryId;
  final ComplaintStatus status;

  @override
  List<Object?> get props => [id, lat, lng, categoryId, status];
}
