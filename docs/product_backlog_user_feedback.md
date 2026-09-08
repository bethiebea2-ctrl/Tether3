# Product backlog — user feedback (Sep 2026)

Captured from Beth’s walkthrough notes. Items are grouped by module.  
**Status key:** `bug-fixed` · `partial` (MVP exists) · `planned` · `not-started`

---

## Creative corner / Notes-adjacent

### Book tracker — `partial` (2C)
**Current:** Grouped by status; blurb, star rating, comments, DNF reason (DB v15); edit/delete.

| Request | Status |
|---------|--------|
| Group/sort into sections (want / reading / finished / DNF) for search | **done** |
| Upload or paste blurb/synopsis | **done** (paste in blurb field) |
| Comments + star rating | **done** |
| Prompt when changing status (esp. DNF → reason did not finish) | **done** |
| Parent-set reading goals on child profiles | planned |
| Genre tags + genre goals | planned |

### Dream board — `partial` (2C)
**Current:** Themed category sections; notes + accomplished field; edit/delete.

| Request | Status |
|---------|--------|
| Rich goal editing (body text, accomplished section) for all board types | **done** |
| Themed sections: dreamy dreams, goal + ball, overflowing bucket list, manifestation aesthetic | **partial** — colour themes by category |
| Edit/delete/reorder items | **partial** — edit/delete done; reorder planned |
| Wire Notes “Dream” quick-log → Dream Board (spec in `docs/notes_spec.md`) | planned |

### Celebration log — `partial`
**Current:** Plain list + FAB; no visual celebration.

| Request | Status |
|---------|--------|
| More colour, motion, confetti (tie to sensitivity toggles) | planned |
| Themed cards, milestones | planned |

### Win log — `partial`
Same as celebration — needs personality, colour, and optional dashboard prominence (depression preset spec).

---

## Pets — `not-started` (weight)

| Request | Status |
|---------|--------|
| Weight field on pet profile | planned |
| Weight history table (date, weight, notes) | planned |
| Growth chart optional | planned |

**Note:** `growth_notes` exists for children only (`growth_notes_screen.dart`).

---

## Calendar — `partial`

| Request | Status |
|---------|--------|
| Edit Family Hub events (memorial/birthday) without assertion crash | **bug-fixed** — yearly repeat + Family Hub banner |
| Memorial “N years” off by one vs actual anniversary | **bug-fixed** — count relative to occurrence date |
| Multi-day events (start date + end date) | **done** — start/end date pickers in creation; range in detail/tile |
| Re-sync memorial titles after fix (re-save person in Family Hub once) | workaround |

---

## Meal preference settings — `done` (2B)
**Current:** Household prefs (servings, skill, equipment, notes) + per-person matrix (allergies, intolerances, dislikes, favorites, dietary pattern) in `meals_settings_screen.dart`; banner on meals screen.

| Request | Status |
|---------|--------|
| Allergies + intolerances per person/profile | **done** |
| Personal preferences, favourite foods | **done** (favorites/dislikes) |
| Cooking setup (appliances, space) | **done** (equipment list) |
| Cooking skill level | **done** |
| Visual prompt mode (ingredients/instructions imagery) | **done** (toggle) |
| Dietary needs: high protein, low carb, high fibre | planned (pattern dropdown only) |
| Medical: diabetes, post-surgery, gastric sleeve, deficiencies | **partial** (medical notes field) |
| Link prefs to Family Hub people | **done** |

---

## Tasks

### Default layer settings — **bug-fixed**
Per-layer priority/energy now saved in `TaskDefaultsPrefs` (`task_defaults_by_layer_v1`).

### Task packs — `partial`
**Current:** Apply built-in packs; remove from library only.

| Request | Status |
|---------|--------|
| Edit pack contents/settings | planned |
| Create custom packs | planned |

---

## Affirmations settings — `done` (2B)
**Current:** Built-in + Marlowe libraries; source/frequency prefs wired to dashboard (`AffirmationLibrary`, `DashboardProvider`, conditional `AffirmationCard`).

| Request | Status |
|---------|--------|
| Built-in library (curated list) | **done** |
| User-added affirmations | **done** |
| Family/friends can add when linked (Phase 2+ sharing) | planned |
| Wire settings → dashboard display | **done** |

---

## Budget — `partial`
**Current:** Manual income/expense (`budget_screen.dart`). No receipts.

| Request | Status |
|---------|--------|
| Save/upload receipt photos or PDFs per entry | planned |
| OCR / smart parsing (spec: meals Phase 3+) | planned |
| Surface sinking funds / bills extras provider in UI | planned |

---

## Meals module — `partial`

| Area | Request | Status |
|------|---------|--------|
| Preferences | Household + per-person matrix in Settings → Meals | **done** (SharedPreferences) |
| Banner | Dietary summary on meals screen from prefs | **done** |
| Plan | Better layout, “tonight” card | **partial** — tonight card **done** |
| Meals | Richer add-meal UI; link websites/videos for recipes | planned |
| Shopping | Smarter list grouping, plan integration | planned |
| Pantry | Expiry UX, plan tie-in | planned |
| BLW | Liked/disliked, expanded reaction log | planned |

---

## Reproductive health — `partial`
**Current:** Cycle tab with period log; calendar overlay **not wired**.

| Request | Status |
|---------|--------|
| Clue-style calendar UX (phases on calendar) | planned |
| Visual polish + flow | planned |
| Men’s health tab first when profile registered male | planned |

---

## Health status — `partial`
**Current:** Meds, quick logs, allergies, documents, seizures (`health_status_screen.dart`). Settings visibility toggles **wired** via `HealthStatusPrefsProvider`.

| Request | Status |
|---------|--------|
| Richer episode forms: location, type, start time, meds taken, notes | planned |
| More guided suggestions / dropdowns | planned |
| Wire settings toggles to main screen | **done** |

---

## Creative corner — `partial` (2B refresh)
**Current:** Themed hub with counts; win/celebration gradient cards; dream board by category; books grouped by status; edit/delete on all items.

| Request | Status |
|---------|--------|
| Visual identity (not grey lists) | **partial** — themed cards/sections |
| Book tracker sections by status | **done** |
| Dream board category themes | **done** |
| Edit/delete entries | **done** |
| DB v15 extra fields (rating, blurb, etc.) | **done** |

---

## Cross-cutting themes

1. **Visual identity per module** — Creative, Celebration, Wins, Meals need themed UI (not grey lists).
2. **Personalisation / colour** — User knows this is later; still note appetite for warmth now.
3. **Profile-linked data** — Meals, affirmations, book goals, allergies should attach to Family Hub people.
4. **Settings → UI wiring** — Affirmations, health status, and meals prefs now read on main screens; other settings may still be pending.

---

## Suggested phase order

1. **2C Creative corner depth** — Notes→Dream Board wire, reorder, child reading goals *(v15 fields done)*  
2. **2D Meals & health depth** — Plan layout polish, reproductive calendar, health episode detail  
3. **3A Budget & receipts** — Attachments, OCR later  

---

## Files touched for Phase 2B batch

- `lib/core/affirmations/affirmation_library.dart` — built-in + Marlowe libraries  
- `lib/providers/dashboard_provider.dart` — affirmation source/frequency  
- `lib/providers/health_status_prefs_provider.dart` — health visibility toggles  
- `lib/providers/meals_provider.dart` — household + per-person meal prefs  
- `lib/models/meal_prefs_models.dart` — prefs JSON models  
- `lib/screens/calendar/event_creation.dart` — multi-day start/end dates  
- `lib/screens/calendar/event_detail.dart` — multi-day date range display  
- `lib/widgets/calendar_event_tile.dart` — multi-day time label  
- `lib/screens/creative/win_dream_screens.dart` — Creative corner refresh  
- `lib/screens/health/health_status_screen.dart` — gated sections  
- `lib/screens/meals/meals_screen.dart` — dietary summary banner  
- `lib/main.dart` — register HealthStatusPrefsProvider  

## Files touched for Phase 2C batch

- `lib/core/affirmations/user_affirmations_store.dart` — custom affirmation list  
- `lib/screens/settings/affirmations_settings_screen.dart` — My affirmations source + CRUD  
- `lib/providers/dashboard_provider.dart` — custom source rotation  
- `lib/database/database_helper.dart` — DB v15 creative columns  
- `lib/screens/creative/win_dream_screens.dart` — book blurb/rating/DNF; dream accomplished  
- `lib/providers/meals_provider.dart` — `tonightDinner()` helper  
- `lib/screens/meals/meals_screen.dart` — Tonight card on Plan tab  

## Files touched for immediate bug fixes

- `lib/services/birthday_calendar_service.dart` — memorial/anniversary year count  
- `lib/screens/calendar/event_creation.dart` — yearly repeat, Family Hub edit banner  
- `lib/core/tasks/task_defaults_prefs.dart` — per-layer defaults  
- `lib/screens/settings/task_defaults_settings_screen.dart`  
- `lib/screens/tasks/task_detail_screen.dart`
