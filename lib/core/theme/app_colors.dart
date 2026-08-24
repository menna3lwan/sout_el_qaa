import 'package:flutter/material.dart';

/// [A8] Assumption — palette مؤقتة، مش مستخرجة من قيم بكسل حقيقية من الـFigma.
///
/// السبب: ملف الـFigma مفيهوش أي design tokens/variables (`get_variable_defs`
/// رجّع فارغ — موثق في القسم 15 من الـplan)، والـsandbox المستخدم في هذه
/// الجلسة اتمنع من تحميل screenshots (شبكة محجوبة على figma.com). القيم تحت
/// مستوحاة من هوية "قاع الهامور" (أزرق محيط + أصفر إسفنجي + أحمر مرجاني)
/// كنقطة بداية معقولة، مش نهائية.
///
/// **لازم تتراجع مقابل Figma Inspect فعليًا (أو تتستبدل بقيم تديهالنا) قبل
/// أي شاشة تتعتبر "مطابقة للتصميم" في الـDoD.**
abstract final class AppColors {
  // --- Brand ---
  static const Color oceanBlue = Color(0xFF0B3D91); // خلفيات/أزرار أساسية
  static const Color oceanBlueLight = Color(0xFF3D6FC4);
  static const Color spongeYellow = Color(0xFFFFC93C); // CTA / highlights
  static const Color coralRed = Color(0xFFE8543E); // تحذيرات/خطورة عالية

  // --- Surface ---
  static const Color background = Color(0xFFF7F9FC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFEFF2F7);

  // --- Text ---
  static const Color textPrimary = Color(0xFF1A1E27);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textOnBrand = Color(0xFFFFFFFF);

  // --- Status (Complaint lifecycle — القسم 3.5/3.8) ---
  // كل حالة عندها لون نص + لون خلفية فاتح (tint) صريح — بدل ما نحسب شفافية
  // وقت التشغيل (.withOpacity/.withValues), عشان ده بيختلف توفره بين إصدارات
  // Flutter (withValues متوفر بس من 3.27+)، وإحنا مش عارفين إصدارك بالظبط
  // في الـsandbox ده (انظر Remaining Issues في تقرير الـbranch).
  static const Color statusReceived = Color(0xFF6B7280); // تم الاستلام
  static const Color statusReceivedBg = Color(0xFFF1F2F4);
  static const Color statusInReview = Color(0xFFF59E0B); // قيد المراجعة/المعالجة
  static const Color statusInReviewBg = Color(0xFFFEF3E2);
  static const Color statusResolved = Color(0xFF16A34A); // تم الحل
  static const Color statusResolvedBg = Color(0xFFE8F7EC);

  // --- Severity (القسم 3.6) ---
  static const Color severityHigh = Color(0xFFDC2626); // عالية
  static const Color severityMedium = Color(0xFFF59E0B); // متوسطة
  static const Color severityLow = Color(0xFF16A34A); // منخفضة

  // --- Semantic ---
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF16A34A);
  static const Color divider = Color(0xFFE5E7EB);
}
