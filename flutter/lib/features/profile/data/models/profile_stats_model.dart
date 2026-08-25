import '../../domain/entities/profile_stats.dart';

final class ProfileStatsModel extends ProfileStats {
  const ProfileStatsModel({
    required super.submittedCount,
    required super.resolvedCount,
    required super.points,
  });

  factory ProfileStatsModel.fromJson(Map<String, dynamic> json) => ProfileStatsModel(
        submittedCount: json['submittedCount'] as int,
        resolvedCount: json['resolvedCount'] as int,
        points: json['points'] as int,
      );
}
