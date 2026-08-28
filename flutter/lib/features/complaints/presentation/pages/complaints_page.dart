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

  /// [Updated, Full Audit & Sync pass, 27 Aug 2026] Display order only — re-verified against a fresh
  /// fetch of Figma node 33:663: the filter bar's DOM/visual order is "تم حلها" (resolved), "شكوائي"
  /// (mine), "كل الشكاوى" (all, selected by default), not the [ComplaintsFilter] enum's own declaration
  /// order (all, mine, resolved). Spelled out explicitly here rather than `ComplaintsFilter.values` so
  /// this page's display order can differ from the enum's business-meaning order without touching the
  /// enum itself (Important Rule #4: don't change business behavior unnecessarily).
  static const _filters = [
    ComplaintsFilter.resolved,
    ComplaintsFilter.mine,
    ComplaintsFilter.all,
  ];

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
                    context.l10n.complaintsFilterResolved,
                    context.l10n.complaintsFilterMine,
                    context.l10n.complaintsFilterAll,
                  ],
                  selectedIndex: _filters.indexOf(selectedFilter),
                  onSelected: (index) => context
                      .read<ComplaintsCubit>()
                      .load(filter: _filters[index]),
                  // Figma node 33:663's selected pill (the "كل الشكاوى" example) is solid warningFigma
                  // gold with textFigmaPrimary text and no border — distinct from this shared widget's
                  // default navy scheme; see [FilterPillTabs.selectedBackgroundColor]'s doc comment.
                  selectedBackgroundColor: AppColors.warningFigma,
                  // Figma shows no border on the selected pill; passing the same color as the
                  // background keeps [FilterPillTabs]'s `Border.all(..., width: 2)` visually borderless
                  // instead of adding a transparent-border special case to the shared widget.
                  selectedBorderColor: AppColors.warningFigma,
                  selectedTextColor: AppColors.textFigmaPrimary,
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
