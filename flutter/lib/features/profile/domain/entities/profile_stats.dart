import 'package:equatable/equatable.dart';

/// GET /users/me/stats (PLAN.md section 16) — backs the 3 [StatCard]s on Profile ("شكاوى مقدَّمة" /
/// "شكاوى محلولة" / a 3rd stat whose Figma label "منقذ بحري" is unclear as final copy, mapped to
/// "points" here — see profileStatPoints's ARB description and the final report's Assumptions section).
final class ProfileStats extends Equatable {
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
