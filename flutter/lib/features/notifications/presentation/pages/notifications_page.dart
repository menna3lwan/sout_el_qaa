import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/filter_pill_tabs.dart';
import '../../../../core/widgets/loading_view.dart';
import '../../../../core/widgets/qaa_avatar.dart';
import '../cubit/notifications_cubit.dart';
import '../cubit/notifications_state.dart';
import '../widgets/notification_card.dart';

/// New screen, matching Figma node 33:936 (PLAN.md section 3.9): filter tabs over a list of
/// [NotificationCard]s; tapping one marks it read and, if it references a complaint, pushes there
/// ("Notifications -> Notification -> Related Complaint" flow from the brief).
class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<NotificationsCubit>()..load(),
      child: const _NotificationsView(),
    );
  }
}

class _NotificationsView extends StatelessWidget {
  const _NotificationsView();

  /// [Updated, Full Audit & Sync pass, 27 Aug 2026] Display order only — a fresh fetch of Figma node
  /// 33:936 shows the filter bar's DOM/visual order is "عام" (general), "تفاعلات" (reactions), "شكاوى"
  /// (complaints), "الكل" (all, selected by default) — the exact reverse of [NotificationsFilter]'s own
  /// declaration order. Spelled out explicitly rather than `NotificationsFilter.values` so this page's
  /// display order can differ from the enum's business-meaning order without touching the enum itself
  /// (Important Rule #4: don't change business behavior unnecessarily) — same pattern already applied
  /// to Complaints List's own filter bar.
  static const _filters = [
    NotificationsFilter.general,
    NotificationsFilter.reactions,
    NotificationsFilter.complaints,
    NotificationsFilter.all,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          // The header avatar every other screen shows (Figma node 33:936) — this app has a single
          // demo resident (SpongeBob), so it's the same bundled asset used everywhere else, not a
          // per-user lookup.
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: QaaAvatar(
              assetPath: 'assets/images/characters/spongebob_avatar.jpg',
              size: 36,
            ),
          ),
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is! NotificationsLoaded) return const SizedBox.shrink();
              return TextButton(
                onPressed: () =>
                    context.read<NotificationsCubit>().markAllRead(),
                child: Text(context.l10n.notificationsMarkAllRead),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final selectedFilter = state is NotificationsLoaded
              ? state.filter
              : NotificationsFilter.all;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilterPillTabs(
                  options: [
                    context.l10n.notificationsFilterGeneral,
                    context.l10n.notificationsFilterReactions,
                    context.l10n.notificationsFilterComplaints,
                    context.l10n.notificationsFilterAll,
                  ],
                  selectedIndex: _filters.indexOf(selectedFilter),
                  onSelected: (index) => context
                      .read<NotificationsCubit>()
                      .setFilter(_filters[index]),
                  // Figma node 33:936's selected pill is solid notificationFilterSelectedBackground
                  // (#FFC928, already this exact token) with notificationCardAccent (#083B4C) text and
                  // no border (same-as-background trick as Complaints List uses, see
                  // [FilterPillTabs.selectedBorderColor]'s doc comment).
                  selectedBackgroundColor:
                      AppColors.notificationFilterSelectedBackground,
                  selectedBorderColor:
                      AppColors.notificationFilterSelectedBackground,
                  selectedTextColor: AppColors.notificationCardAccent,
                  // The unselected pills are translucent white (already the exact
                  // glassOverlayNotificationFilter token) with a notificationCardAccent border and
                  // notificationFilterUnselectedText text — all three genuinely different from
                  // [FilterPillTabs]'s Complaints-List-matching defaults.
                  unselectedBackgroundColor:
                      AppColors.glassOverlayNotificationFilter,
                  unselectedBorderColor: AppColors.notificationCardAccent,
                  unselectedTextColor:
                      AppColors.notificationFilterUnselectedText,
                ),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, NotificationsState state) {
    return switch (state) {
      NotificationsLoading() => const LoadingView(),
      NotificationsError(:final messageKey) => ErrorView(
          message: resolveMessageKey(context, messageKey),
          onRetry: () => context.read<NotificationsCubit>().load(),
        ),
      NotificationsLoaded(:final visibleNotifications)
          when visibleNotifications.isEmpty =>
        EmptyView(message: context.l10n.notificationsEmptyMessage),
      NotificationsLoaded(:final visibleNotifications) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
              AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
          itemCount: visibleNotifications.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final notification = visibleNotifications[index];
            return NotificationCard(
              notification: notification,
              onTap: () {
                context.read<NotificationsCubit>().markRead(notification.id);
                final complaintId = notification.complaintId;
                if (complaintId != null) {
                  context.push(RoutePaths.complaintDetails(complaintId));
                }
              },
            );
          },
        ),
    };
  }
}
