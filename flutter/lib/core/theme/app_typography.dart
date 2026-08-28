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

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Shared "large Cairo Bold section heading" shape — Cairo
  /// Bold 20px/34, no color baked in (Figma reuses this exact size/weight/line-height with two
  /// different colors: node 33:94 "أكثر الشكاوى تفاعلاً" uses profileAccent, node 33:130 "تصنيفات
  /// الشكاوى" uses textFigmaPrimary — callers supply the color via `.copyWith`, same convention as
  /// [chipLabel]/[stepLabel] below). Corrects a prior mismatch: both headings were previously styled
  /// with either [displayLarge] (Baloo Bhaijaan 2, 24px — wrong family and size) or [headingMedium]
  /// (16px — wrong size); [displayLarge] itself is unchanged and still correct for its other real uses
  /// (Profile's [StatCard] figures, the theme's `headlineLarge`) so it's kept as-is rather than edited.
  static TextStyle get sectionHeadingLarge => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        height: 34 / 20,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] "شوف إيه اللي شاغل سكان القاع" (Home's trending-section
  /// subheading, node 55:898) — Cairo Medium 14px/22, did not exist before this pass.
  static TextStyle get trendingSectionSubheading => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: AppColors.textFigmaSecondary,
        height: 22 / 14,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] "عرض الكل" (Home's trending-section "View All" link,
  /// node 33:92) — Cairo Bold 14px/20, color textFigmaPrimary; corrects a prior mismatch ([metaText] +
  /// [AppColors.homeLinkText], Cairo Regular 12px in a different navy). Named generically (not
  /// "homeViewAll...") since the same bold-link treatment is a reusable pattern, not a Home-only one.
  static TextStyle get linkButtonBold => GoogleFonts.cairo(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textFigmaPrimary,
        height: 20 / 14,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Small bold pill/button label — Cairo Bold 12px/16 +
  /// letter-spacing 0.5, no color baked in. Matches Home's "عندي نفس المشكله" button (node 63:1989);
  /// corrects a prior mismatch that reused [statusChipLabel] (10px, no letter-spacing) for this — a
  /// visually similar but distinctly-sized Figma style, not the same one.
  static TextStyle get pillButtonLabel => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        height: 16 / 12,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] "شكاوى محتاجة صوتك" (Home's recent-activity heading,
  /// node 52:810) — Cairo Bold 20px/28, color [AppColors.recentActivityHeading]. Same 20px-Bold family
  /// as [sectionHeadingLarge] above but a different line-height (28 vs 34) and a 7th near-duplicate
  /// navy — see that color token's own "requires confirmation" note; kept as its own style rather than
  /// silently rounded onto [sectionHeadingLarge] since the line-height genuinely differs in Figma.
  static TextStyle get recentActivityHeading => GoogleFonts.cairo(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.recentActivityHeading,
        height: 28 / 20,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Small caption under an icon — Cairo Regular 12px/16, no
  /// color baked in. Matches the category-chip labels on Home/Create Complaint (e.g. node 55:907
  /// "مياه"); corrects a prior mismatch that reused [metaText] with a `fontWeight: w600` override (12px
  /// but the wrong line-height, 16/12 vs [metaText]'s 16/12 — the actual bug was the weight: Figma is
  /// Regular here, not SemiBold).
  static TextStyle get iconCaptionLabel => GoogleFonts.cairo(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        height: 16 / 12,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Home's recent-activity pill row title (e.g. node
  /// 33:162) — Cairo Regular 10px/24, no color baked in. This specific "small text, generous
  /// line-height" combination did not exist elsewhere in the type scale.
  static TextStyle get activityItemTitle => GoogleFonts.cairo(
        fontSize: 10,
        fontWeight: FontWeight.w400,
        height: 24 / 10,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Home's recent-activity pill row meta text ("status -
  /// relative time", e.g. node 33:164) — Cairo Regular 8px/16, no color baked in.
  static TextStyle get activityItemMeta => GoogleFonts.cairo(
        fontSize: 8,
        fontWeight: FontWeight.w400,
        height: 16 / 8,
      );

  /// [New, Full Audit & Sync pass, 27 Aug 2026] Notification card title (Figma node 33:936's 4
  /// example cards, e.g. "تم تحديث حالة شكواك") — Cairo Bold 18px/22.5, color notificationCardAccent.
  /// [NotificationCard] previously reused [fieldLabel] (14px, a different color) for this text; the
  /// weight is still toggled per read/unread state at the call site, same as before this pass.
  static TextStyle get notificationCardTitle => GoogleFonts.cairo(
        fontSize: 18,
        color: AppColors.notificationCardAccent,
        height: 22.5 / 18,
      );

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

  /// [Updated, Full Audit & Sync pass, 27 Aug 2026] Complaint title on the details page (Figma node
  /// 33:600, fresh fetch) — Cairo Bold 16px, not the 20px SemiBold this held before this pass; the
  /// single real call site ([ComplaintDetailsPage]) is corrected in place rather than adding a
  /// duplicate token. [Requires Confirmation] the 40px line-height (2.5x the font size) is unusually
  /// generous for a 16px heading — kept as extracted rather than snapped to a smaller ratio since,
  /// unlike the small 8-12px "auto-layout artifact" cases elsewhere in this file, a prominent 2-line
  /// wrapped heading plausibly does want this much breathing room by design.
  static TextStyle get complaintTitle => GoogleFonts.cairo(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.headerBackground,
        height: 40 / 16,
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
