import 'dart:async';

import 'package:flutter/material.dart';

import 'core/di/injection.dart';
import 'core/locale/app_locale_cubit.dart';
import 'core/storage/local_cache_service.dart';

/// Single init point before runApp — DI + Hive + a unified error zone, instead of main.dart
/// becoming a dumping ground for init calls.
Future<void> bootstrap(Widget Function() appBuilder) async {
  await runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await LocalCacheService.init();
      configureDependencies();
      await getIt<AppLocaleCubit>().hydrate();

      runApp(appBuilder());
    },
    (error, stackTrace) {
      // TODO(polish): wire up crash reporting if it's added to scope; for now, log to console.
      debugPrint('Unhandled error: $error\n$stackTrace');
    },
  );
}
