import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/character_avatar_assets.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../complaints/domain/entities/complaint.dart';
import '../../../complaints/presentation/widgets/category_chip.dart';
import '../../../complaints/presentation/widgets/category_visuals.dart';
import '../../../complaints/presentation/widgets/complaint_list_card.dart';
import '../../../complaints/presentation/widgets/status_badge.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Header with avatar/greeting/notifications bell, category grid, primary CTA, trending list,
/// recent activity list.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..load(),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return switch (state) {
              HomeLoading() => const LoadingView(),
              HomeError(:final messageKey) => ErrorView(
                  message: resolveMessageKey(context, messageKey),
                  onRetry: () => context.read<HomeCubit>().load(),
                ),
              HomeLoaded() => _HomeContent(state: state),
            };
          },
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent({required this.state});

  final HomeLoaded state;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () => context.read<HomeCubit>().load(),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _Header(user: state.user),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // No search flow exists yet (no search screen/endpoint) — a real TextField with
                // nowhere to submit to is more honest than a disabled-looking placeholder.
                const _SearchBar(),
                const SizedBox(height: AppSpacing.lg),
                // The CTA mascot peeks above the button's top-start corner — a Stack + Positioned
                // overlay so the button itself keeps its normal size and tap target.
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    AppButton(
                      label: context.l10n.homeSubmitComplaintCta,
                      icon: Icons.add_circle_outline,
                      onPressed: () => context.push(RoutePaths.createComplaint),
                    ),
                    PositionedDirectional(
                      top: -29,
                      start: 0,
                      child: IgnorePointer(
                        child: Image.asset(
                          'assets/images/characters/spongebob_cta_mascot.png',
                          width: 79,
                          height: 95,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(
                  title: context.l10n.homeTrendingHeading,
                  subtitle: context.l10n.homeTrendingSubheading,
                  onViewAll: () => context.go(RoutePaths.complaints),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...state.trending.map(
                  (complaint) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ComplaintListCard(
                      complaint: complaint,
                      showUrgentBadge: true,
                      showSameProblemAction: true,
                      onTap: () => context
                          .push(RoutePaths.complaintDetails(complaint.id)),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.homeCategoriesHeading,
                  style: AppTypography.sectionHeadingLarge
                      .copyWith(color: AppColors.textFigmaPrimary),
                ),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  // Matches [CategoryChip]'s intrinsic height (48px icon circle + 4px gap + 16px
                  // label line).
                  height: 68,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        CategoryChip(category: state.categories[index]),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.homeRecentActivityHeading,
                  style: AppTypography.recentActivityHeading,
                ),
                const SizedBox(height: AppSpacing.sm),
                if (state.recentActivity.isEmpty)
                  Text(
                    context.l10n.genericEmptyMessage,
                    style: AppTypography.metaText,
                  )
                else
                  ...state.recentActivity.map(
                    (complaint) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _RecentActivityItem(
                        complaint: complaint,
                        onTap: () => context
                            .push(RoutePaths.complaintDetails(complaint.id)),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.headerBackground,
        borderRadius:
            BorderRadius.vertical(bottom: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Row(
        children: [
          QaaAvatar(
            assetPath: characterAvatarAsset(user.displayName),
            displayName: user.displayName,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  context.l10n.homeGreeting(user.displayName),
                  style: AppTypography.greeting,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                // Falls back to just the greeting if the user has no bio (street) set, rather
                // than showing a dangling location line.
                if (user.bio != null && user.bio!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 12,
                        color: AppColors.textOnBrandMuted,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          context.l10n.homeLocationLine(user.bio!),
                          style: AppTypography.metaText
                              .copyWith(color: AppColors.textOnBrandMuted),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: AppColors.textOnBrand,
            ),
            onPressed: () => context.push(RoutePaths.notifications),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    required this.onViewAll,
    this.subtitle,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: onViewAll,
          child: Text(
            context.l10n.homeViewAll,
            style: AppTypography.linkButtonBold,
          ),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                title,
                textAlign: TextAlign.end,
                style: AppTypography.sectionHeadingLarge
                    .copyWith(color: AppColors.profileAccent),
              ),
              if (subtitle != null) ...[
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle!,
                  textAlign: TextAlign.end,
                  style: AppTypography.trendingSectionSubheading,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

/// The search field above the CTA button; see the call site for why it has no `onSubmitted`
/// wiring yet.
class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 53,
      padding: const EdgeInsetsDirectional.only(start: 17, end: 17),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
        border: Border.all(color: AppColors.brandSecondaryDark),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            offset: Offset(0, 1),
            blurRadius: 1,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.search,
            size: 20,
            color: AppColors.textFigmaTertiary,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: TextField(
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
                isDense: true,
                hintText: context.l10n.homeSearchHint,
                hintStyle: AppTypography.fieldPlaceholder
                    .copyWith(fontSize: 14, color: AppColors.textFigmaTertiary),
              ),
              style: AppTypography.fieldPlaceholder.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}

/// Home's recent-activity row — a distinct compact pill, not [ComplaintListCard] (which remains
/// correct for the trending section above it). Kept private to home_page.dart rather than
/// promoted to shared widgets/ since no second screen reuses this exact shape yet.
class _RecentActivityItem extends StatelessWidget {
  const _RecentActivityItem({required this.complaint, required this.onTap});

  final Complaint complaint;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
      child: Container(
        height: 56,
        // Vertical padding of `sm` (not space12) leaves the two-line title+meta Column the
        // ~40px it needs without overflowing this pill's fixed height.
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.space12,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(AppSpacing.radiusPill),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              offset: Offset(0, 1),
              blurRadius: 1,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.surfaceIconCircle,
              ),
              child: Icon(
                categoryIcon(complaint.categoryId),
                size: 20,
                color: AppColors.profileAccent,
              ),
            ),
            const SizedBox(width: AppSpacing.space12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    complaint.title,
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.activityItemTitle
                        .copyWith(color: AppColors.textFigmaPrimary),
                  ),
                  Text(
                    '${complaintStatusLabel(context, complaint.status)} - '
                    '${DateFormatter.relative(complaint.createdAt)}',
                    textAlign: TextAlign.end,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.activityItemMeta
                        .copyWith(color: AppColors.textFigmaTertiary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
