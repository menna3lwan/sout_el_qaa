import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/extensions/context_extensions.dart';

/// Unified empty state; like [ErrorView], each feature supplies its own message in the app's
/// voice, not a generic string.
class EmptyView extends StatelessWidget {
  const EmptyView({
    super.key,
    this.message,
    this.icon = Icons.anchor,
  });

  final String? message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceWhite,
                border: Border.all(color: AppColors.cardBorder),
              ),
              child: Icon(
                icon,
                size: 32,
                color: AppColors.headerBackground,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message ?? context.l10n.genericEmptyMessage,
              style: AppTypography.bodyDefault,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
