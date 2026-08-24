import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// أنماط النصوص — مستخرجة مباشرة من الـFigma الحقيقي (نفس مصدر app_colors.dart،
/// 24 أغسطس 2026). الـFigma بيستخدم **3 عائلات خطوط حقيقية**، مش خط واحد:
///
/// - **Baloo Bhaijaan 2** — العناوين الكبيرة، أزرار الـCTA، التحية في الـheader.
///   خط عربي دائري بارز، مناسب لهوية "قاع الهامور" المرحة.
/// - **Cairo** — كل المتن والنصوص الثانوية (labels، nav، body، معظم الواجهة).
/// - **Be Vietnam Pro** — [Requires Confirmation] ظهر **حصريًا** على عناصر
///   رقمية بس: أرقام خطوات الـwizard (1/2/3)، عداد حروف الوصف (0/300)، عداد
///   الردود على التعليق. ممكن يكون قرار تصميم متعمّد (خط مختلف للأرقام)، أو
///   مجرد اختيار عشوائي وقت التصميم — علشان كده مصنّف "يحتاج تأكيد" مش
///   [Confirmed]. لو مش هيتأكد، أبسط حل وقت التنفيذ إنه يتحط جوه Cairo
///   العادي بدل إضافة خط تالت للتطبيق كله لأجل أرقام بس.
///
/// [P] Proposed: إضافة `google_fonts` كـdependency جديدة (مش موجودة قبل
/// كده في pubspec.yaml) — أبسط طريقة نجيب بيها الثلاث خطوط دول حقيقي بدل
/// خط النظام الافتراضي، وكلهم مدعومين عليها ومدعومين عربي. البديل (تحميل
/// ملفات .ttf يدويًا وتسجيلها في pubspec assets) ممكن لاحقًا لو حبيتي ضمان
/// عمل offline من أول تشغيل بدل استخدام كاش google_fonts وقت أول تحميل.
///
/// خط "Liberation Sans" و"FreeSerif" اللي ظهروا في بعض العناصر (الإيموجي
/// 👋، ونص "عاجل"/"الموقع" في بعض الأماكن) **متجاهلين عمدًا** — أول واحد
/// مجرد fallback رسم إيموجي من الـFigma مش اختيار خط حقيقي، والتاني ظهر
/// بشكل غير متسق (نفس النص "عاجل" جه بخط Cairo في شاشة و FreeSerif في
/// شاشة تانية) وده تأكيد إنه glitch مش قرار تصميم — راجعي تقرير الجلسة.
abstract final class AppTypography {
  // ---------------------------------------------------------------------
  // Baloo Bhaijaan 2 — عناوين كبيرة / CTA / ترحيب
  // ---------------------------------------------------------------------

  /// "أكثر الشكاوى تفاعلاً" (Home section heading) — 24px/34 Bold.
  static TextStyle get displayLarge => GoogleFonts.balooBhaijaan2(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.profileAccent,
        height: 34 / 24,
      );

  /// "صوت القاع"، عنوان الـheader الرئيسي — 20px/32 SemiBold، أبيض عادة.
  static TextStyle get headerTitle => GoogleFonts.balooBhaijaan2(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnBrand,
        height: 32 / 20,
      );

  /// "تصنيفات الشكاوى" (Home sub-heading) — 16px/34 Bold.
  static TextStyle get headingMedium => GoogleFonts.balooBhaijaan2(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.profileAccent,
        height: 34 / 16,
      );

  /// "قدم شكوى جديدة" (زرار CTA أساسي) — 18px/28 SemiBold.
  static TextStyle get ctaLarge => GoogleFonts.balooBhaijaan2(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 28 / 18,
      );

  /// "إرسال الشكوة" (زرار CTA أصغر) — 14px/28 SemiBold.
  static TextStyle get ctaSmall => GoogleFonts.balooBhaijaan2(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.ctaTextAlt,
        height: 28 / 14,
      );

  /// "نشاطاتك الأخيرة" (Home) — 14px/20 SemiBold + letter-spacing 0.5.
  static TextStyle get sectionLabel => GoogleFonts.balooBhaijaan2(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimaryDark,
        letterSpacing: 0.5,
        height: 20 / 14,
      );

  /// "صباح الفل يا ساكن المحيط!" (تحية الـheader) — 16px/32 Medium.
  static TextStyle get greeting => GoogleFonts.balooBhaijaan2(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnBrand,
        height: 32 / 16,
      );

  // ---------------------------------------------------------------------
  // Cairo — متن / labels / nav / معظم الواجهة
  // ---------------------------------------------------------------------

  /// عنوان صفحة (مثال: "حالة الشكوى" Complaint Details) — 24px/32 SemiBold.
  static TextStyle get pageHeading => GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.headerBackground,
        height: 32 / 24,
      );

  /// عنوان اسم المستخدم (Profile) — 28px/38 Bold.
  static TextStyle get profileName => GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.profileAccent,
        height: 38 / 28,
      );

  /// عنوان الشكوى في صفحة التفاصيل — 20px/40 SemiBold.
  static TextStyle get complaintTitle => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.headerBackground,
        height: 40 / 20,
      );

  /// عنوان كارت (عنوان شكوى في القائمة، عنوان قسم "التفاصيل") — 16px/24 Regular.
  static TextStyle get cardTitle => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.headerBackground,
        height: 24 / 16,
      );

  /// متن أساسي (وصف الشكوى، وصف التعليق) — 12px/24 Regular.
  static TextStyle get bodyDefault => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: 24 / 12,
      );

  /// label حقل فورم (نوع المشكلة، وصف المشكلة، درجة الخطورة) — 14px/20 Regular
  /// + letter-spacing 0.5.
  static TextStyle get fieldLabel => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        letterSpacing: 0.5,
        height: 20 / 14,
      );

  /// نص عناصر الـBottomNavBar — 12px/16 Regular.
  static TextStyle get navLabel => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      );

  /// نص ثانوي/meta (موقع، وقت نسبي) — 12px/16-24 Regular (الـline-height
  /// اختلف شوية بين الأماكن في الـFigma، الأقرب المتفق عليه 16).
  static TextStyle get metaText => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryGrey,
        height: 16 / 12,
      );

  /// نص placeholder داخل الحقول — 16px/24 Regular.
  static TextStyle get fieldPlaceholder => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPlaceholderGrey,
        height: 24 / 16,
      );

  /// نص chip/tab صغير (فلاتر، status chip) — 14-16px SemiBold حسب المكان.
  static TextStyle get chipLabel => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      );

  /// نص chip حالة صغير جدًا (StatusChip في كارت القائمة) — 10px/15 Regular.
  static TextStyle get statusChipLabel => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textOnBrand,
        height: 15 / 10,
      );

  /// caption صغيرة جدًا (label الخطوة تحت دائرة الـstepper) — 10px/16 Regular.
  static TextStyle get stepLabel => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 16 / 10,
      );

  // ---------------------------------------------------------------------
  // Be Vietnam Pro — [Requires Confirmation] عناصر رقمية فقط
  // ---------------------------------------------------------------------

  /// أرقام خطوات الـwizard / عداد الحروف / عداد الردود — 12-15px Medium/Bold.
  static TextStyle get numericCounter => GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14,
      );
}
