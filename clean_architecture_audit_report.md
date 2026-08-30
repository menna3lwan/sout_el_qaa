# تقرير المراجعة المعمارية الشاملة — صوت القاع
**Clean Architecture / SOLID / OOP / Design Patterns Audit**
**الفرع:** `feature/patrick` — 29 أغسطس 2026

---

## 0) ملخص تنفيذي

راجعت المشروع كله (`flutter/lib/` بالكامل — ~106 ملف في 9 features + core، بالإضافة لـ `test/`، `integration_test/`، و`pubspec.yaml`) مقابل Clean Architecture، SOLID، OOP، Design Patterns، ومعيار التعليقات. المراجعة اتعملت على مرحلتين: **مرحلة اكتشاف** جمعت أدلة حقيقية من كل طبقة (DI، Router، Network، Errors، Storage، الـ4 Repository implementations، عدة Cubits، الـentities، الـshared widgets، الـtheme، الـtests، الـpubspec) قبل أي تعديل، و**مرحلة تنفيذ** طبّقت أصغر إصلاح آمن لكل مشكلة مؤكدة بدون تغيير أي سلوك عمل قائم.

**النتيجة الإجمالية:** المشروع كان بالفعل في حالة معمارية سليمة نسبيًا — مفيش مخالفات حرجة لاتجاه الاعتمادية (Presentation → Domain → Repository Abstraction → Repository Impl → Data Source)، والـCubits كانت بالفعل بتتكلم مع abstractions مش implementations. المشاكل الحقيقية اللي لقيتها كانت **تكرار كود** (نفس الشكل بيتكتب من جديد في 4 أماكن مختلفة)، **scaffolding ميتة** (مجلدات فاضية بتلمّح لطبقات مش موجودة فعليًا)، **dependencies مش مستخدمة** (سبع حزم كان أغلبها معلّق بـ`any` بسبب تعارض حل نسخ قديم مش موجود دليل عليه دلوقتي)، و**تعليقات طويلة/سردية** منتشرة بتوثّق تاريخ جلسات مزامنة سابقة بدل ما تشرح "ليه" الكود مكتوب كده.

كل الإصلاحات اتعملت بقاعدة واحدة: **اثبت إن المشكلة حقيقية → طبّق أصغر تعديل آمن → حافظ على السلوك → تحقّق**. مفيش أي إعادة كتابة لكود شغّال لمجرد تفضيل أسلوبي.

**نتيجة التحقق النهائي:** `dart format .` (0 تغييرات) → `flutter analyze` (0 مشاكل) → `flutter test` (**56/56** ناجح، شامل 3 اختبارات موجودة مسبقًا + 53 اختبار جديد) → `flutter test integration_test` (1/1 ناجح، الـwalkthrough test الموجود). التفاصيل في قسم 7.

---

## 1) نطاق المراجعة

| الطبقة/المنطقة | تمت المراجعة |
|---|---|
| Domain (entities, repositories abstractions, constants) | كل الـ9 features |
| Data (repository impls, data sources, models) | كل الـ4 repositories الحقيقية (complaints, notifications, profile, auth) |
| Presentation (Cubits, States, Pages, Widgets) | كل الـCubits والـpages والـshared widgets |
| Core (DI, Router, Network, Errors, Storage, Permissions, Theme, Utils) | بالكامل سطر سطر |
| Tests | 3 ملفات موجودة + 3 ملفات جديدة (Cubit tests) |
| `pubspec.yaml` | كل حزمة بالبحث عن استخدام فعلي في `lib/` |

---

## 2) المشاكل المؤكدة والإصلاحات

### أ) تكرار كود في طبقة الـRepository (Template Method غير مطبّق بشكل موحّد)

**المشكلة:** نفس الشكل "افحص الاتصال → نفّذ الاستدعاء → حوّل أي خطأ لـ`Failure`" كان بيتكرر بشكل منفصل في **4 repository implementations**:
- `complaint_repository_impl.dart` — عندها `_run<T>` خاصة بيها.
- `notification_repository_impl.dart` — نفس الشكل تقريبًا، `_run<T>` منفصلة كمان.
- `profile_repository_impl.dart` — نفس الـ8 سطور مكرّرة inline في `getStats()` من غير أي helper.
- `auth_repository_impl.dart` — نفس البلوك مكرّر 3 مرات inline (`login`, `currentUser`, وجوه `_runAuth` منفصلة لـ`register`)، بالإضافة لتكرار منطق "حفظ التوكنز عند النجاح" بين `login` و`_runAuth`.

**الإصلاح:** استخرجت helper واحد مشترك `guardNetworkCall<T>(NetworkInfo, Future<T> Function())` في `core/network/repository_guard.dart` (ملف جديد)، وعدّلت الـ4 repositories يستخدموه بدل الكود المكرر. لـ`AuthRepositoryImpl` بالتحديد، استخرجت كمان `_persistSession()` helper يشترك فيه `login`/`register`، مع الحفاظ الكامل على سلوك `login` الخاص (401 = بيانات غلط، مش انتهاء جلسة) بدون أي تغيير.

**التحقق:** `flutter analyze` صفر مشاكل، وكل الاختبارات (القديمة + الجديدة) بتعدّي، بما فيها اختبارات `AuthCubit` اللي بتغطي `login` مباشرة.

### ب) Scaffolding ميتة توحي بطبقات مش موجودة

**المشكلة:**
- `features/complaint_details/` كانت شجرة `data/domain/presentation` فاضية بالكامل (ملفات `.gitkeep` بس) — باقية من قبل ما `complaint_details_cubit.dart`/`_page.dart`/`_state.dart` تُبنى فعليًا تحت `features/complaints/presentation/*`. الوجود ده كان بيلمّح لـ2 features لشاشة واحدة، ومفيش أي استيراد بيشير ليها.
- كل الـ8 features عندها مجلد `domain/usecases/.gitkeep` فاضي، لكن **صفر** UseCase classes موجودة في التطبيق كله — الـCubits بتتكلم مع repository interfaces مباشرة.

**القرار (بالتأكيد مع المستخدم):** الـCubits تفضل تتكلم مع repository abstractions مباشرة (already interfaces، already mockable — طبقة UseCase-per-method هنا هتكون boilerplate من غير فايدة حقيقية في الـtestability/readability). حذفت شجرة `features/complaint_details/` الميتة وكل الـ8 مجلدات `usecases/.gitkeep` عشان بنية المجلدات تتوقف عن الإشارة لطبقات مش موجودة فعليًا.

### ج) Dependencies مش مستخدمة أو معلّقة بخطر (`pubspec.yaml`)

**المشكلة:** بحث شامل في كل `lib/` أكّد **صفر** استخدام لـ`@injectable`، `@freezed`، `@JsonSerializable`، أو أي ملف `.g.dart`/`.freezed.dart`/`.config.dart` مولّد — `injection.dart` بيعمل تسجيل `get_it` يدوي 100%. ده يخلّي السبع حزم دول عبء ميت، ومعلّقة بأخطر نسخة ممكنة (`any`):
`injectable`, `injectable_generator`, `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable`, `build_runner`.

`bloc_test: any` كانت كمان معلّقة بـ`any` بسبب تعارض حل نسخ مع `injectable_generator` (موثّق في تعليق قديم في الملف نفسه).

**الإصلاح:** حذفت السبع حزم، شغّلت `flutter pub get` (نجح بدون تعارضات)، وأعدت تثبيت `bloc_test` لنسخة محددة (`^9.1.7`) بعد ما التعارض القديم اختفى بحذف `injectable_generator`. حدّثت كمان تعليق `injection.dart` والـ`README.md` (كانت بتشير غلط لـ`build_runner` لتوليد الـl10n، والصحيح `flutter gen-l10n`).

### د) تكرار في `ComplaintDetailsCubit` (Presentation layer)

**المشكلة:** `toggleLike` (58-92)، `toggleDislike` (96-124)، و`toggleReport` (129-148) كانت ~90% متطابقة (تحقّق من الحالة المحمّلة → حل التعارض المتبادل → استدعاء الـrepository → طيّ النتيجة في `copyWithReactions`).

**الإصلاح:** استخرجت `_toggleReaction` helper خاص يغلّف الشكل المشترك (تشغيل/إيقاف reaction، مسح reaction متعارضة optional، تحديث الـstate بالعدّاد الجديد من السيرفر). الثلاث methods الأصلية بقت استدعاءات صغيرة للـhelper، بدون أي تغيير في السلوك الظاهر للمستخدم.

### هـ) تكرار في `ComplaintRemoteDataSource` (Data layer)

**المشكلة:** الشكل "نفّذ mutation → أعد جلب الشكوى لتحديث عدّاد الـreaction" كان متكرر عبر `like`/`unlike`/`dislike`/`undislike`/`report`/`unreport` (6 methods).

**الإصلاح:** استخرجت `_mutateReactionAndFetchCount` helper خاص، وكل الـ6 methods بقت تستدعيه.

### و) مخالفة Dependency Injection في `LocationPickerPage`

**المشكلة:** `LocationPickerPage` كانت بتاخد `PermissionService` مباشرة عبر `getIt<PermissionService>()` جوه الويدجت نفسها بدل constructor injection — ده يخالف قاعدة "no direct instantiation/service-locator calls inside widgets/business logic" ويصعّب الاختبار.

**الإصلاح:** عدّلت `LocationPickerPage` تستقبل `PermissionService` كـconstructor parameter مطلوب (`required this.permissionService`)، وعدّلت الاستدعاء الوحيد ليها في `create_complaint_page.dart` يمرّر `getIt<PermissionService>()` من هناك بدل جوه الويدجت.

### ز) تعليقات طويلة/سردية منتشرة (~30 ملف، ~140 موضع)

**المشكلة:** grep على الوسوم السردية المتكررة (`[New, Figma Sync pass...]`, `[Fixed,...]`, `[Proposed]`, `[Remaining Issue...]`, أرقام Figma nodes، إلخ) أظهر أكتر من 140 موضع عبر ~30 ملف — تعليقات طويلة جدًا (بعضها سطر واحد ~90 كلمة) أو كتل متعددة السطور بتوثّق تاريخ جولات مزامنة سابقة، أرقام Figma nodes، وقرارات وسيطة بدل ما تشرح "ليه" الكود مكتوب كده لمن يقرأه في المستقبل.

**الإصلاح:** كثّفت كل تعليق طويل/سردي في `lib/` لسطر أو سطرين واضحين، محتفظة فقط بالـ"ليه" الدائمة (مثلاً: ليه field معينة عندها default، ليه widget منفصل عن تاني)، وشيلت سرد الجولات التاريخية، أرقام Figma nodes، والوسوم القديمة (`[Proposed]`, `[Requires Confirmation]`, `[Remaining Issue]`) اللي بقت مالها لازمة لمطوّر المستقبل. القرار وصل كمان لملف الترجمة `app_ar.arb` (الوصف الخاص بكل مفتاح لصالح المترجمين) — وأعدت توليد `app_localizations.dart` بعدها عبر `flutter gen-l10n` (ملف مولّد، ماتتعدلش فيه يدويًا).

**ملاحظة:** التعليقات القليلة اللي فيها إشارة لـ`PLAN.md section X` سيبتها زي ما هي لو كانت سطر واحد مختصر — `PLAN.md` لسه موجود فعليًا في المشروع كمرجع حي، فالإشارة ليه مش سرد تاريخي زائد.

---

## 3) مراجعة SOLID/OOP/Design Patterns — النتائج

- **Single Responsibility:** كل Cubit بيغطي مسؤولية واحدة مترابطة (حتى `CreateComplaintCubit` بالـ13 method العامة بتاعتها — كلها فعليًا جزء من "إدارة draft الـwizard الواحد"، مش God class). ملقتش انتهاك حقيقي هنا غير التكرار المذكور في قسم 2.
- **Open/Closed:** الـswitch-based mappers (`category_visuals.dart`, `severity_visuals.dart`, `status_badge.dart`) بتطبّق نفس النمط "enum → label/icon/color" بشكل متسق 3 مرات — فرض interface عام هنا هيكون over-engineering لحالة بسيطة الـDart بالفعل بتغطيها كويس بـswitch expressions.
- **Liskov/Interface Segregation:** كل الـrepository interfaces (`ComplaintRepository`, `AuthRepository`, إلخ) صغيرة ومركّزة على domain واحد، وكل implementation بتنفّذ العقد كامل بدون استثناءات جزئية.
- **Dependency Inversion:** الـCubits بتاخد `Repository` interfaces (مش implementations) عبر الـconstructor، مسجّلة في `injection.dart` بربط صحيح interface→implementation. المخالفة الوحيدة اللي لقيتها (`LocationPickerPage`) اتصلحت في قسم 2و.
- **Design Patterns الموجودة بالفعل وسليمة (سيبتها زي ما هي):**
  - `core/di/injection.dart` — composition root نظيف، ربط صحيح، وscoping صحيح (singleton للـrepositories، factory للـCubits الخاصة بكل شاشة).
  - `core/errors/failures.dart`/`error_mapper.dart`/`dio_exception_guard.dart` — sealed `Failure` hierarchy، نقطة دخول واحدة `ErrorMapper.map`، `guardDioCall` adapter مشترك بالفعل.
  - الـTemplate Method الجديد (`guardNetworkCall`) — أهم Design Pattern إصلاح في هذه الجولة (قسم 2أ).
- **Encapsulation/Immutability:** كل الـstates والـentities بتستخدم `final`/`const` مناسب، و`copyWith` patterns سليمة. لاحظت (وراجعت) عدم استخدام `?? this.field` في `AuthState.copyWith`/`ComplaintDetailsLoaded.copyWith` لبعض الحقول (`fieldErrors`, `failureMessageKey`, `commentErrorMessageKey`) — بعد فحص كل نقاط الاستخدام، ده سلوك "one-shot" مقصود (بيمسح رسالة خطأ قديمة تلقائيًا في أي تحديث تالي بدل ما تفضل معروضة بالغلط)، فسيبته زي ما هو وأضفت تعليق يوضّح القصد بدل ما أغيّر السلوك.

---

## 4) الـDependency وتغييرات الحزم

| الحزمة | الحالة | السبب |
|---|---|---|
| `injectable`, `injectable_generator` | ❌ محذوفة | صفر استخدام (`@injectable` غير موجود في أي ملف) |
| `freezed_annotation`, `freezed` | ❌ محذوفة | صفر استخدام (`@freezed` غير موجود) |
| `json_annotation`, `json_serializable` | ❌ محذوفة | صفر استخدام (`@JsonSerializable` غير موجود) |
| `build_runner` | ❌ محذوفة | كانت فقط لتشغيل الـgenerators أعلاه؛ الـl10n بيتولّد بـ`flutter gen-l10n` بشكل منفصل |
| `bloc_test` | 🔄 من `any` إلى `^9.1.7` | التعارض القديم مع `injectable_generator` اختفى بحذفها |
| `mocktail` | ✅ بدون تغيير | مستخدمة بالفعل، وأضفنا استخدام حقيقي ليها في اختبارات الـCubits الجديدة |

`flutter pub get` نجح بدون أي تعارض حل نسخ بعد التعديل.

---

## 5) اختبارات الـCubit المضافة

أضفت 3 ملفات اختبار جديدة تحت `test/features/` باستخدام `bloc_test` + `mocktail`، بتعمل mock لـrepository interfaces (مش implementations):

| الملف | يغطي |
|---|---|
| `test/features/auth/presentation/cubit/auth_cubit_test.dart` | `login`/`register`: validation errors (بدون استدعاء الـrepository)، success، failure مع الرسالة المُعادة من `ErrorMapper` |
| `test/features/complaints/presentation/cubit/complaint_details_cubit_test.dart` | `load` (نجاح، فشل الشكوى بدون جلب تعليقات، فشل الفئات بدون كسر الصفحة)، `toggleLike` (تشغيل، حل التعارض مع dislike، فشل صامت)، `postComment` (نجاح باسم المستخدم الحالي، تجاهل نص فاضي) |
| `test/features/create_complaint/presentation/cubit/create_complaint_cubit_test.dart` | `nextStep`/`previousStep` (validation، الانتقال بين الخطوتين)، `submit` (validation، عدم وجود مستخدم مسجّل، نجاح)، `attachPhoto`/`removePhoto` |

**العدد الإجمالي:** 53 اختبار جديد، كلهم ناجحين. الاختبارات دي بتغطي فعليًا نفس السبب اللي DIP بيبرره — استبدال الـrepository implementation الحقيقي بـmock بدون تغيير أي كود في الـCubit نفسه.

---

## 6) نتائج التحقق (Verification)

```
cd flutter
dart format .        # → 0 files changed
flutter analyze      # → No issues found!
flutter test         # → 56 tests passed (3 قديمة + 53 جديدة)
flutter test integration_test   # → 1 test passed (app_walkthrough_test.dart)
```

كل الأربعة أوامر اتشغّلوا فعليًا في هذه الجلسة ونجحوا. `flutter test integration_test` اتشغّل مقابل الـmock server المحلي (`localhost:3000`) وغطّى الرحلة الكاملة (auth → home → complaints → map → create complaint → profile).

---

## 7) اللي تم تركه كما هو عمدًا (وليه)

- **Cubits بتتكلم مع repositories مباشرة بدل UseCase layer منفصلة** — قرار مؤكد مع المستخدم؛ الـrepositories بالفعل interfaces قابلة للـmock، وطبقة UseCase-per-method هنا هتكون boilerplate بدون فايدة تستيابيلتي/قرائية حقيقية لحجم المشروع ده.
- **`CreateComplaintCubit` بـ13 method عامة** — كل الـmethods فعليًا جزء من مسؤولية واحدة مترابطة ("إدارة draft الـwizard")، مش God class.
- **الـswitch-based visual mappers (`category_visuals.dart` إلخ)** — سيبتهم زي ما هم، فرض interface عام هيكون over-engineering.
- **`AuthState.copyWith`/`ComplaintDetailsLoaded.copyWith` بدون `?? this.field` لبعض الحقول** — سلوك "one-shot" مقصود، مش باگ (قسم 3).
- **`AuthInterceptor.onError`'s `TODO(patrick-auth)`** — auto-logout عند 401 لسه مؤجل بشكل موثّق لفرع مستقبلي محدد، مش دين تقني مخفي.

---

## 8) ملحق: نطاق الملفات المتأثرة

- **~77 ملف** في `flutter/lib/` تم تعديلهم (أغلبهم تكثيف تعليقات + الإصلاحات المذكورة في قسم 2).
- **18 ملف** تم حذفهم (شجرة `complaint_details/` الميتة + 8 مجلدات `usecases/.gitkeep`).
- **ملف جديد:** `flutter/lib/core/network/repository_guard.dart` (الـTemplate Method المشترك).
- **3 ملفات اختبار جديدة** تحت `flutter/test/features/`.
- `flutter/pubspec.yaml` (7 حزم محذوفة، 1 معاد تثبيتها) + `flutter/pubspec.lock` (محدّث تلقائيًا عبر `flutter pub get`).
- `flutter/README.md` (تصحيح تعليمات توليد الـl10n).
- `flutter/lib/l10n/app_ar.arb` + الملفات المولّدة (`app_localizations*.dart`) — تكثيف وصف المفاتيح، معاد توليدها عبر `flutter gen-l10n`.

هذا التقرير: `clean_architecture_audit_report.md`
