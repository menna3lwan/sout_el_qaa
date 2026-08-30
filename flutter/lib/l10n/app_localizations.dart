import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
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
    Locale('de'),
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

  /// عنوان شاشة تسجيل الدخول — شاشة من تصميمنا، مش من الـFigma
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

  /// سطر الموقع تحت تحية الهيدر مباشرة — الـstreet جاي من user.bio.
  ///
  /// In ar, this message translates to:
  /// **'قاع الهامور، {street}'**
  String homeLocationLine(String street);

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

  /// نص الـsearch bar — لا يوجد search flow حقيقي مربوط بيه لسه
  ///
  /// In ar, this message translates to:
  /// **'إبحث عن شكوى...'**
  String get homeSearchHint;

  /// No description provided for @homeTrendingHeading.
  ///
  /// In ar, this message translates to:
  /// **'أكثر الشكاوى تفاعلاً'**
  String get homeTrendingHeading;

  /// No description provided for @homeTrendingSubheading.
  ///
  /// In ar, this message translates to:
  /// **'شوف إيه اللي شاغل سكان القاع'**
  String get homeTrendingSubheading;

  /// No description provided for @homeViewAll.
  ///
  /// In ar, this message translates to:
  /// **'عرض الكل'**
  String get homeViewAll;

  /// زرار على كارت الشكوى الرائجة — بيودّي لتفاصيل الشكوى بدل ما يعدّل الحالة من الكارت نفسه
  ///
  /// In ar, this message translates to:
  /// **'عندي نفس المشكله'**
  String get homeSameProblemCta;

  /// عدّاد "كام واحد بلّغ عن نفس المشكلة" — بيستخدم نفس قيمة likes لحد ما يتوفر حقل مخصص من الباك إند
  ///
  /// In ar, this message translates to:
  /// **'+{count}'**
  String homeSameProblemCount(int count);

  /// No description provided for @homeRecentActivityHeading.
  ///
  /// In ar, this message translates to:
  /// **'شكاوى محتاجة صوتك'**
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

  /// عنوان الـAppBar لشاشة تفاصيل الشكوى — مختلف عن [detailsTitle]، عنوان القسم الفرعي جوه الصفحة
  ///
  /// In ar, this message translates to:
  /// **'تفاصيل الشكوى'**
  String get complaintDetailsAppBarTitle;

  /// عنوان القسم الفرعي فوق الـstepper مباشرة
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

  /// No description provided for @statusInReviewLabel.
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

  /// ليبل "الخطورة" المنكّه على بادچ تفاصيل الشكوى — مختلف عن ليبل "عالية" العادي في نموذج تقديم الشكوى
  ///
  /// In ar, this message translates to:
  /// **'كارثة قومية'**
  String get severityFlavorHigh;

  /// بنفس روح severityFlavorHigh، لدرجة الخطورة المتوسطة
  ///
  /// In ar, this message translates to:
  /// **'مصيبة مش بسيطة'**
  String get severityFlavorMedium;

  /// بنفس روح severityFlavorHigh، لدرجة الخطورة المنخفضة
  ///
  /// In ar, this message translates to:
  /// **'شكوى عادية'**
  String get severityFlavorLow;

  /// عدّاد البلاغات في صف التفاعلات بتفاصيل الشكوى
  ///
  /// In ar, this message translates to:
  /// **'{count} بلاغ'**
  String complaintReportsCount(int count);

  /// عدّاد عدم الإعجاب في صف التفاعلات بتفاصيل الشكوى
  ///
  /// In ar, this message translates to:
  /// **'{count} عدم إعجاب'**
  String complaintDislikesCount(int count);

  /// No description provided for @createComplaintTitle.
  ///
  /// In ar, this message translates to:
  /// **'تقديم شكوى'**
  String get createComplaintTitle;

  /// عنوان الـAppBar في خطوتي المراجعة والنجاح — أقصر من عنوان خطوة النموذج الأولى
  ///
  /// In ar, this message translates to:
  /// **'تقديم شكوي'**
  String get createComplaintTitleShort;

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

  /// عنوان خطوة المراجعة (خطوة 2 من 3): نموذج موحّد -> مراجعة -> نجاح
  ///
  /// In ar, this message translates to:
  /// **'راجع شكوتك قبل الإرسال'**
  String get createComplaintReviewTitle;

  /// No description provided for @createComplaintReviewSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اتأكد إن كل حاجة تمام قبل ما توصل لسكان القاع'**
  String get createComplaintReviewSubtitle;

  /// No description provided for @createComplaintCancelButton.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الشكوى'**
  String get createComplaintCancelButton;

  /// No description provided for @createComplaintEditButton.
  ///
  /// In ar, this message translates to:
  /// **'تعديل الشكوى'**
  String get createComplaintEditButton;

  /// No description provided for @successTitle.
  ///
  /// In ar, this message translates to:
  /// **'شكوتك وصلت للقاع! 🎉'**
  String get successTitle;

  /// No description provided for @successMessage.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال شكوتك بنجاح، وشفيق استلمها 😂'**
  String get successMessage;

  /// زرار على شاشة النجاح — بيودّي لتفاصيل الشكوى اللي اتقدمت
  ///
  /// In ar, this message translates to:
  /// **'مشاهدة الشكوى'**
  String get successViewComplaintButton;

  /// No description provided for @successBackToHomeButton.
  ///
  /// In ar, this message translates to:
  /// **'العودة للرئيسية'**
  String get successBackToHomeButton;

  /// الشاشة دي مالهاش تصميم في الفيجما، التصميم من عندنا بنفس روح باقي الشاشات
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

  /// اسم الوحدة القصير جوه كارت الإحصائية ("12 شكوى")، مش ليبل طويل تحت الرقم
  ///
  /// In ar, this message translates to:
  /// **'شكوى'**
  String get profileStatSubmitted;

  /// بنفس صياغة profileStatSubmitted ("8 مغلقة")
  ///
  /// In ar, this message translates to:
  /// **'مغلقة'**
  String get profileStatResolved;

  /// "فقاعة" هي وحدة عملة النقاط في التطبيق ("245 فقاعة")
  ///
  /// In ar, this message translates to:
  /// **'فقاعة'**
  String get profileStatPoints;

  /// عنوان الـAppBar لشاشة الملف الشخصي
  ///
  /// In ar, this message translates to:
  /// **'الملف الشخصي'**
  String get profilePageTitle;

  /// عنوان كارت الترقية/التقدّم في الملف الشخصي
  ///
  /// In ar, this message translates to:
  /// **'المستوى الحالي'**
  String get profileCurrentLevelLabel;

  /// الكابشن المنفصل تحت نسبة التقدّم، في سطر مستقل بستايل مختلف
  ///
  /// In ar, this message translates to:
  /// **'للترقية'**
  String get profileProgressToNextLabel;

  /// تعليمة إضافية النقاط للترقية للرتبة التالية
  ///
  /// In ar, this message translates to:
  /// **'اجمع {points} فقاعة إضافية للوصول لرتبة \"{rank}\"'**
  String profileNextRankCaption(int points, String rank);

  /// نص بديل لما المستخدم يوصل لأعلى رتبة
  ///
  /// In ar, this message translates to:
  /// **'وصلت لأعلى رتبة في قاع الهامور! 🏆'**
  String get profileMaxRankCaption;

  /// أول رتبة في السلم، بُنيت لإكمال سلّم منطقي حوالين رتبتي "منقذ بحري"/"بطل القاع" المؤكدتين
  ///
  /// In ar, this message translates to:
  /// **'ساكن القاع'**
  String get profileRankQaaResident;

  /// بنفس ملاحظة profileRankQaaResident
  ///
  /// In ar, this message translates to:
  /// **'مراقب الشوارع'**
  String get profileRankStreetWatcher;

  /// رتبة سبونج بوب الحالية، مؤكدة من الفيجما
  ///
  /// In ar, this message translates to:
  /// **'منقذ بحري'**
  String get profileRankSeaRescuer;

  /// الرتبة التالية بعد "منقذ بحري"، مؤكدة من الفيجما
  ///
  /// In ar, this message translates to:
  /// **'بطل القاع'**
  String get profileRankQaaHero;

  /// رتبة قمة السلّم، بنفس ملاحظة profileRankQaaResident
  ///
  /// In ar, this message translates to:
  /// **'أسطورة قاع الهامور'**
  String get profileRankQaaLegend;

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

  /// No description provided for @relativeTimeNow.
  ///
  /// In ar, this message translates to:
  /// **'الآن'**
  String get relativeTimeNow;

  /// وقت نسبي بالدقائق. المثنى العربي من غير رقم، والجمع برقمه.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ دقيقة} =2{منذ دقيقتين} other{منذ {count} دقايق}}'**
  String relativeMinutes(int count);

  /// No description provided for @relativeHours.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ ساعة} =2{منذ ساعتين} other{منذ {count} ساعات}}'**
  String relativeHours(int count);

  /// No description provided for @relativeDays.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ يوم} =2{منذ يومين} other{منذ {count} ايام}}'**
  String relativeDays(int count);

  /// No description provided for @relativeWeeks.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ اسبوع} =2{منذ اسبوعين} other{منذ {count} اسابيع}}'**
  String relativeWeeks(int count);

  /// No description provided for @relativeMonths.
  ///
  /// In ar, this message translates to:
  /// **'{count, plural, =1{منذ شهر} =2{منذ شهرين} other{منذ {count} شهور}}'**
  String relativeMonths(int count);

  /// عنوان اختيار اللغة في الملف الشخصي
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get settingsLanguageTitle;

  /// No description provided for @languageNameAr.
  ///
  /// In ar, this message translates to:
  /// **'العربية'**
  String get languageNameAr;

  /// No description provided for @languageNameEn.
  ///
  /// In ar, this message translates to:
  /// **'English'**
  String get languageNameEn;

  /// No description provided for @languageNameDe.
  ///
  /// In ar, this message translates to:
  /// **'Deutsch'**
  String get languageNameDe;
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
      <String>['ar', 'de', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
