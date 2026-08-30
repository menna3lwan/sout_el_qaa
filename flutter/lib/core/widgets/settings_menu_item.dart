import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// One row of Profile's settings menu (Personal Info / Complaints / Favorites / Settings /
/// Logout). The destructive use (logout) reuses the same "urgent" color as Home's badge, a
/// consistent destructive signal across screens.
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
            const Icon(Icons.chevron_left, size: 16), // اتجاه RTL
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
              // Every row's icon sits inside a filled 40px circle.
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDestructive
                      ? AppColors.settingsIconCircleDestructiveBackground
                      : AppColors.settingsIconCircleBackground,
                ),
                child: Icon(
                  trailingIcon,
                  size: 20,
                  color: isDestructive
                      ? AppColors.urgentDestructive
                      : AppColors.profileAccent,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
