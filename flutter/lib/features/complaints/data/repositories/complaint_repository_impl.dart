import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../../../core/network/repository_guard.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/complaint.dart';
import '../../domain/entities/complaint_status.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../datasources/complaint_remote_data_source.dart';

final class ComplaintRepositoryImpl implements ComplaintRepository {
  const ComplaintRepositoryImpl(this._remote, this._networkInfo);

  final ComplaintRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Category>>> getCategories() =>
      guardNetworkCall(_networkInfo, () => _remote.getCategories());

  @override
  Future<Either<Failure, List<Complaint>>> getTrending({int limit = 5}) =>
      guardNetworkCall(_networkInfo, () => _remote.getTrending(limit));

  @override
  Future<Either<Failure, List<Complaint>>> getRecentActivity({int limit = 5}) =>
      guardNetworkCall(_networkInfo, () => _remote.getRecentActivity(limit));

  @override
  Future<Either<Failure, List<Complaint>>> getComplaints({
    String? authorId,
    ComplaintStatus? status,
  }) =>
      guardNetworkCall(
        _networkInfo,
        () => _remote.getComplaints(authorId: authorId, status: status),
      );

  @override
  Future<Either<Failure, Complaint>> getComplaintById(String id) =>
      guardNetworkCall(_networkInfo, () => _remote.getComplaintById(id));

  @override
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
  }) =>
      guardNetworkCall(
        _networkInfo,
        () => _remote.createComplaint({
          'title': title,
          'description': description,
          'categoryId': categoryId,
          'severity': severity.name,
          'status': ComplaintStatus.received.name,
          'location': location,
          'lat': lat,
          'lng': lng,
          'views': 0,
          'likes': 0,
          'mediaUrls': mediaUrls,
          'authorId': authorId,
          'createdAt': DateTime.now().toIso8601String(),
        }),
      );

  @override
  Future<Either<Failure, String>> uploadMedia(String filePath) =>
      guardNetworkCall(_networkInfo, () => _remote.uploadMedia(filePath));

  @override
  Future<Either<Failure, List<Comment>>> getComments(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.getComments(complaintId));

  @override
  Future<Either<Failure, Comment>> addComment({
    required String complaintId,
    required String text,
    required String authorName,
  }) =>
      guardNetworkCall(
        _networkInfo,
        () =>
            _remote.addComment(complaintId, text: text, authorName: authorName),
      );

  @override
  Future<Either<Failure, int>> like(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.like(complaintId));

  @override
  Future<Either<Failure, int>> unlike(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.unlike(complaintId));

  @override
  Future<Either<Failure, int>> dislike(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.dislike(complaintId));

  @override
  Future<Either<Failure, int>> undislike(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.undislike(complaintId));

  @override
  Future<Either<Failure, int>> report(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.report(complaintId));

  @override
  Future<Either<Failure, int>> unreport(String complaintId) =>
      guardNetworkCall(_networkInfo, () => _remote.unreport(complaintId));

  @override
  Future<Either<Failure, List<ComplaintMapPin>>> getMapPins() =>
      guardNetworkCall(_networkInfo, () => _remote.getMapPins());
}
