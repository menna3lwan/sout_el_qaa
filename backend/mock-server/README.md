# Mock Server — صوت القاع (dev tooling فقط)

سيرفر محلي بيطبّق شكل الـ**Proposed API Contract** (قسم 16 في `PLAN.md`) عشان
الـFlutter تشتغل ضد حاجة حقيقية أثناء التطوير، من غير ما ننتظر الـbackend
الحقيقي (REST مخصص، غير موجود بعد — قرار [C1]).

هذا **مش backend حقيقي ومش production-ready** — مبني على [json-server](https://github.com/typicode/json-server)
لأغراض التطوير المحلي بس.

## التشغيل

```bash
cd backend/mock-server
npm install
npm start
# السيرفر هيشتغل على http://localhost:3000
```

شغّلي التطبيق ضده كده:

```bash
flutter run --dart-define=API_BASE_URL=http://localhost:3000
```

بيانات دخول جاهزة (من `db.json`):

- **Email:** `spongebob@qaa-el-hamour.eg` (also accepts `resident@qaa-el-hamour.eg`)
- **Password:** `qaaHamour1`

## حدود معروفة (documented limitations — مش bugs)

- **التوكنات وهمية بالكامل** (strings شكلية، مفيش JWT حقيقي ولا expiry فعلي)
  — كافية لاختبار تدفق الـauth headers، مش لاختبار أمان حقيقي.
- **`/media` upload وهمي** — بيرجّع URL شكلي (`placehold.co`)، مفيش تخزين
  ملفات فعلي.
- **الفلترة/الترتيب على `/complaints`** بتعتمد على [query params الافتراضية
  لـjson-server](https://github.com/typicode/json-server#filter) (`_sort`,
  `_order`, حقول الفلترة المباشرة زي `?categoryId=roads`) — مش بالضبط نفس
  أسماء الـquery params الموثقة في الـProposed Contract (`sort=`, `mine=`).
  التطابق الكامل هيتحدد لما الـbackend الحقيقي يتبنى فعليًا — انظر [P2] في
  `PLAN.md`.
- **مفيش pagination حقيقي** على أغلب الـendpoints (كل النتائج بترجع مرة
  واحدة) — كافي لحجم بيانات التطوير الحالي.

لو أي endpoint هنا مختلف عن اللي محتاجاه فعليًا لما تيجي تنفذي feature معينة،
عدّليه هنا مباشرة (الملف ده dev-only ومش هيوصل production أبدًا — موجود في
`.gitignore` استثناء واحد بس لـ`node_modules/`، باقي الملفات متتبّعة عادي).
