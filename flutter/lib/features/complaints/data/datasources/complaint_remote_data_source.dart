import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_exception_guard.dart';
import '../../domain/entities/complaint_status.dart';
import '../models/category_model.dart';
import '../models/comment_model.dart';
import '../models/complaint_map_pin_model.dart';
import '../models/complaint_model.dart';

abstract interface class ComplaintRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<List<ComplaintModel>> getTrending(int limit);
  Future<List<ComplaintModel>> getRecentActivity(int limit);
  Future<List<ComplaintModel>> getComplaints(
      {String? authorId, ComplaintStatus? status});
  Future<ComplaintModel> getComplaintById(String id);
  Future<ComplaintModel> createComplaint(Map<String, dynamic> body);
  Future<String> uploadMedia(String filePath);
  Future<List<CommentModel>> getComments(String complaintId);
  Future<CommentModel> addComment(String complaintId,
      {required String text, required String authorName});
  Future<int> like(String complaintId);
  Future<int> unlike(String complaintId);
  Future<List<ComplaintMapPinModel>> getMapPins();
}

final class ComplaintRemoteDataSourceImpl implements ComplaintRemoteDataSource {
  const ComplaintRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await guardDioCall(
        () => _dio.get<List<dynamic>>(ApiEndpoints.categories));
    return response.data!
        .map((json) => CategoryModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<ComplaintModel>> getTrending(int limit) async {
    final response = await guardDioCall(
      () => _dio.get<List<dynamic>>(
        ApiEndpoints.trendingComplaints,
        queryParameters: {'limit': limit},
      ),
    );
    return _toComplaintList(response.data!);
  }

  @override
  Future<List<ComplaintModel>> getRecentActivity(int limit) async {
    final response = await guardDioCall(
      () => _dio.get<List<dynamic>>(
        ApiEndpoints.recentActivity,
        queryParameters: {'limit': limit},
      ),
    );
    return _toComplaintList(response.data!);
  }

  @override
  Future<List<ComplaintModel>> getComplaints(
      {String? authorId, ComplaintStatus? status}) async {
    final response = await guardDioCall(
      () => _dio.get<List<dynamic>>(
        ApiEndpoints.complaints,
        queryParameters: {
          if (authorId != null) 'authorId': authorId,
          if (status != null) 'status': status.name,
          '_sort': 'createdAt',
          '_order': 'desc',
        },
      ),
    );
    return _toComplaintList(response.data!);
  }

  @override
  Future<ComplaintModel> getComplaintById(String id) async {
    final response = await guardDioCall(
      () => _dio.get<Map<String, dynamic>>(ApiEndpoints.complaintById(id)),
    );
    return ComplaintModel.fromJson(response.data!);
  }

  @override
  Future<ComplaintModel> createComplaint(Map<String, dynamic> body) async {
    final response = await guardDioCall(
      () =>
          _dio.post<Map<String, dynamic>>(ApiEndpoints.complaints, data: body),
    );
    return ComplaintModel.fromJson(response.data!);
  }

  @override
  Future<String> uploadMedia(String filePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(filePath),
    });
    final response = await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(ApiEndpoints.media, data: formData),
    );
    return response.data!['url'] as String;
  }

  @override
  Future<List<CommentModel>> getComments(String complaintId) async {
    final response = await guardDioCall(
      () => _dio.get<Map<String, dynamic>>(ApiEndpoints.comments(complaintId)),
    );
    final items = response.data!['items'] as List<dynamic>;
    return items
        .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CommentModel> addComment(
    String complaintId, {
    required String text,
    required String authorName,
  }) async {
    final response = await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(
        ApiEndpoints.comments(complaintId),
        data: {'text': text, 'authorName': authorName},
      ),
    );
    return CommentModel.fromJson(response.data!);
  }

  @override
  Future<int> like(String complaintId) async {
    await guardDioCall(() =>
        _dio.post<Map<String, dynamic>>(ApiEndpoints.reactions(complaintId)));
    final complaint = await getComplaintById(complaintId);
    return complaint.likes;
  }

  @override
  Future<int> unlike(String complaintId) async {
    await guardDioCall(() =>
        _dio.delete<Map<String, dynamic>>(ApiEndpoints.reactions(complaintId)));
    final complaint = await getComplaintById(complaintId);
    return complaint.likes;
  }

  @override
  Future<List<ComplaintMapPinModel>> getMapPins() async {
    final response = await guardDioCall(
        () => _dio.get<List<dynamic>>(ApiEndpoints.complaintsMap));
    return response.data!
        .map((json) =>
            ComplaintMapPinModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  List<ComplaintModel> _toComplaintList(List<dynamic> data) => data
      .map((json) => ComplaintModel.fromJson(json as Map<String, dynamic>))
      .toList();
}
