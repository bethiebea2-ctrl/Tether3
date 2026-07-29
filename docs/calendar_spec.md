# TETHER — MODULE 2: CALENDAR
## Complete Design Specification

**Module:** Calendar  
**Version:** v3.0 — Route Map Aligned  
**Risk:** 🟢 (D2; surfaces D3 health data via cycle overlay and medical category)  
**Phase:** 1B (core calendar) → 1D (cycle overlay, conflict detection) → 2A (family categories, Schedule Protector, Ant's View)  
**Status:** 🔧 In Progress — Kit building

---

## Implementation status (code)

| Section | Status |
|---------|--------|
| Month view (collapsible grid + day detail) | Live |
| Day view (vertical timeline + NOW line) | Live |
| Agenda view (grouped upcoming list) | Live |
| Week view | Basic (Phase 1C polish deferred) |
| Event creation (title, date, times, all-day, repeat, category, emoji, notes, priority) | Live |
| Location / Leave by | Deferred (location field present; Leave by = 2A) |
| Event Detail + Edit / Delete | Live |
| Source tagging (Pipeline / Manual) | Live |
| Priority badges (Urgent / Important / Routine) | Live |
| 7 default categories | Live (Settings CRUD stub) |
| Recurrence (daily / weekly / biweekly / monthly) | Live (basic; edit-scope prompt) |
| Conflict detection (warn, not block) | Live (basic overlap) |
| Category filtering | Deferred 1C |
| Cycle overlay | Deferred 1D |
| Schedule Protector / Ant's View | Deferred 2A |
| Pull-to-refresh + cold start | Live |

---

## 1. What the Calendar is

The central time-visualisation tool for Tether. Displays every time-bound commitment across Beth's life. Events arrive via the Capture pipeline (Rhen) or are created manually.

Answers: *"What's happening, and when?"*

## 2. Core principles

- **One calendar, many categories** — colour/icon, not separate calendars.
- **Pipeline-driven, but manual-friendly** — both paths equal; source tagged.
- **Visible, not overwhelming** — month for shape, day for detail.
- **Time-blindness aware** — buffers, leave-by, visual timeline.
- **Privacy-respecting** — medical masking, teen graduated privacy, shared vs private.

## 3. Four views

| View | Best for |
|------|----------|
| Month | Big picture; collapsible grid + selected-day detail |
| Week | Busy-day spotting (1C polish) |
| Day | Hour-by-hour timeline |
| Agenda | Quick scan of upcoming events |

## 4. Event categories (defaults)

| Category | Colour | Hex | Icon |
|----------|--------|-----|------|
| Evander | Soft blue | #7ec8e3 | 👶 |
| Ant | Deep green | #66bb6a | 👤 |
| Beth | Warm amber | #ffa726 | 👤 |
| Family | Soft purple | #b8a9d4 | 👨‍👩‍👦 |
| Work | Orange | #FF9800 | 💼 |
| Parents | Teal | #4db6ac | 👥 |
| Social | Pink | #f06292 | 🎉 |

Max 15 categories. Settings → Event Categories.

## 5. Phase delivery

| Phase | Ships |
|-------|-------|
| **1B** | Month (collapsible), Day, Agenda; create/edit/delete; categories; source tags; recurrence basics; pull-to-refresh |
| **1C** | Week polish; emoji polish; conflict; category filter |
| **1D** | Cycle overlay; postpartum / pregnancy modes |
| **2A** | Schedule Protector; Ant's View; Leave by; family auto-tag |
| **2B** | Full state responsiveness |

## 6. What it does not do

- Auto-create without confirmation (unless pipeline confidence ≥ 0.9)
- Delete/move without explicit action
- Share outside household without consent
- Diagnose (cycle overlay says "may be")
- Replace the Dashboard
