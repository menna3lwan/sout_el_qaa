# صوت القاع (Sout El-Qaa) — Technical Implementation Plan

**Deliverable #1 — Rev 2 (بعد أول جولة مراجعة). للمراجعة والاعتماد قبل أي implementation.**
لسه لا يوجد أي كود production. هذا مستند تخطيط فقط، طبقًا للـ Mandatory Rule في تعليمات المشروع (البند 3). التعديل ده جه ردًا على ملاحظاتك بتاريخ 24 أغسطس 2026 — أهمها: فصل صريح بين إيه اللي *أنا وافقتي عليه فعلًا* وإيه اللي *مجرد اقتراح أو افتراض مني*. القاعدة من هنا وإلى ما تقولي غير كده: **مفيش أي حاجة تتوصف "Confirmed" أو "معتمدة" في هذا المستند إلا لو وافقتي عليها صراحة**.

- **Figma file:** `صوت القاع` — key `ysvQxQut5Yu72tKp5wp3HA`
- **تاريخ المراجعة الأولى:** 24 أغسطس 2026
- **حالة الـFigma:** تمت مراجعته بالكامل برمجيًا (metadata كاملة لكل الصفحة، نصوص كل الشاشات، الهيكل الشجري لكل شاشة حتى عمق 6 مستويات). النتائج موثقة بالكامل في القسم 15.

### مفتاح الرموز المستخدم في المستند كله

| رمز | المعنى |
|---|---|
| **[C#]** | **Confirmed** — وافقتي عليه صراحة، موثق بتاريخه في القسم 14 |
| **[P#]** | **Proposed** — اقتراح مني، مستني موافقتك، لسه مش نهائي |
| **[A#]** | **Assumption** — افتراض مؤقت هنمشي عليه عشان نكمل، مش قرار product |
| **[Q#]** | **Open Question** — نقطة محتاجة قرار منك قبل أو أثناء التنفيذ |

كل الـIDs دي مجمّعة ومفصّلة بالكامل في **القسم 14 — Decisions & Assumptions Registry**، وهو المرجع الوحيد لحالة أي قرار في المشروع من دلوقتي.

---

## 0. ملخص تنفيذي (Executive Summary)

الـFigma الحالي **أصغر وأقل اكتمالًا** مما تفترضه الـchecklist العامة في تعليمات المشروع. الملف يحتوي فعليًا على **8 frames رئيسية فقط** على مستوى الصفحة، منها **2 فارغة تمامًا** (لا يوجد بداخلها أي layer):

| الحالة | الشاشات |
|---|---|
| ✅ مصمَّمة بالكامل مع محتوى نصي حقيقي | لوحة المعلومات الرئيسية (Home)، نموذج تقديم شكوى جديدة (Create Complaint)، تفاصيل الشكوى (Complaint Details)، الشكوي (Complaints List) |
| ⚠️ مصمَّمة هيكليًا لكن بنصوص placeholder ("Text") غير معبأة | الملف الشخصي (Profile)، الاشعارات (Notifications) |
| ❌ **Frame فارغ تمامًا — لا يوجد أي تصميم** | ترحيب (Welcome/Splash) — `node 33:2`، الحريطة (Map) — `node 33:351` |

**لا توجد** شاشات منفصلة لـ Login / Register / Settings / Search / Filters كـ top-level frames. هذا لا يعني أنها غير مطلوبة من الـproduct — يعني أن الـFigma لم يصمم لها شاشات مستقلة بعد.

### حالة القرارات دلوقتي (بعد جولة المراجعة الأولى)

| النوع | العدد | التفاصيل الكاملة |
|---|---|---|
| ✅ Confirmed | 6 | القسم 14 — بند "Confirmed" |
| 💡 Proposed | 11 | القسم 14 — بند "Proposed"، مستنية موافقتك |
| 🔸 Assumption | 7 | القسم 14 — بند "Assumption"، هنمشي بيها لحد ما تتأكد أو تتنفى |
| ❓ Open Question | 4 | القسم 14 — بند "Open Question" |

القرار المعماري الأهم في هذا الـplan يفضل زي ما هو: نبني الـproduct الكامل حتى لو لم تُصمَّم بعض الشاشات بعد، عبر طبقة data/repository قائمة على عقود واضحة من اليوم الأول (مش backend حقيقي مطلوب عشان نبدأ)، وتصميم الشاشات الناقصة بنفس لغة الـdesign system المستخرجة من الشاشات الجاهزة فعليًا — لكن كل جزء من ده اتفكك دلوقتي لقرارات مصنّفة بدقة في القسم 14 بدل ما يتقال كـ"قرار معماري" واحد كبير.

---

## 1. Architecture

> ✅ **[C6]** وافقتي على الـarchitecture العامة والـlayering والـstate pattern في هذا القسم بشكل صريح في هذه الجولة. التفاصيل الدقيقة (تسمية ملفات، إلخ) تفضل قابلة للتعديل أثناء التنفيذ الفعلي.

### 1.1 القرار المعماري

**Clean Architecture (feature-first)** مع 3 طبقات صريحة لكل feature:

```
Presentation  →  Domain  →  Data
   (UI + Cubit/Bloc)   (Entities + UseCases + Repository Contracts)   (Models + DataSources + Repository Impl)
```

**السبب:**
- التطبيق مطلوب منه إدارة lifecycle كامل للشكاوى (حالات، تفاعلات، إشعارات، خرائط) — منطق أعمال حقيقي وليس CRUD بسيط، فيستحق فصل الـdomain عن الـUI وعن مصدر البيانات.
- الـData layer الحقيقية لسه مش موجودة (الـbackend REST **[C1]** لسه هيتبنى — انظر القسم 14)، فلازم يكون فيه seam واضح (Repository interface في الـdomain، وimplementation في الـdata) يسمح بالتبديل من mock إلى REST حقيقي بأقل تعديل ممكن (تفصيل دقيق للحدود الحقيقية لهذا التبديل في القسم 16).
- Testability: الـUseCases والـCubits pure ومعزولة عن أي I/O، فيسهل اختبارها بدون mocking معقد.

### 1.2 الطبقات ومسؤولية كل واحدة

| Layer | المسؤولية | لا يجب أن تحتوي على |
|---|---|---|
| **Presentation** | Widgets, Pages, Cubit/Bloc, UI state classes | API calls, JSON parsing, business rules |
| **Domain** | Entities (immutable), UseCases (a single business action each), Repository *interfaces* (abstract) | أي تفاصيل تنفيذ (Dio, Hive...) |
| **Data** | Models (DTOs + `fromJson/toJson` أو `freezed`)، DataSources (Remote/Local)، Repository *implementations*، Mappers (Model ↔ Entity) | UI logic، Cubit state |

اتجاه الـdependency: **Presentation → Domain ← Data**. الـDomain لا يعرف عن Data أو Presentation إطلاقًا (Dependency Inversion — الـData تعتمد على عقود الـDomain، مش العكس).

### 1.3 State Management

**flutter_bloc** — **Cubit** كافتراضي لكل شاشة، و**Bloc** فقط في حالات فيها أكثر من "مصدر حدث" واحد يغذي نفس الـstate.

كل feature غير متزامن (async) لازم يستخدم state واحد مغلق (sealed/union) بدل مجموعة booleans:

```dart
sealed class ComplaintsFeedState {}
class ComplaintsFeedInitial extends ComplaintsFeedState {}
class ComplaintsFeedLoading extends ComplaintsFeedState {}
class ComplaintsFeedLoaded extends ComplaintsFeedState {
  final List<ComplaintEntity> complaints;
  final ComplaintFilter activeFilter;
}
class ComplaintsFeedEmpty extends ComplaintsFeedState {}
class ComplaintsFeedFailure extends ComplaintsFeedState {
  final Failure failure;
}
```

ممنوع: `bool isLoading; bool hasError; bool isEmpty;` في نفس الـclass — بيسمح بحالات متناقضة.

### 1.4 Dependency Injection

**get_it + injectable** — يتماشى مع خبرتك الحالية في DI/IoC/Service Locator. `injectable` بيولّد الـregistration code فبيقلل الـboilerplate اليدوي.

### 1.5 Routing

**go_router** مع `StatefulShellRoute.indexedStack` للـbottom navigation (5 tabs: الرئيسية / الخريطة / إضافة / شكاوي / الملف الشخصي)، و route guards للتحقق من حالة الـauthentication.

### 1.6 Error Handling

تحويل صريح من exception تقنية إلى failure مفهومة، عبر `Either<Failure, T>`:

```
DioException / SocketException / CacheException
      ↓ (Repository catches & maps)
NetworkFailure / ServerFailure / CacheFailure / ValidationFailure
      ↓ (Cubit maps to UI-safe message)
"معنا مشكلة في الاتصال... جرّب تاني يا ساكن القاع 🐠" (رسالة بهوية قاع الهامور، مش exception خام)
```

كل رسالة خطأ تظهر للمستخدم لازم تكون بروح قاع الهامور — هذا شرط منتج أساسي في تعليمات المشروع، مش تفصيل تقني (انظر القسم 19 — Product Definition of Done).

### 1.7 Network Layer

`dio` + interceptors (auth token attach, logging في debug فقط، retry محدود على timeout). الـRemoteDataSource هيتبنى ضد الـ**Proposed API Contract** (القسم 16) — ليس ضد backend حقيقي بعد، لأنه غير موجود **[C1]**.

### 1.8 Local Storage

- `flutter_secure_storage` — auth token.
- `shared_preferences` — flags بسيطة (onboarding seen, locale, theme).
- `hive` — كاش خفيف للشكاوى المعروضة + drafts لشكوى لسه ما اتبعتتش. **(MVP — انظر القسم 17)**. لا نضيف `isar` أو أي بديل أعقد إلا لو احتجنا queries تتخطى إمكانيات `hive` فعليًا أثناء التنفيذ.

### 1.9 كيف تتواصل الـfeatures مع بعضها

- **لا** استدعاء مباشر بين Cubit وCubit من feature مختلفة.
- المشاركة تتم عبر: (أ) `go_router` navigation + extras/query params، (ب) UseCases مشتركة (مثال: `GetCurrentUserUseCase`)، (ج) قيَم مشتركة حقيقية (مثال: user session) في `core/` كـ singleton service.

### 1.10 Core vs Feature-specific

**Core** = أي حاجة بلا سياق منتج. **Feature** = أي حاجة عندها منطق أو بيانات خاصة بمجال واحد. قاعدة الاختبار العملية: لو الكود يعرف اسم "complaint" أو "notification" فهو feature-specific مش core.

---

## 2. Project Structure (Folder Structure)

> ✅ **[C6]** جزء من الـarchitecture المعتمدة.

```text
lib/
├── main.dart                        # entrypoint واحد، يستدعي bootstrap()
├── bootstrap.dart                   # DI init + error zone + runApp
│
├── core/
│   ├── constants/                   # app_strings (نصوص عالم قاع الهامور الثابتة)، api_endpoints، asset_paths
│   ├── di/                          # injectable config (injection.dart + injection.config.dart المولّد)
│   ├── errors/                      # Failure, Exception classes, error_mapper
│   ├── network/                     # DioClient, interceptors, NetworkInfo (connectivity)
│   ├── router/                      # app_router.dart (go_router), route_guards.dart
│   ├── theme/                       # app_theme.dart, app_colors.dart, app_typography.dart, app_spacing.dart
│   ├── localization/                # ARB files (ar الآن، هيكل جاهز لـen — [C5])، RTL helpers
│   ├── storage/                     # SecureStorage, LocalCacheService, HiveAdapters
│   ├── permissions/                 # PermissionService (camera/gallery/location/notifications) موحّد
│   ├── utils/                       # extensions, validators, formatters (تاريخ نسبي "منذ ساعتين" مثلاً)
│   └── widgets/                     # AppButton, AppTextField, LoadingView, ErrorView, EmptyView,
│                                     # StatusBadge, QaaAvatar, BottomNavShell
│
├── features/
│   ├── splash/                      # يشمل onboarding/auth-check redirect
│   ├── auth/                        # login, register, session
│   │   ├── presentation/  domain/  data/
│   ├── home/                        # لوحة المعلومات الرئيسية
│   ├── complaints/                  # feed + my complaints + status tabs + search + filters (انظر القسم 18)
│   ├── create_complaint/            # نموذج تقديم شكوى جديدة (wizard)
│   ├── complaint_details/           # تفاصيل الشكوى + تعليقات + تفاعلات (انظر القسم 18)
│   ├── map/                         # الخريطة + location picker (مشترك مع create_complaint)
│   ├── notifications/
│   ├── profile/                     # profile + settings + logout + edit profile
│   └── shared_widgets/              # widgets تخص أكتر من feature بس مش core عام
│                                     # (مثال: ComplaintCard يُستخدم في Home وComplaints وProfile)
│
└── l10n/                            # generated localization
```

### 2.1 هيكل داخلي لكل feature (مثال: `complaints/`)

```text
complaints/
├── data/
│   ├── datasources/
│   │   ├── complaints_remote_data_source.dart
│   │   └── complaints_local_data_source.dart
│   ├── models/
│   │   └── complaint_model.dart          # freezed + json_serializable
│   ├── mappers/
│   │   └── complaint_mapper.dart
│   └── repositories/
│       └── complaints_repository_impl.dart
├── domain/
│   ├── entities/
│   │   └── complaint_entity.dart
│   ├── repositories/
│   │   └── complaints_repository.dart    # abstract
│   └── usecases/
│       ├── get_complaints_feed_usecase.dart
│       ├── get_my_complaints_usecase.dart
│       └── filter_complaints_usecase.dart
└── presentation/
    ├── cubit/
    │   ├── complaints_feed_cubit.dart
    │   └── complaints_feed_state.dart
    ├── pages/
    │   └── complaints_list_page.dart
    └── widgets/
        ├── complaint_card.dart
        └── status_filter_tabs.dart
```

نفس النمط يتكرر لكل الـfeatures التسعة.

---

## 3. Features Breakdown (مبني على المراجعة الفعلية للـFigma)

> ✅ **[C6]** تقسيم الـfeatures نفسه معتمد. لكن كل تفصيل سلوكي جوه كل feature غير مؤكد من الـFigma نفسه اتحط عليه tag واضح — راجعي القسم 14 لتفاصيل كل ID.

### 3.1 Splash / Onboarding — ❌ لا يوجد تصميم (`node 33:2` فارغ تمامًا)

- **الحالة:** الـframe موجود بالاسم "ترحيب" لكن بدون أي layer بداخله في كل نسخه بالملف (3 نسخ مكررة، كلهم فارغين).
- **مين هيصممه:** إحنا **[C3]**، بنفس الـdesign language المستخرج من الشاشات الجاهزة.
- **States:** Initial → Checking Auth → Redirect.
- **Dependencies:** `auth` feature (session check).

### 3.2 Authentication (Login/Register) — ❌ لا يوجد تصميم مخصص

- **الحالة:** لا يوجد أي frame باسم تسجيل الدخول أو التسجيل في كل الملف.
- **مين هيصممه:** إحنا **[C3]** (نفس الـForm Card style من "نموذج تقديم شكوى جديدة"، نفس الأزرار)، مع مراجعة لاحقة من فريق التصميم قبل الـpolish.
- **الشاشات المتوقعة [P]:** Login, Register, Forgot Password (لو مطلوب), Splash→Auth redirect.
- **البيانات:** email/phone, password, username, avatar اختياري (avatar SpongeBob-style مؤكد من الـcomponent "SpongeBob Avatar" الموجود فعليًا في كل الشاشات المصممة).
- **Validation:** email format, password strength, confirm password match, unique username (server-side).
- **States:** Idle → Validating → Submitting → Success (navigate) → Failure (inline + snackbar بهوية قاع الهامور).
- **Edge cases:** حساب موجود بالفعل، شبكة ضعيفة أثناء التسجيل، رفض الـbackend لاسم مستخدم.

### 3.3 Home — ✅ مصمَّمة بالكامل (`node 33:21`)

المحتوى الفعلي من الـFigma (كله مؤكد، مش استنتاج):
- Header: تحية شخصية "صباح الفل يا ساكن المحيط!" + موقع المستخدم "قاع الهامور، شارع الأناناس" + avatar.
- Search entry point: "إبحث عن شكوى..." (انظر 3.4 — تصميم النتائج نفسه غير موجود).
- CTA رئيسي: "قدم شكوى جديدة" → `create_complaint`.
- قسم "أكثر الشكاوى تفاعلاً" (Trending) — بطاقة مثال: "مدام نفيخة نفسها مش عارفة تدرب سواقة في الشارع ده!" في "شارع القاع البحري".
- قسم "تصنيفات الشكاوى" (Categories): **مياه، طرق، نظافة، كهرباء** — 4 تصنيفات مؤكدة نصيًا (قابلة للتوسع لاحقًا — **[A4]**).
- قسم "نشاطاتك الأخيرة": "مستر سلطع قطع المية ومستنينا نشتريها!"، "شمشون سرق كهرباء الأعمدة عشان يشغل معمله السري!".
- Bottom nav (5 tabs).
- **States:** Loading → Loaded (feed + categories + activity) → Empty (لا نشاط بعد لمستخدم جديد) → Failure → Pull-to-refresh.
- **Edge cases:** مستخدم جديد بلا نشاط، فشل تحميل قسم واحد فقط بينما الباقي نجح (partial failure — معالجة مستقلة لكل قسم).

### 3.4 Search & Filters — ⚠️ موجودة كـ entry points فقط، بلا نتائج مصمَّمة

- "إبحث عن شكوى..." في Home، وتابات "تم حلها / شكوائي / كل الشكاوى" في شاشة الشكوي هي فلترة حالة، مش بحث نصي كامل — دي حقيقة مؤكدة من الملف.
- **[P1]** شكل البحث نفسه (نتائج + فلاتر) اقتراحي: bottom-sheet فوق شاشة الشكوي، مش شاشة نتائج مستقلة. مستني موافقتك.
- **States:** Idle → Typing (debounced) → Results → No Results ("معندناش شكاوى بالوصف ده... جرّب كلمة تانية يا جار!") → Failure.

### 3.5 Complaints (All / Mine / Status Filters) — ✅ مصمَّمة (`node 33:663`)

> ملحوظة حدود المسؤولية: هذه الـfeature (branch #5) مسؤولة عن القائمة والفلترة فقط. تفاصيل شكوى واحدة (شاشة كاملة) مش مسؤوليتها — انظر التوضيح الكامل في القسم 18.

- تابات: "كل الشكاوى" / "شكوائي" / "تم حلها".
- بطاقات شكوى حقيقية بأمثلة نصية: "الشارع الرئيسي مكسر" (شارع القاع البحري، قيد المعالجة، منذ ساعتين)، "القمامة متراكة ف الشارع" (منطقة الاناناس، تم الحل، منذ 3 ايام)، "أعمدة الإنارة لا تعمل" (حى الرمال، تم الحل، منذ اسبوعين).
- **حالات الشكوى المؤكدة (2 مصدرين متطابقين):** تم الاستلام → قيد المراجعة/قيد المعالجة → تم الحل.
- **[A]** Pagination: infinite scroll (غير مصمَّم صراحة، 3 بطاقات فقط ظاهرة).
- **[P7]** Sorting: الأحدث أولًا كافتراضي + خيار "الأكثر تفاعلاً".
- **States:** لكل تاب حالته المستقلة (Loading/Loaded/Empty/Failure) — التبديل بين التابات ما يعيدش تحميل التابات التانية.
- **Empty state per tab:** رسالة مختلفة لكل حالة، بروح الشخصية.

### 3.6 Create Complaint — ✅ مصمَّمة بالتفصيل (`node 33:210`)

الحقول الفعلية من الـForm Card (مؤكدة 100% من الـFigma):
1. **Media Upload** (اختياري).
2. **نوع المشكلة** — اختيار من قائمة أيقونات.
3. **وصف المشكلة** — textarea بحد أقصى **300 حرف** (مؤكد).
4. **حدد الموقع على الخريطة**.
5. **درجة الخطورة** — عالية / متوسطة / منخفضة (مؤكد).
6. **إرسال الشكوة** + نص طمأنة "سيتم مراجعة شكواك من فريقنا".

- **[A5] Assumption — مش قرار نهائي:** ظهر مؤشر خطوات "1" و"3" أعلى الشاشة، لكن الملف يحتوي شاشة واحدة فقط لهذا الـflow. افتراضنا الحالي: هذا wizard من 3 خطوات، والـFigma صمم خطوة واحدة تمثيليًا فقط. **التنفيذ هيفضل flexible عمدًا** (state واحد مركزي + كل خطوة widget مستقل) عشان لو اتأكد إن الشكل الحقيقي مختلف (شاشة واحدة، أو توزيع تاني للحقول، أو عدد خطوات مختلف)، التعديل يبقى محدود وسريع، مش refactor كامل.
- **Validation:** نوع المشكلة required، الوصف required (حد أقصى 300 مؤكد)، الموقع required قبل الإرسال، الخطورة required.
- **Media:** `image_picker`، ضغط قبل الرفع، معاينة، حذف صورة مختارة.
- **Location:** `geolocator` + اختيار يدوي من الخريطة، مع `permission_handler`.
- **Upload progress:** progress indicator منفصل لرفع الوسائط عن إرسال الشكوى (retry يعيد الإرسال بدون إعادة رفع الوسائط من الصفر).
- **Draft handling:** حفظ محلي (Hive) لو المستخدم غادر الشاشة قبل الإرسال.
- **States:** Idle → Uploading Media (progress %) → Submitting → Success → Failure (retry يحافظ على كل البيانات المدخلة).

### 3.7 Map & Location — ❌ لا يوجد تصميم (`node 33:351` فارغ تمامًا)

- **المطلوب:** خريطة تفاعلية بعلامات (markers) لمواقع الشكاوى، مربوطة فعليًا بالبيانات — شرط صريح في تعليمات المشروع.
- **الاستخدام المزدوج:** (أ) خريطة استكشاف عامة، (ب) location picker داخل Create Complaint (نفس الـwidget بمود مختلف).
- **مكتبة الخريطة:** `flutter_map` **[C4]** — معتمد صراحة.
- **[P3] مين هيصمم شكل الشاشة نفسها:** اقتراحي إحنا نصممها (نفس معاملة Auth/Splash)، لكن ده لسه ما اتسألش عليه بشكل مباشر ومستني موافقتك — مختلف عن اختيار المكتبة (C4) اللي اتوافق عليه فعلًا.
- **Markers:** تصنيف بالـcategory، tap → bottom sheet ملخص → "عرض التفاصيل" → `complaint_details`.
- **States:** Loading (تحديد الموقع الحالي) → Loaded (markers) → Location Permission Denied → Location Services Disabled → Failure.

### 3.8 Complaint Details — ✅ مصمَّمة (`node 33:518`)

> ملحوظة حدود المسؤولية: هذه الـfeature (branch #7) هي المالك الوحيد لكل حاجة بتحصل بعد فتح شكوى معينة. انظر القسم 18.

- Header: "قارب مدام نفيخة مش هيعدي من هنا أبداً!" — شارع القاع البحري — **342 مشاهدة** / **1248 إعجاب**.
- **Status tracker** (3 خطوات مؤكدة): تم الاستلام → قيد المراجعة → تم الحل.
- **Comments section:** بطاقة تعليق واحدة نموذجية — avatar + اسم ("شفيق") + نص التعليق + زرار تفاعل. البنية تدعم قائمة تعليقات، وليست تعليق ثابت.
- **[P10]** الإعجاب على مستوى الشكوى ومستوى التعليق منفصلين منطقيًا — اقتراحي، لأن الـFigma أظهر عداد واحد بس على مستوى الشكوى.
- **Views counter [A7]:** افتراضنا إنه بيتزود مرة واحدة لكل مستخدم (dedup) — تفصيل مش موجود في الـFigma.
- **States:** Loading → Loaded → Failure. تعليقات: Loading (منفصل) → Loaded → Empty ("لسه محدش علّق... يلا يا جيران قولوا رأيكوا!") → Failure → Submitting → Optimistic add.
- **[P11]** تغيير حالة الشكوى نفسها (status transition) معلّق على **[Q2]** — للـMVP، التطبيق يعرض الحالة read-only فقط من جهة المواطن.
- **Edge cases:** حذف تعليق بواسطة صاحبه، شكوى محذوفة أثناء التصفح، محاولة تعليق بدون تسجيل دخول.

### 3.9 Notifications — ⚠️ هيكل مصمَّم، نصوص placeholder (`node 33:936`)

- Header "الاشعارات" + 4 أزرار فلترة (نصوصهم placeholder في الـFigma).
- **[A]** المعنى الأرجح للفلاتر: الكل/غير مقروء/شكاوى/تفاعلات — غير مؤكد.
- **4 بطاقة إشعار** بنفس التصميم، نص واحد فعلي ظهر: "**جاري الحل**".
- **[Q3]** زرار "عرض الكل" — يفتح صفحة كاملة منفصلة، أو "تحديد الكل كمقروء"؟ الاسم يوحي بالأول، الموضع يوحي بالثاني — محتاج قرارك.
- **[A]** أنواع الإشعارات المتوقعة (استنتاج من باقي الـproduct): تحديث حالة شكوى، تعليق جديد، إعجاب/تفاعل، رد إداري.
- **Read/Unread:** يحتاج تمييز بصري (لم يُصمَّم صراحة لكنه شرط منتج أساسي).
- **States:** Loading → Loaded → Empty ("مفيش إشعارات لسه... لما حد يزعل من شكوتك هنقولك!") → Failure.
- **[Q1] استراتيجية الـpush:** لسه مفتوحة بالكامل — للـMVP، إشعارات in-app فقط (بدون FCM) لحد ما يتقرر غير كده. تفاصيل في القسم 17.

### 3.10 Profile & Settings — ⚠️ هيكل مصمَّم، نصوص placeholder (`node 33:794`)

- Avatar + info (placeholder نصيًا).
- **[A6]** Stats Grid — 3 بطاقة إحصائية placeholder، افتراضنا: عدد الشكاوى المقدمة، المحلولة، النقاط.
- **[P5]** Settings Menu List — 5 عناصر placeholder، اقتراحي: تعديل الملف الشخصي، شكاواي، تفضيلات الإشعارات، عن التطبيق/اللغة، تسجيل الخروج.
- **States:** Loading → Loaded → Failure. Logout: تأكيد قبل التنفيذ → clear session → redirect لـLogin.
- **[P9]** Account deletion: مؤجّل خارج نطاق الـMVP (غير مصمَّم في الـFigma أصلًا).

---

## 4. Dependencies (الحزم المقترحة)

> جدول الـScope هنا فهرس سريع فقط — التفاصيل والمبرر الكامل لكل بند Future/Optional في القسم 17.

| الفئة | الحزمة | Scope | السبب |
|---|---|---|---|
| State Management | `flutter_bloc`, `bloc` | **MVP** | Cubit/Bloc، حالات صريحة |
| DI | `get_it`, `injectable`, `injectable_generator` | **MVP** | يتماشى مع خبرتك الحالية في DI/IoC |
| Routing | `go_router` | **MVP** | Guards، nested shell، deep links |
| Networking | `dio`, `pretty_dio_logger` (debug only) | **MVP** | Interceptors، cancel tokens |
| Models | `freezed`, `json_serializable`, `build_runner` | **MVP** | Immutability + copyWith + equality |
| Functional/Error | `fpdart` (أو `dartz`) | **MVP** | `Either<Failure, T>` بدل try/catch متناثر |
| Local Storage | `hive`, `hive_flutter`, `flutter_secure_storage`, `shared_preferences` | **MVP** | كاش + drafts + token آمن + flags |
| Map | `flutter_map`, `latlong2` | **MVP** ✅ [C4] | مجاني بلا billing |
| Location | `geolocator`, `permission_handler` | **MVP** | موقع حالي + أذونات |
| Media | `image_picker`, `flutter_image_compress`, `cached_network_image` | **MVP** | رفع وضغط وعرض الصور/الفيديو |
| Notifications (in-app) | `flutter_local_notifications` | **MVP** | عرض محلي فقط |
| Notifications (push) | `firebase_messaging` | **Future — معلّق على [Q1]** | مش هيتضاف قبل ما استراتيجية الـpush تتأكد |
| Dev/Mock server | `json-server` أو `mockoon` (dev-only) | **MVP (dev tooling، مش app dependency)** | تشغيل الـProposed API Contract محليًا |
| Connectivity | `connectivity_plus` | **MVP** | تمييز offline/poor network |
| Localization | `flutter_localizations`, `intl` | **MVP** ✅ [C5] | بنية AR/EN من البداية |
| Testing | `bloc_test`, `mocktail`, `flutter_test`, `integration_test` | **MVP** | Unit/Widget/Integration |
| Testing (بصري) | `golden_toolkit` | **Future/Optional** | مش جزء من أي DoD إلا لو طُلب صراحة لاحقًا |
| Utils | `equatable` (لو مش هنعتمد `freezed` بالكامل)، `logger` | **MVP** | مساواة كائنات + logging منظم |

---

## 5. Data Flow

```text
UI (Widget)
  → يستدعي method على Cubit (مثال: cubit.loadFeed())
  → Cubit يستدعي UseCase واحد أو أكتر (Domain)
  → UseCase يستدعي Repository interface (Domain)
  → RepositoryImpl (Data) يقرر: Remote أولاً؟ Local fallback؟ Cache-then-network؟
  → DataSource (Remote/Local) ينفذ الـI/O الفعلي
  → النتيجة ترجع كـ Either<Failure, Entity> صعودًا لغاية الـCubit
  → الـCubit يـemit الـstate المناسب (Loaded/Empty/Failure)
  → الـUI يعيد البناء بناءً على الـstate فقط (لا منطق قرار داخل الـwidget)
```

كل استدعاء Repository يمر أولًا بفحص `NetworkInfo` قبل محاولة الـremote call، ويستخدم الكاش المحلي كـfallback للعرض مع إشارة واضحة للمستخدم إن البيانات مش محدّثة، مش عرض صامت.

---

## 6. State Management (تفصيل تطبيقي)

نموذج الحالات الموحد في **كل** feature غير متزامن:

```
Initial → Loading → (Success | Empty | Failure)
```

مع حالات فرعية عند الحاجة فقط (`Submitting`, `Uploading(progress)`) — لكن دايمًا كـsealed class واحد. أي Cubit يحتاج retry بيحتفظ بالـfailure الأخير + آخر params ناجحة.

---

## 7. Error Handling (تفصيل تطبيقي)

**تصنيف الأخطاء** (`core/errors/failures.dart`):

- `NetworkFailure` — لا يوجد اتصال.
- `ServerFailure(int? statusCode, String? message)` — خطأ من الـbackend.
- `CacheFailure` — فشل قراءة/كتابة محلية.
- `ValidationFailure(Map<String,String> fieldErrors)` — أخطاء فورم، inline جنب كل حقل.
- `PermissionFailure(PermissionType type)` — كاميرا/موقع/إشعارات مرفوضة، مع CTA لفتح الإعدادات.
- `UnauthorizedFailure` — token منتهي → auto-logout + redirect لـLogin (مركزي في `Dio` interceptor).
- `UnknownFailure` — أي حاجة تانية، log كامل + رسالة عامة بروح قاع الهامور.

كل exception تقني يُقبض عليه **فقط** في الـDataSource/RepositoryImpl، ويُحوَّل فورًا لـFailure. الـPresentation ما يشوفش أي exception خام إطلاقًا.

---

## 8. Testing Strategy

> ✅ **[C6]** معتمدة كما هي.

| النوع | نطاق التغطية | أدوات |
|---|---|---|
| **Unit Tests** | كل UseCase (نجاح + فشل)، كل Cubit (تسلسل الـstates عبر `bloc_test`)، Mappers، Validators | `flutter_test`, `bloc_test`, `mocktail` |
| **Widget Tests** | كل حالة UI مستقلة (Loading/Empty/Error/Success)، Form validation (Create Complaint تحديدًا) | `flutter_test` |
| **Integration Tests** | Happy path: Login → Home → Create Complaint → Submit → Details يظهر الشكوى الجديدة. flow المصادقة كامل | `integration_test` |
| **Golden Tests** | **Future/Optional** — انظر القسم 17 | `golden_toolkit` |

معيار القبول: أي UseCase أو Cubit جديد **لازم** يترفض في الـPR review لو مفيش test يغطي حالة النجاح وحالة فشل واحدة على الأقل.

---

## 9. Branching Strategy

> ✅ **[C6]** معتمدة كما هي.

Convention: `feature/<spongebob-character>-<scope>`، كل branch = vertical slice كامل وقابل للمراجعة والدمج بمفرده دون كسر باقي التطبيق. **بعد كل branch، تنفيذ يوقف ويستني موافقتك قبل الانتقال للتالية — تفاصيل بروتوكول التقرير في القسم 20.**

الترتيب والنطاق مبني على التبعيات الفعلية — مطابق لتسلسل تعليمات المشروع مع تعديل داخلي واحد: Map (#4) قبل Create Complaint (#6) لأن الأخيرة تعتمد على location picker من Map (ترتيب الأسماء الظاهري يفضل زي المتفق عليه في التعليمات).

---

## 10. Order of Implementation & Branch Table

| # | Branch | Scope | Dependencies | Expected Deliverable | Testing |
|---|---|---|---|---|---|
| 1 | `feature/spongebob-foundation` | Flutter init، Clean Architecture skeleton، DI، `go_router` shell (بلا محتوى حقيقي بعد)، theme (مستخرج من الشاشات المصممة)، RTL setup، `core/` كامل، lint rules، test scaffolding، mock server محلي (json-server) بنفس Proposed API Contract | لا يوجد | مشروع Flutter يشتغل، shell فارغ بالـ5 تابات، `flutter analyze` نظيف | Unit tests لـcore utils |
| 2 | `feature/patrick-auth` | Splash + Login + Register (تصميمنا [C3]) + session persistence + auth guards | 1 | مستخدم يقدر يسجل دخول/خروج | Unit + Widget (validation) + Integration (login) |
| 3 | `feature/squidward-home` | Home كاملة، مطابقة للـFigma `33:21` | 1، 2 | شاشة Home functional ضد mock server | Widget tests لكل حالة |
| 4 | `feature/plankton-map` | Map screen (تصميمنا المقترح [P3]) + location picker مشترك + permissions | 1 | خريطة تعرض markers حقيقية، location picker جاهز لإعادة الاستخدام | Widget + permission-denied test |
| 5 | `feature/mrkrabs-complaints` | شاشة الشكوي (تابات، فلترة، بطاقات) — **قائمة فقط، مش تفاصيل شكوى فردية (انظر القسم 18)**، مطابقة لـ`33:663` | 1، 3 | نظام الشكاوى الأساسي functional (list + navigation)، مع stub بسيط جدًا لصفحة التفاصيل (بدون منطق) عشان الـnavigation ما تكسرش | Unit (filter/sort) + Widget (كل تاب/حالة) |
| 6 | `feature/sandy-create-complaint` | نموذج تقديم شكوى (اقتراح 3 خطوات [A5])، media upload، severity، ربط بـMap، drafts، retry | 4، 5 | مستخدم يقدر يقدم شكوى كاملة من البداية للنهاية | Widget (validation) + Integration (submit) |
| 7 | `feature/gary-interactions` | Complaint Details الكاملة — **المالك الوحيد للـfeature دي، بيستبدل الـstub اللي اتعمل في #5** (status tracker, comments, reactions, views)، مطابقة لـ`33:518` | 5 | الشكوى تبقى محتوى تفاعلي كامل | Unit (optimistic update) + Widget (comments states) |
| 8 | `feature/krabs-notifications` | شاشة الإشعارات كاملة + نصوص حقيقية بروح قاع الهامور. **In-app فقط في هذا الـbranch — FCM مش هيتضاف إلا لو [Q1] اتحلت قبل كده** | 1 | مستخدم يعرف كل حاجة بتحصل لشكاواه وتفاعلاته (in-app) | Widget (read/unread) + Unit (mark-as-read) |
| 9 | `feature/sandy-profile` | Profile + Settings (نصوصنا المقترحة [P5])، logout، edit profile | 2 | Profile/Settings flow مكتمل | Widget + Integration (logout) |
| 10 | `feature/spongebob-polish` | تكامل شامل، RTL/responsive verification، performance pass، إزالة أي hardcoded/mock متبقي، الاستبدال من mock server لـbackend الحقيقي **لو جهز بحلول هذه المرحلة** (مش افتراض إنه هيجهز)، regression testing كامل، **مراجعة الـProduct/Creative DoD (القسم 19)** | كل ما سبق | نسخة متكاملة جاهزة للمراجعة النهائية | Full regression suite + manual QA checklist |

> **ملحوظة Backend:** REST backend مخصص **[C1]**، غير موجود بعد. الـProposed API Contract (القسم 16) هو المرجع، والـFlutter تشتغل ضد mock server محلي من branch #1. مفيش branch منفصل لبناء الـbackend لأنه خارج نطاق هذا الـrepo — لو ده غير مقصود، محتاجين نتكلم عنه.

---

## 11. Risks & Edge Cases

| الخطر | التأثير | التخفيف |
|---|---|---|
| الـbackend الحقيقي لسه ما بُنيش (النوع REST متفق عليه [C1]، لكن التنفيذ الفعلي لسه صفر) | أي "بيانات حقيقية" فعليًا بتفضل مؤجلة لحد ما الـbackend يوصل | Data layer بعقود واضحة من البداية + mock data source ضد الـProposed Contract، فالتبديل لاحقًا محصور في طبقة الـData (انظر القسم 16) |
| شاشات فارغة (Splash, Map) قد تُصمَّم لاحقًا بشكل مختلف عمّا نبنيه | إعادة عمل UI | فصل الـUI عن الـlogic بالكامل — لو الشاشة اتغيرت شكليًا، الـCubit/UseCase ما بيتلمسوش |
| Wizard الـ3 خطوات في Create Complaint افتراض [A5] غير مؤكد | إعادة توزيع الحقول لاحقًا | كل خطوة widget مستقل + state مركزي، فإعادة الترتيب سهلة |
| نصوص Placeholder في Profile/Notifications ([A6], [P5]) قد تُستبدل رسميًا لاحقًا | تضارب بين نصوصنا المؤقتة والنص الرسمي | كل النصوص من `core/constants/app_strings` مركزية |
| الأداء مع قوائم شكاوى طويلة + صور | تهنيج/استهلاك بيانات | Pagination + `cached_network_image` + lazy loading من البداية |
| RTL + خطوط عربية مع نصوص إنجليزية تقنية مختلطة | كسر بصري | اختبار RTL من branch #1، مش يُؤجَّل لـpolish |
| Offline أثناء تقديم شكوى فيها وسائط كبيرة | فقد بيانات المستخدم | Draft محلي إجباري قبل محاولة الرفع |
| إضافة packages/abstractions زيادة عن الحاجة (over-engineering) | تعقيد بدون فايدة قريبة | فصل صريح MVP/Future في القسم 17 — مفيش إضافة بدون سبب واضح وقريب |

---

## 12. Assumptions — دُمجت في القسم 14

كل الـAssumptions اتنقلت وبقالها IDs (`[A1]`...`[A7]`) جوه **القسم 14 — Decisions & Assumptions Registry**، عشان تفضل مصنّفة بوضوح جنب الـConfirmed/Proposed/Open Questions بدل ما تكون في قسم منفصل.

---

## 13. Open Questions — دُمجت في القسم 14

نفس الشيء: كل الـOpen Questions اتنقلت وبقالها IDs (`[Q1]`...`[Q4]`) جوه **القسم 14**.

---

## 14. Decisions & Assumptions Registry (المرجع الوحيد لحالة أي قرار)

القاعدة: **مفيش أي بند هنا يتكتب "Confirmed" إلا لو وافقتي عليه صراحة بالكلام أو باختيار من أسئلة اتسألتلك مباشرة.** أي حاجة تانية Proposed أو Assumption أو Open Question، حتى لو أنا شايفها الخيار الأصح.

### ✅ Confirmed (وافقتي عليها صراحة)

| ID | القرار | تاريخ الموافقة |
|---|---|---|
| **C1** | Backend: REST مخصص، غير موجود بعد. اتفقنا نرسم الـAPI contract دلوقتي كمقترح (مش نأجل القرار، ومش Firebase) | 24 أغسطس 2026 — سؤال مباشر |
| **C2** | الـFlutter تشتغل ضد mock server محلي بنفس شكل الـProposed Contract لحد ما الـbackend الحقيقي يجهز | 24 أغسطس 2026 — نتيجة مباشرة لـC1 |
| **C3** | شاشات Splash/Login/Register: إحنا اللي هنصممها (مش هننتظر تصميم Figma رسمي) | 24 أغسطس 2026 — سؤال مباشر |
| **C4** | مكتبة الخريطة: `flutter_map` (مش `google_maps_flutter`) | 24 أغسطس 2026 — سؤال مباشر |
| **C5** | بنية ثنائية اللغة (AR/EN) من اليوم الأول، حتى لو الواجهة عربي بالكامل الآن | 24 أغسطس 2026 — سؤال مباشر |
| **C6** | الـarchitecture العامة (Clean Architecture + layering)، تقسيم الـfeatures، استراتيجية الـbranching (10 branches)، طريقة الـtesting، وتغطية الـedge cases في هذا المستند | 24 أغسطس 2026 — موافقة نصية صريحة في مراجعتك |

### 💡 Proposed (اقتراحي، مستني موافقتك)

| ID | الاقتراح | مرتبط بـ |
|---|---|---|
| **P1** | Search UX كـbottom-sheet فوق شاشة الشكوي، مش شاشة نتائج مستقلة | القسم 3.4 |
| **P2** | شكل الـProposed API Contract التفصيلي (تسمية الحقول، pagination style) — القسم 16 كامل مقترح، مش نهائي | القسم 16 |
| **P3** | تصميم شاشة الخريطة نفسها (مش المكتبة اللي هي C4) إحنا اللي نعمله | القسم 3.7 |
| **P4** | لو ولما [Q1] اتقررت إن الـpush مطلوب، نستخدم FCM كقناة توصيل فوق REST (مش بديل للـbackend) | القسم 3.9، 17 |
| **P5** | محتوى الـSettings Menu: تعديل الملف الشخصي / شكاواي / تفضيلات الإشعارات / عن التطبيق-اللغة / تسجيل الخروج | القسم 3.10 |
| **P6** | معنى تابات فلترة الإشعارات: الكل/غير مقروء/شكاوى/تفاعلات | القسم 3.9 |
| **P7** | الترتيب الافتراضي لقائمة الشكاوى: الأحدث أولًا + خيار "الأكثر تفاعلاً" | القسم 3.5 |
| **P8** | Pagination بنمط infinite scroll | القسم 3.5 |
| **P9** | حذف الحساب (Account deletion) خارج نطاق الـMVP | القسم 3.10، 17 |
| **P10** | الإعجاب على مستوى الشكوى ومستوى التعليق كـentities منفصلة منطقيًا | القسم 3.8 |
| **P11** | تغيير حالة الشكوى read-only من جهة المواطن في الـMVP لحد ما [Q2] تتحل | القسم 3.8 |

### 🔸 Assumption (افتراض مؤقت، مش قرار product)

| ID | الافتراض |
|---|---|
| **A1** | "الإضافة" هو التاب الأوسط المرتفع في الـBottomNavBar (نمط FAB)، بناءً على الـstyling المتكرر |
| **A2** | أول نسخة من الـBottomNavBar في كل frame هي الكانونية؛ النسخة المكررة تُعتبر artifact ونتجاهلها |
| **A3** | عنوان بطاقة الشكوى مشتق من الوصف — لا يوجد حقل عنوان منفصل في التصميم |
| **A4** | التصنيفات الأربعة المؤكدة قابلة للتوسع (enum قابل للتوسع أو driven-by-backend) |
| **A5** | Create Complaint wizard من 3 خطوات (استنتاج من مؤشر "1/3") |
| **A6** | إحصائيات Profile الثلاثة: شكاوى مقدمة / محلولة / نقاط |
| **A7** | Views counter يتزود مرة واحدة لكل مستخدم (dedup منطقي، مش موثق في الـFigma) |

### ❓ Open Question (محتاجة قرارك)

| ID | السؤال |
|---|---|
| **Q1** | استراتيجية الـpush notifications: نعملها أصلًا؟ وإمتى (من أنهي branch)؟ |
| **Q2** | نطاق الدور الإداري: تغيير حالة الشكوى backend-only بالكامل، ولا فيه دور داخل نفس الـapp يقدر يغيّرها؟ |
| **Q3** | زرار "عرض الكل" في Notifications: صفحة كاملة، ولا "تحديد الكل كمقروء"؟ |
| **Q4** | التفاصيل الدقيقة لسيمانتيك الإعجاب/التفاعل عند وجود backend حقيقي (P10 اقتراحنا المبدئي، لسه محتاج تأكيد منتج) |

---

## 15. خطة مراجعة الـFigma وربط كل Screen بالـFeature (تم تنفيذها بالفعل — نتائج، مش قرارات)

تمت المراجعة الكاملة برمجيًا عبر Figma MCP (metadata + نصوص كل الشاشات)، وهذه خلاصتها كمرجع دائم:

| Figma node | اسم الـFrame | Feature المقابلة | الحالة |
|---|---|---|---|
| `33:2` | ترحيب | `splash` + `auth` | ❌ فارغ — يحتاج تصميم |
| `33:21` | لوحة المعلومات الرئيسية | `home` | ✅ مكتمل |
| `33:210` | نموذج تقديم شكوى جديدة | `create_complaint` | ✅ مكتمل |
| `33:351` | الحريطة | `map` | ❌ فارغ — يحتاج تصميم |
| `33:518` | تفاصيل الشكوى المحددة | `complaint_details` | ✅ مكتمل (يشمل تعليق نموذجي واحد) |
| `33:663` | الشكوي | `complaints` | ✅ مكتمل |
| `33:794` | الملف الشخصي | `profile` | ⚠️ هيكل فقط، نصوص placeholder |
| `33:936` | الاشعارات | `notifications` | ⚠️ هيكل فقط، نصوص placeholder |
| `26:5` (Frame 41) | غلاف/عرض تجميعي لكل الشاشات | — | مرجعي فقط، ليس شاشة تنفيذية مستقلة |

لا توجد أي variables/design tokens معرّفة في ملف الـFigma (`get_variable_defs` رجّع فارغ) — الألوان والخطوط والمسافات هتتحدد من فحص كل عنصر مباشرة أثناء بناء `core/theme/` في branch #1.

---

## 16. Proposed API Contract (مقترح — مش Final، لأنه مفيش backend حقيقي لسه)

> ⚠️ هذا العقد **Proposed**، مش Confirmed. غرضه إعطاء أي فريق backend نقطة بداية دقيقة مبنية على محتوى الـFigma الفعلي، وإعطاء الـFlutter mock server محلي تشتغل ضده من branch #1. **مفيش افتراض إن التكامل مع الـbackend الحقيقي هيكون مجرد تغيير `baseUrl`** — ده هيبقى صحيح بس لو الـfinal backend contract طابق هذا المقترح فعليًا. لو الـfinal contract اختلف (تسمية حقول، شكل الـpagination، إلخ)، التعديل المطلوب هيكون محصور في طبقة الـData (Models/Mappers/DataSource) بفضل الـRepository interface الثابت في الـDomain — لكنه تعديل حقيقي، مش صفر تعديل.

عقد أولي مبني على الـentities المستخرجة من مراجعة الـFigma الفعلية (القسم 3). كل الـendpoints تحت `/api/v1`، كل الردود `application/json`، الـauth عبر `Authorization: Bearer <accessToken>` ما عدا `/auth/*`.

**Auth**
- `POST /auth/register` — `{username, email, password, avatarId?}` → `{user, accessToken, refreshToken}`
- `POST /auth/login` — `{email, password}` → `{user, accessToken, refreshToken}`
- `POST /auth/refresh` — `{refreshToken}` → `{accessToken}`
- `POST /auth/logout`
- `GET /auth/me` → `UserProfile`

**Home**
- `GET /categories` → `[{id, name, iconKey}]`
- `GET /complaints/trending?limit=` → `[ComplaintSummary]`
- `GET /users/me/recent-activity?limit=` → `[ActivityItem]`

**Complaints**
- `GET /complaints?status=&mine=&categoryId=&sort=&page=&pageSize=` → `{items: [ComplaintSummary], page, totalPages}`
- `GET /complaints/{id}` → `ComplaintDetail`
- `POST /complaints` — `{categoryId, description, severity, lat, lng, mediaIds[]}` → `ComplaintDetail`
- `POST /media` (multipart) → `{mediaId, url}`
- `PATCH /complaints/{id}/status` — `{status}` (نطاقها معلّق على [Q2])

**Comments & Reactions**
- `GET /complaints/{id}/comments?page=` → `{items: [Comment], page, totalPages}`
- `POST /complaints/{id}/comments` — `{text}` → `Comment`
- `DELETE /comments/{commentId}`
- `POST /complaints/{id}/reactions` — `{type: "like"}` / `DELETE /complaints/{id}/reactions`

**Map**
- `GET /complaints/map?swLat=&swLng=&neLat=&neLng=` → `[{id, lat, lng, categoryId, status}]`

**Notifications**
- `GET /notifications?filter=&page=` → `{items: [Notification], page, totalPages}`
- `POST /notifications/{id}/read`
- `POST /notifications/read-all`
- `POST /devices` — `{fcmToken}` (مطلوب فقط لو [Q1] اتقررت بنعم)

**Profile**
- `GET /users/me/stats` → `{submittedCount, resolvedCount, points}`
- `PATCH /users/me` — `{displayName?, avatarId?, bio?}`
- `DELETE /users/me` — **P9، خارج نطاق الـMVP**

---

## 17. MVP vs Future-Ready Scope (نطاق التنفيذ الحالي مقابل المؤجَّل)

القاعدة: **أي package أو abstraction أو service مش مذكور تحت "MVP" هنا محتاج نقاش وموافقة صريحة قبل ما يتضاف لأي branch.** مفيش إضافة استباقية "علشان هتلزم بعدين".

### ✅ MVP — مطلوب في التنفيذ الحالي
- Clean Architecture skeleton كامل (core + 9 features) — القسم 1-2.
- `get_it`+`injectable`, `go_router`, `flutter_bloc` (Cubit-first), `dio`, `freezed`+`json_serializable`, `fpdart`/Either.
- `flutter_secure_storage`, `shared_preferences`, `hive` (كاش بسيط + drafts — بدون `isar`).
- `flutter_map` [C4]، `geolocator`+`permission_handler`.
- `image_picker`+`flutter_image_compress`+`cached_network_image`.
- `connectivity_plus`.
- `flutter_localizations`+`intl` (بنية ARB ثنائية اللغة [C5]، واجهة عربي فقط حاليًا).
- `bloc_test`+`mocktail`+`flutter_test`+`integration_test`.
- كل الشاشات الـ8 (المصممة + placeholder + المصممة بمعرفتنا Auth/Splash/Map [C3][P3]).
- Comments + reactions على Complaint Details.
- Notifications **in-app فقط** (بدون push).
- Profile + Settings + logout.
- Draft-saving لـCreate Complaint (مطلوبة فعليًا بسبب مخاطر media+location على شبكة ضعيفة — موثقة في القسم 11).

### 🔜 Future-Ready / Optional / مش مطلوب دلوقتي
- **FCM push notifications** — معلّق بالكامل على [Q1]. لحد الحل، الإشعارات in-app بس.
- **`isar`** أو أي بديل لـ`hive` أعقد — مش هيتضاف إلا لو احتياجات الـquery الفعلية أثناء التنفيذ تخطت إمكانيات `hive`.
- **`golden_toolkit` / Golden Tests** — مش جزء من أي branch's Definition of Done إلا لو طلبتي صراحة لاحقًا.
- **Offline architecture متقدمة** (background sync queues, conflict resolution, offline complaint creation قابلة للمزامنة تلقائيًا) — الـMVP بيوقف عند: كاش آخر تحميل ناجح مع إشارة "بيانات مش محدّثة"، ودرافت محلي لشكوى لسه ما اتبعتتش. أي حاجة أبعد من كده مؤجّلة.
- **أي واجهة أو صلاحية إدارية (admin) داخل نفس الـapp** — خارج النطاق بالكامل لحد ما [Q2] تتحل.
- **Account deletion** [P9] — مؤجّل.
- **`google_maps_flutter`** — مش هيتضاف إلا لو [C4] اتراجعت بميزانية Maps مؤكدة.
- **Firebase (أي حاجة غير FCM كقناة push)** — مرفوض ضمنيًا بموجب [C1]، مش جزء من هذا الـplan أصلًا.

---

## 18. حدود المسؤولية: `Complaints` مقابل `Complaint Details`

نقطة كانت مبعثرة في النسخة الأولى ومحتاجة توضيح صريح:

- **`complaints` feature (branch #5 — mrkrabs):** يملك شاشة القائمة فقط (تابات، فلترة، ترتيب، `ComplaintCard` widget). مسؤوليته تنتهي عند استدعاء navigation لـ `/complaints/:id` — **مفيش أي منطق أو state خاص بشكوى واحدة جوه هذه الـfeature.**
- **`complaint_details` feature (branch #7 — gary):** المالك الوحيد لكل حاجة بتحصل بعد فتح شكوى معينة — status tracker، الوصف الكامل، التعليقات، التفاعلات، عداد المشاهدات، وكل الـCubit/UseCases/Repository الخاصة بيها.

**آلية تجنب التكرار أو الانسداد بين الـbranchين:** بما إن ترتيب التنفيذ هو #5 قبل #7 (وبينهم #6)، وعشان branch #5 يفضل قابل للدمج بدون ما يكسر الـnavigation ولا يسبق مسؤولية #7:
- branch #5 بينشئ فقط **stub page فاضي** جوه `complaint_details/presentation/pages/` (Scaffold + AppBar + نص placeholder زي "لسه بنجهز التفاصيل 🐠") ويسجله في الـrouter — **بدون أي Cubit أو data fetching أو state**، بالظبط عشان ميبقاش فيه تكرار مع #7.
- branch #7 بيستبدل هذا الـstub بالتنفيذ الكامل (كل الـlayers الثلاثة). هو المسؤول الوحيد عن أي كود منطقي في هذه الـfeature.
- لو حصل أي تعارض ملكية أثناء التنفيذ الفعلي، القاعدة: أي كود فيه Cubit/UseCase/Repository لشكوى واحدة بالتحديد بيتوقع يكون جوه `complaint_details`، مش `complaints`، مهما كان الـbranch اللي بيشتغل فيه.

---

## 19. Product / Creative Definition of Done (بالإضافة للـTechnical DoD في القسم التالي)

قبل ما أي branch — وخصوصًا `spongebob-polish` النهائي — يتاعتبر مكتمل، لازم يتأكد إن:

- هوية Qaa El Hamour محافظ عليها في كل شاشة، مش بس في الشاشات اللي فيها نص جاهز من الـFigma.
- العالم الخيالي (الشخصيات، الأماكن، أسلوب الكوميديا) ظاهر في **كل** أجزاء التطبيق باستمرارية: الـcopy، الشخصيات، الأماكن، الشكاوى، الإشعارات، التعليقات، empty states، رسائل الأخطاء — مش بس الشاشات الأساسية.
- أي نص محتاج نكتبه إحنا (شاشات مفقودة زي Splash/Auth/Map، أو نصوص placeholder زي Profile/Notifications) اتكتب بنفس الروح الساخرة والهوية المصرية، مش نص عام تقني.
- المستخدم بيحس إنه بيستخدم منصة شكاوى رسمية حقيقية جوه Qaa El Hamour — مش تطبيق شكاوى عادي حطينا عليه ثيم SpongeBob.
- النبرة والفكاهة محافظ عليهم من غير ما يأثروا على وضوح الاستخدام (usability) — رسالة الخطأ الكوميدية لازم تفضل مفهومة وواضحة الحل، مش مجرد جملة مضحكة.

هذا الـcheck منفصل تمامًا عن الـTechnical DoD تحت — الاتنين لازم يتحققوا، مش بديل عن بعض.

---

## Technical Definition of Done (مرجع لكل الـbranches — كما في تعليمات المشروع، بند 7)

كل branch لا يُعتبر مكتمل إلا بعد: مطابقة الـFigma (أو التصميم المعتمد للشاشات الناقصة)، user flow كامل يعمل، كل الـstates (Loading/Empty/Error/Success) موجودة، validation كاملة، edge cases الأساسية معالجة، state management نظيف بدون تناقضات، فصل واضح بين الطبقات، بدون hardcoded data غير مبرر، بدون تكرار منطق، معالجة أخطاء كاملة، أذونات معالجة عند الحاجة، فشل الشبكة معالج، اختبارات مناسبة، `dart format .` و`flutter analyze` نظيفين بدون تحذيرات، بدون debug code أو secrets، RTL وresponsive مُختبَرين، ومراجعة الـbranch تمت قبل الدمج.

---

## 20. Branch Completion Report Protocol

بعد كل branch، وقبل الانتقال للتالية، هبعتلك تقرير يغطي:

1. **إيه اللي اتعمل** — ملخص واضح لما تحقق في هذه الـbranch تحديدًا.
2. **الـfiles والـmodules اللي اتغيرت** — قائمة مسارات، مش diff كامل غير لو طلبتي.
3. **الـarchitectural decisions اللي اتاخدت أثناء التنفيذ** — أي قرار تفصيلي ظهر أثناء الكود ومكانش موثق في الـplan.
4. **الـtests اللي اتضافت ونتايجها** — عدد، نوع، وهل عدّت ولا لأ.
5. **الـedge cases اللي اتعاملت معاها فعليًا** (مش بس اللي كانت متوقعة في الـplan).
6. **أي assumptions استخدمتها أثناء التنفيذ** — بنفس تصنيف القسم 14 (تتضاف كـIDs جديدة لو محتاجة).
7. **أي remaining issues** — حاجة ناقصة، مؤجّلة، أو محتاجة قرارك.
8. **Screenshots أو تسجيل** لما يكون مناسبًا (خصوصًا الشاشات اللي إحنا صممناها بأنفسنا زي Auth/Splash/Map).

**قاعدة صارمة:** مفيش انتقال لـbranch تانية إلا بعد ما توافقي صراحة على الـbranch الحالية. لو ظهر أي قرار أو افتراض جديد أثناء التنفيذ مش موجود في القسم 14، هيتضاف كـID جديد بنفس التصنيف (Confirmed/Proposed/Assumption/Open Question) في التقرير، مش هيتفترض إنه "متفق عليه" بالسكوت.

---

## الخطوة التالية

هذا الـplan (Rev 2) **لسه ما بدأش تنفيذه**. القرارات الستة المعتمدة فعليًا موثقة بوضوح في القسم 14 تحت "Confirmed" — ده كل حاجة أنا واثقة إنها اتفق عليها صراحة. كل حاجة تانية (11 Proposed، 7 Assumptions، 4 Open Questions) مبينة بنفس الوضوح ومستنية رأيك.

**ما إن توافقي على هذه النسخة (أو تعدّلي أي بند فيها)، هبدأ فعليًا في `feature/spongebob-foundation`، وبعد ما تخلص هبعتلك التقرير الكامل حسب بروتوكول القسم 20 وأستنى موافقتك قبل أي branch تانية.**
