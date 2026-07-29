# TETHER — MODULE 14: SETTINGS, PRIVACY & SHARING
## Complete Design Specification

**Module:** Settings, Privacy & Sharing
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢-🟠 (D1-D4 depending on section; D4 for crisis data handling)
**Phase:** 1B (core settings) → 1D (Support Presets, Health, Reproductive Health settings) → 2A (full sharing, household roles, data sensitivity, DV privacy mode on hold)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT SETTINGS, PRIVACY & SHARING IS

This module is the control centre for Tether. It contains every configuration option, every privacy control, every sharing permission, and every data management tool. It is not a single screen — it is a tree of screens that give Beth full control over how the app behaves, who sees what, and what happens to her data.

It answers the questions: *"How do I want this to work?"* and *"Who can see this?"* and *"Where is my data?"*

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Everything is configurable** | No hidden settings. No buried toggles. If the app does something, there's a setting for it. |
| **Privacy by default** | Everything is private unless explicitly shared. Sharing is per-item, per-person, opt-in. |
| **Granular, not blanket** | Beth doesn't "share everything with Ant." She shares specific categories, specific data types, with specific people. |
| **Transparent, not mysterious** | The User Activity Ledger shows exactly what the app did, what data was used, and what was shared. |
| **Data belongs to Beth** | Export everything. Delete anything. The data is hers. |
| **D4 data is sacred** | Crisis plans, safety plans, self-harm logs, hidden notes — these have the strictest controls. Minimal sharing. Excluded from summaries. Exportable only with deliberate, multi-step confirmation. |

---

## 3. HOW YOU GET HERE

**Primary:** Dashboard → ☰ hamburger menu → Settings. Or Dashboard → 👤 profile icon → Settings.
**From any screen:** The Settings gear icon (⚙️) is accessible from the top bar on most screens.

---

## 4. SETTINGS MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard        ⚙️ SETTINGS     │
├─────────────────────────────────────┤
│                                     │
│  👤 Bethany Clulow                  │
│  bethany.clulow.1@gmail.com        │
│  [Edit profile]                     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  🧩 MODULES                         │
│  ┌─────────────────────────────┐   │
│  │ Module Management       >   │   │
│  │ Active: 6 · Registered: 12 │   │
│  └─────────────────────────────┘   │
│                                     │
│  🧠 SUPPORT & ACCESSIBILITY         │
│  ┌─────────────────────────────┐   │
│  │ 🧠 Support Presets       >  │   │
│  │ 🎚 Sensitivity Toggles   >  │   │
│  │ ⚡ Current State         >  │   │
│  │ ♿ Accessibility         >  │   │
│  │ 🎨 Appearance & Themes  >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  📅 CALENDAR & TIME                 │
│  ┌─────────────────────────────┐   │
│  │ 📅 Calendar Settings     >  │   │
│  │ 🏷 Event Categories      >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  👨‍👩‍👦 FAMILY & HOUSEHOLD              │
│  ┌─────────────────────────────┐   │
│  │ 👨‍👩‍👦 Family Hub Settings  >  │   │
│  │ 🍽 Meals Preferences     >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  🩺 HEALTH & WELLBEING              │
│  ┌─────────────────────────────┐   │
│  │ 🩺 Health Status Settings >  │   │
│  │ 🩸 Reproductive Health   >  │   │
│  │ 🧠 Mental Health Toolkit >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  💰 FINANCE                         │
│  ┌─────────────────────────────┐   │
│  │ 💰 Budget Settings       >  │   │
│  │ 💳 Budget Categories     >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  📋 TASKS                           │
│  ┌─────────────────────────────┐   │
│  │ 📋 Task Defaults         >  │   │
│  │ 📦 Task Packs            >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  👥 TEAM & COMPANION                │
│  ┌─────────────────────────────┐   │
│  │ 👥 Team Configuration    >  │   │
│  │ 🎭 Instance Personalise  >  │   │
│  │ 💬 Companion Settings    >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  🔔 NOTIFICATIONS                   │
│  ┌─────────────────────────────┐   │
│  │ 🔔 Notification Settings >  │   │
│  │ 🛡 Status Shield         >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  🔒 PRIVACY & DATA                  │
│  ┌─────────────────────────────┐   │
│  │ 🔒 Sharing & Privacy     >  │   │
│  │ 📊 User Activity Ledger  >  │   │
│  │ 💾 Data Export & Delete  >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ℹ️ APP                              │
│  ┌─────────────────────────────┐   │
│  │ 💬 Affirmations          >  │   │
│  │ 🆕 What's New            >  │   │
│  │ ℹ️ About & Licences      >  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Sign out]                        │
│                                     │
│  Version 1.0.0 · Phase 1B          │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. MODULE MANAGEMENT

Controls which modules are active and visible.

```
┌─────────────────────────────────────┐
│  ← Settings    🧩 MODULE MANAGEMENT │
├─────────────────────────────────────┤
│                                     │
│  Active modules appear in your      │
│  bottom nav and on your dashboard.  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  REQUIRED (cannot disable)          │
│  ☑ 🏠 Dashboard                    │
│  ☑ 📝 Notes                        │
│                                     │
│  ACTIVE MODULES                     │
│  ☑ 📅 Calendar                     │
│  ☑ 📋 Tasks                        │
│  ☑ 👨‍👩‍👦 Family Hub                 │
│  ☐ 🍽 Meals                        │
│  ☑ 💰 Budget                       │
│  ☐ 🩺 Health Status                │
│  ☐ 🩸 Reproductive Health          │
│  ☐ 🧠 Mental Health Toolkit        │
│  ☐ 📚 Resource Library             │
│  ☑ 👥 Team                         │
│  ☐ 💬 Companion                    │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Maximum 5 tabs in bottom nav.      │
│  Additional active modules appear   │
│  in More (⋯).                      │
│                                     │
│  Inactive modules are hidden but    │
│  their data is preserved.           │
│                                     │
│  [Reset to defaults]                │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. PROFILE & ACCOUNT

```
┌─────────────────────────────────────┐
│  ← Settings     👤 PROFILE & ACCOUNT│
├─────────────────────────────────────┤
│                                     │
│  Photo                         [📷] │
│                                     │
│  Full name                          │
│  [Bethany Clulow_______________]    │
│                                     │
│  Display name                       │
│  [Beth_________________________]    │
│                                     │
│  Email                              │
│  [bethany.clulow.1@gmail.com____]   │
│                                     │
│  Date of birth                      │
│  [7th March 2001]                   │
│                                     │
│  Profession                         │
│  [Registered Nurse______________]   │
│                                     │
│  Current role                       │
│  [Specimen Collector · SNP______]   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  HOUSEHOLD ROLE                     │
│  Owner / Admin                      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  This information helps your AI     │
│  team personalise responses. Your   │
│  profession and role are used to    │
│  calibrate employment listings,     │
│  debrief context, and scheduling    │
│  awareness.                         │
│                                     │
│  [Save]                             │
│                                     │
└─────────────────────────────────────┘
```

---

## 7. PRIVACY & SHARING — MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Settings   🔒 SHARING & PRIVACY  │
├─────────────────────────────────────┤
│                                     │
│  HOUSEHOLD ROLES & PERMISSIONS      │
│  ┌─────────────────────────────┐   │
│  │ 👤 Beth · Owner/Admin       │   │
│  │ 👤 Ant · Partner     [Edit]│   │
│  │ 👶 Evander · Child   [Edit]│   │
│  │ 👦 Theodore · Teen   [Edit]│   │
│  │ 👧 Annabella · Teen  [Edit]│   │
│  └─────────────────────────────┘   │
│                                     │
│  DATA SENSITIVITY LEVELS            │
│  ┌─────────────────────────────┐   │
│  │ D1 Low: Standard handling   │   │
│  │ D2 Medium: Standard         │   │
│  │ D3 High: Stricter rules     │   │
│  │ D4 Very High: Strictest     │   │
│  │ [View sensitivity rules]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  SHARED DATA — BY TYPE              │
│  ┌─────────────────────────────┐   │
│  │ 📅 Calendar    [Configure]  │   │
│  │ 📋 Tasks       [Configure]  │   │
│  │ 💰 Budget      [Configure]  │   │
│  │ 👶 Children    [Configure]  │   │
│  │ 🩺 Health      [Configure]  │   │
│  │ 🩸 Reproductive[Configure]  │   │
│  │ 🐾 Pets        [Configure]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  TEEN PRIVACY                       │
│  ┌─────────────────────────────┐   │
│  │ 👦 Theodore (13) [Configure]│   │
│  │ 👧 Annabella (16)[Configure]│   │
│  └─────────────────────────────┘   │
│                                     │
│  SECURITY                           │
│  ┌─────────────────────────────┐   │
│  │ ☐ Require PIN to open app   │   │
│  │ ☐ Require biometrics        │   │
│  │ ☐ Hide sensitive notifs     │   │
│  │    on lock screen           │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 8. SHARING CONFIGURATION — PER DATA TYPE

Tapping "Configure" on any data type opens granular sharing controls.

```
┌─────────────────────────────────────┐
│  ← Sharing       📅 CALENDAR SHARING│
├─────────────────────────────────────┤
│                                     │
│  Share calendar with:               │
│                                     │
│  👤 Ant · Partner                   │
│  ┌─────────────────────────────┐   │
│  │ ☑ All calendar events       │   │
│  │ ● Selected categories only:  │   │
│  │   ☑ Family                   │   │
│  │   ☑ Evander                  │   │
│  │   ☑ Theodore                 │   │
│  │   ☑ Annabella                │   │
│  │   ☑ Pets                     │   │
│  │   ☐ Beth (personal)         │   │
│  │   ☐ Work                     │   │
│  │   ☐ Social                   │   │
│  │   ☐ Medical                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  Ant can:                           │
│  ☑ View events                     │
│  ☑ Edit events                     │
│  ☑ Create events                   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  👦 Theodore · Teen (13)            │
│  ┌─────────────────────────────┐   │
│  │ ☑ School events             │   │
│  │ ☑ Family events             │   │
│  │ ☐ Everything else           │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Share all with Ant]              │
│  [Stop sharing with Ant]           │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. HOUSEHOLD ROLES & PERMISSIONS

```
┌─────────────────────────────────────┐
│  ← Privacy    HOUSEHOLD PERMISSIONS │
├─────────────────────────────────────┤
│                                     │
│  Household roles determine what     │
│  each person can see and do.        │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ROLES                              │
│  · Owner/Admin — Full access        │
│  · Partner/Adult — Shared access    │
│  · Teen (13-15) — Graduated privacy │
│  · Teen (16-17) — Increased privacy │
│  · Child profile — Parent-managed   │
│  · Carer — Configurable access      │
│  · Viewer only — Read-only          │
│  · Emergency contact — Crisis only  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  WHAT HAPPENS WHEN...               │
│  · A teen turns 16                  │
│    → Privacy review prompt. More    │
│      options unlock.                │
│                                     │
│  · A teen turns 18                  │
│    → Full adult privacy. Parent     │
│      sync becomes opt-in for them.  │
│                                     │
│  · A partner disconnects            │
│    → Shared data remains with the   │
│      owner. Partner's access is     │
│      revoked.                       │
│                                     │
│  · Someone leaves the household     │
│    → Their profile is archived.     │
│      Shared data is reviewed.       │
│                                     │
│  · A carer's access ends            │
│    → Time-limited access expires    │
│      automatically.                 │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. TEEN PRIVACY CONFIGURATION

```
┌─────────────────────────────────────┐
│  ← Privacy   👦 THEODORE · PRIVACY  │
├─────────────────────────────────────┤
│                                     │
│  Theodore is 13.                    │
│  Privacy model: Graduated (13-15)   │
│                                     │
│  PARENTS CAN SEE:                   │
│  ☑ Calendar (shared events)        │
│  ☑ Chores & tasks                  │
│  ☑ Medication log (safety)         │
│  ☑ School events                   │
│  ☑ Check-ins (if shared)           │
│                                     │
│  PARENTS CANNOT SEE:                │
│  ☐ Messages with AI team           │
│  ☐ Personal notes                  │
│  ☐ Private calendar events         │
│  ☐ Browsing history in app         │
│                                     │
│  SAFETY OVERRIDES (always active)   │
│  ☑ Medication log visible          │
│  ☑ Emergency contacts accessible   │
│  ☑ Crisis plan accessible (if set) │
│                                     │
│  PARENT NOTIFICATIONS               │
│  ☑ Notify if Theodore shares       │
│    safety concerns                  │
│    (transparent — Theodore knows)  │
│                                     │
│  [Adjust privacy]                   │
│                                     │
└─────────────────────────────────────┘
```

---

## 11. DATA SENSITIVITY LEVELS

```
┌─────────────────────────────────────┐
│  ← Privacy  DATA SENSITIVITY LEVELS │
├─────────────────────────────────────┤
│                                     │
│  Every piece of data in Tether has  │
│  a sensitivity level. This controls │
│  how it's handled.                  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  D1 — LOW                           │
│  · Meal preferences                 │
│  · Household tasks                  │
│  · Pet reminders                    │
│  · Generic routines                 │
│  Handling: Standard. Exportable.    │
│  Shareable.                         │
│                                     │
│  D2 — MEDIUM                        │
│  · Calendar events                  │
│  · Budget data                      │
│  · Family notes                     │
│  · School information               │
│  Handling: Standard. Exportable.    │
│  Shareable with permission.         │
│                                     │
│  D3 — HIGH                          │
│  · Health data                      │
│  · Reproductive health              │
│  · Mental health logs               │
│  · Addiction recovery data          │
│  · Child health data                │
│  · Medication records               │
│  Handling: Stricter sharing rules.  │
│  Export restricted. Not shared      │
│  without explicit opt-in.           │
│                                     │
│  D4 — VERY HIGH                     │
│  · Crisis plans                     │
│  · Safety plans                     │
│  · Hidden notes                     │
│  · Self-harm/suicidal ideation logs │
│  · DV/coercive control information  │
│  · Sexual trauma notes              │
│  Handling: Strictest controls.      │
│  Minimal sharing. Excluded from     │
│  summaries. Export requires         │
│  deliberate multi-step confirmation.│
│  Auto-delete options available.     │
│                                     │
└─────────────────────────────────────┘
```

---

## 12. USER ACTIVITY LEDGER

```
┌─────────────────────────────────────┐
│  ← Privacy  📊 USER ACTIVITY LEDGER │
├─────────────────────────────────────┤
│                                     │
│  This is a transparent record of    │
│  what Tether did with your data.    │
│  It's for you.                      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  TODAY — Monday 30th June           │
│                                     │
│  10:33 AM                           │
│  Val created a calendar event from  │
│  your note: "Handover · 9am"       │
│  Data used: note text, timestamp    │
│                                     │
│  10:30 AM                           │
│  Feed logged for Evander. Routed    │
│  to Family Hub.                     │
│  Data used: "Feed · 10:30am"       │
│  Shared with: Ant (Family Hub)      │
│                                     │
│  9:15 AM                            │
│  Note saved. Routed to Rae          │
│  (Nurse Debrief).                   │
│  Data used: note content            │
│  Shared with: No one (confidential) │
│                                     │
│  8:45 AM                            │
│  Tim updated grocery budget:        │
│  $340 of $400 spent.                │
│  Data used: expense logs            │
│  Shared with: Ant (Budget)          │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Filter by module]                 │
│  [Filter by shared/private]         │
│  [Search activity]                  │
│  [Export ledger]                    │
│                                     │
└─────────────────────────────────────┘
```

**User Activity Ledger principles:**
- Plain English. No technical jargon.
- Shows what happened, what data was used, and who it was shared with.
- Confidential content (Rae debriefs, D4 data) is noted as "Shared with: No one (confidential)" — the content is never shown in the ledger.
- Searchable. Filterable. Exportable.

---

## 13. DATA EXPORT & DELETE

```
┌─────────────────────────────────────┐
│  ← Privacy  💾 DATA EXPORT & DELETE │
├─────────────────────────────────────┤
│                                     │
│  Your data belongs to you.          │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  EXPORT YOUR DATA                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 Calendar events   [JSON] │   │
│  │ 📋 Tasks             [JSON] │   │
│  │ 💬 Chat history      [JSON] │   │
│  │ 📝 Notes & captures  [JSON] │   │
│  │ 💊 Medication logs   [JSON] │   │
│  │ 📊 Budget data       [JSON] │   │
│  │ 👨‍👩‍👦 Family Hub data   [JSON] │   │
│  │ 🩺 Health data       [JSON] │   │
│  │ 🩸 Reproductive data [JSON] │   │
│  │ 🧠 Mental health data[JSON] │   │
│  │ 📊 Activity ledger   [JSON] │   │
│  │                             │   │
│  │ [Export all data]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  DELETE YOUR DATA                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ [Delete conversation history]│   │
│  │ [Delete all notes & captures]│  │
│  │ [Delete all health data]     │   │
│  │ [Delete all reproductive     │   │
│  │  health data]                │   │
│  │ [Delete all mental health    │   │
│  │  data]                       │   │
│  │ [Delete account & all data]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⚠ Deletion is permanent and       │
│    cannot be undone.                │
│                                     │
│  Export your data first if you      │
│  want to keep a copy.               │
│                                     │
└─────────────────────────────────────┘
```

**Export format:** JSON (structured, machine-readable) or plain text (human-readable). Files are timestamped. D4 data requires additional confirmation to export.

**Deletion rules:**
- Individual data types can be deleted separately.
- "Delete account & all data" removes everything. Irreversible.
- D4 data deletion requires typing "DELETE" to confirm.
- Before deletion, the app offers: "Would you like to export your data first?"

---

## 14. DOMESTIC VIOLENCE / COERCIVE CONTROL PRIVACY MODE

```
┌─────────────────────────────────────┐
│  ← Privacy    ⚠ SAFETY & PRIVACY    │
├─────────────────────────────────────┤
│                                     │
│  🔴 ON HOLD                         │
│                                     │
│  This feature requires specialist   │
│  consultation before building.      │
│  Poorly implemented safety features │
│  can increase risk.                 │
│                                     │
│  PLANNED FEATURES (pending review): │
│  · Disguised app name/icon          │
│  · Quick exit to neutral screen     │
│  · Hidden notes and data            │
│  · Safe contact storage             │
│  · Privacy masking on all screens   │
│  · Emergency exit pathway           │
│                                     │
│  If you need help now:              │
│  · 1800RESPECT: 1800 737 732       │
│  · Lifeline: 13 11 14               │
│  · 000 (Emergency)                  │
│                                     │
└─────────────────────────────────────┘
```

**Status:** On hold. Do not build without specialist DV/coercive control consultation.

---

## 15. AFFIRMATIONS SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings     💬 AFFIRMATIONS     │
├─────────────────────────────────────┤
│                                     │
│  SOURCE                             │
│  ● AI-generated                    │
│  ○ Self-written                     │
│  ○ Mixed (AI suggests, I approve)   │
│  ○ Curated by Dream Architect       │
│                                     │
│  FREQUENCY                          │
│  ● Daily (changes each morning)     │
│  ○ Weekly                           │
│  ○ Fixed (I'll change it myself)    │
│                                     │
│  TONE                               │
│  ○ Warm & encouraging               │
│  ● Calm & grounding                 │
│  ○ Short & direct                   │
│  ○ Gentle & compassionate           │
│                                     │
│  STATE-RESPONSIVE                   │
│  ☑ Adjust tone when Current State  │
│    is active                        │
│  ☑ Adjust tone for Support Presets │
│                                     │
│  SAVED AFFIRMATIONS                 │
│  · "One step at a time."           │
│  · "Rest is productive."           │
│  [+ Add your own]                   │
│                                     │
└─────────────────────────────────────┘
```

---

## 16. WHAT'S NEW

```
┌─────────────────────────────────────┐
│  ← Settings        🆕 WHAT'S NEW    │
├─────────────────────────────────────┤
│                                     │
│  Version 1.0.0 · Phase 1B          │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  NEW IN THIS UPDATE                 │
│                                     │
│  · Calendar: Month view with        │
│    collapsible grid                 │
│  · Tasks: Urgent/Not Urgent split   │
│  · Family Hub: Evander medication   │
│    tracker with visual timer        │
│  · Team: Conversation persistence   │
│  · Notifications: Hybrid mode       │
│                                     │
│  COMING SOON                        │
│                                     │
│  · Support Presets (first 5)        │
│  · Current State selector           │
│  · Meals module                     │
│  · Health Status trackers           │
│                                     │
│  [View full changelog]              │
│                                     │
└─────────────────────────────────────┘
```

---

## 17. ABOUT & LICENCES

```
┌─────────────────────────────────────┐
│  ← Settings    ℹ️ ABOUT & LICENCES  │
├─────────────────────────────────────┤
│                                     │
│  Tether                             │
│  Version 1.0.0 · Phase 1B          │
│                                     │
│  Built for Beth.                    │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ACKNOWLEDGEMENTS                   │
│  · Flutter — UI framework           │
│  · Flask — Backend framework        │
│  · DeepSeek — AI API                │
│  · Render — Cloud hosting           │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  PRIVACY POLICY                     │
│  [View privacy policy]              │
│                                     │
│  TERMS OF USE                       │
│  [View terms of use]                │
│                                     │
│  OPEN SOURCE LICENCES               │
│  [View licences]                    │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  This app is not a medical device.  │
│  It does not diagnose, treat, or    │
│  replace professional healthcare.   │
│                                     │
│  © 2026 Tether                       │
│                                     │
└─────────────────────────────────────┘
```

---

## 18. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Current) | Settings main screen with all sections (some as placeholders). Module Management. Profile & Account. Calendar Settings. Event Categories. Notification Settings. Status Shield Settings. Task Defaults. Team Configuration. Affirmations. About & Licences. |
| **1D** | Support Presets settings (activate, configure, create custom). Sensitivity Toggles (all 9 categories). Current State settings. Accessibility settings. Appearance & Themes. Health Status settings. Reproductive Health settings. Mental Health Toolkit settings. Family Hub settings (people, pets, household). Meals preferences. Budget settings & categories. Data Export & Delete. User Activity Ledger. |
| **2A** | Full Sharing & Privacy (household roles, per-data-type sharing, teen privacy configuration, data sensitivity levels). Connectable Accounts management. Companion settings. What's New changelog. |
| **2B** | DV/Coercive Control privacy mode (pending specialist consultation). Advanced privacy features. |

---

## 19. WHAT SETTINGS, PRIVACY & SHARING DOES NOT DO

- It does not hide settings. Everything is accessible.
- It does not share data by default. Everything is private until Beth chooses otherwise.
- It does not expose D4 data in exports or sharing without deliberate, multi-step confirmation.
- It does not allow teens to be surveilled without their knowledge. Safety overrides are transparent.
- It does not build the DV privacy mode without expert consultation. On hold.
- It does not make decisions for Beth. It gives her the controls. She decides.

---

That's Settings, Privacy & Sharing. Full control. Granular sharing. Transparent activity ledger. Data export and deletion. Teen privacy with graduated autonomy. D4 data sacred. DV mode on hold pending expert review.
