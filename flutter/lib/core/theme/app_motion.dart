import 'package:flutter/animation.dart';

/// Shared motion durations — keeps page/list/button transitions consistent without magic numbers.
abstract final class AppMotion {
  static const Duration fast = Duration(milliseconds: 160);
  static const Duration medium = Duration(milliseconds: 280);
  static const Curve standard = Curves.easeOutCubic;
}
