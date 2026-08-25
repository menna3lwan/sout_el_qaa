import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Horizontal pill filter bar — a real shared component, used with the same pattern (selected pill in a different color, others with a gray border) on two separate screens: the "All/Mine/Resolved" tabs (Complaints List) and the "All/Complaints/Reactions/General" filters (Notifications); built once instead of duplicated per feature. Minor differences between the two screens (1px vs 2px border, padding) are unified on the more common value; adjust per use later if needed.
class FilterPillTabs extends StatelessWidget {
  const FilterPillTabs({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
  });

  /// Option labels in order — their text and meaning are fully owned by the consuming feature; this widget only owns the visual style.
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: List.generate(options.length, (index) {
        final isSelected = index == selectedIndex;
        return _Pill(
          label: options[index],
          isSelected: isSelected,
          onTap: () => onSelected(index),
        );
      }),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.headerBackground
              : AppColors.surfaceOffWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color:
                isSelected ? AppColors.headerBorder : AppColors.borderNeutral,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: isSelected
                ? AppColors.textOnBrand
                : AppColors.textSecondaryGrey,
          ),
        ),
      ),
    );
  }
}
