import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../entities/category.dart';
import '../entities/comment.dart';
import '../entities/complaint.dart';
import '../entities/complaint_status.dart';

/// Owns the whole "complaint" domain — every feature that shows complaints depends on this one
/// interface instead of each inventing its own partial repository.
abstract interface class ComplaintRepository {
  Future<Either<Failure, List<Category>>> getCategories();

  Future<Either<Failure, List<Complaint>>> getTrending({int limit = 5});

  Future<Either<Failure, List<Complaint>>> getRecentActivity({int limit = 5});

  /// [authorId]/[status] filter server-side (json-server query params); both null returns every complaint.
  Future<Either<Failure, List<Complaint>>> getComplaints({
    String? authorId,
    ComplaintStatus? status,
  });

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

  /// Uploads one media file and returns its URL for [createComplaint]'s mediaUrls.
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

  /// Mirrors [like]/[unlike] exactly, just a second independent counter — no per-user "vote" state
  /// exists server-side to reconcile against.
  Future<Either<Failure, int>> dislike(String complaintId);

  Future<Either<Failure, int>> undislike(String complaintId);

  /// A tally of residents flagging the complaint as serious (not a moderation queue — see
  /// [Complaint.reports]'s doc comment). Returns the new report count.
  Future<Either<Failure, int>> report(String complaintId);

  Future<Either<Failure, int>> unreport(String complaintId);

  Future<Either<Failure, List<ComplaintMapPin>>> getMapPins();
}
