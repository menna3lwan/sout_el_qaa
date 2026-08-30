import 'package:dio/dio.dart';

import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/dio_exception_guard.dart';
import '../models/user_model.dart';

/// Raw REST calls only — no [Either]/[Failure] here, that's [AuthRepositoryImpl]'s job; every Dio failure is normalized into a [ServerException] (see [guardDioCall]) so the Repository has one exception shape to catch.
abstract interface class AuthRemoteDataSource {
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  });
  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
  });
  Future<void> logout();
  Future<UserModel> getCurrentUser();
}

final class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  const AuthRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<AuthResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      ),
    );
    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<AuthResponseModel> register({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await guardDioCall(
      () => _dio.post<Map<String, dynamic>>(
        ApiEndpoints.register,
        data: {'username': username, 'email': email, 'password': password},
      ),
    );
    return AuthResponseModel.fromJson(response.data!);
  }

  @override
  Future<void> logout() async {
    await guardDioCall(() => _dio.post<void>(ApiEndpoints.logout));
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await guardDioCall(
      () => _dio.get<Map<String, dynamic>>(ApiEndpoints.me),
    );
    return UserModel.fromJson(response.data!);
  }
}
