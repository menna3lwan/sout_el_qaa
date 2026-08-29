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
      // [New, Figma Sync pass, 29 Aug 2026] A real fetch of node 33:794 shows the same navy header
      // bar every other screen has (bell action + avatar) — this page had none at all before this
      // pass, the only one of the 6 real screens missing it.
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
              // [Fixed, Figma Sync pass, 29 Aug 2026] A real fetch of node `61:1700` places this
              // badge at the avatar's bottom-*end* corner (`bottom-[-8px] right-[-8px]`), not
              // bottom-center — [PositionedDirectional.end] mirrors correctly for RTL/LTR alike.
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
              // [New, Figma Sync pass, 29 Aug 2026] The "bubble-currency" line under the name (Figma
              // node `61:1706`: "فقاعة 245 🫧") — was missing entirely; only shown inside the stats
              // grid's points cell before this pass.
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
        // [Verified, Figma Sync pass, 29 Aug 2026] Order re-confirmed against the real screenshot
        // (not just DOM order, which reads misleadingly under this RTL app — see [RankProgressCard]'s
        // own note on the same pitfall): physically left-to-right is points/resolved/submitted, which
        // under Flutter's RTL Row (first child = right edge) means submitted must be listed first.
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
