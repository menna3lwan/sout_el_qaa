import '../../domain/entities/complaint.dart';
import '../../domain/entities/complaint_status.dart';

/// JSON (de)serialization for [Complaint]; the mock server's slugs (see ComplaintConstants / server.js) map 1:1 to [ComplaintSeverity]/[ComplaintStatus] enum names, so `.name`/a switch is enough — no separate string-constant duplication.
final class ComplaintModel extends Complaint {
  const ComplaintModel({
    required super.id,
    required super.title,
    required super.description,
    required super.categoryId,
    required super.severity,
    required super.status,
    required super.location,
    required super.lat,
    required super.lng,
    required super.views,
    required super.likes,
    required super.mediaUrls,
    required super.authorId,
    required super.createdAt,
    super.dislikes,
    super.reports,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) => ComplaintModel(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        categoryId: json['categoryId'] as String,
        severity: severityFromSlug(json['severity'] as String),
        status: statusFromSlug(json['status'] as String),
        location: json['location'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        views: json['views'] as int? ?? 0,
        likes: json['likes'] as int? ?? 0,
        dislikes: json['dislikes'] as int? ?? 0,
        reports: json['reports'] as int? ?? 0,
        mediaUrls: (json['mediaUrls'] as List<dynamic>? ?? const [])
            .map((e) => e as String)
            .toList(),
        authorId: json['authorId'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'categoryId': categoryId,
        'severity': severity.name,
        'status': status.name,
        'location': location,
        'lat': lat,
        'lng': lng,
        'views': views,
        'likes': likes,
        'dislikes': dislikes,
        'reports': reports,
        'mediaUrls': mediaUrls,
        'authorId': authorId,
        'createdAt': createdAt.toIso8601String(),
      };
}

ComplaintSeverity severityFromSlug(String slug) =>
    ComplaintSeverity.values.firstWhere(
      (value) => value.name == slug,
      orElse: () => ComplaintSeverity.medium,
    );

ComplaintStatus statusFromSlug(String slug) =>
    ComplaintStatus.values.firstWhere(
      (value) => value.name == slug,
      orElse: () => ComplaintStatus.received,
    );
