import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/complaints/data/datasources/complaint_remote_data_source.dart';
import '../../features/complaints/data/repositories/complaint_repository_impl.dart';
import '../../features/complaints/domain/repositories/complaint_repository.dart';
import '../../features/complaints/presentation/cubit/complaint_details_cubit.dart';
import '../../features/complaints/presentation/cubit/complaints_cubit.dart';
import '../../features/create_complaint/presentation/cubit/create_complaint_cubit.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';
import '../../features/map/presentation/cubit/map_cubit.dart';
import '../../features/notifications/data/datasources/notification_remote_data_source.dart';
import '../../features/notifications/data/repositories/notification_repository_impl.dart';
import '../../features/notifications/domain/repositories/notification_repository.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/profile/data/datasources/profile_remote_data_source.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../network/dio_client.dart';
import '../network/interceptors/auth_interceptor.dart';
import '../network/network_info.dart';
import '../permissions/permission_service.dart';
import '../router/app_router.dart';
import '../storage/secure_storage_service.dart';

final GetIt getIt = GetIt.instance;

/// Manual get_it registration instead of @injectable codegen — build_runner has no network access in this sandbox (see branch report A9); swap in @InjectableInit once you can run it locally.
void configureDependencies() {
  // --- Storage ---
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  getIt.registerLazySingleton<SecureStorageService>(
    () => SecureStorageServiceImpl(getIt<FlutterSecureStorage>()),
  );

  // --- Network ---
  getIt.registerLazySingleton<Connectivity>(() => Connectivity());
  getIt.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(getIt<Connectivity>()),
  );
  getIt.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(getIt<SecureStorageService>()),
  );
  getIt.registerLazySingleton<Dio>(
    () => DioClientFactory(getIt<AuthInterceptor>()).create(),
  );

  // --- Permissions ---
  getIt.registerLazySingleton<PermissionService>(
    () => const PermissionServiceImpl(),
  );

  // --- Routing ---
  getIt.registerLazySingleton<GoRouter>(
    () => AppRouterFactory(getIt<SecureStorageService>()).create(),
  );

  // --- Auth feature ---
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      getIt<NetworkInfo>(),
      getIt<SecureStorageService>(),
    ),
  );
  // Factory, not singleton — every Cubit below is per-screen state (form drafts, loaded lists...)
  // and must not leak between separate visits to the same screen.
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));

  // --- Complaints feature (shared by Home/Complaints/Map/Create Complaint/Profile, PLAN.md section 18) ---
  getIt.registerLazySingleton<ComplaintRemoteDataSource>(
    () => ComplaintRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ComplaintRepository>(
    () => ComplaintRepositoryImpl(
        getIt<ComplaintRemoteDataSource>(), getIt<NetworkInfo>()),
  );
  getIt.registerFactory<ComplaintsCubit>(
    () => ComplaintsCubit(
        getIt<ComplaintRepository>(), getIt<SecureStorageService>()),
  );
  getIt.registerFactory<ComplaintDetailsCubit>(
    () => ComplaintDetailsCubit(
      getIt<ComplaintRepository>(),
      getIt<AuthRepository>(),
      getIt<SecureStorageService>(),
    ),
  );

  // --- Home feature ---
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<AuthRepository>(), getIt<ComplaintRepository>()),
  );

  // --- Create Complaint feature ---
  getIt.registerFactory<CreateComplaintCubit>(
    () => CreateComplaintCubit(
        getIt<ComplaintRepository>(), getIt<SecureStorageService>()),
  );

  // --- Map feature ---
  getIt.registerFactory<MapCubit>(() => MapCubit(getIt<ComplaintRepository>()));

  // --- Notifications feature ---
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
        getIt<NotificationRemoteDataSource>(), getIt<NetworkInfo>()),
  );
  getIt.registerFactory<NotificationsCubit>(
    () => NotificationsCubit(
        getIt<NotificationRepository>(), getIt<SecureStorageService>()),
  );

  // --- Profile feature ---
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(getIt<Dio>()),
  );
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
        getIt<ProfileRemoteDataSource>(), getIt<NetworkInfo>()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<AuthRepository>(), getIt<ProfileRepository>()),
  );
}
