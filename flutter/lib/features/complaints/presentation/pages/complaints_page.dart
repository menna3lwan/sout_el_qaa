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
import '../../../../core/widgets/qaa_avatar.dart';
import '../cubit/complaints_cubit.dart';
import '../cubit/complaints_state.dart';
import '../widgets/complaint_list_card.dart';

/// Real implementation, matching Figma node 33:663 (PLAN.md section 3.5): 3-tab filter bar over a
/// list of [ComplaintListCard]s; scope reminder (PLAN.md section 18) no longer applies as written —
/// the combined Demo App pass also builds ComplaintDetailsPage, so tapping a card here pushes there.
class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ComplaintsCubit>()..load(),
      child: const _ComplaintsView(),
    );
  }
}

class _ComplaintsView extends StatelessWidget {
  const _ComplaintsView();

  static const _filters = ComplaintsFilter.values;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.navComplaints),
        actions: const [
          // The header avatar Figma shows here too (node 33:663) — same bundled asset as every
          // other screen (single demo resident, not a per-user lookup).
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
            child: QaaAvatar(
              assetPath: 'assets/images/characters/spongebob_avatar.jpg',
              size: 36,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
        builder: (context, state) {
          final selectedFilter = switch (state) {
            ComplaintsLoaded(:final filter) => filter,
            _ => ComplaintsFilter.all,
          };

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: FilterPillTabs(
                  options: [
                    context.l10n.complaintsFilterAll,
                    context.l10n.complaintsFilterMine,
                    context.l10n.complaintsFilterResolved,
                  ],
                  selectedIndex: _filters.indexOf(selectedFilter),
                  onSelected: (index) => context
                      .read<ComplaintsCubit>()
                      .load(filter: _filters[index]),
                ),
              ),
              Expanded(child: _buildBody(context, state)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context, ComplaintsState state) {
    return switch (state) {
      ComplaintsLoading() => const LoadingView(),
      ComplaintsError(:final messageKey) => ErrorView(
          message: resolveMessageKey(context, messageKey),
          onRetry: () => context.read<ComplaintsCubit>().load(),
        ),
      ComplaintsLoaded(:final complaints) when complaints.isEmpty =>
        EmptyView(message: context.l10n.complaintsEmptyMessage),
      ComplaintsLoaded(:final complaints) => ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          itemCount: complaints.length,
          separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final complaint = complaints[index];
            return ComplaintListCard(
              complaint: complaint,
              onTap: () =>
                  context.push(RoutePaths.complaintDetails(complaint.id)),
            );
          },
        ),
    };
  }
}
