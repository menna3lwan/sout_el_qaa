import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

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

  // Feature-specific registrations are added per branch as features land, not speculatively (PLAN.md section 17).
}
