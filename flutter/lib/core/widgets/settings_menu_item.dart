import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Settings-list row matching "Personal Info / Complaints / Favorites / Settings / Log Out" on the Profile page, extracted from the real Figma; the "destructive" (logout) variant ([isDestructive]) reuses Home's "Urgent" red, confirmed as a unified destructive token across both screens.
class SettingsMenuItem extends StatelessWidget {
  const SettingsMenuItem({
    required this.label,
    required this.onTap,
    super.key,
    this.trailingIcon,
    this.isDestructive = false,
    this.showDivider = true,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final bool isDestructive;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          border: showDivider
              ? const Border(
                  bottom: BorderSide(color: Color(0x33002431)),
                )
              : null,
        ),
        child: Row(
          children: [
            const Icon(Icons.chevron_left, size: 16), // RTL direction
            const Spacer(),
            Text(
              label,
              style: AppTypography.chipLabel.copyWith(
                fontWeight: FontWeight.w500,
                color: isDestructive
                    ? AppColors.urgentDestructive
                    : AppColors.profileAccent,
              ),
            ),
            if (trailingIcon != null) ...[
              const SizedBox(width: AppSpacing.sm),
              Icon(
                trailingIcon,
                size: 20,
                color: isDestructive
                    ? AppColors.urgentDestructive
                    : AppColors.profileAccent,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
