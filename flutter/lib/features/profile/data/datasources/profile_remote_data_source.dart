import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_exception_guard.dart';
import '../models/profile_stats_model.dart';

abstract interface class ProfileRemoteDataSource {
  Future<ProfileStatsModel> getStats();
}

final class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  const ProfileRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<ProfileStatsModel> getStats() async {
    final response = await guardDioCall(
      () => _dio.get<Map<String, dynamic>>(ApiEndpoints.myStats),
    );
    return ProfileStatsModel.fromJson(response.data!);
  }
}
