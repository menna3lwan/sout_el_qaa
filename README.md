# صوت القاع (Sout El-Qaa)

المنصة الرسمية لشكاوى سكان قاع الهامور. راجعي `PLAN.md` (Rev 2) للـTechnical
Implementation Plan الكامل — Architecture، Decisions & Assumptions Registry
(القسم 14)، وترتيب تنفيذ الـbranches.

هذا الـbranch الحالي: `feature/spongebob-foundation`.

## ⚠️ خطوة مطلوبة منك قبل التشغيل: platform folders

المشروع ده اتبنى **بدون** `flutter create` — الـsandbox اللي اتكتب فيه الكود
معندوش وصول شبكة لتحميل Flutter SDK نفسه (تفاصيل كاملة تحت "Remaining
Issues" في تقرير الـbranch). يعني مجلدات `android/` و`ios/` **مش موجودة
لسه**، وده حاجة مقصودة ومش هفبركها يدويًا (ملفات زي `gradle-wrapper.jar`
أو Xcode `project.pbxproj` معقدة وbinary/generated، وتفبيركها يدوي هيديك
مشروع "شكله شغال" بس فعليًا مكسور).

**قبل أول تشغيل، شغّلي من جوه مجلد المشروع (اللي فيه `pubspec.yaml`):**

```bash
flutter create --platforms=android,ios --org com.soutelqaa --project-name sout_el_qaa .
```

الأمر ده آمن يتشغل على مشروع فيه `lib/` وملفات جاهزة بالفعل — بيضيف
`android/`/`ios/` بس، ومبيلمسش `lib/` أو `pubspec.yaml` الموجودين (Flutter
بيسأل confirmation لو حس إنه هيكتب فوق حاجة موجودة). لو عايزة org name
مختلف عن `com.soutelqaa`، غيّريه هنا وخلاص.

## تشغيل المشروع

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # يولّد ملفات الـl10n وأي .g.dart/.freezed.dart لاحقًا
dart format .
flutter analyze
flutter test
```

ثم شغّلي الـmock server المحلي في تيرمنال تاني (تفاصيل في
`dev/mock-server/README.md`):

```bash
cd dev/mock-server && npm install && npm start
```

وشغّلي التطبيق ضده:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

## ⚠️ لسه محتاج يتنفذ عندك (مقدرتش أشغّله في الـsandbox بتاعي)

الـsandbox اللي اشتغلت فيه **معندوش وصول شبكة لـ `pub.dev`/`storage.googleapis.com`**
(اتفحص مباشرة، مش افتراض) — يعني الأوامر التالية **متشغلتش فعليًا** ومحتاجة
تتشغل عندك وتتراجع نتيجتها:

1. `flutter create` لإضافة platform folders (فوق).
2. `flutter pub get` — للتأكد إن كل رقم إصدار في `pubspec.yaml` فعلًا موجود
   ومتوافق (الأرقام مكتوبة يدويًا من معرفتي بآخر إصدارات مستقرة، مش متأكدة
   100%).
3. `dart run build_runner build` — لتوليد ملفات الـl10n (`app_localizations.dart`
   المستخدم فعليًا في `lib/main.dart` و`context_extensions.dart` — الملف ده
   **لسه مش موجود فعليًا في الـrepo**، بيتولد من `l10n.yaml` + ARB files).
4. `dart format .` و `flutter analyze` — عشان نتأكد فعلًا إن الكود نظيف
   بمعايير الـlints المفعّلة في `analysis_options.yaml`، مش بس "شكله صح"
   بمراجعة يدوية مني.
5. `flutter test` — كل الـunit tests في `test/core/` اتكتبت وتتبعت المنطق
   يدويًا بعناية، لكن محتاجة تشغيل فعلي للتأكد.

**لو أي حاجة من دي فشلت عندك، ابعتيلي رسالة/screenshot الخطأ وهصلحها فورًا**
— ده بالظبط النوع من الـfeedback loop اللي القسم 20 في `PLAN.md` مبني عليه.

## هيكل المشروع

راجعي القسم 2 من `PLAN.md` للتفصيل الكامل — ملخص سريع:

```
lib/
├── core/         # كل حاجة feature-agnostic: DI, routing, theme, errors, network...
├── features/     # 9 features، كل واحدة Clean Architecture (data/domain/presentation)
└── l10n/         # ARB files (ar + en) — [C5] بنية bilingual من البداية
```

## الـLocalization

`app_ar.arb` هو الـtemplate الأساسي. عدّلي فيه أول ما تحتاجي نص جديد، وأضيفي
نفس المفتاح في `app_en.arb` (حتى لو الترجمة مؤقتة/حرفية — الأهم إن البنية
تفضل ثنائية اللغة من البداية).
