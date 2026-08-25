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

  /// No description provided for @genericCancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get genericCancel;

  /// No description provided for @genericConfirm.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد'**
  String get genericConfirm;

  /// No description provided for @genericNext.
  ///
  /// In ar, this message translates to:
  /// **'التالي'**
  String get genericNext;

  /// No description provided for @genericBack.
  ///
  /// In ar, this message translates to:
  /// **'رجوع'**
  String get genericBack;

  /// No description provided for @genericSave.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get genericSave;

  /// No description provided for @genericOptional.
  ///
  /// In ar, this message translates to:
  /// **'اختياري'**
  String get genericOptional;

  /// No description provided for @validationRequired.
  ///
  /// In ar, this message translates to:
  /// **'الحقل ده مطلوب'**
  String get validationRequired;

  /// No description provided for @validationInvalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'الإيميل مش صيغته صح'**
  String get validationInvalidEmail;

  /// No description provided for @validationPasswordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر لازم تكون 8 حروف على الأقل'**
  String get validationPasswordTooShort;

  /// No description provided for @validationPasswordTooWeak.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر لازم تحتوي على حروف وأرقام'**
  String get validationPasswordTooWeak;

  /// No description provided for @validationPasswordMismatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر مش متطابقة'**
  String get validationPasswordMismatch;

  /// No description provided for @validationTooLong.
  ///
  /// In ar, this message translates to:
  /// **'النص ده أطول من المسموح'**
  String get validationTooLong;

  /// عنوان شاشة تسجيل الدخول — شاشة من تصميمنا [C3]، مش من الـFigma
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get authLoginTitle;

  /// No description provided for @authEmailLabel.
  ///
  /// In ar, this message translates to:
  /// **'الإيميل'**
  String get authEmailLabel;

  /// No description provided for @authPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر'**
  String get authPasswordLabel;

  /// No description provided for @authLoginButton.
  ///
  /// In ar, this message translates to:
  /// **'دخول'**
  String get authLoginButton;

  /// No description provided for @authNoAccountPrompt.
  ///
  /// In ar, this message translates to:
  /// **'لسه معملتش حساب؟'**
  String get authNoAccountPrompt;

  /// No description provided for @authRegisterLink.
  ///
  /// In ar, this message translates to:
  /// **'سجل دلوقتي'**
  String get authRegisterLink;

  /// No description provided for @authRegisterTitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب جديد'**
  String get authRegisterTitle;

  /// No description provided for @authUsernameLabel.
  ///
  /// In ar, this message translates to:
  /// **'اسم المستخدم'**
  String get authUsernameLabel;

  /// No description provided for @authConfirmPasswordLabel.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة السر'**
  String get authConfirmPasswordLabel;

  /// No description provided for @authRegisterButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get authRegisterButton;

  /// No description provided for @authHaveAccountPrompt.
  ///
  /// In ar, this message translates to:
  /// **'عندك حساب بالفعل؟'**
  String get authHaveAccountPrompt;

  /// No description provided for @authLoginLink.
  ///
  /// In ar, this message translates to:
  /// **'سجل دخولك'**
  String get authLoginLink;

  /// تحية الهيدر — النص مؤكد من الـFigma "صباح الفل يا ساكن المحيط!"، اتعدّل هنا عشان يشيل اسم المستخدم الحقيقي بدل النص الثابت
  ///
  /// In ar, this message translates to:
  /// **'صباح الفل يا ساكن القاع، {name}!'**
  String homeGreeting(String name);

  /// No description provided for @homeCategoriesHeading.
  ///
  /// In ar, this message translates to:
  /// **'تصنيفات الشكاوى'**
  String get homeCategoriesHeading;

  /// No description provided for @homeSubmitComplaintCta.
  ///
  /// In ar, this message translates to:
  /// **'قدم شكوى جديدة'**
  String get homeSubmitComplaintCta;

  /// No description provided for @homeTrendingHeading.
  ///
  /// In ar, this message translates to:
  /// **'أكثر الشكاوى تفاعلاً'**
  String get homeTrendingHeading;

  /// No description provided for @homeViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get homeViewAll;

  /// No description provided for @homeRecentActivityHeading.
  ///
  /// In ar, this message translates to:
  /// **'نشاطاتك الأخيرة'**
  String get homeRecentActivityHeading;

  /// No description provided for @homeUrgentBadge.
  ///
  /// In ar, this message translates to:
  /// **'عاجل'**
  String get homeUrgentBadge;

  /// No description provided for @homeViewsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مشاهدة'**
  String homeViewsCount(int count);

  /// No description provided for @homeLikesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} إعجاب'**
  String homeLikesCount(int count);

  /// No description provided for @complaintsFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get complaintsFilterAll;

  /// No description provided for @complaintsFilterMine.
  ///
  /// In ar, this message translates to:
  /// **'شكاواي'**
  String get complaintsFilterMine;

  /// No description provided for @complaintsFilterResolved.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get complaintsFilterResolved;

  /// No description provided for @complaintsEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'مفيش شكاوى في القسم ده لسه'**
  String get complaintsEmptyMessage;

  /// No description provided for @detailsTitle.
  ///
  /// In ar, this message translates to:
  /// **'حالة الشكوى'**
  String get detailsTitle;

  /// No description provided for @detailsSectionHeading.
  ///
  /// In ar, this message translates to:
  /// **'التفاصيل'**
  String get detailsSectionHeading;

  /// No description provided for @statusReceivedLabel.
  ///
  /// In ar, this message translates to:
  /// **'تم الاستلام'**
  String get statusReceivedLabel;

  /// [Assumption A#] الفيجما بتستخدم صياغتين مختلفتين لنفس الحالة (قيد المراجعة/قيد المعالجة) — اخترنا دي كنص موحّد لحد ما يتأكد
  ///
  /// In ar, this message translates to:
  /// **'قيد المراجعة'**
  String get statusInReviewLabel;

  /// No description provided for @statusResolvedLabel.
  ///
  /// In ar, this message translates to:
  /// **'تم الحل'**
  String get statusResolvedLabel;

  /// No description provided for @commentsHeading.
  ///
  /// In ar, this message translates to:
  /// **'التعليقات'**
  String get commentsHeading;

  /// No description provided for @commentInputHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب تعليقك هنا يا جار...'**
  String get commentInputHint;

  /// No description provided for @commentSubmit.
  ///
  /// In ar, this message translates to:
  /// **'إرسال'**
  String get commentSubmit;

  /// No description provided for @commentsEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'لسه محدش علّق، خلّيك أول واحد'**
  String get commentsEmptyMessage;

  /// No description provided for @locationLabel.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get locationLabel;

  /// No description provided for @createComplaintTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقديم شكوى'**
  String get createComplaintTitle;

  /// No description provided for @stepFillTitle.
  ///
  /// In ar, this message translates to:
  /// **'بيانات الشكوى'**
  String get stepFillTitle;

  /// No description provided for @fieldTitleLabel.
  ///
  /// In ar, this message translates to:
  /// **'عنوان الشكوى'**
  String get fieldTitleLabel;

  /// No description provided for @fieldTitleHint.
  ///
  /// In ar, this message translates to:
  /// **'اكتب عنوان مختصر للشكوى'**
  String get fieldTitleHint;

  /// No description provided for @fieldDescriptionLabel.
  ///
  /// In ar, this message translates to:
  /// **'وصف الشكوى'**
  String get fieldDescriptionLabel;

  /// No description provided for @fieldDescriptionHint.
  ///
  /// In ar, this message translates to:
  /// **'احكيلنا المشكلة بالتفصيل...'**
  String get fieldDescriptionHint;

  /// No description provided for @descriptionCounter.
  ///
  /// In ar, this message translates to:
  /// **'{current}/{max}'**
  String descriptionCounter(int current, int max);

  /// No description provided for @stepCategoryTitle.
  ///
  /// In ar, this message translates to:
  /// **'نوع الشكوى'**
  String get stepCategoryTitle;

  /// No description provided for @stepLocationTitle.
  ///
  /// In ar, this message translates to:
  /// **'الموقع'**
  String get stepLocationTitle;

  /// No description provided for @pickLocationOnMapButton.
  ///
  /// In ar, this message translates to:
  /// **'اختار الموقع من الخريطة'**
  String get pickLocationOnMapButton;

  /// No description provided for @locationSelectedLabel.
  ///
  /// In ar, this message translates to:
  /// **'الموقع المختار'**
  String get locationSelectedLabel;

  /// No description provided for @stepSeverityTitle.
  ///
  /// In ar, this message translates to:
  /// **'درجة الخطورة'**
  String get stepSeverityTitle;

  /// No description provided for @severityHighLabel.
  ///
  /// In ar, this message translates to:
  /// **'عالية'**
  String get severityHighLabel;

  /// No description provided for @severityMediumLabel.
  ///
  /// In ar, this message translates to:
  /// **'متوسطة'**
  String get severityMediumLabel;

  /// No description provided for @severityLowLabel.
  ///
  /// In ar, this message translates to:
  /// **'منخفضة'**
  String get severityLowLabel;

  /// No description provided for @attachPhotoButton.
  ///
  /// In ar, this message translates to:
  /// **'أضف صورة'**
  String get attachPhotoButton;

  /// No description provided for @removePhotoLabel.
  ///
  /// In ar, this message translates to:
  /// **'احذف الصورة'**
  String get removePhotoLabel;

  /// No description provided for @submitComplaintButton.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الشكوة'**
  String get submitComplaintButton;

  /// No description provided for @successTitle.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال شكواك!'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'هنراجعها ونحدثك أول بأول يا ساكن القاع 🐠'**
  String get successMessage;

  /// No description provided for @successBackToHomeButton.
  ///
  /// In ar, this message translates to:
  /// **'الرجوع للرئيسية'**
  String get successBackToHomeButton;

  /// [Proposed P3] الشاشة دي مالهاش تصميم في الفيجما (الفريم فاضي)، التصميم من عندنا بنفس روح باقي الشاشات
  ///
  /// In ar, this message translates to:
  /// **'الخريطة'**
  String get mapTitle;

  /// No description provided for @mapViewDetailsButton.
  ///
  /// In ar, this message translates to:
  /// **'عرض التفاصيل'**
  String get mapViewDetailsButton;

  /// No description provided for @notificationsTitle.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notificationsTitle;

  /// No description provided for @notificationsFilterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get notificationsFilterAll;

  /// No description provided for @notificationsFilterComplaints.
  ///
  /// In ar, this message translates to:
  /// **'الشكاوى'**
  String get notificationsFilterComplaints;

  /// No description provided for @notificationsFilterReactions.
  ///
  /// In ar, this message translates to:
  /// **'التفاعلات'**
  String get notificationsFilterReactions;

  /// No description provided for @notificationsFilterGeneral.
  ///
  /// In ar, this message translates to:
  /// **'عام'**
  String get notificationsFilterGeneral;

  /// No description provided for @notificationsMarkAllRead.
  ///
  /// In ar, this message translates to:
  /// **'تحديد الكل كمقروء'**
  String get notificationsMarkAllRead;

  /// No description provided for @notificationsEmptyMessage.
  ///
  /// In ar, this message translates to:
  /// **'مفيش إشعارات جديدة يا جار'**
  String get notificationsEmptyMessage;

  /// No description provided for @profilePersonalInfoMenu.
  ///
  /// In ar, this message translates to:
  /// **'البيانات الشخصية'**
  String get profilePersonalInfoMenu;

  /// No description provided for @profileMyComplaintsMenu.
  ///
  /// In ar, this message translates to:
  /// **'شكاواي'**
  String get profileMyComplaintsMenu;

  /// No description provided for @profileFavoritesMenu.
  ///
  /// In ar, this message translates to:
  /// **'المفضلة'**
  String get profileFavoritesMenu;

  /// No description provided for @profileSettingsMenu.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get profileSettingsMenu;

  /// No description provided for @profileLogoutMenu.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get profileLogoutMenu;

  /// No description provided for @profileStatSubmitted.
  ///
  /// In ar, this message translates to:
  /// **'شكاوى مقدَّمة'**
  String get profileStatSubmitted;

  /// No description provided for @profileStatResolved.
  ///
  /// In ar, this message translates to:
  /// **'شكاوى محلولة'**
  String get profileStatResolved;

  /// [Requires Confirmation] الفيجما فيها ليبل "منقذ بحري" غير واضح المعنى كنص نهائي — استخدمنا "نقاط المشاركة" كأقرب تفسير منطقي لحد ما يتأكد، انظر التقرير
  ///
  /// In ar, this message translates to:
  /// **'نقاط المشاركة'**
  String get profileStatPoints;

  /// No description provided for @myComplaintsTitle.
  ///
  /// In ar, this message translates to:
  /// **'شكاواي'**
  String get myComplaintsTitle;

  /// No description provided for @logoutConfirmTitle.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get logoutConfirmTitle;

  /// No description provided for @logoutConfirmMessage.
  ///
  /// In ar, this message translates to:
  /// **'متأكد إنك عايز تسجل خروج يا ساكن القاع؟'**
  String get logoutConfirmMessage;

  /// No description provided for @logoutConfirmYes.
  ///
  /// In ar, this message translates to:
  /// **'أيوة، سجلني خروج'**
  String get logoutConfirmYes;

  /// No description provided for @logoutConfirmCancel.
  ///
  /// In ar, this message translates to:
  /// **'لأ، رجّعني'**
  String get logoutConfirmCancel;
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
