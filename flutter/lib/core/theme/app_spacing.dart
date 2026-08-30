/// Unified spacing/radius scale on a 4pt grid — prevents magic numbers scattered across widgets.
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;

  /// A common gap/padding value between sm=8 and md=16 on the same 4pt grid.
  static const double space12 = 12;

  /// Horizontal padding on the Complaint Details engagement counter pills, between md=16 and
  /// lg=24 on the same 4pt grid.
  static const double space18 = 18;

  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8; // Image-upload box, location box
  static const double radiusMd = 12; // Stat cards, settings list
  static const double radiusLg =
      16; // Most cards (Trending, Description, Notification)

  /// Corner radius for the header and the BottomNavBar's top corners, distinct from radiusLg.
  static const double radiusXl = 32;

  /// Semantic shortcut for "fully round" (pills, avatars, chips) instead of every widget
  /// repeating BorderRadius.circular(9999).
  static const double radiusPill = 9999;

  static const double iconSm = 16;
  static const double iconMd = 20;
  static const double iconLg = 24;

  static const double bottomNavHeight = 84;
}
