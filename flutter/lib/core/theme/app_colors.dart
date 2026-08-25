import 'package:flutter/material.dart';

/// All values extracted from the real Figma file (`صوت القاع`, 24 Aug 2026 review of all 6 screens) — none invented; [Requires Confirmation] the file has no shared design variables, so the near-duplicate navy (7 values) and yellow (5 values) families below may be intentional micro-variation or design drift — confirm with the designer before treating them as final (see PLAN.md sections 15/21).
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // Screen background
  // ---------------------------------------------------------------------

  /// Background for all 6 screens without exception — the only value confirmed 100% consistent.
  static const Color screenBackground = Color(0xFFE0FBFC);

  // ---------------------------------------------------------------------
  // Navy family — [Requires Confirmation], see the note above
  // ---------------------------------------------------------------------

  /// Most-used navy: header background, Home CTA text, active nav item, card titles — strongest "primary" candidate if this family gets unified.
  static const Color headerBackground = Color(0xFF002960);

  /// Header's bottom border + the selected "All Complaints" tab border (Complaints List).
  static const Color headerBorder = Color(0xFF023E8A);

  /// Dark teal-navy: Profile page header/border, stats & settings-menu card borders, complaint card borders (Complaints List: Card 1/2/3).
  static const Color profileAccent = Color(0xFF002431);

  /// Background of the raised center FAB in the BottomNavBar.
  static const Color fabBackground = Color(0xFF001F49);

  /// "Submit Complaint" button text (Create Complaint) + "View All" text (Notifications) + active "Complaints" tab text (bottom nav).
  static const Color ctaTextAlt = Color(0xFF01204A);

  /// Border of all notification cards (Notifications).
  static const Color notificationCardAccent = Color(0xFF083B4C);

  /// "View All" link text above the "Most Engaged Complaints" card (Home only).
  static const Color homeLinkText = Color(0xFF396476);

  // ---------------------------------------------------------------------
  // Yellow / gold family — [Requires Confirmation], see the note above
  // ---------------------------------------------------------------------

  /// BottomNavBar top border yellow — the only value 100% consistent across all 6 screens; strongest single "brand yellow" candidate.
  static const Color navyBarAccentBorder = Color(0xFFFFB200);

  /// Primary CTA button background: "Submit New Complaint" (Home) and "Submit Complaint" (Create Complaint).
  static const Color ctaBackground = Color(0xFFFFD147);

  /// Hard drop-shadow color under yellow CTA buttons (consistent "pressed 3D button" style everywhere a primary CTA appears).
  static const Color ctaShadow = Color(0xFFD9A300);

  /// Header avatar border (44px) + search bar border + active step-indicator circles (Create Complaint wizard).
  static const Color avatarBorder = Color(0xFFFFD166);

  /// Background of the selected "All" filter in Notifications.
  static const Color notificationFilterSelectedBackground = Color(0xFFFFC928);

  /// "Pick Location on Map" button text (Create Complaint).
  static const Color mapButtonText = Color(0xFFFFB70F);

  // ---------------------------------------------------------------------
  // Reds — different semantic uses, don't conflate them
  // ---------------------------------------------------------------------

  /// "Urgent"/"Log Out" red — identical value in Home's "Urgent" badge and Profile's "Log Out" text, strongest candidate for a unified "destructive/urgent" token.
  static const Color urgentDestructive = Color(0xFFBA1A1A);

  /// Border of the "Urgent" badge in Home.
  static const Color urgentBadgeBorder = Color(0xFF93000A);

  /// [Requires Confirmation] the "Urgent" badge on Complaint Details uses a different value (#EF476F) than the identical badge/text on Home (#BA1A1A) — likely drift, kept separate until confirmed.
  static const Color urgentBadgeAltDetailPage = Color(0xFFEF476F);

  /// Background of the selected "High" severity button in Create Complaint — a distinct meaning from "urgent" (severity vs. urgency), so it doesn't share that token.
  static const Color severityHighSelected = Color(0xFFEF4870);

  /// "Unread" dot on notification cards.
  static const Color notificationUnreadDot = Color(0xFFEF4444);

  // ---------------------------------------------------------------------
  // Status — [Requires Confirmation], see the note below
  // ---------------------------------------------------------------------

  /// Complaint status has two distinct Figma representations, not one color per status: a horizontal stepper (Complaint Details, same gold/gray regardless of status) and solid-color chips (Complaints List cards) — resolvedChip corrects a wrong prior green (#16A34A) to the real navy (#002960); [Requires Confirmation] no "received" chip example was found in the sample reviewed.
  static const Color statusStepReached = Color(0xFFFFD166);
  static const Color statusStepPending = Color(0xFFE1E3E4);
  static const Color statusStepBorder = Color(0xFFF8F9FA);

  static const Color statusInProgressChip = Color(0xFFF77F00);
  static const Color statusResolvedChip = Color(0xFF002960);

  /// [Requires Confirmation] no real Figma source yet — placeholder gray until a real example or your confirmation exists; the only value in this file not actually extracted from Figma.
  static const Color statusReceivedChip = Color(0xFF6B7280);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------

  static const Color textOnBrand = Colors.white;
  static const Color textPrimaryDark =
      Color(0xFF191C1D); // Primary dark body text
  static const Color textSecondaryGrey =
      Color(0xFF434751); // Secondary body text
  static const Color textMutedGrey = Color(0xFF737782); // Muted/helper text
  static const Color textPlaceholderGrey =
      Color(0xFF9CA3AF); // Field placeholder text

  // ---------------------------------------------------------------------
  // Surfaces
  // ---------------------------------------------------------------------

  static const Color surfaceWhite = Colors.white;
  static const Color surfaceOffWhite =
      Color(0xFFF8F9FA); // Form cards, unselected buttons
  static const Color surfaceLightGrey =
      Color(0xFFF3F4F5); // BottomNavBar background, textarea
  static const Color surfaceIconCircle =
      Color(0xFFEDEEEF); // Icon-circle backgrounds
  static const Color borderNeutral =
      Color(0xFFC3C6D3); // General light-gray border

  // ---------------------------------------------------------------------
  // Category chip colors (Home) — each category has its own bg/border pair
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
  // Glass/blurred overlay cards (Trending card, Profile stats/menu, Notification cards) — same "semi-transparent glass" idea, slightly different alpha
  // ---------------------------------------------------------------------

  static const Color glassOverlayTrending =
      Color(0xD9FFFFFF); // rgba(255,255,255,0.85)
  static const Color glassOverlayNotificationFilter =
      Color(0xCCFFFFFF); // rgba(255,255,255,0.8)
  static const Color glassOverlayNotificationCard =
      Color(0xE6F2FBFF); // rgba(242,251,255,0.9)

  // ---------------------------------------------------------------------
  // Notification icon-badge pastels (Notifications) — icon-circle backgrounds
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
  // Semantic — [A] Assumption: no real validation-error example in the 6 screens reviewed; using a reasonable Material value until one appears
  // ---------------------------------------------------------------------

  static const Color error = Color(0xFFDC2626);
  static const Color divider = Color(0xFFE5E7EB);
}
