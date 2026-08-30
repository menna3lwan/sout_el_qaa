import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Category id -> icon, shared by [CategoryChip] (Home/Create Complaint) and the Map tab's markers.
const Map<String, IconData> categoryIcons = {
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
