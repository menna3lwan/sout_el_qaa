import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Category id -> icon, shared by [CategoryChip] (Home/Create Complaint) and the Map tab's markers —
/// extracted here once a second consumer needed the same lookup (see dio_exception_guard.dart for the
/// same "wait for a real third use" rule applied the other way).
const Map<String, IconData> categoryIcons = {
  // [New, Full Audit & Sync pass, 27 Aug 2026] "أخر" (Other) — a 5th category
  // added in the redesigned Figma (Home's category grid and the Create
  // Complaint form both show it first, before "مياه"), not present in the
  // original 4-category set. Figma's icon reads as a generic pin/marker
  // glyph; the closest Material equivalent is used pending a real exported
  // asset.
  'other': Icons.push_pin_outlined,
  'water': Icons.water_drop_outlined,
  'roads': Icons.add_road_outlined,
  'cleanliness': Icons.cleaning_services_outlined,
  'electricity': Icons.bolt_outlined,
};

const Map<String, Color> categoryBackgroundColors = {
  'other': AppColors.screenBackground,
  'water': AppColors.categoryWaterBackground,
  'roads': AppColors.categoryRoadsBackground,
  'cleanliness': AppColors.categoryCleanlinessBackground,
  'electricity': AppColors.categoryElectricityBackground,
};

const Map<String, Color> categoryBorderColors = {
  'other': AppColors.borderNeutral,
  'water': AppColors.categoryWaterBorder,
  'roads': AppColors.categoryRoadsBorder,
  'cleanliness': AppColors.categoryCleanlinessBorder,
  'electricity': AppColors.categoryElectricityBorder,
};

IconData categoryIcon(String categoryId) =>
    categoryIcons[categoryId] ?? Icons.category_outlined;
