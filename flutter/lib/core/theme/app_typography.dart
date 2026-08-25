import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Figma uses 3 real font families (not 1): Baloo Bhaijaan 2 (large headings/CTAs/greeting), Cairo (body/labels/nav, most of the UI), and Be Vietnam Pro ([Requires Confirmation] numeric-only elements — wizard step numbers, char counters — may be intentional or incidental, fold into Cairo if unconfirmed); google_fonts is a [P] Proposed new dependency to source them; "Liberation Sans"/"FreeSerif" appearances are excluded as Figma rendering glitches, not real font choices (see branch report).
abstract final class AppTypography {
  // ---------------------------------------------------------------------
  // Baloo Bhaijaan 2 — large headings / CTAs / greeting
  // ---------------------------------------------------------------------

  /// "أكثر الشكاوى تفاعلاً" (Home section heading) — 24px/34 Bold.
  static TextStyle get displayLarge => GoogleFonts.balooBhaijaan2(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: AppColors.profileAccent,
        height: 34 / 24,
      );

  /// "صوت القاع" — the main header title, 20px/32 SemiBold, usually white.
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

  /// "قدم شكوى جديدة" (primary CTA button) — 18px/28 SemiBold.
  static TextStyle get ctaLarge => GoogleFonts.balooBhaijaan2(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 28 / 18,
      );

  /// "إرسال الشكوة" (smaller CTA button) — 14px/28 SemiBold.
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

  /// "صباح الفل يا ساكن المحيط!" (header greeting) — 16px/32 Medium.
  static TextStyle get greeting => GoogleFonts.balooBhaijaan2(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textOnBrand,
        height: 32 / 16,
      );

  // ---------------------------------------------------------------------
  // Cairo — body / labels / nav / most of the UI
  // ---------------------------------------------------------------------

  /// Page heading (e.g. "حالة الشكوى", Complaint Details) — 24px/32 SemiBold.
  static TextStyle get pageHeading => GoogleFonts.cairo(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: AppColors.headerBackground,
        height: 32 / 24,
      );

  /// User display-name heading (Profile) — 28px/38 Bold.
  static TextStyle get profileName => GoogleFonts.cairo(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: AppColors.profileAccent,
        height: 38 / 28,
      );

  /// Complaint title on the details page — 20px/40 SemiBold.
  static TextStyle get complaintTitle => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: AppColors.headerBackground,
        height: 40 / 20,
      );

  /// Card title (complaint title in list, "Details" section heading) — 16px/24 Regular.
  static TextStyle get cardTitle => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.headerBackground,
        height: 24 / 16,
      );

  /// Primary body text (complaint description, comment text) — 12px/24 Regular.
  static TextStyle get bodyDefault => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        height: 24 / 12,
      );

  /// Form field label (issue type, description, severity) — 14px/20 Regular + letter-spacing 0.5.
  static TextStyle get fieldLabel => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimaryDark,
        letterSpacing: 0.5,
        height: 20 / 14,
      );

  /// BottomNavBar item text — 12px/16 Regular.
  static TextStyle get navLabel => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      );

  /// Secondary/meta text (location, relative time) — 12px/16 Regular (line-height varied slightly across Figma; 16 is the closest consistent value).
  static TextStyle get metaText => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondaryGrey,
        height: 16 / 12,
      );

  /// Placeholder text inside form fields — 16px/24 Regular.
  static TextStyle get fieldPlaceholder => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPlaceholderGrey,
        height: 24 / 16,
      );

  /// Small chip/tab text (filters, status chip) — 14-16px SemiBold depending on placement.
  static TextStyle get chipLabel => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 24 / 16,
      );

  /// Very small status-chip text (StatusChip on list cards) — 10px/15 Regular.
  static TextStyle get statusChipLabel => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: AppColors.textOnBrand,
        height: 15 / 10,
      );

  /// Very small caption (step label under the stepper circle) — 10px/16 Regular.
  static TextStyle get stepLabel => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 16 / 10,
      );

  // ---------------------------------------------------------------------
  // Be Vietnam Pro — [Requires Confirmation], numeric elements only
  // ---------------------------------------------------------------------

  /// Wizard step numbers / character counter / reply counter — 12-15px Medium/Bold.
  static TextStyle get numericCounter => GoogleFonts.beVietnamPro(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        height: 20 / 14,
      );
}
