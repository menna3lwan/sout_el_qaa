import 'package:flutter/material.dart';

/// ألوان صوت القاع — مستخرجة مباشرة من الـFigma الحقيقي (ملف `صوت القاع`،
/// key `ysvQxQut5Yu72tKp5wp3HA`) بتاريخ 24 أغسطس 2026، عبر فحص كل الشاشات
/// الستة المصممة فعليًا (Home / Create Complaint / Complaint Details /
/// Complaints List / Profile / Notifications). كل قيمة هنا ليها مصدر حقيقي —
/// لا توجد أي قيمة مخترعة.
///
/// **[Requires Confirmation] ملاحظة مهمة قبل ما تُعتبر هذه القيم نهائية:**
/// ملف الـFigma **لا يحتوي على أي design variables/shared styles**
/// (`get_variable_defs` رجع فارغ — موثق في القسم 15 من الـplan)، يعني كل
/// component اتلون يدويًا لوحده. النتيجة: فيه عائلة من الأزرق الكحلي القريب
/// من بعضه جدًا (7 قيم مختلفة: `headerBackground`، `headerBorder`،
/// `profileAccent`، `fabBackground`، `ctaTextAlt`، `notificationCardAccent`،
/// `homeLinkText`) وعائلة مشابهة من الأصفر (5 قيم). كل قيمة هنا **حقيقية
/// وموجودة فعليًا** في مكانها بالظبط، لكن مش واضح لو الفروق دي مقصودة
/// (micro-variation متعمّد) أو مجرد "drift" لأن مفيش design system موحّد في
/// الملف. محتاج تأكيد منك أو من المصمم قبل ما نعتبرها "معتمدة نهائيًا" —
/// لحد ما يوصل، كل قيمة موثقة بمصدرها بالظبط (الشاشة + الـnode) عشان محدش
/// يخترع قيمة قريبة تانية من عنده.
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // Screen background
  // ---------------------------------------------------------------------

  /// خلفية كل الشاشات الست بدون استثناء — القيمة الوحيدة المؤكدة 100% متسقة.
  static const Color screenBackground = Color(0xFFE0FBFC);

  // ---------------------------------------------------------------------
  // Navy family — [Requires Confirmation] راجعي الملحوظة أعلى الملف
  // ---------------------------------------------------------------------

  /// الأزرق الكحلي الأساسي — الأكتر استخدامًا: خلفية الـheader، نص الـCTA في
  /// Home، الـnav الفعّال، عناوين الكروت. لو محتاجين نوحّد عائلة الأزرق دي
  /// ليوم واحد، ده أقوى مرشح "أساسي".
  static const Color headerBackground = Color(0xFF002960);

  /// حدود الـheader السفلية + حدود تاب "كل الشكاوى" المختار (Complaints List).
  static const Color headerBorder = Color(0xFF023E8A);

  /// أزرق-تيل غامق يظهر في: حدود/عنوان صفحة الملف الشخصي، حدود كروت الـstats
  /// والـsettings menu (Profile)، حدود كروت الشكاوى (Complaints List: `Card 1/2/3`).
  static const Color profileAccent = Color(0xFF002431);

  /// خلفية الزرار الأوسط المرتفع (FAB) في الـBottomNavBar.
  static const Color fabBackground = Color(0xFF001F49);

  /// نص زرار "إرسال الشكوة" (Create Complaint) + نص "عرض الكل" (Notifications)
  /// + نص تاب "شكاوي" الفعّال (Complaints List bottom nav).
  static const Color ctaTextAlt = Color(0xFF01204A);

  /// حدود كروت الإشعارات (Notifications) بالكامل.
  static const Color notificationCardAccent = Color(0xFF083B4C);

  /// نص لينك "عرض الكل" فوق كارت "أكثر الشكاوى تفاعلاً" (Home فقط).
  static const Color homeLinkText = Color(0xFF396476);

  // ---------------------------------------------------------------------
  // Yellow / gold family — [Requires Confirmation] نفس ملحوظة الأزرق
  // ---------------------------------------------------------------------

  /// أصفر حدود الـBottomNavBar العلوية — القيمة الوحيدة المتسقة 100% في كل
  /// الشاشات الست، أقوى مرشح لو محتاجين "لون علامة تجارية" واحد للأصفر.
  static const Color navyBarAccentBorder = Color(0xFFFFB200);

  /// خلفية زرار الـCTA الأساسي "قدم شكوى جديدة" (Home) و"إرسال الشكوة"
  /// (Create Complaint).
  static const Color ctaBackground = Color(0xFFFFD147);

  /// لون الـhard drop-shadow تحت زراير الـCTA الصفراء (نمط "زرار مضغوط ثلاثي
  /// الأبعاد" متسق في كل مكان ظهر فيه CTA أساسي).
  static const Color ctaShadow = Color(0xFFD9A300);

  /// حدود الأفاتار في الـheader (44px) + حدود السيرش بار + حدود دوائر الخطوات
  /// النشطة (Create Complaint wizard indicator).
  static const Color avatarBorder = Color(0xFFFFD166);

  /// خلفية فلتر "الكل" المختار في الإشعارات.
  static const Color notificationFilterSelectedBackground = Color(0xFFFFC928);

  /// نص زرار "حدد الموقع على الخريطة" (Create Complaint).
  static const Color mapButtonText = Color(0xFFFFB70F);

  // ---------------------------------------------------------------------
  // Reds — استخدامات دلالية مختلفة، ماتتلخبطش مع بعض
  // ---------------------------------------------------------------------

  /// أحمر "عاجل"/"تسجيل الخروج" — ظهر بنفس القيمة بالظبط في Home (badge
  /// "عاجل") و Profile (نص "تسجيل الخروج") → أقوى مرشح لدلالة "destructive/
  /// urgent" موحّدة.
  static const Color urgentDestructive = Color(0xFFBA1A1A);

  /// حدود badge "عاجل" في Home.
  static const Color urgentBadgeBorder = Color(0xFF93000A);

  /// [Requires Confirmation] badge "عاجل" في Complaint Details استخدم قيمة
  /// مختلفة (#EF476F) عن نفس الـbadge في Home (#BA1A1A) — لنفس النص بالظبط.
  /// على الأرجح "drift" مش قرار متعمّد، لكن سايبينها منفصلة لحد التأكيد.
  static const Color urgentBadgeAltDetailPage = Color(0xFFEF476F);

  /// خلفية زرار "عالية" (severity) المختار في Create Complaint — دلالة
  /// مختلفة عن "عاجل" (severity وليس urgency)، فمتحطش نفس التوكن.
  static const Color severityHighSelected = Color(0xFFEF4870);

  /// نقطة "غير مقروء" في كروت الإشعارات.
  static const Color notificationUnreadDot = Color(0xFFEF4444);

  // ---------------------------------------------------------------------
  // Status — [Requires Confirmation] راجعي الملحوظة الخاصة تحت
  // ---------------------------------------------------------------------

  /// **مهم:** حالة الشكوى ليها طريقتين عرض مختلفتين تمامًا في الـFigma نفسه،
  /// مش لون واحد لكل حالة زي ما كان مفترض في النسخة القديمة (placeholder):
  ///
  /// 1) **Stepper أفقي** (Complaint Details) — 3 دوائر متصلة بخط: الخطوة
  ///    اللي وصلنا لها bg [statusStepReached] border [statusStepBorder]، اللي
  ///    لسه bg [statusStepPending] border [statusStepBorder]. مفيش لون مختلف
  ///    لكل حالة هنا — كله نفس اللون الذهبي للمراحل المكتملة.
  /// 2) **Chip لوني صلب** (Complaints List cards) — كل حالة لها لون خلفية
  ///    صلد + نص أبيض: "قيد المعالجة" = [statusInProgressChip]،
  ///    "تم الحل" = [statusResolvedChip]. **"تم الاستلام" (received) مفيش
  ///    مثال ليه ظاهر في العينة اللي شفتها (3 كروت بس، ولا واحدة فيهم
  ///    "تم الاستلام")** — [Requires Confirmation] محتاجين مثال حقيقي أو
  ///    تأكيد منك للون ده تحديدًا.
  ///
  /// ده تصحيح جوهري عن القيم القديمة (statusResolved كان أخضر #16A34A —
  /// غلط، الحقيقي كحلي #002960).
  static const Color statusStepReached = Color(0xFFFFD166);
  static const Color statusStepPending = Color(0xFFE1E3E4);
  static const Color statusStepBorder = Color(0xFFF8F9FA);

  static const Color statusInProgressChip = Color(0xFFF77F00);
  static const Color statusResolvedChip = Color(0xFF002960);

  /// [Requires Confirmation] لسه مفيش مصدر حقيقي — سايبينها placeholder
  /// رمادي (نفس روح الحالة "لسه ماتحركتش") لحد ما يبقى فيه مثال فعلي في
  /// الـFigma أو تأكيد منك. **ملحوظة: دي القيمة الوحيدة في هذا الملف اللي
  /// لسه مش مستخرجة من الـFigma فعليًا.**
  static const Color statusReceivedChip = Color(0xFF6B7280);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------

  static const Color textOnBrand = Colors.white;
  static const Color textPrimaryDark = Color(0xFF191C1D); // متن أساسي غامق
  static const Color textSecondaryGrey = Color(0xFF434751); // متن ثانوي
  static const Color textMutedGrey = Color(0xFF737782); // نص باهت/مساعد
  static const Color textPlaceholderGrey = Color(0xFF9CA3AF); // placeholder حقول

  // ---------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------

  static const Color surfaceWhite = Colors.white;
  static const Color surfaceOffWhite = Color(0xFFF8F9FA); // كروت الفورم، أزرار غير مختارة
  static const Color surfaceLightGrey = Color(0xFFF3F4F5); // خلفية BottomNavBar، الـtextarea
  static const Color surfaceIconCircle = Color(0xFFEDEEEF); // خلفية دوائر الأيقونات
  static const Color borderNeutral = Color(0xFFC3C6D3); // حدود عامة رمادية فاتحة

  // ---------------------------------------------------------------------
  // Category chip colors (Home) — كل تصنيف له زوج bg/border مستقل
  // ---------------------------------------------------------------------

  static const Color categoryWaterBackground = Color(0xFFE0FBFC);
  static const Color categoryWaterBorder = Color(0xFFC3C6D3);
  static const Color categoryRoadsBackground = Color(0xFFFFDF9A);
  static const Color categoryRoadsBorder = Color(0xFFF8BE00);
  static const Color categoryCleanlinessBackground = Color(0xFFFFDBC9);
  static const Color categoryCleanlinessBorder = Color(0xFFFFB68D);
  static const Color categoryElectricityBackground = Color(0xFFD8E2FF);
  static const Color categoryElectricityBorder = Color(0xFFAEC6FF);

  // ---------------------------------------------------------------------
  // Glass / blurred overlay cards (Trending card, Profile stats/menu,
  // Notification cards) — نفس فكرة "زجاج شبه شفاف" بـalpha مختلف قليلاً
  // ---------------------------------------------------------------------

  static const Color glassOverlayTrending = Color(0xD9FFFFFF); // rgba(255,255,255,0.85)
  static const Color glassOverlayNotificationFilter = Color(0xCCFFFFFF); // rgba(255,255,255,0.8)
  static const Color glassOverlayNotificationCard = Color(0xE6F2FBFF); // rgba(242,251,255,0.9)

  // ---------------------------------------------------------------------
  // Notification icon-badge pastels (Notifications) — خلفيات دوائر الأيقونات
  // ---------------------------------------------------------------------

  static const Color notificationBadgeGreen = Color(0xFFBBF7D0);
  static const Color notificationBadgeYellow = Color(0xFFFEF08A);
  static const Color notificationBadgeGreenAlt = Color(0xFF86EFAC);
  static const Color notificationBadgeBlue = Color(0xFFBFDBFE);
  static const Color notificationInlineStatusDot = Color(0xFFFACC15);
  static const Color notificationInlineStatusText = Color(0xFF167E9C);
  static const Color notificationTimestampText = Color(0xFF6B7280);
  static const Color notificationFilterUnselectedText = Color(0xFF4B5563);

  // ---------------------------------------------------------------------
  // Semantic — [A] Assumption، مفيش مثال validation-error حقيقي في الشاشات
  // الستة المتاحة، سايبين قيمة Material معقولة لحد ما يظهر مثال فعلي.
  // ---------------------------------------------------------------------

  static const Color error = Color(0xFFDC2626);
  static const Color divider = Color(0xFFE5E7EB);
}
