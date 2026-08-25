import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint.dart';

/// The 3 filter tabs confirmed from Figma's Complaints List (PLAN.md section 3.5): "الكل"/"شكاواي"/"تم الحل".
enum ComplaintsFilter { all, mine, resolved }

/// Loading/Success(+Empty)/Error per PLAN.md section 6; Empty isn't a separate subclass — it's
/// [ComplaintsLoaded] with an empty list, so the UI (`state.complaints.isEmpty`) decides whether to
/// show [EmptyView] instead of doubling every "loaded" transition into two near-identical states.
sealed class ComplaintsState extends Equatable {
  const ComplaintsState();

  @override
  List<Object?> get props => [];
}

final class ComplaintsLoading extends ComplaintsState {
  const ComplaintsLoading();
}

final class ComplaintsLoaded extends ComplaintsState {
  const ComplaintsLoaded({required this.complaints, required this.filter});

  final List<Complaint> complaints;
  final ComplaintsFilter filter;

  @override
  List<Object?> get props => [complaints, filter];
}

final class ComplaintsError extends ComplaintsState {
  const ComplaintsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
