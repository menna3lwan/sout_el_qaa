/// قيم/مفاتيح ثابتة مأخوذة من عالم "قاع الهامور" ومؤكدة فعليًا من مراجعة
/// الـFigma (القسم 15 من الـplan) — مش نصوص عرض قابلة للترجمة (دي وظيفة
/// ARB/l10n)، دي identifiers ثابتة هتتشارك بين أكتر من feature (Home,
/// Complaints, Create Complaint) فمكانها هنا في core مش داخل feature واحدة.
abstract final class AppStrings {
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
