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
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../complaints/presentation/widgets/category_chip.dart';
import '../../../complaints/presentation/widgets/complaint_list_card.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

/// Real implementation, matching Figma node 33:21 (PLAN.md section 3.3): header with avatar/greeting/
/// notifications bell, category grid, primary CTA, trending list, recent activity list.
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
                Text(context.l10n.homeCategoriesHeading, style: AppTypography.headingMedium),
                const SizedBox(height: AppSpacing.sm),
                SizedBox(
                  height: 96,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
                    itemBuilder: (context, index) =>
                        CategoryChip(category: state.categories[index]),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: context.l10n.homeSubmitComplaintCta,
                  icon: Icons.add_circle_outline,
                  onPressed: () => context.push(RoutePaths.createComplaint),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SectionHeader(
                  title: context.l10n.homeTrendingHeading,
                  onViewAll: () => context.go(RoutePaths.complaints),
                ),
                const SizedBox(height: AppSpacing.sm),
                ...state.trending.map(
                  (complaint) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: ComplaintListCard(
                      complaint: complaint,
                      showUrgentBadge: true,
                      onTap: () => context.push(RoutePaths.complaintDetails(complaint.id)),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(context.l10n.homeRecentActivityHeading, style: AppTypography.sectionLabel),
                const SizedBox(height: AppSpacing.sm),
                if (state.recentActivity.isEmpty)
                  Text(context.l10n.genericEmptyMessage, style: AppTypography.metaText)
                else
                  ...state.recentActivity.map(
                    (complaint) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: ComplaintListCard(
                        complaint: complaint,
                        onTap: () => context.push(RoutePaths.complaintDetails(complaint.id)),
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
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AppSpacing.radiusXl)),
      ),
      child: Row(
        children: [
          QaaAvatar(displayName: user.displayName),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              context.l10n.homeGreeting(user.displayName),
              style: AppTypography.greeting,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: AppColors.textOnBrand),
            onPressed: () => context.push(RoutePaths.notifications),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.onViewAll});

  final String title;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.sectionLabel),
        TextButton(
          onPressed: onViewAll,
          child: Text(
            context.l10n.homeViewAll,
            style: AppTypography.metaText.copyWith(color: AppColors.homeLinkText),
          ),
        ),
      ],
    );
  }
}
