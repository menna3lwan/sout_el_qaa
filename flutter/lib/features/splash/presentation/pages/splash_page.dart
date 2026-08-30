import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Visual placeholder only — the "Checking Auth → Redirect" logic lives in
/// core/router/app_router.dart (GoRouter.redirect), not here, keeping this widget
/// presentation-only with no direct I/O.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.headerBackground,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 88,
                height: 88,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.ctaBackground,
                ),
                child: const Icon(
                  Icons.anchor,
                  size: 40,
                  color: AppColors.headerBackground,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                context.l10n.appTitle,
                style: AppTypography.headerTitle,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                context.l10n.genericLoading,
                style: AppTypography.metaText
                    .copyWith(color: AppColors.textOnBrandMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
