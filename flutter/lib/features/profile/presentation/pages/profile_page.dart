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
import '../widgets/rank_progress_card.dart';

/// Real implementation, matching Figma node 33:794 (PLAN.md section 3.10).
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
      body: SafeArea(
        child: BlocBuilder<ProfileCubit, ProfileState>(
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
              // [New, Figma Sync pass, 29 Aug 2026] Rank badge overlapping the avatar's bottom edge
              // (Figma node 33:794) — a Stack + slight negative margin instead of Positioned, since
              // (unlike the Home CTA mascot) both children stay in normal flow otherwise.
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  QaaAvatar(
                    assetPath: characterAvatarAsset(state.user.displayName),
                    displayName: state.user.displayName,
                    variant: QaaAvatarVariant.profile,
                  ),
                  PositionedDirectional(
                    bottom: -12,
                    child: RankBadge(
                      rank: ProfileRankLadder.rankFor(state.stats.points),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(state.user.displayName, style: AppTypography.profileName),
              if (state.user.bio != null && state.user.bio!.isNotEmpty)
                Text(state.user.bio!, style: AppTypography.metaText),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          onTap: () => _showComingSoon(context),
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

  /// [Proposed] Personal Info / Favorites / Settings are real Figma menu rows with no dedicated
  /// screen or spec behind them (the brief's 5 named flows don't cover them, and inventing their
  /// content would be inventing product behavior, which the brief explicitly forbids) — a visible
  /// "coming soon" response keeps the row from being a silent dead tap without fabricating a screen.
  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.placeholderScreenMessage)),
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
