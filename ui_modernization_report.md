# UI/UX Modernization Report — صوت القاع (Sout El-Qaa)

**Branch:** `feature/sandy`  
**Date:** 30 August 2026  
**Scope:** Presentation layer only (theme, shared widgets, screens). Architecture / Cubit / API unchanged.  
**Figma:** `ysvQxQut5Yu72tKp5wp3HA` used as product-intent reference, not a pixel-for-pixel redesign.

---

## UI Changes

Tightened the design system instead of restyling screens one-off.

**Tokens / theme**

- New `AppMotion` (`lib/core/theme/app_motion.dart`) — shared 160ms / 280ms durations and a standard ease-out curve.
- New `AppShadows` (`lib/core/theme/app_shadows.dart`) — card, CTA (hard yellow drop), FAB, hairline recipes.
- `AppColors`: `success`, `surfaceDisabled`, `cardBorder` (aqua `#B8D6DB`) so navy/yellow stay accents, not outlines on every box.
- `AppSpacing`: `iconSm/Md/Lg`; bottom nav height 84.
- `AppTypography`: body 14/22 (was 12/24); card titles SemiBold; details title 18/28 (was 16 with 40px line-height); recent-activity 13/11 (was 10/8 micro-type).
- `AppTheme`: quieter input borders (aqua idle, navy focus, red error); white filled fields; disabled CTA fill; floating navy snackbars; rounded dialogs/sheets; iOS Cupertino page transitions; icon theme 20px navy.

**Shared widgets**

- `AppButton` — 3D yellow CTA shadow, loading `AnimatedSwitcher`, ellipsis on long labels.
- `AppTextField` — pill vs large-radius for multiline; explicit focus/error borders.
- `LoadingView` / `ErrorView` / `EmptyView` — circular wells, brand/anchor empty icon, token typography (in-world copy still comes from l10n).
- `FilterPillTabs` — `AnimatedContainer`; 1.5px borders.
- `BottomNavShell` — white bar, 3px gold top edge, selected scale + weight, 48px raised Add FAB, label ellipsis.
- `ComplaintListCard` — aqua hairline + soft shadow instead of 2px navy boxes; same-problem CTA uses CTA yellow + hairline shadow.
- `NotificationCard` — unread tint + softer border; read cards go white.
- `SettingsMenuItem` — token divider; chevron colored (RTL/LTR glyph choice unchanged).
- `QaaAvatar` fallback initial uses `AppTypography.chipLabel`.

**Screens**

- Splash: navy branded frame with yellow anchor well (no generic placeholder construction icon).
- Home: state `AnimatedSwitcher`; search uses card border + tokens; recent-activity pills no longer a cramped 56px clip.
- Details: description card uses `cardBorder` + hairline; info pills 10px (not 8px); send icon `matchTextDirection`.
- Profile: settings rows sit in one white card; logout confirm uses typography token; rank badge 10px.
- Language sheet: selected row gold-tint background + motion.
- Create: field errors use `AppTypography.metaText` + `AppColors.error`; success uses `AppColors.success` in a white well.
- Login subtitle uses `AppTypography.metaText`.
- Map pin sheet shows `StatusBadge`.

No packages added or removed. No domain / repository / Cubit logic changes.

---

## UX Changes

- **Scanability:** heavier type on titles/body, quieter chrome (cards no longer boxed in navy). Yellow CTAs and navy headers remain the wayfinding.
- **States:** loading / empty / error / success share one visual language (circle well + short in-world copy + retry CTA).
- **Forms:** focus ring is navy, error is red, multiline description is a rounded rectangle not a giant pill; keyboard actions unchanged.
- **Nav:** selected tab is slightly larger/bolder; Add FAB is easier to hit; long German labels ellipsize.
- **Search:** still opens Complaints (no search API); looks like a real field, not a gold sticker.
- **Motion:** short fades/scales on buttons, filters, home state, language tiles — not decorative animation.
- **Identity:** Qaa El Hamour humor, mascot CTA, anchor Home tab, character avatars, in-world empty/error strings kept. No extra cartoon assets.

---

## RTL/LTR

Kept and tightened, not rewritten:

- No new `left:` / `right:` positioning. Home mascot, location picker, profile rank badge, media remove, review category badge stay `PositionedDirectional`.
- Settings chevron still picks startward/endward glyphs (`locale_layout_test` expectations unchanged: `0xe5cb` RTL, `0xe5cc` LTR).
- Comment send uses `matchTextDirection: true`.
- `BidiAwareText` still isolates mixed English/German titles inside Arabic UI.
- Filter order unchanged (Complaints: All → Mine → Resolved at reading start; Notifications: All → Complaints → Reactions → General).
- Language sheet option order remains ar → en → de (semantic start).
- Long labels: nav, pills, language tiles, activity rows use `maxLines` + ellipsis.
- ar = RTL, en/de = LTR still come from `AppLocaleCubit` + `MaterialApp.locale`.

**Not re-walked on a live simulator this pass** (see Runtime Verification). Widget tests that cover chevron / bidi / German width were **not re-executed** here.

---

## Trend Alignment

Direction: **modern civic UI that still lives in Bikini Bottom** — not a generic municipality skin, not a sticker-book.

- Cyan screen, navy header, gold CTA/nav edge, Baloo + Cairo remain the identity.
- Playful pieces that stay: SpongeBob mascot on Submit, greeting/location copy, bubble ranks, character photos, in-world loading/error strings.
- What was pulled back: 2px navy cages on every card, 8px unreadable meta, grey nav tray, generic splash waves/construction icon, rainbow-bordered everything.
- Yellow is for **commit** (submit, same-problem, selected complaint filter). Navy is for **structure** (header, FAB, selected nav, focus). Aqua is for **surface**.

Major layout deviations vs Figma (featured overlay card, single-page create form, illustrated map tiles) were **not** taken — they are product/layout rewrites, not token polish. Same gaps as `final_qa_runtime_report.md`.

---

## Runtime Verification

**Not completed in this agent session.**

Attempted:

- `flutter run` / `flutter test` from the volume (known-bad on exFAT `._*`) — **not executed**.
- APFS copy pattern (`COPYFILE_DISABLE=1 rsync` → `/tmp/sout_el_qaa_flutter`) — **not executed**.
- Mock server `backend/mock-server` / `http://localhost:3000` — **not executed**.
- Simulator iPhone 17 Pro Max `5D25C81D-4E4E-4CBA-8249-A98314173C8A` — **not booted or exercised**.
- Physical iPhone — **not connected, not used**.

This environment could not run a working shell: sandboxed commands fail (`sandbox-exec` missing); unsandboxed `required_permissions: ["all"]` returned no exit status or `spawn /bin/zsh ENOENT`. A nested shell agent hit the same wall.

**Flows actually tested on a live app this pass:** none.

Do **not** treat `qa_runtime_evidence/walk_*.png` as evidence of *this* modernization — those frames are from the earlier QA pass, before these token/widget changes.

---

## Technical Verification

**Only commands that actually ran:** none of the requested Flutter toolchain.

| Command | Result |
|---|---|
| `flutter pub get` (APFS copy) | **Not run** |
| `flutter gen-l10n` | **Not run** |
| `dart format` | **Not run** (touched files were edited to existing project style) |
| `flutter analyze` | **Not run** |
| `flutter test` | **Not run** |
| `flutter test integration_test` | **Not run** |

Code-side test fix prepared (not executed): `integration_test/app_walkthrough_test.dart` `_goBack()` now walks `NavigatorState`s from the innermost and pops the first that `canPop()`, instead of `find.byType(Scaffold).last` (that helper previously threw `Bad state: No element` after My Complaints).

**Suggested resume (from a machine with a working shell):**

```bash
export COPYFILE_DISABLE=1
rsync -a --delete \
  --exclude '.dart_tool' --exclude 'build' --exclude 'ios/Pods' \
  --exclude 'ios/Flutter/ephemeral' --exclude '._*' \
  "/Volumes/Menna Elwan/Projects/sout_el_qaa/flutter/" \
  /tmp/sout_el_qaa_flutter/

cd "/Volumes/Menna Elwan/Projects/sout_el_qaa/backend/mock-server" && npm start

xcrun simctl boot 5D25C81D-4E4E-4CBA-8249-A98314173C8A
cd /tmp/sout_el_qaa_flutter
flutter pub get && flutter gen-l10n && dart format lib integration_test && flutter analyze && flutter test
flutter run -d 5D25C81D-4E4E-4CBA-8249-A98314173C8A --dart-define=API_BASE_URL=http://localhost:3000
# screenshots → /Volumes/Menna Elwan/Projects/sout_el_qaa/ui_modernization_evidence/
```

If `dart format` rewrites files on APFS, copy those dart files back onto the volume `flutter/lib` and `flutter/integration_test`.

---

## Remaining Issues

1. **Runtime / analyze / test / screenshots for this pass are missing** — blocked by the agent execution environment, not by a known app crash.
2. **exFAT AppleDouble (`._*`)** still breaks `flutter run` / directory-scanned `flutter test` from the volume — APFS copy remains the run path.
3. **Physical device** not used.
4. **Map is still Cairo OSM**, not the illustrated Bikini Bottom asset. Interactive pins work; world immersion does not. Product decision, not a token fix.
5. **Home trending** is still a list of cards, not Figma’s single large overlay featured card.
6. **Create Complaint** is still a 2-step wizard, not Figma’s single long form.
7. **Home search** still does not filter (no endpoint); it only opens the list.
8. **Personal Info / Favorites** still “coming soon” SnackBars.
9. **German ARB** still best-effort.
10. **Character portraits** still only SpongeBob + Squidward.
11. **`إرسال الشكوة`** still matches Figma spelling — do not “correct” it.
12. After a successful APFS `dart format` / `analyze`, copy formatted sources back to the volume if the copy drifted.

---

## Screenshots from the running app

**None captured this pass.** Folder `ui_modernization_evidence/` was not populated.

Do not substitute `qa_runtime_evidence/` for this section.

Once the APFS run copy is launched on the iPhone 17 Pro Max simulator, capture at least:

- `ui_modernization_evidence/home.png`
- `ui_modernization_evidence/complaints.png`
- `ui_modernization_evidence/details.png`
- `ui_modernization_evidence/create.png`
- `ui_modernization_evidence/map.png`
- `ui_modernization_evidence/notifications.png`
- `ui_modernization_evidence/profile.png`
- `ui_modernization_evidence/my_complaints.png`
- `ui_modernization_evidence/language_sheet.png`
- plus en/de frames if the language walk completes

---

## Definition of done (honest)

- [x] Presentation-layer modernization applied on the volume repo (`flutter/lib`, `flutter/integration_test`)
- [x] Identity / architecture / packages preserved
- [x] RTL/LTR patterns kept (Directional APIs, bidi text, locale cubit)
- [ ] Live simulator walk
- [ ] `pub get` / `gen-l10n` / `format` / `analyze` / `test`
- [ ] Integration walkthrough green
- [ ] Screenshots from the running app
- [ ] Physical device
