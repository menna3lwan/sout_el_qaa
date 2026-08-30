import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Elevation recipes used by cards, CTAs, and the raised nav FAB — one place instead of
/// per-widget `BoxShadow` literals drifting apart.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x14002652),
      offset: Offset(0, 4),
      blurRadius: 16,
    ),
  ];

  static const List<BoxShadow> cta = [
    BoxShadow(
      color: AppColors.ctaShadow,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> fab = [
    BoxShadow(
      color: Color(0x33001F49),
      offset: Offset(0, 4),
      blurRadius: 10,
    ),
  ];

  static const List<BoxShadow> hairline = [
    BoxShadow(
      color: Color(0x0D000000),
      offset: Offset(0, 1),
      blurRadius: 2,
    ),
  ];
}
