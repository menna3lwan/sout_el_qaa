/// تنسيق تاريخ نسبي — مطابق حرفيًا للأمثلة المؤكدة من الـFigma (القسم 3.5):
/// "منذ ساعتين" (dual، بلا رقم)، "منذ 3 ايام" (جمع، مع الرقم)، "منذ اسبوعين"
/// (dual، بلا رقم). النصوص عربي مباشر مؤقتًا؛ هتتحول لمفاتيح ARB بدعم plural
/// حقيقي لما التطبيق يبقى فعليًا bilingual في الاستخدام، مش بس في البنية
/// (القرار [C5] بنية بس دلوقتي).
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
      // "ايام" بدون همزة عمدًا — نفس الإملاء الحرفي الظاهر في نص الـFigma
      // المؤكد ("منذ 3 ايام"، القسم 3.5 من الـplan)، مش الإملاء الرسمي "أيام".
      return _phrase(difference.inDays, 'يوم', 'يومين', 'ايام');
    }

    final weeks = (difference.inDays / 7).floor();
    if (weeks < 5) {
      return _phrase(weeks, 'اسبوع', 'اسبوعين', 'اسابيع');
    }

    final months = (difference.inDays / 30).floor();
    return _phrase(months, 'شهر', 'شهرين', 'شهور');
  }

  /// عربي: المفرد والمثنى (dual) بياخدوا شكل خاص من غير ما يتكرر معاهم الرقم
  /// ("منذ ساعتين" مش "منذ 2 ساعتين")؛ الجمع (3+) بياخد الرقم صراحة —
  /// النمط ده مؤكد حرفيًا من نصوص الـFigma الفعلية.
  static String _phrase(int count, String singular, String dual, String plural) {
    if (count == 1) return 'منذ $singular';
    if (count == 2) return 'منذ $dual';
    return 'منذ $count $plural';
  }
}
