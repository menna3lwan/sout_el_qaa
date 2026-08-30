# تقرير مراجعة RTL/LTR والدعم ثلاثي اللغة — صوت القاع
**RTL / LTR & Multilingual Audit**
**الفرع:** `feature/sandy` — 30 أغسطس 2026

---

## 0) ملخص تنفيذي

التطبيق بقى ثلاثي اللغة فعليًا: **العربية (RTL)** و**الإنجليزية (LTR)** و**الألمانية (LTR)**، مع اختيار لغة يُحفظ بين التشغيلات، وتخطيط بيتقلب مع اتجاه اللغة بدل `Locale('ar')` الثابت.

الترجمة الألمانية **best-effort** ومحتاجة مراجعة ناطق أصلي قبل الشحن — معلّمة في رأس `app_de.arb`.

---

## 1) البنية ثلاثية اللغة اللي اتضافت

| العنصر | أين | السلوك |
|---|---|---|
| `app_de.arb` | `flutter/lib/l10n/` | كل مفاتيح ar/en + مفاتيح الوقت النسبي واختيار اللغة |
| `Locale('de')` | `AppLocalizations.supportedLocales` (بعد `flutter gen-l10n`) | ar / en / de |
| `AppLocaleCubit` + `HiveLocaleSettingsStore` | `core/locale/` | الافتراضي عربي؛ القيمة تتخزن في Hive box `app_settings` |
| `MaterialApp.router.locale` | `main.dart` | بيتقرأ من الـ Cubit مش `const Locale('ar')` |
| اختيار اللغة | Profile → الإعدادات → bottom sheet | العربية / English / Deutsch |
| iOS | `Info.plist` `CFBundleLocalizations` | ar, en, de |

---

## 2) الأعطال الاتجاهية والـ bidi اللي اتصلحت

| قبل | بعد | ليه |
|---|---|---|
| `Icons.chevron_left` ثابت في `SettingsMenuItem` | glyph اتجاهي بدون `matchTextDirection` تلقائي | السهم كان بيفشل في LTR |
| `Icons.arrow_back` في مراجعة الشكوى | `BackButtonIcon()` | بيتقلب مع RTL/LTR |
| `DateFormatter` عربي ثابت في Dart | ICU plurals عبر `AppLocalizations` | الوقت النسبي كان بيكسر الإنجليزية/الألمانية |
| `resolveMessageKey` بيرجّع نص السيرفر العربي زي ما هو | في en/de يرجع `genericErrorMessage` | تسريب عربي في UI غير عربي |
| `Positioned(left/right)` في اختيار الموقع | `PositionedDirectional(start/end)` | توحيد الاتجاه |
| هيدر الرئيسية وشريط البحث وصف النشاط: `TextAlign.end` / ترتيب "عرض الكل" أولاً | ترتيب دلالي: العنوان في الـ start، الإجراء في الـ end | كان متثبت على سكرينشوت RTL |
| فلاتر الإشعارات: labels عكس `_filters` | All / Complaints / Reactions / General بنفس ترتيب الـ enum المعروض | التاب المختار كان بيتعلّم على ليبل غلط |
| عناوين/أوصاف/تعليقات المستخدم | `BidiAwareText` بعزل اتجاه النص | عناوين إنجليزي/ألماني جوه RTL ما تتعكسش |
| كلمات ألمانية طويلة في الفلاتر والكابشن | `maxLines` + `ellipsis` | منع overflow |

**كان سليم واتساب:**
- مفيش `textDirection:` يدوي على الشاشات
- صفوف التفاعل في التفاصيل (like → dislike → report) وشبكة الإحصائيات وفلاتر الشكاوى مترتبة قراءةً (أول عنصر = start في الاتجاهين)
- `AppTextField` و`EdgeInsetsDirectional` في السيرش بار
- الـ AppBar القياسي (تفاصيل/إشعارات) بيستخدم leading اتجاهي من Material

---

## 3) مراجعة الشاشات (Phase 3–5)

اتراجعت: Splash، Login/Register، Home، Map، Create Complaint + Location Picker، Complaints، Details، Notifications، Profile، My Complaints، Bottom nav، shared widgets، فورم/حوارات/empty-error-loading.

اختبار الطول: `locale_layout_test` بيضخ نصوص ألمانية طويلة في عمود 180px ونصوص عربية قصيرة — بدون overflow.

---

## 4) التحقق

```
dart format .     # نظيف
dart analyze      # No issues found!
flutter test      # 72/72 على ملفات الاختبار الصريحة (بعد مسح sidecars)
```

اختبارات جديدة:
- `date_formatter_test` — ar/en/de
- `message_key_resolver_test` — تسريب السيرفر
- `app_locale_cubit_test` — hydrate / persist / رفض locale غير مدعوم
- `locale_layout_test` — شيفرون RTL/LTR، BidiAwareText، طول ألماني

`flutter analyze` / `flutter test` من غير قائمة ملفات، و`flutter run` على iOS، ممكن يفشلوا على هذا الـ volume لأن المشروع على **exFAT** والماك بيكتب ملفات `._*`؛ Flutter بيحاول يقرأها كـ UTF-8 أو يمسح `ios/.../Packages/.packages` ويفشل. ده قيد filesystem مش انحدار في كود الـ l10n.

`flutter test integration_test` اتحدّث عشان يعمل `hydrate()` على `AppLocaleCubit`؛ التشغيل الكامل يحتاج نفس التنظيف أو مسار APFS.

---

## 5) قيود معروفة

1. **الألمانية best-effort** — مراجعة ناطق أصلي قبل الشحن.
2. **رسائل السيرفر** — الـ mock لسه عربي؛ في en/de بنعرض خطأ عام بدل النص الخام (توطين الـ API برا النطاق).
3. **exFAT** — `._*` ممكن ترجع بعد `pub get`/`gen-l10n` وتكسر أدوات Flutter. الحل الثابت: شغل المشروع من APFS.
4. **لقطات السييميوليتر** — Run على iOS من المسار الحالي غير موثوق لنفس سبب الـ ephemeral. التحقق الاتجاهي اتعمل عبر widget tests للـ 3 locales.

---

## 6) ملفات أساسية اتغيرت

- `flutter/lib/l10n/app_de.arb` (جديد) + مفاتيح في `app_ar.arb` / `app_en.arb` + generated `app_localizations*.dart`
- `flutter/lib/core/locale/*` (جديد)
- `flutter/lib/main.dart`, `bootstrap.dart`, `core/di/injection.dart`
- `date_formatter.dart`, `message_key_resolver.dart`
- `settings_menu_item.dart`, `bidi_aware_text.dart` (جديد), `filter_pill_tabs.dart`
- `language_picker_sheet.dart` (جديد) + `profile_page.dart`
- `home_page.dart`, `complaint_details_page.dart`, `complaint_list_card.dart`, `notification_card.dart`, `notifications_page.dart`, `rank_progress_card.dart`
- `create_complaint_page.dart`, `location_picker_page.dart`
- `flutter/ios/Runner/Info.plist`
- اختبارات تحت `flutter/test/core/`
- `flutter/integration_test/app_walkthrough_test.dart`
