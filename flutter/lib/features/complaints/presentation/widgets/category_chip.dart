import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/category.dart';
import 'category_visuals.dart';

/// Icon + background/border pair per category come from [category_visuals.dart] (extracted from
/// Figma's Home category grid, app_colors.dart's "Category chip colors" block) — a shared lookup
/// table instead of storing UI-specific colors on the [Category] entity itself.
///
/// [Updated, Full Audit & Sync pass, 27 Aug 2026] Rebuilt to match the redesigned Figma (Home node
/// 33:131, reused unchanged on Create Complaint's category picker): a 48x48 circular icon badge with
/// its own background/border, and a separate 12px label centered below it — not one bordered
/// rounded-rectangle wrapping both icon and label, which is what this widget drew before this pass.
/// The container size (48x48) is deliberately not the icon's own size (20x20) — the two are set
/// independently in [build] below rather than one implying the other.
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
                // Kept the pre-existing "selected = thicker border" affordance — Figma's export
                // doesn't include a distinct selected-state frame for this component, so this
                // interaction detail is preserved rather than silently dropped (Important Rule #3:
                // don't assume the old implementation is wrong without evidence either way).
                border: Border.all(color: border, width: isSelected ? 3 : 2),
              ),
              child: Icon(categoryIcon(category.id),
                  color: AppColors.headerBackground, size: 20),
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
