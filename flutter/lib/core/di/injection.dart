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

/// ⚠️ **Remaining Issue موثّق في تقرير الـbranch [A9]:** القرار المعتمد
/// [C6] هو `get_it` + `injectable` مع code generation (`@lazySingleton` /
/// `@injectable`). الـsandbox المستخدم في هذه الجلسة معندوش وصول شبكة لتشغيل
/// `build_runner` (pub.dev/storage.googleapis.com محجوبين — Remaining
/// Issues كاملة في تقرير الـbranch). فبدل ما نمنع كل الـfoundation على ده،
/// التسجيل هنا **يدوي مباشر عبر get_it**، بنفس البنية والنتيجة النهائية.
/// لما تشغّلي `build_runner` محليًا، سهل نستبدل الملف ده بـ`@InjectableInit`
/// + الكلاسات تتحط عليها annotations — التغيير محصور في هذا الملف بس.
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

  // Feature-specific registrations (repositories/usecases/cubits) بتتضاف
  // مع كل branch لما الـfeature المعنية تتنفذ فعليًا — مفيش تسجيل استباقي
  // لحاجة لسه مالهاش تنفيذ حقيقي (القسم 17: مفيش إضافة بدون سبب واضح وقريب).
}
