/// Relative-time formatting. Arabic strings are hardcoded for now and should become ARB plural
/// keys once the app is genuinely bilingual at runtime.
abstract final class DateFormatter {
  static String relative(DateTime dateTime, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final difference = reference.difference(dateTime);

    if (difference.inSeconds < 60) return 'الآن';
    if (difference.inMinutes < 60) {
      return _phrase(difference.inMinutes, 'دقيقة', 'دقيقتين', 'دقايق');
    }
    if (difference.inHours < 24) {
      return _phrase(difference.inHours, 'ساعة', 'ساعتين', 'ساعات');
    }
    if (difference.inDays < 7) {
      // "ايام" is deliberately spelled without the hamza, matching the design's literal text.
      return _phrase(difference.inDays, 'يوم', 'يومين', 'ايام');
    }

    final weeks = (difference.inDays / 7).floor();
    if (weeks < 5) {
      return _phrase(weeks, 'اسبوع', 'اسبوعين', 'اسابيع');
    }

    final months = (difference.inDays / 30).floor();
    return _phrase(months, 'شهر', 'شهرين', 'شهور');
  }

  /// Arabic singular/dual forms omit the digit ("منذ ساعتين" not "منذ 2 ساعتين"); plural (3+)
  /// includes it explicitly.
  static String _phrase(
    int count,
    String singular,
    String dual,
    String plural,
  ) {
    if (count == 1) return 'منذ $singular';
    if (count == 2) return 'منذ $dual';
    return 'منذ $count $plural';
  }
}
