import 'package:fpdart/fpdart.dart';

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/comment.dart';
import '../../domain/entities/complaint.dart';
import '../../domain/repositories/complaint_repository.dart';
import '../../presentation/widgets/status_badge.dart' show ComplaintStatus;
import '../datasources/complaint_remote_data_source.dart';

final class ComplaintRepositoryImpl implements ComplaintRepository {
  const ComplaintRepositoryImpl(this._remote, this._networkInfo);

  final ComplaintRemoteDataSource _remote;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, List<Category>>> getCategories() =>
      _run(() => _remote.getCategories());

  @override
  Future<Either<Failure, List<Complaint>>> getTrending({int limit = 5}) =>
      _run(() => _remote.getTrending(limit));

  @override
  Future<Either<Failure, List<Complaint>>> getRecentActivity({int limit = 5}) =>
      _run(() => _remote.getRecentActivity(limit));

  @override
  Future<Either<Failure, List<Complaint>>> getComplaints({
    String? authorId,
    ComplaintStatus? status,
  }) =>
      _run(() => _remote.getComplaints(authorId: authorId, status: status));

  @override
  Future<Either<Failure, Complaint>> getComplaintById(String id) =>
      _run(() => _remote.getComplaintById(id));

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
      _run(
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
      _run(() => _remote.uploadMedia(filePath));

  @override
  Future<Either<Failure, List<Comment>>> getComments(String complaintId) =>
      _run(() => _remote.getComments(complaintId));

  @override
  Future<Either<Failure, Comment>> addComment({
    required String complaintId,
    required String text,
    required String authorName,
  }) =>
      _run(() =>
          _remote.addComment(complaintId, text: text, authorName: authorName));

  @override
  Future<Either<Failure, int>> like(String complaintId) =>
      _run(() => _remote.like(complaintId));

  @override
  Future<Either<Failure, int>> unlike(String complaintId) =>
      _run(() => _remote.unlike(complaintId));

  @override
  Future<Either<Failure, List<ComplaintMapPin>>> getMapPins() =>
      _run(() => _remote.getMapPins());

  /// Shared "check connectivity, run the call, map any error" shape for every method above — the
  /// only thing distinguishing them is *what* they fetch, not *how* errors/connectivity are handled
  /// (PLAN.md section 5: Data Flow), so that shared "how" lives in exactly one place.
  Future<Either<Failure, T>> _run<T>(Future<T> Function() call) async {
    if (!await _networkInfo.isConnected) {
      return const Left(NetworkFailure(message: 'noInternetConnectionMessage'));
    }
    try {
      return Right(await call());
    } catch (error) {
      return Left(ErrorMapper.map(error));
    }
  }
}
