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
  String get genericCancel => 'إلغاء';

  @override
  String get genericConfirm => 'تأكيد';

  @override
  String get genericNext => 'التالي';

  @override
  String get genericBack => 'رجوع';

  @override
  String get genericSave => 'حفظ';

  @override
  String get genericOptional => 'اختياري';

  @override
  String get validationRequired => 'الحقل ده مطلوب';

  @override
  String get validationInvalidEmail => 'الإيميل مش صيغته صح';

  @override
  String get validationPasswordTooShort =>
      'كلمة السر لازم تكون 8 حروف على الأقل';

  @override
  String get validationPasswordTooWeak =>
      'كلمة السر لازم تحتوي على حروف وأرقام';

  @override
  String get validationPasswordMismatch => 'كلمة السر مش متطابقة';

  @override
  String get validationTooLong => 'النص ده أطول من المسموح';

  @override
  String get authLoginTitle => 'تسجيل الدخول';

  @override
  String get authEmailLabel => 'الإيميل';

  @override
  String get authPasswordLabel => 'كلمة السر';

  @override
  String get authLoginButton => 'دخول';

  @override
  String get authNoAccountPrompt => 'لسه معملتش حساب؟';

  @override
  String get authRegisterLink => 'سجل دلوقتي';

  @override
  String get authRegisterTitle => 'حساب جديد';

  @override
  String get authUsernameLabel => 'اسم المستخدم';

  @override
  String get authConfirmPasswordLabel => 'تأكيد كلمة السر';

  @override
  String get authRegisterButton => 'إنشاء الحساب';

  @override
  String get authHaveAccountPrompt => 'عندك حساب بالفعل؟';

  @override
  String get authLoginLink => 'سجل دخولك';

  @override
  String homeGreeting(String name) {
    return 'صباح الفل يا ساكن القاع، $name!';
  }

  @override
  String get homeCategoriesHeading => 'تصنيفات الشكاوى';

  @override
  String get homeSubmitComplaintCta => 'قدم شكوى جديدة';

  @override
  String get homeSearchHint => 'إبحث عن شكوى...';

  @override
  String get homeTrendingHeading => 'أكثر الشكاوى تفاعلاً';

  @override
  String get homeTrendingSubheading => 'شوف إيه اللي شاغل سكان القاع';

  @override
  String get homeViewAll => 'عرض الكل';

  @override
  String get homeSameProblemCta => 'عندي نفس المشكله';

  @override
  String homeSameProblemCount(int count) {
    return '+$count';
  }

  @override
  String get homeRecentActivityHeading => 'شكاوى محتاجة صوتك';

  @override
  String get homeUrgentBadge => 'عاجل';

  @override
  String homeViewsCount(int count) {
    return '$count مشاهدة';
  }

  @override
  String homeLikesCount(int count) {
    return '$count إعجاب';
  }

  @override
  String get complaintsFilterAll => 'الكل';

  @override
  String get complaintsFilterMine => 'شكاواي';

  @override
  String get complaintsFilterResolved => 'تم الحل';

  @override
  String get complaintsEmptyMessage => 'مفيش شكاوى في القسم ده لسه';

  @override
  String get detailsTitle => 'حالة الشكوى';

  @override
  String get detailsSectionHeading => 'التفاصيل';

  @override
  String get statusReceivedLabel => 'تم الاستلام';

  @override
  String get statusInReviewLabel => 'قيد المراجعة';

  @override
  String get statusResolvedLabel => 'تم الحل';

  @override
  String get commentsHeading => 'التعليقات';

  @override
  String get commentInputHint => 'اكتب تعليقك هنا يا جار...';

  @override
  String get commentSubmit => 'إرسال';

  @override
  String get commentsEmptyMessage => 'لسه محدش علّق، خلّيك أول واحد';

  @override
  String get locationLabel => 'الموقع';

  @override
  String get createComplaintTitle => 'تقديم شكوى';

  @override
  String get createComplaintTitleShort => 'تقديم شكوي';

  @override
  String get stepFillTitle => 'بيانات الشكوى';

  @override
  String get fieldTitleLabel => 'عنوان الشكوى';

  @override
  String get fieldTitleHint => 'اكتب عنوان مختصر للشكوى';

  @override
  String get fieldDescriptionLabel => 'وصف الشكوى';

  @override
  String get fieldDescriptionHint => 'احكيلنا المشكلة بالتفصيل...';

  @override
  String descriptionCounter(int current, int max) {
    return '$current/$max';
  }

  @override
  String get stepCategoryTitle => 'نوع الشكوى';

  @override
  String get stepLocationTitle => 'الموقع';

  @override
  String get pickLocationOnMapButton => 'اختار الموقع من الخريطة';

  @override
  String get locationSelectedLabel => 'الموقع المختار';

  @override
  String get stepSeverityTitle => 'درجة الخطورة';

  @override
  String get severityHighLabel => 'عالية';

  @override
  String get severityMediumLabel => 'متوسطة';

  @override
  String get severityLowLabel => 'منخفضة';

  @override
  String get attachPhotoButton => 'أضف صورة';

  @override
  String get removePhotoLabel => 'احذف الصورة';

  @override
  String get submitComplaintButton => 'إرسال الشكوة';

  @override
  String get createComplaintReviewTitle => 'راجع شكوتك قبل الإرسال';

  @override
  String get createComplaintReviewSubtitle =>
      'اتأكد إن كل حاجة تمام قبل ما توصل لسكان القاع';

  @override
  String get createComplaintCancelButton => 'إلغاء الشكوى';

  @override
  String get createComplaintEditButton => 'تعديل الشكوى';

  @override
  String get successTitle => 'شكوتك وصلت للقاع! 🎉';

  @override
  String get successMessage => 'تم إرسال شكوتك بنجاح، وشفيق استلمها 😂';

  @override
  String get successViewComplaintButton => 'مشاهدة الشكوى';

  @override
  String get successBackToHomeButton => 'العودة للرئيسية';

  @override
  String get mapTitle => 'الخريطة';

  @override
  String get mapViewDetailsButton => 'عرض التفاصيل';

  @override
  String get notificationsTitle => 'الإشعارات';

  @override
  String get notificationsFilterAll => 'الكل';

  @override
  String get notificationsFilterComplaints => 'الشكاوى';

  @override
  String get notificationsFilterReactions => 'التفاعلات';

  @override
  String get notificationsFilterGeneral => 'عام';

  @override
  String get notificationsMarkAllRead => 'تحديد الكل كمقروء';

  @override
  String get notificationsEmptyMessage => 'مفيش إشعارات جديدة يا جار';

  @override
  String get profilePersonalInfoMenu => 'البيانات الشخصية';

  @override
  String get profileMyComplaintsMenu => 'شكاواي';

  @override
  String get profileFavoritesMenu => 'المفضلة';

  @override
  String get profileSettingsMenu => 'الإعدادات';

  @override
  String get profileLogoutMenu => 'تسجيل الخروج';

  @override
  String get profileStatSubmitted => 'شكاوى مقدَّمة';

  @override
  String get profileStatResolved => 'شكاوى محلولة';

  @override
  String get profileStatPoints => 'نقاط المشاركة';

  @override
  String get myComplaintsTitle => 'شكاواي';

  @override
  String get logoutConfirmTitle => 'تسجيل الخروج';

  @override
  String get logoutConfirmMessage => 'متأكد إنك عايز تسجل خروج يا ساكن القاع؟';

  @override
  String get logoutConfirmYes => 'أيوة، سجلني خروج';

  @override
  String get logoutConfirmCancel => 'لأ، رجّعني';
}
