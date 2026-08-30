import 'package:hive_flutter/hive_flutter.dart';

/// Deliberately minimal: only Hive init + generic box helpers, no offline-first
/// sync/conflict-resolution logic; feature-specific boxes register inside their own feature to
/// keep Core feature-agnostic.
abstract final class LocalCacheService {
  /// Called once from [bootstrap.dart] before any Hive usage.
  static Future<void> init() async {
    await Hive.initFlutter();
    // TypeAdapters register here per branch as real models land — no box is opened speculatively.
  }

  /// Generic helper so features open boxes without repeating Hive.openBox logic.
  static Future<Box<T>> openBox<T>(String name) {
    if (Hive.isBoxOpen(name)) {
      return Future.value(Hive.box<T>(name));
    }
    return Hive.openBox<T>(name);
  }
}
