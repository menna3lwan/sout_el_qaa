import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/category.dart';
import 'category_visuals.dart';

/// Icon + background/border pair per category come from [category_visuals.dart] (extracted from
/// Figma's Home category grid, app_colors.dart's "Category chip colors" block) — a shared lookup
/// table instead of storing UI-specific colors on the [Category] entity itself.
class CategoryChip extends StatelessWidget {
  const CategoryChip(
      {required this.category, super.key, this.isSelected = false, this.onTap});

  final Category category;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final background =
        categoryBackgroundColors[category.id] ?? AppColors.surfaceOffWhite;
    final border = categoryBorderColors[category.id] ?? AppColors.borderNeutral;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
      child: Container(
        width: 84,
        padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md, horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: border, width: isSelected ? 3 : 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(categoryIcon(category.id),
                color: AppColors.headerBackground, size: 26),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.metaText.copyWith(
                color: AppColors.textPrimaryDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
