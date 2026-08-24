import 'package:hive_flutter/hive_flutter.dart';

/// نطاق foundation branch متعمّد إنه محدود: بس تهيئة Hive + فتح boxes عامة.
///
/// **ملحوظة مهمة (تعليمات صريحة):** إحنا مش بنبني offline-first architecture
/// كاملة هنا (background sync, conflict resolution, إلخ) — ده Future/Optional
/// حسب القسم 17 من الـplan. اللي فعلًا MVP دلوقتي هو drafts تقديم الشكوى بس،
/// وده هيتضاف كـbox خاص بيه (`create_complaint_drafts`) جوه
/// `feature/sandy-create-complaint` نفسها لما الـfeature تتنفذ، مش هنا —
/// عشان الملف ده يفضل بلا معرفة بأي feature معينة (Core لازم يكون
/// feature-agnostic، القسم 1.10).
abstract final class LocalCacheService {
  /// بينادى مرة واحدة من [bootstrap.dart] قبل أي استخدام لـHive.
  static Future<void> init() async {
    await Hive.initFlutter();
    // TypeAdapters بتتسجل هنا فرع بفرع لما الـmodels الفعلية تتعمل
    // (Hive.registerAdapter(...))  — مفيش أي box يتفتح هنا استباقيًا.
  }

  /// helper عام لأي feature تحتاج تفتح box بسيط لاحقًا، بدل ما كل feature
  /// تكرر منطق `Hive.openBox` بنفسها.
  static Future<Box<T>> openBox<T>(String name) {
    if (Hive.isBoxOpen(name)) {
      return Future.value(Hive.box<T>(name));
    }
    return Hive.openBox<T>(name);
  }
}
