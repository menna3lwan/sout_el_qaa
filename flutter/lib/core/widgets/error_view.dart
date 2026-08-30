import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';
import '../utils/extensions/context_extensions.dart';
import 'app_button.dart';

/// Unified failure state with an optional "Try Again" button; the message must come from the
/// Cubit in the app's voice — this widget only displays it, never decides its content.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

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
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.settingsIconCircleDestructiveBackground,
              ),
              child: const Icon(
                Icons.sentiment_dissatisfied_outlined,
                size: 36,
                color: AppColors.urgentDestructive,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              message,
              style: AppTypography.bodyDefault,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: AppSpacing.lg),
              AppButton(label: context.l10n.genericRetry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
