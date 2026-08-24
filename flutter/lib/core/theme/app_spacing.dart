/// مقياس مسافات ونصف أقطار موحّد — يمنع أرقام sizing متفرقة (magic numbers)
/// منتشرة في كل widget. مبني على شبكة 4pt، ومُحدّث بقيم حقيقية مستخرجة من
/// مراجعة الـFigma الكاملة (24 أغسطس 2026) بعد ما كان placeholder [A8].
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;

  /// [إضافة جديدة بعد مراجعة الـFigma] 12 ظهرت كقيمة gap/padding متكررة
  /// جدًا في كل الشاشات الست (بين sm=8 وmd=16 على نفس شبكة الـ4pt) — مش
  /// موجودة في المقياس القديم رغم استخدامها الفعلي المتكرر.
  static const double space12 = 12;

  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8; // صندوق رفع الصور، صندوق الموقع
  static const double radiusMd = 12; // كروت الإحصائيات، قائمة الإعدادات
  static const double radiusLg = 16; // معظم الكروت (Trending, Description, Notification)

  /// [إضافة جديدة] نصف قطر زوايا الـheader والـBottomNavBar العلوية — قيمة
  /// متسقة 100% في كل الشاشات الست، مختلفة عن radiusLg.
  static const double radiusXl = 32;

  /// [إضافة جديدة] اختصار دلالي لـ"دائري بالكامل" (pills, avatars, chips)،
  /// بدل ما كل widget يكرر `BorderRadius.circular(9999)` بنفسه. مش رقم من
  /// عندنا — نفس القيمة الحرفية اللي استخدمها الـFigma في كل مكان.
  static const double radiusPill = 9999;

  /// [Requires Confirmation] القيمة الفعلية المرئية في الـscreenshot ووحدة
  /// الـBottomNavBar المستخدمة فعليًا في كل شاشة (bottom:0) = 80px، **مش 72**
  /// زي القيمة القديمة. يوجد طبقة "BottomNavBar" تانية بارتفاع 72px لكنها
  /// موجودة في كل شاشة خارج حدود الشاشة (`bottom: -165px`) — تكرار/بقايا
  /// تصميم غالبًا، مش حالة فعلية تانية (الـscreenshot بيأكد إن ظاهر واحد بس).
  /// خدنا الـ80 كقيمة حقيقية؛ لو المصمم أكد إن الطبقة التانية مقصودة لحاجة
  /// تانية، يحتاج تصحيح.
  static const double bottomNavHeight = 80;
}
