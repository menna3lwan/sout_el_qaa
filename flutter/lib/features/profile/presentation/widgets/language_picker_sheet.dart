import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/locale/app_locale_cubit.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_motion.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Direction-aware language picker. The list order is semantic (Arabic, English, German) so
/// Flutter's RTL/LTR mirroring places the first option at the reading-start edge.
class LanguagePickerSheet extends StatelessWidget {
  const LanguagePickerSheet({super.key});

  static const _options = [
    Locale('ar'),
    Locale('en'),
    Locale('de'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.sm,
          AppSpacing.md,
          AppSpacing.md,
        ),
        child: BlocBuilder<AppLocaleCubit, Locale>(
          builder: (context, current) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.settingsLanguageTitle,
                  style: AppTypography.sectionHeadingLarge.copyWith(
                    color: AppColors.profileAccent,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.md),
                for (final locale in _options)
                  _LanguageTile(
                    label: _labelFor(context, locale),
                    selected: current.languageCode == locale.languageCode,
                    onTap: () {
                      context.read<AppLocaleCubit>().setLocale(locale);
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  static String _labelFor(BuildContext context, Locale locale) {
    return switch (locale.languageCode) {
      'ar' => context.l10n.languageNameAr,
      'en' => context.l10n.languageNameEn,
      'de' => context.l10n.languageNameDe,
      _ => locale.languageCode,
    };
  }
}

class _LanguageTile extends StatelessWidget {
  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: AnimatedContainer(
        duration: AppMotion.fast,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.statCardHighlightBackground
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          children: [
            Icon(
              selected ? Icons.check_circle : Icons.circle_outlined,
              color: selected
                  ? AppColors.profileAccent
                  : AppColors.textFigmaSecondary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                label,
                style: AppTypography.chipLabel.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: AppColors.profileAccent,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
