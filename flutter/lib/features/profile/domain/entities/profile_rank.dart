/// [New, Figma Sync pass, 29 Aug 2026] The Profile screen's rank/points system (Figma node 33:794:
/// avatar ring badge "منقذ بحري", "245 فقاعة", progress card "49% للترقية" / "اجمع 51 فقاعة إضافية
/// للوصول لرتبة 'بطل القاع'"). Only [ProfileRank.seaRescuer] and [ProfileRank.qaaHero] are
/// Figma-confirmed rank *names* (from the one reviewed example); the other 3 are [Proposed] to
/// complete a believable 5-rank ladder. Localized labels live in the presentation layer
/// ([profile_rank_visuals.dart]) — same split as [ComplaintSeverity] (plain enum here) vs.
/// `severityFlavorLabel` (BuildContext-dependent, in presentation/widgets/).
enum ProfileRank { qaaResident, streetWatcher, seaRescuer, qaaHero, qaaLegend }

/// A points-to-rank ladder — a pure domain rule, not server data (the mock server has no dedicated
/// rank field; [ProfileStats.points] is all it serves, same `submittedCount * 10` formula as before
/// this pass). Thresholds are deliberately tuned to this world's actual (small) complaint volume
/// rather than copying Figma's own example numbers (245 points / 51-to-go / 49%) verbatim — those read
/// as one-off placeholder content, consistent with other placeholder values already flagged in prior
/// audit rounds, not a formula to reverse-engineer exactly.
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
