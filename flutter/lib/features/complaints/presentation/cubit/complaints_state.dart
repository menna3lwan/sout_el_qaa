import 'package:equatable/equatable.dart';

import '../../domain/entities/complaint.dart';

enum ComplaintsFilter { all, mine, resolved }

/// Empty isn't a separate subclass — it's [ComplaintsLoaded] with an empty list, so the UI
/// (`state.complaints.isEmpty`) decides whether to show [EmptyView] instead of doubling every
/// "loaded" transition into two near-identical states.
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
