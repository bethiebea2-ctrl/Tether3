# Product backlog — user feedback (Sep 2026)

Captured from Beth’s walkthrough notes. Items are grouped by module.  
**Status key:** `bug-fixed` · `partial` (MVP exists) · `planned` · `not-started`

---

## Creative corner / Notes-adjacent

### Book tracker — `partial`
**Current:** Flat list, add title/author/status only (`lib/screens/creative/win_dream_screens.dart`).

| Request | Status |
|---------|--------|
| Group/sort into sections (want / reading / finished / DNF) for search | planned |
| Upload or paste blurb/synopsis | planned |
| Comments + star rating | planned |
| Prompt when changing status (esp. DNF → reason did not finish) | planned |
| Parent-set reading goals on child profiles | planned |
| Genre tags + genre goals | planned |

### Dream board — `partial`
**Current:** 2-column grid, title + category; notes saved but not shown.

| Request | Status |
|---------|--------|
| Rich goal editing (body text, accomplished section) for all board types | planned |
| Themed sections: dreamy dreams, goal + ball, overflowing bucket list, manifestation aesthetic | planned |
| Edit/delete/reorder items | planned |
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
| Multi-day events (start date + end date) | planned — schema has `end_time`; UI assumes single day |
| Re-sync memorial titles after fix (re-save person in Family Hub once) | workaround |

---

## Meal preference settings — `partial`
**Current:** Default servings only (`meals_settings_screen.dart`).

| Request | Status |
|---------|--------|
| Allergies + intolerances per person/profile | planned |
| Personal preferences, favourite foods | planned |
| Cooking setup (appliances, space) | planned |
| Cooking skill level | planned |
| Visual prompt mode (ingredients/instructions imagery) | planned |
| Dietary needs: high protein, low carb, high fibre | planned |
| Medical: diabetes, post-surgery, gastric sleeve, deficiencies | planned |
| Link prefs to Family Hub people | planned |

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

## Affirmations settings — `partial`
**Current:** Source + frequency prefs saved but **not wired** to dashboard (`affirmations_settings_screen.dart` vs `affirmation_card.dart`).

| Request | Status |
|---------|--------|
| Built-in library (curated list) | planned |
| User-added affirmations | planned |
| Family/friends can add when linked (Phase 2+ sharing) | planned |
| Wire settings → dashboard display | planned |

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
| Plan | Better layout, “tonight” card | planned |
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
**Current:** Meds, quick logs, allergies, documents, seizures (`health_status_screen.dart`). Settings visibility toggles not applied.

| Request | Status |
|---------|--------|
| Richer episode forms: location, type, start time, meds taken, notes | planned |
| More guided suggestions / dropdowns | planned |
| Wire settings toggles to main screen | planned |

---

## Cross-cutting themes

1. **Visual identity per module** — Creative, Celebration, Wins, Meals need themed UI (not grey lists).
2. **Personalisation / colour** — User knows this is later; still note appetite for warmth now.
3. **Profile-linked data** — Meals, affirmations, book goals, allergies should attach to Family Hub people.
4. **Settings → UI wiring** — Several settings screens save prefs that nothing reads yet.

---

## Suggested phase order

1. **2B polish & bugs** — Calendar multi-day, affirmations wiring, health settings wiring *(calendar memorial done)*  
2. **2C Creative corner** — Book tracker v2, dream board themes, celebration/win flair  
3. **2D Meals & health depth** — Preference matrix, reproductive calendar, health episode detail  
4. **3A Budget & receipts** — Attachments, OCR later  

---

## Files touched for immediate bug fixes

- `lib/services/birthday_calendar_service.dart` — memorial/anniversary year count  
- `lib/screens/calendar/event_creation.dart` — yearly repeat, Family Hub edit banner  
- `lib/core/tasks/task_defaults_prefs.dart` — per-layer defaults  
- `lib/screens/settings/task_defaults_settings_screen.dart`  
- `lib/screens/tasks/task_detail_screen.dart`
