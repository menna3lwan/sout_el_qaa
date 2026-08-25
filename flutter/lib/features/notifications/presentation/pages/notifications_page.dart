import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../core/utils/message_key_resolver.dart';
import '../../../../core/widgets/empty_view.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/filter_pill_tabs.dart';
import '../../../../core/widgets/loading_view.dart';
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

  static const _filters = NotificationsFilter.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.notificationsTitle),
        actions: [
          BlocBuilder<NotificationsCubit, NotificationsState>(
            builder: (context, state) {
              if (state is! NotificationsLoaded) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => context.read<NotificationsCubit>().markAllRead(),
                child: Text(context.l10n.notificationsMarkAllRead),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          final selectedFilter =
              state is NotificationsLoaded ? state.filter : NotificationsFilter.all;

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilterPillTabs(
                  options: [
                    context.l10n.notificationsFilterAll,
                    context.l10n.notificationsFilterComplaints,
                    context.l10n.notificationsFilterReactions,
                    context.l10n.notificationsFilterGeneral,
                  ],
                  selectedIndex: _filters.indexOf(selectedFilter),
                  onSelected: (index) =>
                      context.read<NotificationsCubit>().setFilter(_filters[index]),
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
      NotificationsLoaded(:final visibleNotifications) when visibleNotifications.isEmpty =>
        EmptyView(message: context.l10n.notificationsEmptyMessage),
      NotificationsLoaded(:final visibleNotifications) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
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
