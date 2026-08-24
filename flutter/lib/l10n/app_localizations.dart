import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// اسم التطبيق — يظهر في عنوان النافذة/الـtask switcher. مؤكد من مفهوم المنتج.
  ///
  /// In ar, this message translates to:
  /// **'صوت القاع'**
  String get appTitle;

  /// تاب الشاشة الرئيسية في الـBottomNavBar — مؤكد نصيًا من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// تاب الخريطة — مؤكد نصيًا من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get navMap;

  /// تاب تقديم شكوى جديدة (الزرار الأوسط المرتفع) — مؤكد نصيًا من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get navAdd;

  /// تاب الشكاوى — مؤكد نصيًا من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'شكاوي'**
  String get navComplaints;

  /// تاب الملف الشخصي — مؤكد نصيًا من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get navProfile;

  /// نص افتراضي لـLoadingView المشترك، بروح قاع الهامور
  ///
  /// In ar, this message translates to:
  /// **'بنجيب لك الآخر يا ساكن القاع...'**
  String get genericLoading;

  /// رسالة الخطأ العامة الافتراضية — القسم 1.6 من الـplan
  ///
  /// In ar, this message translates to:
  /// **'معنا مشكلة في الاتصال... جرّب تاني يا ساكن القاع 🐠'**
  String get genericErrorMessage;

  /// نص زرار إعادة المحاولة الافتراضي
  ///
  /// In ar, this message translates to:
  /// **'حاول تاني'**
  String get genericRetry;

  /// نص افتراضي لـEmptyView المشترك
  ///
  /// In ar, this message translates to:
  /// **'مفيش حاجة هنا لسه يا جار...'**
  String get genericEmptyMessage;

  /// نص placeholder موحّد للشاشات اللي لسه ما اتنفذتش (foundation branch فقط)
  ///
  /// In ar, this message translates to:
  /// **'لسه بنجهز الصفحة دي... قريب هتلاقيها هنا 🐠'**
  String get placeholderScreenMessage;

  /// رسالة عدم الاتصال بالإنترنت — NetworkFailure
  ///
  /// In ar, this message translates to:
  /// **'مفيش نت دلوقتي... حتى سكان القاع محتاجين واي فاي! جرّب تاني.'**
  String get noInternetConnectionMessage;

  /// رسالة UnauthorizedFailure — تظهر قبل auto-logout
  ///
  /// In ar, this message translates to:
  /// **'لازم تسجل دخول تاني يا ساكن القاع، الجلسة خلصت.'**
  String get unauthorizedMessage;

  /// عنوان شاشة تسجيل الدخول — شاشة من تصميمنا [C3]، مش من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLoginTitle;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
