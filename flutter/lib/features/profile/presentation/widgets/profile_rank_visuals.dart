import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/profile_rank.dart';

/// The one place [ProfileRank] maps to a localized label — same "single mapping, multiple
/// callers" pattern as `complaintStatusLabel`/`severityFlavorLabel`.
String profileRankLabel(BuildContext context, ProfileRank rank) =>
    switch (rank) {
      ProfileRank.qaaResident => context.l10n.profileRankQaaResident,
      ProfileRank.streetWatcher => context.l10n.profileRankStreetWatcher,
      ProfileRank.seaRescuer => context.l10n.profileRankSeaRescuer,
      ProfileRank.qaaHero => context.l10n.profileRankQaaHero,
      ProfileRank.qaaLegend => context.l10n.profileRankQaaLegend,
    };

/// Icons picked to each rank's own theme, same "complete the set consistently" rule as
/// [severityFlavorIcon]'s medium/low entries.
IconData profileRankIcon(ProfileRank rank) => switch (rank) {
      ProfileRank.qaaResident => Icons.home_outlined,
      ProfileRank.streetWatcher => Icons.visibility_outlined,
      ProfileRank.seaRescuer => Icons.support,
      ProfileRank.qaaHero => Icons.shield_outlined,
      ProfileRank.qaaLegend => Icons.military_tech,
    };
