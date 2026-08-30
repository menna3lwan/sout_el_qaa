import 'package:equatable/equatable.dart';

/// Backs the 3 [StatCard]s on Profile — submitted / resolved / points.
base class ProfileStats extends Equatable {
  const ProfileStats({
    required this.submittedCount,
    required this.resolvedCount,
    required this.points,
  });

  final int submittedCount;
  final int resolvedCount;
  final int points;

  @override
  List<Object?> get props => [submittedCount, resolvedCount, points];
}
