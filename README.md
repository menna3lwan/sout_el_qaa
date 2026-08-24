# صوت القاع (Sout El-Qaa)

المنصة الرسمية لشكاوى سكان قاع الهامور. راجعي `PLAN.md` (Rev 2) للـTechnical
Implementation Plan الكامل — Architecture، Decisions & Assumptions Registry
(القسم 14)، وترتيب تنفيذ الـbranches.

## هيكل الـRepo

الـrepo ده Monorepo واحد، بـGit repository واحد بس، فيه:

```
sout_el_qaa/
│
├── flutter/      # تطبيق الـFlutter — التفاصيل والتشغيل في flutter/README.md
│
├── backend/          # حدود الـBackend — التفاصيل في backend/README.md
│                      # (لسه فيه بس dev mock server؛ الـbackend الحقيقي [C1] لسه مبنيش)
│
├── .vscode/           # إعدادات VS Code للـmonorepo (مفيش machine-specific settings)
│
├── PLAN.md            # الـTechnical Implementation Plan الكامل
└── README.md          # الملف ده
```

كل تطبيق (`flutter/`, `backend/`) isolated عن التاني — الـFlutter
مبيعتمدش على كود الـbackend مباشرة، والتواصل بينهم عن طريق API contract فقط
(القسم 16 من `PLAN.md`).

هذا الـbranch الحالي: `feature/spongebob-foundation` (+ إعادة هيكلة الـrepo
لـmonorepo).
