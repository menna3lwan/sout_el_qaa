// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'صوت القاع';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get navMap => 'الخريطة';

  @override
  String get navAdd => 'إضافة';

  @override
  String get navComplaints => 'شكاوي';

  @override
  String get navProfile => 'الملف الشخصي';

  @override
  String get genericLoading => 'بنجيب لك الآخر يا ساكن القاع...';

  @override
  String get genericErrorMessage =>
      'معنا مشكلة في الاتصال... جرّب تاني يا ساكن القاع 🐠';

  @override
  String get genericRetry => 'حاول تاني';

  @override
  String get genericEmptyMessage => 'مفيش حاجة هنا لسه يا جار...';

  @override
  String get placeholderScreenMessage =>
      'لسه بنجهز الصفحة دي... قريب هتلاقيها هنا 🐠';

  @override
  String get noInternetConnectionMessage =>
      'مفيش نت دلوقتي... حتى سكان القاع محتاجين واي فاي! جرّب تاني.';

  @override
  String get unauthorizedMessage =>
      'لازم تسجل دخول تاني يا ساكن القاع، الجلسة خلصت.';

  @override
  String get authLoginTitle => 'تسجيل الدخول';
}
