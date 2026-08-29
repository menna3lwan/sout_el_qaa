import 'package:flutter_test/flutter_test.dart';
import 'package:sout_el_qaa/core/utils/date_formatter.dart';

void main() {
  final referenceNow = DateTime(2026, 8, 24, 12, 0, 0);

  group('DateFormatter.relative — matches Figma-confirmed copy exactly', () {
    test('"منذ ساعتين" for a 2-hour-old complaint (Complaints List example)',
        () {
      final twoHoursAgo = referenceNow.subtract(const Duration(hours: 2));
      expect(
        DateFormatter.relative(twoHoursAgo, now: referenceNow),
        'منذ ساعتين',
      );
    });

    test('"منذ 3 ايام" for a 3-day-old complaint (Complaints List example)',
        () {
      final threeDaysAgo = referenceNow.subtract(const Duration(days: 3));
      expect(
        DateFormatter.relative(threeDaysAgo, now: referenceNow),
        'منذ 3 ايام',
      );
    });

    test('"منذ اسبوعين" for a 2-week-old complaint (Complaints List example)',
        () {
      final twoWeeksAgo = referenceNow.subtract(const Duration(days: 14));
      expect(
        DateFormatter.relative(twoWeeksAgo, now: referenceNow),
        'منذ اسبوعين',
      );
    });
  });

  group('DateFormatter.relative — boundary and unit-scale behavior', () {
    test('under a minute returns "الآن"', () {
      final justNow = referenceNow.subtract(const Duration(seconds: 30));
      expect(DateFormatter.relative(justNow, now: referenceNow), 'الآن');
    });

    test('singular minute has no leading number', () {
      final oneMinuteAgo = referenceNow.subtract(const Duration(minutes: 1));
      expect(
          DateFormatter.relative(oneMinuteAgo, now: referenceNow), 'منذ دقيقة');
    });

    test('plural minutes include the count', () {
      final fiveMinutesAgo = referenceNow.subtract(const Duration(minutes: 5));
      expect(
        DateFormatter.relative(fiveMinutesAgo, now: referenceNow),
        'منذ 5 دقايق',
      );
    });

    test('singular hour has no leading number', () {
      final oneHourAgo = referenceNow.subtract(const Duration(hours: 1));
      expect(DateFormatter.relative(oneHourAgo, now: referenceNow), 'منذ ساعة');
    });

    test('59 minutes stays in the minutes bucket, not hours', () {
      final fiftyNineMinutesAgo =
          referenceNow.subtract(const Duration(minutes: 59));
      expect(
        DateFormatter.relative(fiftyNineMinutesAgo, now: referenceNow),
        'منذ 59 دقايق',
      );
    });

    test('6 days stays in the days bucket, not weeks', () {
      final sixDaysAgo = referenceNow.subtract(const Duration(days: 6));
      expect(
        DateFormatter.relative(sixDaysAgo, now: referenceNow),
        'منذ 6 ايام',
      );
    });

    test('singular month has no leading number', () {
      final oneMonthAgo = referenceNow.subtract(const Duration(days: 35));
      expect(DateFormatter.relative(oneMonthAgo, now: referenceNow), 'منذ شهر');
    });
  });
}
