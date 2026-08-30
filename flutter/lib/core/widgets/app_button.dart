import 'package:flutter/material.dart';

import '../theme/app_motion.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// Unified primary button wrapping [ElevatedButton] with a built-in loading state, so every form screen (Login, Create Complaint...) doesn't repeat "disable + show spinner while submitting" logic.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading && onPressed != null;

    return AnimatedOpacity(
      duration: AppMotion.fast,
      opacity: canPress || isLoading ? 1 : 0.64,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: canPress ? AppShadows.cta : const [],
        ),
        child: ElevatedButton(
          onPressed: canPress ? onPressed : null,
          child: AnimatedSwitcher(
            duration: AppMotion.fast,
            child: isLoading
                ? const SizedBox(
                    key: ValueKey('loading'),
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : Row(
                    key: const ValueKey('label'),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: AppSpacing.iconMd),
                        const SizedBox(width: AppSpacing.sm),
                      ],
                      Flexible(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
