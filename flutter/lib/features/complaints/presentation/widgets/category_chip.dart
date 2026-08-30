import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/category.dart';
import 'category_visuals.dart';

/// Icon + background/border pair per category come from category_visuals.dart — a shared lookup
/// table instead of storing UI-specific colors on the [Category] entity itself. A circular icon
/// badge with its own background/border, and a separate label centered below it; the container
/// size (48x48) is deliberately not the icon's own size (20x20) — the two are set independently.
class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.category,
    super.key,
    this.isSelected = false,
    this.onTap,
  });

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
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: SizedBox(
        width: 65,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: background,
                border: Border.all(color: border, width: isSelected ? 3 : 2),
              ),
              child: Icon(
                categoryIcon(category.id),
                color: AppColors.headerBackground,
                size: 20,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              category.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.iconCaptionLabel
                  .copyWith(color: AppColors.textPrimaryDark),
            ),
          ],
        ),
      ),
    );
  }
}
