import 'package:permission_handler/permission_handler.dart';

enum AppPermission { camera, gallery, location, notifications }

enum AppPermissionStatus { granted, denied, permanentlyDenied }

/// نقطة واحدة موحّدة لطلب/فحص أي إذن في التطبيق (كاميرا/جاليري/موقع/إشعارات)
/// — بدل ما كل feature تستخدم `permission_handler` مباشرة وتكرر منطق
/// "لو اترفض دايمًا، افتح الإعدادات" في كل مكان. القسم 1 (core/permissions).
abstract interface class PermissionService {
  Future<AppPermissionStatus> request(AppPermission permission);
  Future<AppPermissionStatus> check(AppPermission permission);
  Future<void> openSettings();
}

final class PermissionServiceImpl implements PermissionService {
  const PermissionServiceImpl();

  @override
  Future<AppPermissionStatus> request(AppPermission permission) async {
    final status = await _toPermission(permission).request();
    return _mapStatus(status);
  }

  @override
  Future<AppPermissionStatus> check(AppPermission permission) async {
    final status = await _toPermission(permission).status;
    return _mapStatus(status);
  }

  @override
  Future<void> openSettings() => openAppSettings();

  Permission _toPermission(AppPermission permission) => switch (permission) {
        AppPermission.camera => Permission.camera,
        AppPermission.gallery => Permission.photos,
        AppPermission.location => Permission.locationWhenInUse,
        AppPermission.notifications => Permission.notification,
      };

  AppPermissionStatus _mapStatus(PermissionStatus status) => switch (status) {
        PermissionStatus.granted || PermissionStatus.limited =>
          AppPermissionStatus.granted,
        PermissionStatus.permanentlyDenied =>
          AppPermissionStatus.permanentlyDenied,
        _ => AppPermissionStatus.denied,
      };
}
