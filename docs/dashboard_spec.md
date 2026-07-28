# TETHER — MODULE 1: DASHBOARD

**Module:** Dashboard  
**Version:** v3.0 — Route Map Aligned  
**Risk:** 🟢 (D1-D2; surfaces data from D3 sources with privacy controls)  
**Phase:** 1B (core) → 1D (Current State, Colour Card, Capacity) → 2A (partner/household)  
**Status:** In progress

---

## Implementation status (code)

| Section | Status |
|---------|--------|
| Top bar (menu → Settings, greeting, notifications stub, profile menu) | Live |
| Greeting + affirmation (state-responsive copy) | Live |
| Colour Card (8 moods + modal) | Live (local) |
| Capacity Check-In (slider + chips) | Live (local) |
| Current State bar | Live (wired to Settings prefs) |
| Family Summary Card | Live (module-gated) |
| Today's Schedule | Live (module-gated) |
| Cycle Indicator | Stub line (hidden unless reproductive module active — module inactive by default) |
| Urgent / Snoozed | Live (tasks module) |
| Status Shield | Live |
| At a Glance cards | Live (tasks summary; budget if active) |
| Full Support Preset dashboard transforms | Partial (simplified dashboard flag) |
| Privacy lock-screen mode / pull-to-refresh cloud | Deferred 1D/2A |

---

## 1. What the Dashboard is

The first screen when opening Tether. An intelligent assembly of the most relevant information from every **active** module, prioritised by urgency, time-sensitivity, and current state.

Answers: *"What matters right now?"*

The Dashboard does not own data — it surfaces other modules. Inactive modules do not appear.

## 2. Core principles

- **One screen, not a scroll** — critical info above the fold when possible.
- **Calm, not shouting** — priority via position and colour, not volume.
- **Configurable, not chaotic** — module activation controls what appears.
- **Privacy-aware** — D3–D4 masking via settings (later phases).
- **State-responsive** — Colour Card, Capacity, Current State, Support Presets, Status Shield.

## 3. Layout (wireframe order)

1. Top bar — ☰ Settings, greeting title area, 🔔, 👤  
2. Greeting + affirmation  
3. Colour Card + Capacity  
4. Current State bar (or activate prompt)  
5. Family summary  
6. Today's schedule  
7. Cycle indicator (if reproductive health active)  
8. Urgent  
9. Snoozed  
10. Status Shield  
11. At a Glance (collapsed)  
12. Bottom nav (app shell)

## 4. Colour Card moods

| Colour | Meaning | App behaviour (summary) |
|--------|---------|-------------------------|
| Green | Open to talk | Normal |
| Yellow | Guarded / keep it light | Reduce non-urgent |
| Orange | On edge / fragile | Urgent-only + Bare Minimums |
| Red | Stop / need space | Suppress non-crisis |
| Purple | Connect / closeness | Gentler companion tone |
| Black | Shutdown | Minimise dashboard |
| Brown | Process / need time | Reduced contact |
| Sparkle | Productive / in zone | Urgent-only, let them cook |

## 5. Conflict resolution

**Most protective setting wins** when presets and Current State conflict. Manual override always respected.

## 6. Phase delivery

See Section 10 of the product paste: 1B core chrome + Colour/Capacity/Family/Schedule/Urgent/Snoozed/Shield; 1C voice; 1D full Current State + glance + histories; 2A partner/pet/budget/meals cloud; 2B full preset responsiveness.

## 7. What the Dashboard does not do

Does not create, store, or show everything. Does not diagnose. Cycle copy uses “may be” language only.

---

Full wireframes and per-section tables live in the product design paste (v3.0). This file is the repo canonical summary for Kit/Viva alignment.
