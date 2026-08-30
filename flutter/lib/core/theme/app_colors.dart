import 'package:flutter/material.dart';

/// Design tokens extracted from Figma. The near-duplicate navy and yellow families below may be
/// intentional micro-variation or design drift rather than a single unified color; kept distinct
/// rather than merged since each is tied to a specific, confirmed Figma value.
abstract final class AppColors {
  // ---------------------------------------------------------------------
  // Screen background
  // ---------------------------------------------------------------------

  /// Background for all 6 screens without exception — the only value confirmed 100% consistent.
  static const Color screenBackground = Color(0xFFE0FBFC);

  // ---------------------------------------------------------------------
  // Navy family — see the class-level note on near-duplicate values
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

  /// Superseded by [AppTypography.linkButtonBold]'s color; kept as a documented record rather
  /// than deleted.
  static const Color homeLinkText = Color(0xFF396476);

  // ---------------------------------------------------------------------
  // Yellow / gold family — see the class-level note on near-duplicate values
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

  /// The "Urgent" badge on Complaint Details uses a distinct value from the identical badge/text
  /// on Home ([urgentDestructive]); kept separate rather than merged.
  static const Color urgentBadgeAltDetailPage = Color(0xFFEF476F);

  /// Background of the selected "High" severity button in Create Complaint — a distinct meaning from "urgent" (severity vs. urgency), so it doesn't share that token.
  static const Color severityHighSelected = Color(0xFFEF4870);

  /// "Unread" dot on notification cards.
  static const Color notificationUnreadDot = Color(0xFFEF4444);

  // ---------------------------------------------------------------------
  // Status
  // ---------------------------------------------------------------------

  /// Complaint status has two distinct representations, not one color per status: a horizontal
  /// stepper (Complaint Details, same gold/gray regardless of status) and solid-color chips
  /// (Complaints List cards).
  static const Color statusStepReached = Color(0xFFFFD166);
  static const Color statusStepPending = Color(0xFFE1E3E4);
  static const Color statusStepBorder = Color(0xFFF8F9FA);

  static const Color statusInProgressChip = Color(0xFFF77F00);
  static const Color statusResolvedChip = Color(0xFF002960);
  static const Color statusReceivedChip = Color(0xFF6B7280);

  // ---------------------------------------------------------------------
  // Text
  // ---------------------------------------------------------------------

  static const Color textOnBrand = Colors.white;

  /// Home header's location line — a dimmed white, distinct from the fully-opaque [textOnBrand]
  /// the bold greeting above it uses.
  static const Color textOnBrandMuted =
      Color(0xB3FFFFFF); // rgba(255,255,255,0.7)
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
  // Complaint Details info-pill row — distinct from the solid urgent badge above the title
  // ([urgentBadgeAltDetailPage]): these 3 pills (severity flavor / category / location) use
  // soft, translucent tints with dark text instead.
  // ---------------------------------------------------------------------

  static const Color severityHighPillBackground = Color(0xFFFFDAD6);
  static const Color severityHighPillBorder = Color(0x33BA1A1A);
  static const Color severityHighPillText = Color(0xFF93000A);

  /// Same soft-tint family as [severityHighPillBackground].
  static const Color severityMediumPillBackground = Color(0xFFFFE4C2);
  static const Color severityMediumPillBorder = Color(0x33F77F00);
  static const Color severityMediumPillText = Color(0xFF8A4B00);

  /// Same soft-tint family as [severityHighPillBackground].
  static const Color severityLowPillBackground = Color(0xFFD3E8D6);
  static const Color severityLowPillBorder = Color(0x33256B36);
  static const Color severityLowPillText = Color(0xFF1E5128);

  static const Color categoryPillBackground = Color(0x8080D4DB);
  static const Color categoryPillBorder = Color(0x6680D4DB);
  static const Color categoryPillText = Color(0xFF063B78);

  static const Color locationPillBackground = Color(0xFFDFE8FF);
  static const Color locationPillBorder = Color(0x4DC3C6D2);
  static const Color locationPillText = Color(0xFF434750);

  // ---------------------------------------------------------------------
  // Profile rank badge + stats/progress cards — distinct shades from every other navy/gold
  // token in this file.
  // ---------------------------------------------------------------------

  /// Border on the rank badge (`border-[#f9f9ff]`) and the stats-grid/progress-section card
  /// backgrounds (`bg-[#f9f9ff]`) — same very-pale lavender-white in both real uses.
  static const Color surfaceCardBackground = Color(0xFFF9F9FF);

  static const Color rankBadgeText = Color(0xFFDDF7F8);

  /// Plain (non-highlighted) stat cell background — distinct from [glassOverlayTrending], which
  /// this cell's Figma example does NOT use despite a prior pass assuming it did.
  static const Color statCardPlainBackground = Color(0xFFF1F3FF);

  static const Color rankProgressFill = Color(0xFFFEC73C);

  /// "اجمع 51 فقاعة..." caption's own soft background band, distinct from the progress bar fill it
  /// echoes the color family of.
  static const Color rankCaptionBackground = Color(0x1AFEC73C);

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
  // Semantic
  // ---------------------------------------------------------------------

  static const Color error = Color(0xFFDC2626);
  static const Color divider = Color(0xFFE5E7EB);

  // ---------------------------------------------------------------------
  // A separate named token layer (search bar, category grid, complaint-review card, profile
  // stats, Create Complaint wizard) — kept as its own names rather than merged into the
  // sections above so Figma variable-name lookups stay a direct 1:1 match.
  // ---------------------------------------------------------------------

  static const Color textFigmaPrimary = Color(0xFF12324A);
  static const Color textFigmaSecondary = Color(0xFF547080);
  static const Color textFigmaTertiary = Color(0xFF78909C);
  static const Color textFigmaDisabled = Color(0xFF9AAEB8);

  static const Color brandPrimary = Color(0xFF063B78);
  static const Color brandPrimaryDark = Color(0xFF032B5B);
  static const Color brandSecondary = Color(0xFFFFC83D);
  static const Color brandSecondaryDark = Color(0xFFF2B800);
  static const Color brandAccent = Color(0xFF8FE3EA);

  static const Color infoFigma = Color(0xFF4A9FE8);
  static const Color warningFigma = Color(0xFFF5B82E);

  /// Distinct from [error] above — this is Create Complaint's review-step error color.
  static const Color errorFigma = Color(0xFFE85B70);

  /// Home's recent-activity heading — a near-duplicate navy distinct from every value in the
  /// "Navy family" section above; same micro-variation caveat as that section.
  static const Color recentActivityHeading = Color(0xFF002652);

  static const Color borderFigmaDefault = Color(0xFFB8D6DB);
  static const Color borderFigmaStrong = Color(0xFF6D9DA8);
  static const Color borderFigmaFocus = Color(0xFF063B78);

  /// Extremely close to but not byte-identical to [screenBackground]; kept separate rather than
  /// silently swapped in everywhere since [screenBackground] remains the active value.
  static const Color backgroundFigmaPrimaryCandidate = Color(0xFFDDF7F8);

  // ---------------------------------------------------------------------
  // Profile settings-menu icon circles — every row's trailing icon sits inside a 40px filled
  // circle.
  // ---------------------------------------------------------------------

  static const Color settingsIconCircleBackground = Color(0xFFD7E3FF);
  static const Color settingsIconCircleDestructiveBackground =
      Color(0xFFFFDAD6);

  // ---------------------------------------------------------------------
  // Profile rank/points card — the highlighted stat cell is a translucent gold tint, and the
  // badge uses [brandPrimary]'s navy, not [headerBackground]'s.
  // ---------------------------------------------------------------------

  static const Color statCardHighlightBackground = Color(0x33FEC73C);
  static const Color statCardHighlightBorder = Color(0x4DFEC73C);
  static const Color statCardHighlightText = Color(0xFFF2B800);
  static const Color rankBadgeBackground = Color(0xFF063B78);
  static const Color rankProgressTrack = Color(0xFF9AAEB8);
}
