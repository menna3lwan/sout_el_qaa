import 'package:equatable/equatable.dart';

import 'complaint_status.dart';

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

  /// [New, Figma Sync pass, 29 Aug 2026] Complaint Details' 3-counter reaction row (node 33:518:
  /// report/dislike/like pills) needs a "disagree" counter distinct from [likes] — defaults to 0 for
  /// any caller that doesn't pass one (map pins, older fixtures), same as [reports] below.
  final int dislikes;

  /// [New, Figma Sync pass, 29 Aug 2026] The same reaction row's "report" counter — a tally of
  /// residents flagging the complaint as serious, not a moderation/abuse-report queue (no such queue
  /// exists in this brief); defaults to 0.
  final int reports;
  final List<String> mediaUrls;
  final String authorId;
  final DateTime createdAt;

  /// [Renamed from copyWithLikes, Figma Sync pass, 29 Aug 2026] Now covers all 3 reaction counters
  /// (like/dislike/report), still patched client-side after a reaction toggle
  /// ([ComplaintDetailsCubit]) — the rest of the entity is always replaced wholesale via a fresh
  /// fetch, so this stays a partial copyWith rather than exposing every field.
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
