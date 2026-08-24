import 'dart:async';

import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/storage/local_cache_service.dart';

/// نقطة التهيئة الوحيدة قبل `runApp` — DI + Hive + error zone موحّد، بدل ما
/// `main.dart` يتحول لمكان مبعثر لكل حاجة init.
Future<void> bootstrap(Widget Function() appBuilder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await LocalCacheService.init();
      configureDependencies();

      runApp(appBuilder());
    },
    (error, stackTrace) {
      // TODO(polish): crash reporting integration لو اتقرر إنها في الـscope
      // (مش جزء من الـMVP الحالي — القسم 17). دلوقتي بنسجل في الـconsole
      // بس وقت التطوير عشان الـstack trace ميضيعش.
      debugPrint('Unhandled error: $error\n$stackTrace');
    },
  );
}
