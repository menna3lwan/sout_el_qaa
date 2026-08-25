import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_exception_guard.dart';
import '../models/notification_model.dart';

abstract interface class NotificationRemoteDataSource {
  Future<List<NotificationModel>> getNotifications(String userId);
  Future<void> markRead(String id);
  Future<void> markAllRead();
}

final class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  const NotificationRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<NotificationModel>> getNotifications(String userId) async {
    final response = await guardDioCall(
      () => _dio.get<List<dynamic>>(
        ApiEndpoints.notifications,
        queryParameters: {'userId': userId, '_sort': 'createdAt', '_order': 'desc'},
      ),
    );
    return response.data!
        .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> markRead(String id) async {
    await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(ApiEndpoints.notificationRead(id)),
    );
  }

  @override
  Future<void> markAllRead() async {
    await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(ApiEndpoints.notificationsReadAll),
    );
  }
}
