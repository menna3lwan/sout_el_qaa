/// قيم/مفاتيح ثابتة مأخوذة من عالم "قاع الهامور" ومؤكدة فعليًا من مراجعة
/// الـFigma (القسم 15 من الـplan) — مش نصوص عرض قابلة للترجمة (دي وظيفة
/// ARB/l10n)، دي identifiers ثابتة عن domain الشكاوى تحديدًا.
///
/// **ملحوظة معمارية (بعد الـmonorepo restructure task):** الملف ده كان
/// اسمه `AppStrings` وجوه `core/constants/` — نُقل هنا واتسمى
/// `ComplaintConstants` لأنه عارف تفاصيل عن domain الشكاوى (تصنيفات، حالات،
/// درجات خطورة) مش identifiers عامة للتطبيق كله، فمكانه جوه `features/complaints/`
/// مش `core/` (نفس القاعدة المطبّقة على `StatusBadge` — انظر
/// `presentation/widgets/status_badge.dart`). لسه بيتستخدم من features تانية
/// (Home, Create Complaint) لأنهم أصلًا بيتعاملوا مع نفس الـentity
/// (الشكوى)، ده طبيعي وميعنيش رجوع الملف لـcore.
abstract final class ComplaintConstants {
  /// تصنيفات الشكاوى الأربعة المؤكدة نصيًا من شاشة Home — [A4] قابلة
  /// للتوسع لاحقًا (enum مش مقفول، أو driven-by-backend).
  static const List<String> confirmedCategorySlugs = [
    'water', // مياه
    'roads', // طرق
    'cleanliness', // نظافة
    'electricity', // كهرباء
  ];

  /// دورة حياة الشكوى المؤكدة (3 مراحل) من Complaint Details وComplaints List.
  static const List<String> complaintStatusSlugs = [
    'received', // تم الاستلام
    'inReview', // قيد المراجعة / قيد المعالجة
    'resolved', // تم الحل
  ];

  /// درجات الخطورة المؤكدة من نموذج تقديم الشكوى.
  static const List<String> severitySlugs = [
    'high', // عالية
    'medium', // متوسطة
    'low', // منخفضة
  ];
}
