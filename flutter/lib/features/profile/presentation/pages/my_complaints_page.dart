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
import '../../../../core/widgets/loading_view.dart';
import '../../../complaints/presentation/cubit/complaints_cubit.dart';
import '../../../complaints/presentation/cubit/complaints_state.dart';
import '../../../complaints/presentation/widgets/complaint_list_card.dart';

/// "Profile -> My Complaints -> Complaint Details" flow from the brief. Deliberately reuses
/// [ComplaintsCubit] pre-set to [ComplaintsFilter.mine] instead of a second Cubit that would just
/// re-implement the same fetch — Complaints List already owns "complaints, filtered" as a concept;
/// this screen is that concept with the filter fixed and the tab bar hidden, not a new one.
class MyComplaintsPage extends StatelessWidget {
  const MyComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<ComplaintsCubit>()..load(filter: ComplaintsFilter.mine),
      child: const _MyComplaintsView(),
    );
  }
}

class _MyComplaintsView extends StatelessWidget {
  const _MyComplaintsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.myComplaintsTitle)),
      body: BlocBuilder<ComplaintsCubit, ComplaintsState>(
        builder: (context, state) {
          return switch (state) {
            ComplaintsLoading() => const LoadingView(),
            ComplaintsError(:final messageKey) => ErrorView(
                message: resolveMessageKey(context, messageKey),
                onRetry: () =>
                    context.read<ComplaintsCubit>().load(filter: ComplaintsFilter.mine),
              ),
            ComplaintsLoaded(:final complaints) when complaints.isEmpty =>
              EmptyView(message: context.l10n.complaintsEmptyMessage),
            ComplaintsLoaded(:final complaints) => ListView.separated(
                padding: const EdgeInsets.all(AppSpacing.md),
                itemCount: complaints.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
                itemBuilder: (context, index) {
                  final complaint = complaints[index];
                  return ComplaintListCard(
                    complaint: complaint,
                    onTap: () => context.push(RoutePaths.complaintDetails(complaint.id)),
                  );
                },
              ),
          };
        },
      ),
    );
  }
}
