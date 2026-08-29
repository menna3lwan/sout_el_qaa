# Backend

هذا هو الـboundary بتاع الـBackend application جوه الـMonorepo — مستقل تمامًا
عن `flutter/` (مفيش Flutter dependency جواه، ومفيش الـFlutter بيعتمد على
كوده مباشرة؛ التواصل بينهم عن طريق API contract فقط — راجعي `PLAN.md` القسم 16).

## الوضع الحالي

**لسه معندناش backend حقيقي.** الـREST backend المخصص **[C1]** في `PLAN.md`
لسه مبنيش. اللي موجود هنا دلوقتي هو `mock-server/` بس — سيرفر محلي مؤقت
(json-server) بيحاكي الـ[Proposed API Contract](../PLAN.md) (القسم 16، مقترح
مش نهائي) عشان الـFlutter يقدر يتطور ضده لحد ما الـbackend الحقيقي يتبنى.

```
backend/
└── mock-server/     # dev-only mock — مش الـbackend الحقيقي، انظر mock-server/README.md
```

لما الـbackend الحقيقي يتبنى، الكود بتاعه هيتحط مباشرة جوه `backend/`
(مثلًا `backend/src/`, `backend/tests/`, `backend/package.json` — أو أي
structure يناسب الـstack اللي هيتختار، وده لسه open question).

## تشغيل الـmock server

```bash
cd backend/mock-server
npm install
npm start
```

تفاصيل كاملة (endpoints، بيانات الـseed، القيود المعروفة) في
[`mock-server/README.md`](./mock-server/README.md).
