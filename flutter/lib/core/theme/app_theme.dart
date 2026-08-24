import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// [ThemeData] موحّد للتطبيق. RTL بيتحدد على مستوى [MaterialApp.locale]
/// وليس هنا (انظر core/router/app_router.dart و l10n) — الـtheme مسؤول عن
/// المظهر البصري فقط. القيم هنا محدّثة بالكامل بعد مراجعة الـFigma الحقيقية
/// (24 أغسطس 2026) — راجعي app_colors.dart وapp_typography.dart لتفاصيل كل
/// قيمة ومصدرها، وأي نقطة لسه [Requires Confirmation].
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.headerBackground,
      primary: AppColors.headerBackground,
      secondary: AppColors.ctaBackground,
      error: AppColors.error,
      surface: AppColors.surfaceWhite,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.screenBackground,
      textTheme: TextTheme(
        headlineLarge: AppTypography.displayLarge,
        headlineMedium: AppTypography.pageHeading,
        headlineSmall: AppTypography.headingMedium,
        bodyLarge: AppTypography.fieldPlaceholder,
        bodyMedium: AppTypography.bodyDefault,
        bodySmall: AppTypography.metaText,
        labelLarge: AppTypography.chipLabel,
        labelSmall: AppTypography.navLabel,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.headerBackground,
        foregroundColor: AppColors.textOnBrand,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.headerTitle,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.ctaBackground,
          foregroundColor: AppColors.textPrimaryDark,
          textStyle: AppTypography.ctaLarge,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        // [A] لا يوجد مثال outlined button واضح في الشاشات الست المتاحة —
        // استخدمنا نفس منطق أزرار الـseverity toggle/filter tabs غير
        // المختارة (حدود #C3C6D3، خلفية بيضاء تقريبًا) كأقرب افتراض معقول.
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textSecondaryGrey,
          side: const BorderSide(color: AppColors.borderNeutral, width: 2),
          textStyle: AppTypography.chipLabel,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLightGrey,
        hintStyle: AppTypography.fieldPlaceholder,
        labelStyle: AppTypography.fieldLabel,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          borderSide: const BorderSide(
            color: AppColors.headerBackground,
            width: 2,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          borderSide: const BorderSide(
            color: AppColors.headerBackground,
            width: 2,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          borderSide: const BorderSide(
            color: AppColors.headerBackground,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceOffWhite,
        selectedColor: AppColors.headerBackground,
        labelStyle: AppTypography.chipLabel,
        side: const BorderSide(color: AppColors.borderNeutral, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLightGrey,
        selectedItemColor: AppColors.headerBackground,
        unselectedItemColor: AppColors.textSecondaryGrey,
        selectedLabelStyle: AppTypography.navLabel,
        unselectedLabelStyle: AppTypography.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
