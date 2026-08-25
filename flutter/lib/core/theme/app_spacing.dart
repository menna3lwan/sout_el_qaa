/// Unified spacing/radius scale (prevents magic numbers scattered across widgets); built on a 4pt grid, updated with real values from the full Figma review (24 Aug 2026), replacing the earlier placeholder [A8].
abstract final class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;

  /// [New, added after the Figma review] 12 is a very common gap/padding value across all 6 screens (between sm=8 and md=16 on the same 4pt grid) — missing from the old scale despite real, repeated use.
  static const double space12 = 12;

  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const double radiusSm = 8; // Image-upload box, location box
  static const double radiusMd = 12; // Stat cards, settings list
  static const double radiusLg = 16; // Most cards (Trending, Description, Notification)

  /// [New] Corner radius for the header and the BottomNavBar's top corners — 100% consistent across all 6 screens, distinct from radiusLg.
  static const double radiusXl = 32;

  /// [New] Semantic shortcut for "fully round" (pills, avatars, chips) instead of every widget repeating BorderRadius.circular(9999) — matches the literal value Figma uses everywhere.
  static const double radiusPill = 9999;

  /// [Requires Confirmation] the real screenshot and every screen's BottomNavBar bounds measure 80px, not the old 72 — a second "BottomNavBar" layer at 72px exists on every screen but sits off-screen (bottom: -165px), most likely leftover/duplicate art rather than a real second state; using 80 as the real value pending designer confirmation.
  static const double bottomNavHeight = 80;
}
