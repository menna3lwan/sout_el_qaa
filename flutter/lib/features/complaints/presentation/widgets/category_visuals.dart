import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Category id -> icon, shared by [CategoryChip] (Home/Create Complaint) and the Map tab's markers —
/// extracted here once a second consumer needed the same lookup (see dio_exception_guard.dart for the
/// same "wait for a real third use" rule applied the other way).
const Map<String, IconData> categoryIcons = {
  'water': Icons.water_drop_outlined,
  'roads': Icons.add_road_outlined,
  'cleanliness': Icons.cleaning_services_outlined,
  'electricity': Icons.bolt_outlined,
};

const Map<String, Color> categoryBackgroundColors = {
  'water': AppColors.categoryWaterBackground,
  'roads': AppColors.categoryRoadsBackground,
  'cleanliness': AppColors.categoryCleanlinessBackground,
  'electricity': AppColors.categoryElectricityBackground,
};

const Map<String, Color> categoryBorderColors = {
  'water': AppColors.categoryWaterBorder,
  'roads': AppColors.categoryRoadsBorder,
  'cleanliness': AppColors.categoryCleanlinessBorder,
  'electricity': AppColors.categoryElectricityBorder,
};

IconData categoryIcon(String categoryId) => categoryIcons[categoryId] ?? Icons.category_outlined;
