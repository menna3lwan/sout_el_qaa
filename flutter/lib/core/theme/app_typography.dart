import 'package:flutter/material.dart';

import 'app_colors.dart';

/// [A8] نفس ملحوظة الألوان — الأحجام هنا معقولة افتراضيًا (Material Design
/// scale قياسي)، مش مقاسة من الـFigma فعليًا (تعذّر أخذ screenshots — انظر
/// app_colors.dart). خط عربي حقيقي (مثال: Cairo/Tajawal) هيتضاف مع الأصول
/// الفعلية بدل الاعتماد على system font الافتراضي — غير مطلوب في foundation
/// عشان مفيش أصول محتاجينها فعليًا لسه (مبدأ عدم الإضافة الاستباقية، القسم 17).
abstract final class AppTypography {
  static const String? fontFamily = null; // TODO: خط عربي حقيقي لما يتحدد

  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.35,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );
}
