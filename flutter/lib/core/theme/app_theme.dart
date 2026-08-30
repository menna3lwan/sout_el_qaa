import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_typography.dart';

/// Unified [ThemeData]; RTL is set via [MaterialApp.locale], not here (see
/// core/router/app_router.dart and l10n) — this only owns visual appearance.
abstract final class AppTheme {
  static ThemeData get light {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.headerBackground,
      primary: AppColors.headerBackground,
      secondary: AppColors.ctaBackground,
      error: AppColors.error,
      surface: AppColors.surfaceWhite,
    );

    final pillRadius = BorderRadius.circular(AppSpacing.radiusPill);
    final fieldRadius = BorderRadius.circular(AppSpacing.radiusLg);

    OutlineInputBorder fieldBorder(Color color, {double width = 1.5}) =>
        OutlineInputBorder(
          borderRadius: fieldRadius,
          borderSide: BorderSide(color: color, width: width),
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.screenBackground,
      splashFactory: InkRipple.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),
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
          foregroundColor: AppColors.ctaTextAlt,
          disabledBackgroundColor: AppColors.surfaceDisabled,
          disabledForegroundColor: AppColors.textFigmaDisabled,
          textStyle: AppTypography.ctaLarge,
          minimumSize: const Size.fromHeight(52),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: pillRadius),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.brandPrimary,
          side: const BorderSide(color: AppColors.borderFigmaDefault, width: 1.5),
          textStyle: AppTypography.chipLabel,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: pillRadius),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.brandPrimary,
          textStyle: AppTypography.linkButtonBold,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceWhite,
        hintStyle: AppTypography.fieldPlaceholder,
        labelStyle: AppTypography.fieldLabel,
        errorStyle: AppTypography.metaText.copyWith(color: AppColors.error),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        border: fieldBorder(AppColors.borderFigmaDefault),
        enabledBorder: fieldBorder(AppColors.borderFigmaDefault),
        focusedBorder: fieldBorder(AppColors.borderFigmaFocus, width: 2),
        errorBorder: fieldBorder(AppColors.error),
        focusedErrorBorder: fieldBorder(AppColors.error, width: 2),
        disabledBorder: fieldBorder(AppColors.surfaceDisabled),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surfaceWhite,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          side: const BorderSide(color: AppColors.cardBorder),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceOffWhite,
        selectedColor: AppColors.headerBackground,
        labelStyle: AppTypography.chipLabel,
        side: const BorderSide(color: AppColors.borderFigmaDefault),
        shape: RoundedRectangleBorder(borderRadius: pillRadius),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.headerBackground,
        contentTextStyle:
            AppTypography.bodyDefault.copyWith(color: AppColors.textOnBrand),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        ),
        titleTextStyle: AppTypography.sectionHeadingLarge
            .copyWith(color: AppColors.profileAccent),
        contentTextStyle: AppTypography.bodyDefault,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.surfaceWhite,
        showDragHandle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSpacing.radiusXl),
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.headerBackground,
        linearTrackColor: AppColors.statusStepPending,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceWhite,
        selectedItemColor: AppColors.headerBackground,
        unselectedItemColor: AppColors.textSecondaryGrey,
        selectedLabelStyle: AppTypography.navLabel,
        unselectedLabelStyle: AppTypography.navLabel,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      iconTheme: const IconThemeData(
        size: AppSpacing.iconMd,
        color: AppColors.headerBackground,
      ),
    );
  }
}
