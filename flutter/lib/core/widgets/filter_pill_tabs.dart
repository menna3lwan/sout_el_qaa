import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Horizontal pill filter bar shared by Complaints List's status tabs and Notifications' filter
/// bar — same selected/unselected visual pattern, built once instead of duplicated per feature.
class FilterPillTabs extends StatelessWidget {
  const FilterPillTabs({
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    super.key,
    this.selectedBackgroundColor = AppColors.headerBackground,
    this.selectedBorderColor = AppColors.headerBorder,
    this.selectedTextColor = AppColors.textOnBrand,
    this.unselectedBackgroundColor = AppColors.surfaceOffWhite,
    this.unselectedBorderColor = AppColors.borderNeutral,
    this.unselectedTextColor = AppColors.textSecondaryGrey,
  });

  /// Option labels in order — the text and its meaning come entirely from the calling feature;
  /// this widget owns only the visual shape.
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Notifications and Complaints List use genuinely different selected-pill colors — these
  /// overrides default to Complaints List's scheme; Notifications' call site overrides all six.
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;

  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

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
          selectedBackgroundColor: selectedBackgroundColor,
          selectedBorderColor: selectedBorderColor,
          selectedTextColor: selectedTextColor,
          unselectedBackgroundColor: unselectedBackgroundColor,
          unselectedBorderColor: unselectedBorderColor,
          unselectedTextColor: unselectedTextColor,
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
    required this.selectedBackgroundColor,
    required this.selectedBorderColor,
    required this.selectedTextColor,
    required this.unselectedBackgroundColor,
    required this.unselectedBorderColor,
    required this.unselectedTextColor,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color selectedBackgroundColor;
  final Color selectedBorderColor;
  final Color selectedTextColor;
  final Color unselectedBackgroundColor;
  final Color unselectedBorderColor;
  final Color unselectedTextColor;

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
          color:
              isSelected ? selectedBackgroundColor : unselectedBackgroundColor,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          border: Border.all(
            color: isSelected ? selectedBorderColor : unselectedBorderColor,
            width: 2,
          ),
        ),
        child: Text(
          label,
          style: AppTypography.chipLabel.copyWith(
            color: isSelected ? selectedTextColor : unselectedTextColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
