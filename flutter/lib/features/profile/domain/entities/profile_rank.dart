/// The Profile screen's rank/points system. Only [ProfileRank.seaRescuer] and
/// [ProfileRank.qaaHero] are Figma-confirmed rank names; the other 3 complete a believable
/// 5-rank ladder. Localized labels live in the presentation layer ([profile_rank_visuals.dart])
/// — same split as [ComplaintSeverity] (plain enum here) vs. `severityFlavorLabel`
/// (BuildContext-dependent, in presentation/widgets/).
enum ProfileRank { qaaResident, streetWatcher, seaRescuer, qaaHero, qaaLegend }

/// A points-to-rank ladder — a pure domain rule, not server data (the mock server only serves
/// [ProfileStats.points]). Thresholds are tuned to this world's actual (small) complaint volume
/// rather than copying Figma's own example numbers verbatim.
abstract final class ProfileRankLadder {
  static const List<(int minPoints, ProfileRank rank)> _thresholds = [
    (0, ProfileRank.qaaResident),
    (20, ProfileRank.streetWatcher),
    (40, ProfileRank.seaRescuer),
    (80, ProfileRank.qaaHero),
    (150, ProfileRank.qaaLegend),
  ];

  static ProfileRank rankFor(int points) {
    var current = _thresholds.first.$2;
    for (final (minPoints, rank) in _thresholds) {
      if (points >= minPoints) current = rank;
    }
    return current;
  }

  /// Null once [rankFor] already returns the top rank ([ProfileRank.qaaLegend]).
  static ProfileRank? nextRankFor(int points) {
    for (final (minPoints, rank) in _thresholds) {
      if (points < minPoints) return rank;
    }
    return null;
  }

  /// 0 once there's no next rank to reach.
  static int pointsToNextRank(int points) {
    for (final (minPoints, _) in _thresholds) {
      if (points < minPoints) return minPoints - points;
    }
    return 0;
  }

  /// 0.0-1.0 progress within the current rank's band; 1.0 once at the top rank.
  static double progressToNextRank(int points) {
    final currentRank = rankFor(points);
    final currentIndex =
        _thresholds.indexWhere((entry) => entry.$2 == currentRank);
    final currentMin = _thresholds[currentIndex].$1;
    if (currentIndex == _thresholds.length - 1) return 1;
    final nextMin = _thresholds[currentIndex + 1].$1;
    return ((points - currentMin) / (nextMin - currentMin)).clamp(0, 1);
  }
}
