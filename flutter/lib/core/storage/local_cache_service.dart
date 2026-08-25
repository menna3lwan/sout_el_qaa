import 'package:hive_flutter/hive_flutter.dart';

/// Deliberately minimal: only Hive init + generic box helpers, no offline-first sync/conflict-resolution logic (PLAN.md section 17); feature-specific boxes register inside their own feature branch to keep Core feature-agnostic (PLAN.md section 1.10).
abstract final class LocalCacheService {
  /// Called once from [bootstrap.dart] before any Hive usage.
  static Future<void> init() async {
    await Hive.initFlutter();
    // TypeAdapters register here per branch as real models land — no box is opened speculatively.
  }

  /// Generic helper for any feature that needs to open a simple box later, instead of repeating Hive.openBox logic.
  static Future<Box<T>> openBox<T>(String name) {
    if (Hive.isBoxOpen(name)) {
      return Future.value(Hive.box<T>(name));
    }
    return Hive.openBox<T>(name);
  }
}
