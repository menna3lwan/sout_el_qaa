import 'package:flutter/widgets.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../domain/entities/profile_rank.dart';

/// [New, Figma Sync pass, 29 Aug 2026] The one place [ProfileRank] maps to a localized label — same
/// "single mapping, multiple callers" pattern as `complaintStatusLabel`/`severityFlavorLabel`.
String profileRankLabel(BuildContext context, ProfileRank rank) =>
    switch (rank) {
      ProfileRank.qaaResident => context.l10n.profileRankQaaResident,
      ProfileRank.streetWatcher => context.l10n.profileRankStreetWatcher,
      ProfileRank.seaRescuer => context.l10n.profileRankSeaRescuer,
      ProfileRank.qaaHero => context.l10n.profileRankQaaHero,
      ProfileRank.qaaLegend => context.l10n.profileRankQaaLegend,
    };
