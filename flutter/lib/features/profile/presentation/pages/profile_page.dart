import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/character_avatar_assets.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../../../../core/widgets/settings_menu_item.dart';
import '../../../../core/widgets/stat_card.dart';
import '../../domain/entities/profile_rank.dart';
import '../cubit/profile_cubit.dart';
import '../cubit/profile_state.dart';
import '../widgets/language_picker_sheet.dart';
import '../widgets/rank_progress_card.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ProfileCubit>()..load(),
      child: const _ProfileView(),
    );
  }
}

class _ProfileView extends StatelessWidget {
  const _ProfileView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profilePageTitle),
        leading: IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () => context.push(RoutePaths.notifications),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: QaaAvatar(
              assetPath: 'assets/images/characters/spongebob_avatar.jpg',
              size: 36,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return switch (state) {
            ProfileLoading() => const LoadingView(),
            ProfileError(:final messageKey) => ErrorView(
                message: resolveMessageKey(context, messageKey),
                onRetry: () => context.read<ProfileCubit>().load(),
              ),
            ProfileLoaded() => _ProfileContent(state: state),
          };
        },
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  const _ProfileContent({required this.state});

  final ProfileLoaded state;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        Center(
          child: Column(
            children: [
              // [PositionedDirectional.end] mirrors correctly for RTL/LTR alike.
              Stack(
                clipBehavior: Clip.none,
                children: [
                  QaaAvatar(
                    assetPath: characterAvatarAsset(state.user.displayName),
                    displayName: state.user.displayName,
                    variant: QaaAvatarVariant.profile,
                  ),
                  PositionedDirectional(
                    bottom: -8,
                    end: -8,
                    child: RankBadge(
                      rank: ProfileRankLadder.rankFor(state.stats.points),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(state.user.displayName, style: AppTypography.profileName),
              if (state.user.bio != null && state.user.bio!.isNotEmpty)
                Text(state.user.bio!, style: AppTypography.metaText),
              const SizedBox(height: AppSpacing.xs),
              // The "bubble-currency" line under the name.
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    context.l10n.profileStatPoints,
                    style: AppTypography.chipLabel.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textFigmaSecondary,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${state.stats.points}',
                    style: AppTypography.chipLabel.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.statCardHighlightText,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '🫧',
                    style: AppTypography.chipLabel.copyWith(
                      fontSize: 16,
                      color: AppColors.statCardHighlightText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        // Physically left-to-right is points/resolved/submitted; under Flutter's RTL Row (first
        // child = right edge) that means submitted must be listed first (see [RankProgressCard]'s
        // note on the same pitfall).
        ProfileStatsGridCard(
          children: [
            StatCard(
              value: '${state.stats.submittedCount}',
              label: context.l10n.profileStatSubmitted,
            ),
            StatCard(
              value: '${state.stats.resolvedCount}',
              label: context.l10n.profileStatResolved,
            ),
            StatCard(
              value: '${state.stats.points}',
              label: context.l10n.profileStatPoints,
              isHighlighted: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.lg),
        RankProgressCard(points: state.stats.points),
        const SizedBox(height: AppSpacing.lg),
        SettingsMenuItem(
          label: context.l10n.profilePersonalInfoMenu,
          trailingIcon: Icons.person_outline,
          onTap: () => _showComingSoon(context),
        ),
        SettingsMenuItem(
          label: context.l10n.profileMyComplaintsMenu,
          trailingIcon: Icons.report_outlined,
          onTap: () => context.push(RoutePaths.myComplaints),
        ),
        SettingsMenuItem(
          label: context.l10n.profileFavoritesMenu,
          trailingIcon: Icons.favorite_border,
          onTap: () => _showComingSoon(context),
        ),
        SettingsMenuItem(
          label: context.l10n.profileSettingsMenu,
          trailingIcon: Icons.settings_outlined,
          onTap: () => _showLanguagePicker(context),
        ),
        SettingsMenuItem(
          label: context.l10n.profileLogoutMenu,
          trailingIcon: Icons.logout,
          isDestructive: true,
          showDivider: false,
          onTap: () => _confirmLogout(context),
        ),
      ],
    );
  }

  /// Personal Info / Favorites have no dedicated screen yet — a visible "coming soon"
  /// response keeps the row from being a silent dead tap.
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.placeholderScreenMessage)),
    );
  }

  void _showLanguagePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (_) => const LanguagePickerSheet(),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.logoutConfirmTitle),
        content: Text(context.l10n.logoutConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(context.l10n.logoutConfirmCancel),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              context.l10n.logoutConfirmYes,
              style: const TextStyle(color: AppColors.urgentDestructive),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await context.read<ProfileCubit>().logout();
      if (context.mounted) context.go(RoutePaths.login);
    }
  }
}
