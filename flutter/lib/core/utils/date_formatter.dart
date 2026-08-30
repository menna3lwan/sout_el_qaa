import '../../l10n/app_localizations.dart';

/// Relative-time formatting resolved through [AppLocalizations] ICU plurals (ar/en/de).
abstract final class DateFormatter {
  static String relative(
    DateTime dateTime, {
    required AppLocalizations l10n,
    DateTime? now,
  }) {
    final reference = now ?? DateTime.now();
    final difference = reference.difference(dateTime);

    if (difference.inSeconds < 60) return l10n.relativeTimeNow;
    if (difference.inMinutes < 60) {
      return l10n.relativeMinutes(difference.inMinutes);
    }
    if (difference.inHours < 24) {
      return l10n.relativeHours(difference.inHours);
    }
    if (difference.inDays < 7) {
      return l10n.relativeDays(difference.inDays);
    }

    final weeks = (difference.inDays / 7).floor();
    if (weeks < 5) {
      return l10n.relativeWeeks(weeks);
    }

    final months = (difference.inDays / 30).floor();
    return l10n.relativeMonths(months == 0 ? 1 : months);
  }
}
