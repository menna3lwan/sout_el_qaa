import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/extensions/context_extensions.dart';

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

  /// Material's chevron glyphs flip with text direction; we pick the glyph ourselves so it
  /// always points toward the row content in both RTL and LTR.
  static const _chevronStartward = IconData(
    0xe5cb,
    fontFamily: 'MaterialIcons',
  );
  static const _chevronEndward = IconData(
    0xe5cc,
    fontFamily: 'MaterialIcons',
  );

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
                  bottom: BorderSide(color: AppColors.divider),
                )
              : null,
        ),
        child: Row(
          children: [
            Icon(
              context.isRtl ? _chevronStartward : _chevronEndward,
              size: AppSpacing.iconSm,
              color: isDestructive
                  ? AppColors.urgentDestructive
                  : AppColors.profileAccent,
            ),
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
