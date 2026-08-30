# تقرير المراجعة الشاملة النهائية للتطبيق — صوت القاع
**بعد اكتمال مزامنة الفيجما — مراجعة، إصلاح، وتحقق من التشغيل الفعلي**
28 أغسطس 2026

---

## 0) ملخص تنفيذي (اقرأ هذا أولًا)

راجعت المشروع كله — مش بس الملفات اللي اتعدلت في جولة مزامنة الفيجما اللي فاتت — يعني: كل الشاشات، كل طبقات Clean Architecture (Data/Domain/Presentation) لكل feature، كل الـcore infrastructure (DI، Network، Storage، Errors، Permissions، Router)، الـpubspec.yaml، ملفات الـARB، والـnavigation graph كامل.

لقيت واصلحت **مشكلة معمارية حقيقية** (مش تجميلية): enum بيوصف حالة الشكوى كان متعرّف جوه Presentation layer وبيتم استيراده من طبقتي Data وDomain — ده مخالف مباشر لقاعدة "Repositories must never know about UI". صلحتها بنقل الـenum لمكانه الصح في Domain، وعدّلت كل الملفات (8 ملفات) اللي كانت بتستورده غلط، وصلحت ترتيب الـimports كمان عشان يفضل متوافق مع `directives_ordering` في `analysis_options.yaml`.

لقيت واصلحت **باگ حقيقي في تجربة الاستخدام**: لو فشل إرسال تعليق في شاشة تفاصيل الشكوى، الشاشة كانت "تبلع" الخطأ من غير أي رسالة للمستخدم — المستخدم يكتب تعليق، يدوس إرسال، السبينر يختفي، ولا حاجة تحصل. ده مخالف مباشر لقاعدة "Never silently ignore errors". أضفت state field وSnackBar يوضحوا الخطأ فعليًا.

لقيت وأزلت **حزمتين مش مستخدمتين خالص** من `pubspec.yaml` (`flutter_image_compress` و`shared_preferences`) بعد ما اتأكدت إنهم صفر استخدام في كل `lib/`.

**اكتشاف مهم غير متوقع:** لما عدّلت `pubspec.yaml`، لقيت إن `pubspec.lock` وملفات الـl10n المولّدة (`app_localizations*.dart`) اتحدّثوا لوحدهم على جهازك خلال دقايق من التعديل — يعني فيه حاجة (على الأغلب الـIDE بتاعك بيراقب المشروع) شغالة `flutter pub get` و`flutter gen-l10n` فعليًا على الجهاز الحقيقي. ده دليل غير مباشر لكن حقيقي إن الـdependency resolution نجح من غير تعارضات، وإن الـl10n codegen اشتغل صح. لكن ده مختلف تمامًا عن `flutter analyze`/`flutter test`/`flutter run` الفعلي — التفاصيل في قسم 8 و9.

**القيد اللي لسه موجود:** مفيش سطح تنفيذ واحد متاح لي في الجلسة دي بيقدر يشغّل أدوات Flutter (`flutter analyze`/`test`/`run`) أو يفتح المحاكي/الجهاز الحقيقي. القسم 8 و9 بيشرحوا ده بالتفصيل مع الأوامر الجاهزة اللي محتاجة إنك تشغّلها بنفسك خلال دقيقة واحدة.

---

## 1) الشاشات اللي اتراجعت

| الشاشة | حالة المراجعة |
|---|---|
| Splash | اتراجعت — placeholder متعمّد وصحيح معماريًا (منطق الـredirect في الـrouter مش في الويدجت) |
| تسجيل الدخول / إنشاء حساب | اتراجعت بالكامل (UI + Cubit + State + Repository + DataSource) — تصميم أصلي موثّق `[C3]` لأن الفيجما مفيهاش شاشات Login/Register |
| الرئيسية (Home) | اتراجعت — متوافقة مع آخر فيجما (node 33:21) من الجولة اللي فاتت، اتأكد عدم وجود انحراف |
| الخريطة (Map) | اتراجعت بالكامل — تصميم أصلي موثّق `[Proposed P3]` لأن Frame الفيجما (node 33:351) فاضي تمامًا |
| إضافة شكوى (Create Complaint) + اختيار الموقع على الخريطة (Location Picker) | اتراجعت بالكامل (Cubit + State + Page + LocationPickerPage) — تدفق Form→Review→Submit→Success اتتبّع بالكامل |
| قائمة الشكاوى | اتراجعت (من الجولة اللي فاتت + مراجعة ثانية للتأكد من عدم وجود ارتداد) |
| تفاصيل الشكوى | اتراجعت — وفيها اتصلح باگ التعليقات (قسم 3) |
| الإشعارات | اتراجعت بالكامل (Presentation + Data + Domain) |
| الملف الشخصي (Profile) | اتراجعت بالكامل هالمرة (كانت جزئية قبل كده) — تأكدت من عدم وجود أزرار ميتة (Personal Info/Favorites/Settings بتوضح "قريبًا" بدل ما تكون صامتة) |
| شكاويي (My Complaints) | اتراجعت لأول مرة — بتعيد استخدام `ComplaintsCubit` بفلتر `mine` بدل ما تخترع منطق جديد، قرار معماري سليم |
| BottomNavShell + التنقل | اتراجع الـrouter كامل (`app_router.dart`, `route_paths.dart`) وكل الـ5 تدفقات المطلوبة (قسم 5) |
| البنية التحتية (Core) | Errors، Network (Dio + Interceptors)، Storage (Secure + Local Cache)، Permissions، DI (`injection.dart`) — كلهم اتراجعوا سطر سطر |

---

## 2) المشاكل المكتشفة

### حرجة (معمارية)
**`ComplaintStatus` enum كان معرّف جوه Presentation ومستورد من Data/Domain.**
الملف `presentation/widgets/status_badge.dart` كان فيه تعريف الـenum، وكان بيتم استيراده بـ`show ComplaintStatus` من 6 ملفات في طبقتي Data وDomain: `complaint.dart` (Domain entity)، `complaint_repository.dart` (Domain)، `complaint_repository_impl.dart`، `complaint_remote_data_source.dart`، `complaint_model.dart` (كلهم Data). ده مخالفة مباشرة لقاعدة "Repositories must never know about UI" و"Never allow Presentation ↓ Data Layer" من الـoperating system بتاعك.

### باگ حقيقي (تجربة استخدام)
**فشل إرسال تعليق في تفاصيل الشكوى كان بيتم تجاهله بصمت.**
`ComplaintDetailsCubit.postComment()` كان عند الفشل بيرجّع `isPostingComment` لـ`false` من غير أي إشارة تانية — السبينر يختفي والمستخدم مالوش أي فكرة إن التعليق مترسلش. `ComplaintDetailsLoaded` مكانش فيه أصلًا field لحمل رسالة الخطأ ده، والصفحة كانت بتستخدم `BlocBuilder` مش `BlocConsumer` — يعني مفيش حتى آلية لعرض SnackBar لو الـfield كان موجود.

### تنظيف حزم (Packages)
- `flutter_image_compress` — متعرّفة في `pubspec.yaml` بس صفر استخدام في كل `lib/` (تأكدت بالبحث الشامل). `attachPhoto()` في `CreateComplaintCubit` بيرفع الملف الخام من `image_picker` من غير أي خطوة ضغط.
- `shared_preferences` — نفس الموضوع، صفر استخدام ومفيش أي تعليق موثّق بيقول إنها لسه محجوزة لاستخدام قريب (بعكس `freezed_annotation`/`json_annotation` اللي موثّقين صراحة كـ"Proposed" للـcodegen المستقبلي).

### أصول (Assets)
- `assets/images/complaints/complaint_road_crack_thumbnail.jpg` — ملف صورة موجود وجواه الـbundle (لأن المجلد كله مسجّل في `pubspec.yaml`)، بس صفر مرجع في الكود؛ `complaint_scene_assets.dart` بيستخدم `complaint_road_crack_banner.jpg` بدل منه كـthumbnail. **لم أقدر أحذفه** — طلب الحذف اتمنع من نظام الصلاحيات في الجلسة (auto-mode classifier)، فسيبته موثّق كمشكلة متبقية بدل ما أعمل حاجة ملتوية زي نقله لمجلد تاني.

### ملاحظات موثّقة (مش مشاكل — قرارات سليمة تستحق التوضيح فقط)
- Splash شاشة placeholder متعمدة (منطق التوجيه في `app_router.dart`، مش في الويدجت) — ده تصميم صح، مش نقص.
- Login/Register مصممتين من الصفر لأن مفيش فريم فيجما ليهم أصلًا — قرار موثّق `[C3]`.
- شاشة الخريطة مصممة من الصفر لأن Frame الفيجما (33:351) فاضي — قرار موثّق `[Proposed P3]`.
- `AuthInterceptor.onError` فيه `TODO(patrick-auth)` للـauto-logout عند انتهاء الجلسة — مؤجل بشكل موثّق لفرع مستقبلي، مش نسيان.
- `bloc` و`hive` معرّفين كـdirect dependencies في `pubspec.yaml` بدون أي `import` مباشر ليهم في الكود (لأن `flutter_bloc`/`hive_flutter` بيعيدوا تصديرهم) — ده نمط شائع وغير ضار في تطبيقات Flutter، مش عيب حقيقي، فسبته زي ما هو.

---

## 3) المشاكل التي تم إصلاحها

### أ) نقل `ComplaintStatus` من Presentation إلى Domain
أنشأت `flutter/lib/features/complaints/domain/entities/complaint_status.dart` يحتوي الـenum فقط، بنفس القيم بالظبط (`received, inReview, resolved`) — صفر تغيير في السلوك. بعدين:
- عدّلت `status_badge.dart` يستورد الـenum من مكانه الجديد بدل ما يعرّفه.
- عدّلت 5 ملفات في Data/Domain (`complaint.dart`, `complaint_repository.dart`, `complaint_repository_impl.dart`, `complaint_remote_data_source.dart`, `complaint_model.dart`) تستورد من `domain/entities/complaint_status.dart` بدل `presentation/widgets/status_badge.dart`.
- عدّلت `complaints_cubit.dart` و`map_page.dart` (اللي بيستخدموا اسم النوع مباشرة) يضيفوا استيراد صريح للـenum من Domain.
- صلحت ترتيب الـimports في 3 ملفات (`complaints_cubit.dart`, `complaint_repository.dart`, `map_page.dart`) عشان يفضلوا متوافقين مع lint rule `directives_ordering` المفعّل في `analysis_options.yaml`.

**فحص/اختبار:** تأكدت بالـgrep إن مفيش أي ملف لسه بيستورد `ComplaintStatus` من `status_badge.dart`، وراجعت كل الملفات المعدّلة سطر سطر للتأكد من صحة الـimports الجديدة ومساراتها النسبية.

### ب) إظهار فشل إرسال التعليق للمستخدم
- أضفت `commentErrorMessageKey` field لـ`ComplaintDetailsLoaded` — بنفس نمط "one-shot" الموجود بالفعل في `AuthState.failureMessageKey` (مش بيتحط له `?? this.x` في الـcopyWith، فيمسح نفسه تلقائيًا في أي تحديث تالي بدل ما يفضل معروض).
- `ComplaintDetailsCubit.postComment()` دلوقتي بيبعت `commentErrorMessageKey: failure.message` عند الفشل.
- غيّرت `complaint_details_page.dart` من `BlocBuilder` إلى `BlocConsumer` وضفت `listener` بيعرض `SnackBar` بالرسالة (باستخدام `resolveMessageKey` الموجودة بالفعل — نفس النمط المستخدم في كل مكان تاني بالتطبيق).

**فحص/اختبار:** راجعت `message_key_resolver.dart` للتأكد إن `failure.message` (سواء ARB key أو نص عربي خام من السيرفر) بيتعامل معاه صح في الحالتين، وده فعلاً الحال.

### ج) إزالة حزمتين مش مستخدمتين
أزلت `flutter_image_compress` و`shared_preferences` من `pubspec.yaml` مع تعليق توثيقي بيشرح السبب في كل حالة.

**اختبار غير متوقع لكنه حقيقي:** بعد التعديل مباشرة، `pubspec.lock` اتحدّث لوحده على جهازك (104 سطر حذف، بالظبط الحزمتين دول وتبعياتهم الفرعية، صفر إضافات غير متوقعة) — يعني `flutter pub get` اتشغّل فعليًا وده تأكيد حقيقي إن التعديل سليم ومفيهوش تعارض في الـdependency resolution.

---

## 4) التحقق من الواجهة (UI) وتجربة الاستخدام (UX)

- **الرئيسية:** متوافقة مع آخر فيجما (node 33:21) — التعليقات في `home_page.dart` بتوثق كل تفصيلة (search bar، ترتيب الأقسام، CTA mascot) من جولة المزامنة اللي فاتت، وما لقيتش أي انحراف جديد.
- **الخريطة:** تصميم أصلي متسق بصريًا مع باقي التطبيق (نفس الألوان/الخطوط) — موثّق كقرار `[Proposed P3]` لأن مفيش تصميم فيجما أصلًا.
- **الدخول/التسجيل:** تصميم أصلي متسق، بيستخدم نفس الـcomponents المشتركة (`AppButton`, `AppTextField`) وحل الأخطاء الحقلية (field errors) inline بدل SnackBar عام — سلوك صحيح.
- **تفاصيل الشكوى:** بعد الإصلاح، حالات النجاح/الفشل/التحميل كلها واضحة للمستخدم، بما فيها التعليقات.
- **الملف الشخصي:** لا يوجد أزرار ميتة — 3 عناصر قائمة بدون شاشة فعلية (معلومات شخصية/مفضلة/إعدادات) بتوضح "قريبًا" عبر SnackBar بدل ما تكون صامتة تمامًا، وده قرار موثّق وسليم لأن اختراع شاشات مش موجودة في البريف كان هيكون مخالفة لقاعدة "لا تخترع سلوك عمل".
- **شكاويي:** بتعيد استخدام نفس بطاقة القائمة (`ComplaintListCard`) والـfilter المسبق `mine` — يعني أي تحسين بصري مستقبلي في قائمة الشكاوى هينعكس هنا تلقائيًا، مفيش ازدواجية.
- **الحالات الفارغة/التحميل/الخطأ:** كل شاشة راجعتها بتستخدم نفس الـcomponents المشتركة (`LoadingView`, `ErrorView`, `EmptyView`) بدل ما كل شاشة تخترع شكلها الخاص — اتساق حقيقي، مش نسخ ولزق.

---

## 5) التحقق من التنقل (Navigation)

تتبعت `app_router.dart` و`route_paths.dart` كاملين (الملف الوحيد اللي بيحدد كل الروابط في التطبيق):

| التدفق المطلوب | التتبع في الكود |
|---|---|
| تشغيل التطبيق → المصادقة → الرئيسية → الشكاوى → التفاصيل | `redirect()` بيتحقق من الـtoken المخزّن؛ splash يوجّه لـ`/login` أو `/home`؛ التابات الأربعة (`home/map/complaints/profile`) عبارة عن `StatefulShellBranch` حقيقية؛ الشكاوى → `push('/complaints/:id')`. ✅ |
| الرئيسية → إضافة شكوى → تعبئة → مراجعة → إرسال → نجاح | زرار "+" في `BottomNavShell` بيعمل `push('/create-complaint')` (مش تاب خامس — قرار `[P14]` موثّق ومنطقي لأن كل مرة لازم فورم جديد فاضي)؛ الفورم بيتحقق كامل قبل الانتقال لخطوة المراجعة (`nextStep()`)؛ النجاح بيتم التعامل معاه كـstatus داخل نفس الصفحة (`CreateComplaintStatus.success`) مش route جديد. ✅ |
| الرئيسية → الخريطة → علامة → التفاصيل | تاب الخريطة → الضغط على marker بيفتح bottom sheet بملخص الشكوى → زرار "عرض التفاصيل" بيعمل `push('/complaints/:id')`. ✅ |
| الإشعارات → إشعار → الشكوى المرتبطة → التفاصيل | `push('/notifications')` → الضغط على كارت بيعمل `markRead()` ثم `push` لتفاصيل الشكوى **فقط لو** `complaintId != null` (الإشعارات العامة اللي مالهاش شكوى مرتبطة معندهاش زرار انتقال ميت — الشرط موجود صراحة). ✅ |
| الملف الشخصي → شكاويي → التفاصيل | تاب الملف الشخصي → `push('/profile/my-complaints')` → `push('/complaints/:id')`. ✅ |

**الرجوع للخلف:** كل الـpush routes (تفاصيل شكوى، إشعارات، شكاويي، تسجيل) بترجع بشكل طبيعي عبر `GoRouter`/`Navigator` القياسي — ملقتش أي `pop` مخصص بيكسر السلوك الافتراضي.

**تكرار التنقل:** الضغط على نفس التاب تاني بيرجّع لأول صفحة فيه (`initialLocation: index == currentIndex`) — سلوك موثّق ومقصود في `bottom_nav_shell.dart`، مش باگ.

**بعد الإرسال/الخطأ/المصادقة:** نجاح تسجيل الدخول/التسجيل بيعمل `context.go('/home')` (مش `push`، يعني الـstack بينضف صح مفيش رجوع لصفحة الدخول بالغلط)؛ الخروج (logout) بعد تأكيد الـdialog بيعمل `context.go('/login')` بنفس الطريقة.

---

## 6) نتائج جودة الكود

- **Clean Architecture:** بعد إصلاح مشكلة `ComplaintStatus`، ملقتش أي مخالفة تانية لاتجاه الاعتمادية (Data/Domain ماعندهمش أي استيراد من Presentation في أي feature تاني راجعته).
- **الأخطاء:** كل Repository بيتبع نفس النمط بالظبط (فحص `NetworkInfo` → try/catch → `ErrorMapper.map`) — نمط مشترك حقيقي مش نسخ متكرر. بعد إصلاح باگ التعليقات، ملقتش أي مكان تاني بيبلع خطأ بصمت (فحصت `toggleLike()` كمان وهو موثّق بوضوح كقرار متعمد إن فشله مش لازم يوقف الشاشة، بعكس حالة التعليق).
- **`print()`:** صفر استخدام في كل `lib/` — بحث شامل تأكدت منه.
- **`dynamic`:** صفر استخدام خطر (غير الاستخدامات الطبيعية لـ`Map<String, dynamic>` في الـJSON parsing، وده متوقع ومقبول).
- **TODOs:** 2 بس في كل المشروع، الاتنين موثقين بوضوح ومرتبطين بفرع مستقبلي محدد (`patrick-auth`) — مش نسيان أو دين تقني مخفي.
- **الـl10n:** صفر نصوص مكتوبة يدويًا (hardcoded) في أي `Text()` widget — كل حاجة بتمر عبر `context.l10n`. تأكدت بالعد إن `app_ar.arb` و`app_en.arb` عندهم **113 مفتاح بالظبط** في كل ملف، بدون أي مفتاح ناقص في أي اتجاه.
- **الأصول:** كل الملفات المسجّلة في `pubspec.yaml` موجودة فعليًا، وكل مجلد أصول متسجل صح، ما عدا الصورة اليتيمة المذكورة في قسم 2.
- **RTL:** التطبيق بيستخدم `Locale('ar')` مع `flutter_localizations` — الاتجاه بييجي تلقائي من غير `Directionality` يدوي، وده الطريقة الصح.
- **التسمية:** ملقتش أسماء غامضة أو مختصرة زي `data`/`temp`/`helper` في أي مكان — الأسماء كلها واضحة ومعبّرة عن قصدها.

---

## 7) مراجعة الحزم (pubspec.yaml)

- **أزلت:** `flutter_image_compress`، `shared_preferences` (قسم 3ج).
- **باقي كل الحزم:** راجعتها واحدة واحدة بالبحث عن استخدام فعلي في `lib/` — كل حزمة باقية ليها استخدام حقيقي موثّق:
  - `flutter_bloc`/`equatable` — كل الـCubits والـStates.
  - `get_it` — `injection.dart` كامل.
  - `go_router` — الـrouter والتنقل في كل صفحة.
  - `dio`/`pretty_dio_logger`/`connectivity_plus` — طبقة الشبكة.
  - `fpdart` — `Either<Failure, T>` في كل Repository.
  - `hive`/`hive_flutter` — تهيئة الكاش المحلي (لسه معندهاش أي box مفتوح فعليًا، وده موثّق كقرار متعمد لحد ما يظهر أول موديل محتاجه).
  - `flutter_secure_storage` — التوكنز ومعرف المستخدم.
  - `flutter_map`/`latlong2`/`geolocator`/`permission_handler` — شاشة الخريطة وLocation Picker.
  - `image_picker`/`cached_network_image` — إرفاق الصور وعرضها.
  - `google_fonts` — الخطوط الثلاثة المؤكدة من الفيجما.
- **`injectable`/`freezed_annotation`/`json_annotation` (وتوابعهم dev)** — لسه "any"-pinned بنفس السبب الموثّق من جلسة "2026-08-25 live run" (تعارض حل الإصدارات عبر سلسلة `analyzer`/`macros`/`source_gen`) — ما لقيتش أي دليل إن السبب ده اتغيّر، فسبتها زي ما هي بدل ما أعمل تغيير غير مبني على تحقق فعلي.
- **لا ازدواجية:** ملقتش حزمتين بيعملوا نفس الغرض (زي حزمتين HTTP أو حزمتين state management).

---

## 8) نتائج الاختبار (Test Results)

**ملفات اختبار موجودة فعليًا في المشروع:** `test/core/utils/date_formatter_test.dart`، `test/core/utils/validators_test.dart`، `test/core/errors/error_mapper_test.dart`.

**لم أستطع تشغيل `flutter test` فعليًا.** الجلسة دي عندها سطحين تنفيذ بس: الـcloud sandbox (مفيهوش SDK بتاع Dart/Flutter، وممنوع من الشبكة يوصل لـ`pub.dev`)، والـ`device_bash` (بيشتغل على VM لينكس منفصل تمامًا عن جهاز الماك بتاعك، وده اتأكد بـ`uname -a`/`which flutter dart` من غير أي نتيجة). الاتنين مالهومش أي وصول لأدوات Flutter الحقيقية المثبتة على جهازك.

**لكن — ملاحظة مهمة وصادقة:** لاحظت إن `pubspec.lock` وملفات الـl10n المولّدة اتحدّثوا لوحدهم على جهازك خلال دقايق من تعديلي لـ`pubspec.yaml`/الـARB — ده معناه إن فيه IDE أو أداة مراقبة ملفات شغالة على جهازك بتشغّل `flutter pub get`/`flutter gen-l10n` تلقائيًا. ده مش نفس تشغيل `flutter test`، بس هو دليل غير مباشر إن الـtoolchain حي وشغّال، وإن تعديلاتي مفيهاش أخطاء بنيوية واضحة (وإلا كان الـIDE هيوضح أخطاء في الـProblems panel بتاعه).

**الأمر اللي محتاج تشغّله بنفسك (دقيقة واحدة):**
```
cd flutter && flutter test
```

---

## 9) نتيجة التشغيل الفعلي (Runtime Result)

**لم يتم تشغيل التطبيق فعليًا من طرفي** — بنفس السبب المذكور في قسم 8: مفيش سطح تنفيذ متاح لي يقدر يفتح محاكي، يوصّل بجهاز فعلي، أو يشغّل `flutter run`. ده قيد بيئي حقيقي في الجلسة دي، مش تقصير في المراجعة نفسها — راجعت الكود بعمق بدل ما أفترض إنه شغال.

**الأوامر اللي محتاجة تشغّلها بنفسك بالترتيب** (على الأرجح جزء منها اتشغّل لوحده فعلًا حسب الملاحظة في قسم 8، بس شغّلها كلها للتأكد):
```
cd flutter
flutter pub get
flutter gen-l10n
dart format .
flutter analyze
flutter test
flutter run
```
بعد التشغيل، امشي يدويًا على الـ5 تدفقات المذكورة في قسم 5 (المصادقة، الرئيسية→الشكاوى→التفاصيل، إضافة شكوى كاملة، الخريطة→التفاصيل، الإشعارات→التفاصيل، الملف الشخصي→شكاويي→التفاصيل) وأكّد إن الـSnackBar الجديد بتاع فشل التعليق بيظهر لو قفلت الإنترنت وحاولت تبعت تعليق.

---

## 10) المشاكل المتبقية

| # | المشكلة | الحالة | يحتاج |
|---|---|---|---|
| 1 | صورة `complaint_road_crack_thumbnail.jpg` غير مستخدمة | موثّقة، لم تُحذف | حذف يدوي منك (صلاحية الحذف اتمنعت مني في الجلسة دي) |
| 2 | `AuthInterceptor.onError` — auto-logout عند 401 مش متنفذ لسه | موثّق ومؤجل بشكل متعمد | فرع `patrick-auth` المستقبلي |
| 3 | عناصر "معلومات شخصية"/"مفضلة"/"إعدادات" في البروفايل بتوضح "قريبًا" بدل شاشة حقيقية | قرار منتج متعمد، مش باگ | قرار منتج: هل الشاشات دي مطلوبة الآن؟ |
| 4 | `flutter analyze`/`flutter test`/`flutter run` لم يتم تنفيذهم فعليًا من طرفي | قيد بيئي في هذه الجلسة | تشغيلهم يدويًا (الأوامر في قسم 8/9)، أو إتاحة وصول تنفيذي حقيقي لجهازك في جلسة مستقبلية |
| 5 | مشاكل Part 1 المتبقية غير المرتبطة بمزامنة الفيجما (نظام النقاط في البروفايل، شارات الخطورة/الفئة في تفاصيل الشكوى، تصميم كارت التعليق) | موثّقة بالتفصيل في `figma_audit_report.md` | قرار منتج/تصميم — راجع التقرير السابق |

---

## 11) لقطات شاشة من التطبيق الفعلي قيد التشغيل

**لم أستطع التقاط أي لقطة شاشة من التطبيق الفعلي شغّال** — بنفس القيد البيئي في قسم 9 (مفيش وصول لمحاكي أو جهاز فعلي من أي سطح تنفيذ متاح لي).

**كمان حاولت** ألتقط لقطات شاشة جديدة من الفيجما نفسه (node 33:21 للرئيسية) للمقارنة البصرية المباشرة، ونجح طلب اللقطة من MCP، لكن تحميلها فشل (`curl` رجّع خطأ شبكة — نفس قيد الشبكة المحدود في الـcloud sandbox من جولة المزامنة اللي فاتت، بينطبق كمان على استضافة صور فيجما). اعتمدت بدل منها على `get_design_context`/المقارنة النصية اللي كانت موثقة بالفعل من الجولة اللي فاتت لشاشة الرئيسية، ودي كانت كافية للتأكد من عدم وجود انحراف.

---

## ملحق: الملفات المعدّلة في هذه الجولة (Part 2)

**إصلاح معماري (ComplaintStatus):**
`flutter/lib/features/complaints/domain/entities/complaint_status.dart` (جديد)، `status_badge.dart`، `complaint.dart`، `complaint_repository.dart`، `complaint_repository_impl.dart`، `complaint_remote_data_source.dart`، `complaint_model.dart`، `complaints_cubit.dart`، `map_page.dart`

**إصلاح باگ التعليقات:**
`complaint_details_state.dart`، `complaint_details_cubit.dart`، `complaint_details_page.dart`

**تنظيف الحزم:**
`pubspec.yaml` (وتحديث تلقائي لـ`pubspec.lock` على جهازك)

**هذا التقرير:**
`full_review_report.md`
