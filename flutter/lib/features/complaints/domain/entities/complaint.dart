import 'package:equatable/equatable.dart';

import 'complaint_status.dart';

/// A distinct axis from [ComplaintStatus]: severity is set once by the reporter, status changes
/// over the complaint's lifecycle.
enum ComplaintSeverity { high, medium, low }

/// A single complaint, shared as one domain concept across Home, Complaints List, Complaint
/// Details, Map, and Profile/My Complaints rather than duplicated per screen.
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
    this.dislikes = 0,
    this.reports = 0,
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

  /// The "disagree" counter in the 3-way reaction row, distinct from [likes]; defaults to 0 for
  /// callers that don't pass one.
  final int dislikes;

  /// A tally of residents flagging the complaint as serious — not a moderation/abuse-report queue.
  final int reports;
  final List<String> mediaUrls;
  final String authorId;
  final DateTime createdAt;

  /// Covers only the 3 reaction counters, patched client-side after a toggle
  /// ([ComplaintDetailsCubit]) — every other field is always replaced wholesale via a fresh fetch.
  Complaint copyWithReactions({int? likes, int? dislikes, int? reports}) =>
      Complaint(
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
        likes: likes ?? this.likes,
        dislikes: dislikes ?? this.dislikes,
        reports: reports ?? this.reports,
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
        dislikes,
        reports,
        mediaUrls,
        authorId,
        createdAt,
      ];
}

/// Lightweight projection returned by the map-pins endpoint (id/lat/lng/categoryId/status only) —
/// a distinct entity rather than reusing [Complaint] with fake defaults for the fields it lacks.
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
