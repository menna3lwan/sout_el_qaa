import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../presentation/widgets/status_badge.dart' show ComplaintStatus;
import '../entities/category.dart';
import '../entities/comment.dart';
import '../entities/complaint.dart';

/// Owns the whole "complaint" domain (PLAN.md section 18) — every feature that shows complaints
/// (Home, Complaints List, Complaint Details, Map, Profile/My Complaints) depends on this one
/// interface instead of five features each inventing their own partial repository.
abstract interface class ComplaintRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Complaint>>> getTrending({int limit = 5});

  Future<Either<Failure, List<Complaint>>> getRecentActivity({int limit = 5});

  /// [authorId]/[status] filter server-side (json-server query params); both null returns every complaint.
  Future<Either<Failure, List<Complaint>>> getComplaints({String? authorId, ComplaintStatus? status});

  Future<Either<Failure, Complaint>> getComplaintById(String id);

  Future<Either<Failure, Complaint>> createComplaint({
    required String title,
    required String description,
    required String categoryId,
    required ComplaintSeverity severity,
    required String location,
    required double lat,
    required double lng,
    required List<String> mediaUrls,
    required String authorId,
  });

  /// Uploads one media file (mock: returns a placeholder URL — PLAN.md section 16 "Media" endpoint) and returns its URL for [createComplaint]'s mediaUrls.
  Future<Either<Failure, String>> uploadMedia(String filePath);

  Future<Either<Failure, List<Comment>>> getComments(String complaintId);

  Future<Either<Failure, Comment>> addComment({
    required String complaintId,
    required String text,
    required String authorName,
  });

  /// Returns the complaint's new like count.
  Future<Either<Failure, int>> like(String complaintId);

  Future<Either<Failure, int>> unlike(String complaintId);

  Future<Either<Failure, List<ComplaintMapPin>>> getMapPins();
}
