> **Implementation status (Phase 1B shell — Jul 2026)**
>
> | Area | Status |
> |------|--------|
> | Settings main screen (Section 2 wireframe) | Live shell |
> | Module Management | Live (active/registered counts; max-8 nav note) |
> | Support Presets catalog | Live browse + activate (subset fully wired; others activate as flags) |
> | Sensitivity Toggles / Current State / Accessibility | Live local prefs (SharedPreferences) |
> | Calendar Settings / Notifications / Status Shield | Live local prefs |
> | Event Categories | Live list + Edit/Add stubs |
> | Family Hub Settings | Live people/pets + defaults prefs |
> | Health / Finance / Tasks / Team / Privacy / App sections | Stub or phase-labeled screens |
> | Sign out | Stub |
>
> Full product specification follows.

# TETHER — SETTINGS: COMPLETE SPECIFICATION

**Module:** Settings
**Version:** v2.0 — Route Map Aligned
**Risk:** 🟢-🟠 (D1-D4 depending on section)
**Phase:** 1B (core settings) → 1D (Support Presets, Health, Reproductive Health) → 2A (Sharing, Privacy, Household) → 2B (full sensitivity toggles, accessibility)

---

## 1. HOW YOU GET THERE

**Primary entry:** Dashboard → top-right profile icon (👤) or hamburger menu (☰) → Settings
**Alternative:** Bottom nav overflow (if Settings is not a main tab) → Settings
**Developer access:** Debug Screen → Settings (for developer ghost log and audit tools)

---

## 2. SETTINGS MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard        ⚙ SETTINGS      │
├─────────────────────────────────────┤
│                                     │
│  👤 Bethany Clulow                  │
│  bethany.clulow.1@gmail.com        │
│  [Edit profile]                     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  MODULES                            │
│  ┌─────────────────────────────┐   │
│  │ Module Management       >   │   │
│  │ Active: 6 · Registered: 12 │   │
│  └─────────────────────────────┘   │
│                                     │
│  SUPPORT & ACCESSIBILITY            │
│  ┌─────────────────────────────┐   │
│  │ Support Presets           > │   │
│  │ Sensitivity Toggles       > │   │
│  │ Current State             > │   │
│  │ Accessibility             > │   │
│  └─────────────────────────────┘   │
│                                     │
│  CALENDAR & TIME                    │
│  ┌─────────────────────────────┐   │
│  │ Calendar Settings         > │   │
│  │ Event Categories          > │   │
│  │ Notifications             > │   │
│  │ Status Shield             > │   │
│  └─────────────────────────────┘   │
│                                     │
│  FAMILY & HOUSEHOLD                  │
│  ┌─────────────────────────────┐   │
│  │ Family Hub Settings       > │   │
│  │ Meals Preferences         > │   │
│  └─────────────────────────────┘   │
│                                     │
│  HEALTH & WELLBEING                 │
│  ┌─────────────────────────────┐   │
│  │ Health Status Settings     > │   │
│  │ Reproductive Health        > │   │
│  │ Mental Health Toolkit      > │   │
│  └─────────────────────────────┘   │
│                                     │
│  FINANCE                            │
│  ┌─────────────────────────────┐   │
│  │ Budget Settings            > │   │
│  │ Budget Categories          > │   │
│  └─────────────────────────────┘   │
│                                     │
│  TASKS                              │
│  ┌─────────────────────────────┐   │
│  │ Task Defaults              > │   │
│  │ Task Packs                 > │   │
│  └─────────────────────────────┘   │
│                                     │
│  TEAM & COMPANION                   │
│  ┌─────────────────────────────┐   │
│  │ Team Configuration         > │   │
│  │ Instance Personalisation   > │   │
│  │ Companion Settings         > │   │
│  └─────────────────────────────┘   │
│                                     │
│  PRIVACY & DATA                     │
│  ┌─────────────────────────────┐   │
│  │ Sharing & Privacy          > │   │
│  │ User Activity Ledger       > │   │
│  │ Data Export & Delete       > │   │
│  └─────────────────────────────┘   │
│                                     │
│  APP                                 │
│  ┌─────────────────────────────┐   │
│  │ Affirmations               > │   │
│  │ What's New                 > │   │
│  │ About & Licences           > │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Sign out]                        │
│                                     │
│  Version 1.0.0 (Phase 1B)          │
│                                     │
└─────────────────────────────────────┘
```

---

## 3. MODULE MANAGEMENT

Controls which modules are active and visible in the bottom navigation.

```
┌─────────────────────────────────────┐
│  ← Settings      MODULE MANAGEMENT  │
├─────────────────────────────────────┤
│                                     │
│  Active modules appear in your      │
│  bottom nav and dashboard.          │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ☑ Dashboard            (required)  │
│  ☑ Capture / Notes      (required)  │
│  ☑ Calendar                        │
│  ☑ Tasks                           │
│  ☑ Family Hub                      │
│  ☐ Meals                           │
│  ☑ Budget                          │
│  ☐ Health Status                   │
│  ☐ Reproductive Health             │
│  ☐ Mental Health Toolkit           │
│  ☐ Resource Library                │
│  ☑ Team                            │
│  ☐ Companion                       │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Modules marked (required) cannot   │
│  be disabled.                       │
│                                     │
│  Maximum 8 active modules for       │
│  bottom nav. Additional active      │
│  modules appear in More (⋯).       │
│                                     │
│  [Reset to defaults]               │
│                                     │
└─────────────────────────────────────┘
```

**Rules:**
- Dashboard and Capture/Notes are always active. Cannot be disabled.
- Maximum 8 modules in bottom nav. Additional active modules appear in an overflow menu (⋯).
- Inactive modules are hidden from navigation but their data is preserved. Reactivating a module restores all data.
- Default active modules (Phase 1B): Dashboard, Capture/Notes, Calendar, Tasks, Family Hub, Budget, Team.

---

## 4. SUPPORT PRESETS

The three-layer Support Presets system. Full detail is in the Support Presets spec. Here is the Settings interface.

### 4.1 Support Presets Main Screen

```
┌─────────────────────────────────────┐
│  ← Settings      SUPPORT PRESETS    │
├─────────────────────────────────────┤
│                                     │
│  Support Presets are bundles of     │
│  settings that adapt the app to     │
│  your needs. You can customise      │
│  any preset or build your own.      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ACTIVE PRESETS                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧠 ADHD Support        [✓] │   │
│  │ 4 toggles active           │   │
│  │ [Configure]  [Deactivate]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🤰 Postpartum Support  [✓] │   │
│  │ 6 toggles active           │   │
│  │ [Configure]  [Deactivate]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Activate a preset]             │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  AVAILABLE PRESETS                  │
│                                     │
│  Neurodivergent Support             │
│  ┌─────────────────────────────┐   │
│  │ 🧠 ADHD Support        [+] │   │
│  │ 🌈 Autism Support       [+] │   │
│  │ 📖 Dyslexia Support     [+] │   │
│  │ 🔢 Dyscalculia Support  [+] │   │
│  │ 🤲 Dyspraxia Support    [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Emotional & Mental Health          │
│  ┌─────────────────────────────┐   │
│  │ 🌧 Depression Support   [+] │   │
│  │ 😰 Anxiety Support      [+] │   │
│  │ 🛡 Trauma-Informed      [+] │   │
│  │ 💜 Emotional Regulation [+] │   │
│  │ 🍽 Food/Body Neutrality [+] │   │
│  │ 🧘 Panic Support        [+] │   │
│  │ 🌫 Dissociation Support [+] │   │
│  │ 🔄 OCD Support          [+] │   │
│  │ 📊 Bipolar Support      [+] │   │
│  │ 🧭 Psychosis Support    [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Life Stages & Recovery             │
│  ┌─────────────────────────────┐   │
│  │ 🤰 Postpartum Support   [+] │   │
│  │ 💪 Addiction Recovery   [+] │   │
│  │ 🩺 Chronic Health       [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Sensory & Physical                 │
│  ┌─────────────────────────────┐   │
│  │ 🌙 Low-Stimulation      [+] │   │
│  │ 👁 Blind/Low Vision     [+] │   │
│  │ 👂 Deaf/Hard of Hearing [+] │   │
│  │ ♿ Accessibility/Mobility[+]│   │
│  │ ⚡ Epilepsy Support     [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [+ Create custom preset]           │
│                                     │
└─────────────────────────────────────┘
```

### 4.2 Configuring a Preset

Tapping "Configure" on an active preset opens its detail:

```
┌─────────────────────────────────────┐
│  ← Presets       ADHD SUPPORT       │
├─────────────────────────────────────┤
│                                     │
│  You've turned on ADHD support.     │
│  These settings are active. You     │
│  can adjust or turn off any.        │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  NOTIFICATIONS                      │
│  ☑ Digest mode by default          │
│  ☑ Reduce non-urgent reminders     │
│  ☐ Increase reminders              │
│                                     │
│  TASKS                              │
│  ☑ Visual task breakdowns          │
│  ☑ One next step mode              │
│  ☑ Body-doubling prompts           │
│  ☑ Focus timer                     │
│  ☑ "Start tiny" prompts            │
│  ☑ Missed-task recovery (no shame) │
│  ☐ Hyperfocus warning              │
│  ☐ Transition reminders            │
│  ☐ "Leaving soon" reminders        │
│                                     │
│  LANGUAGE                           │
│  ☑ Plain language                  │
│  ☑ No shame-based wording          │
│  ☐ Extra direct language           │
│                                     │
│  DASHBOARD                          │
│  ☑ One next step visible           │
│  ☑ Urgent items surfaced           │
│  ☐ Dopamine-friendly progress      │
│  ☐ Clutter reduction mode          │
│                                     │
│  CURRENT STATE SHORTCUTS            │
│  ☑ Overwhelmed                     │
│  ☑ Low energy                      │
│  ☐ Shutdown/meltdown               │
│                                     │
│  [Reset to preset defaults]         │
│  [Deactivate this preset]           │
│                                     │
└─────────────────────────────────────┘
```

**Rules for presets:**
- Every toggle is visible. No hidden behaviour.
- Toggles changed from preset defaults show a small dot (•) to indicate customisation.
- "Reset to preset defaults" restores the original preset configuration.
- Deactivating a preset turns off all its toggles (unless another active preset also uses them).
- Multiple presets can be active simultaneously.
- Conflicting toggles are resolved by the rule: **more protective setting wins.**

---

### 4.3 Sensitivity Toggles

Individual toggles available outside of any preset.

```
┌─────────────────────────────────────┐
│  ← Settings    SENSITIVITY TOGGLES  │
├─────────────────────────────────────┤
│                                     │
│  Fine-tune how the app behaves.     │
│  These work with or without a       │
│  Support Preset.                    │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  NOTIFICATION SENSITIVITY           │
│  ☑ Digest mode default             │
│  ☐ Reduce all notifications        │
│  ☐ Increase reminders              │
│  ☐ Real-time urgent only           │
│  ☐ Quiet hours (set time range)    │
│  ☐ No sound                        │
│  ☐ No vibration                    │
│  ☐ Visual alerts only              │
│                                     │
│  LANGUAGE SENSITIVITY               │
│  ☑ Plain language                  │
│  ☐ Extra direct language           │
│  ☐ Gentle language                 │
│  ☐ No shame-based wording          │
│  ☐ No diet/body language           │
│  ☐ No clinical labels              │
│  ☐ No "should" wording             │
│  ☐ No productivity pressure        │
│  ☐ Trauma-informed wording         │
│  ☐ Short prompts only              │
│  ☐ Detailed explanations           │
│                                     │
│  SENSORY SENSITIVITY                │
│  ☐ Disable animations              │
│  ☐ Reduce motion                   │
│  ☐ Reduce sound                    │
│  ☐ Reduce haptics                  │
│  ☐ Low-stim theme                  │
│  ☐ High contrast                   │
│  ☐ Soft contrast                   │
│  ☐ No flashing                     │
│  ☐ No confetti/celebrations        │
│  ☐ Simplified dashboard            │
│  ☐ Fewer badges/alerts             │
│                                     │
│  COGNITIVE LOAD SENSITIVITY         │
│  ☑ One next step                   │
│  ☐ Hide non-urgent items           │
│  ☐ Visual steps                    │
│  ☐ Checklists                      │
│  ☐ Short summaries                 │
│  ☐ "Explain this simply"           │
│  ☐ Memory prompts                  │
│  ☐ Routine support                 │
│  ☐ Fewer choices                   │
│  ☐ Default to one recommendation   │
│  ☐ Keep original messy capture     │
│                                     │
│  FOOD / BODY SENSITIVITY            │
│  ☐ Avoid calories                  │
│  ☐ Hide weight                     │
│  ☐ No good/bad food language       │
│  ☐ No diet culture language        │
│  ☐ No weight-loss prompts          │
│  ☐ No exercise-as-punishment       │
│  ☐ Neutral meal reminders          │
│  ☐ Safe foods list                 │
│  ☐ Sensory foods support           │
│  ☐ ARFID support                   │
│  ☐ Distress-after-meals support    │
│                                     │
│  COMMUNICATION SENSITIVITY          │
│  ☐ Pause before sending            │
│  ☐ Require confirmation to send    │
│  ☐ Cooling-off timer               │
│  ☐ Draft only, don't send          │
│  ☐ One draft, not five             │
│  ☐ Tone check                      │
│  ☐ Conflict de-escalation          │
│  ☐ Repair prompt                   │
│  ☐ Trusted-person check-in         │
│  ☐ Hide message suggestions during │
│    overwhelm                        │
│                                     │
│  FINANCIAL SENSITIVITY              │
│  ☐ Require confirmation to spend   │
│  ☐ Delay big financial decisions   │
│  ☐ Avoid shame spending language   │
│  ☐ Bare-minimum budget mode        │
│  ☐ Bill warning mode               │
│  ☐ Sinking fund suggestions        │
│  ☐ Visual budget bars              │
│  ☐ Simplified numbers              │
│  ☐ Reduce impulse-purchase prompts │
│                                     │
│  HEALTH SENSITIVITY                 │
│  ☐ Medication reminders            │
│  ☐ Appointment prep                │
│  ☐ Symptom logging                 │
│  ☐ Doctor export                   │
│  ☐ Low-energy mode                 │
│  ☐ Flare mode                      │
│  ☐ Pain day mode                   │
│  ☐ Migraine mode                   │
│  ☐ Post-seizure mode               │
│  ☐ Pregnancy/postpartum sensitivity│
│                                     │
│  PRIVACY SENSITIVITY                │
│  ☐ Hide sensitive notes            │
│  ☐ Require app lock                │
│  ☐ Private chat mode               │
│  ☐ Exclude from AI summaries       │
│  ☐ Exclude from partner sharing    │
│  ☐ Hide from dashboard             │
│  ☐ Visible only to user            │
│  ☐ Auto-delete after set period    │
│                                     │
│  [Reset all toggles to off]         │
│                                     │
└─────────────────────────────────────┘
```

**Toggle behaviour:**
- Toggles active from a Support Preset show a small preset icon (📦) next to them.
- Toggling a preset-managed toggle off customises that preset (the • dot appears).
- Toggles turned on manually (outside any preset) show no preset icon.
- All toggles are searchable via a search bar at the top.

---

### 4.4 Current State

Temporary overrides activated based on how the user is doing right now.

```
┌─────────────────────────────────────┐
│  ← Settings       CURRENT STATE     │
├─────────────────────────────────────┤
│                                     │
│  Activate a temporary state.        │
│  The app will adjust until you      │
│  turn it off or the timer expires.  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  CURRENT STATE: None                │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  EMOTIONAL STATES                   │
│  ┌─────────────────────────────┐   │
│  │ 😰 I'm overwhelmed          │   │
│  │ 😨 I'm panicking            │   │
│  │ 🌫 I'm dissociating         │   │
│  │ 💥 I'm triggered            │   │
│  │ 😡 I'm in shutdown/meltdown │   │
│  │ 🧠 I'm having intrusive     │   │
│  │    thoughts                 │   │
│  │ 🆘 I need human support     │   │
│  └─────────────────────────────┘   │
│                                     │
│  PHYSICAL STATES                    │
│  ┌─────────────────────────────┐   │
│  │ 🩹 I'm in pain              │   │
│  │ 🥱 I'm exhausted            │   │
│  │ 😴 I'm sleep deprived       │   │
│  │ 🤒 I'm sick                 │   │
│  │ 🤕 Migraine mode            │   │
│  │ 🔥 Flare day                │   │
│  │ ⚡ Post-seizure recovery    │   │
│  └─────────────────────────────┘   │
│                                     │
│  LIFE STATES                        │
│  ┌─────────────────────────────┐   │
│  │ 💔 Grief day                │   │
│  │ ⚠ Relapse risk              │   │
│  │ 📉 Low energy               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Timer (optional):                  │
│  ○ Until I turn it off             │
│  ● [2] hours                        │
│  ○ [4] hours                        │
│  ○ Rest of day                      │
│                                     │
│  [Activate]                         │
│                                     │
└─────────────────────────────────────┘
```

**Current State behaviour:**
- Activating a state temporarily overrides normal app behaviour.
- Example: "Overwhelmed" → hides non-urgent tasks, reduces notifications, shows one next step, surfaces grounding tools.
- Timer auto-expires. User can also manually deactivate.
- Current State appears on the Dashboard as a coloured bar below the Status Shield.
- Integrates with Status Shield: "Overwhelmed" auto-sets to Heads Down.
- Integrates with Notifications: non-urgent notifications are suppressed.
- Integrates with Tasks: Bare Minimums are emphasised, everything else is hidden.
- If a Support Preset has a Current State shortcut (e.g., ADHD preset → "Overwhelmed" shortcut), that state appears at the top of the Current State screen as "Quick access."

---

## 5. ACCESSIBILITY

System-wide accessibility settings. Available to all users regardless of Support Presets.

```
┌─────────────────────────────────────┐
│  ← Settings        ACCESSIBILITY    │
├─────────────────────────────────────┤
│                                     │
│  VISUAL                             │
│  ┌─────────────────────────────┐   │
│  │ Font: [System default ▼]   │   │
│  │ Font size: [Medium] ··●··  │   │
│  │ Line spacing: [Standard ▼] │   │
│  │ ☐ OpenDyslexic font         │   │
│  │ ☐ High contrast              │   │
│  │ ☐ Soft contrast              │   │
│  │ ☐ Reduced motion             │   │
│  │ ☐ Disable animations         │   │
│  │ ☐ No flashing/strobing       │   │
│  │ ☐ Colour overlays            │   │
│  │    Tint: [None ▼]           │   │
│  │ ☐ Large buttons              │   │
│  │ ☐ Simplified dashboard       │   │
│  └─────────────────────────────┘   │
│                                     │
│  AUDIO                              │
│  ┌─────────────────────────────┐   │
│  │ ☐ Silent mode                │   │
│  │ ☐ Vibration only             │   │
│  │ ☐ Visual alerts for audio    │   │
│  │ ☐ Captions for all media     │   │
│  │ ☐ No sharp alert tones       │   │
│  └─────────────────────────────┘   │
│                                     │
│  INTERACTION                        │
│  ┌─────────────────────────────┐   │
│  │ ☐ Screen reader optimised    │   │
│  │ ☐ Voice input prioritised    │   │
│  │ ☐ Text-to-speech by default  │   │
│  │ ☐ One-handed mode            │   │
│  │ ☐ Reduced precision input    │   │
│  │ ☐ Switch access support      │   │
│  │ ☐ Keyboard navigation        │   │
│  └─────────────────────────────┘   │
│                                     │
│  COGNITIVE                          │
│  ┌─────────────────────────────┐   │
│  │ ☐ Plain language by default  │   │
│  │ ☐ Simplified text mode       │   │
│  │ ☐ One step at a time         │   │
│  │ ☐ Confirm before destructive │   │
│  │    actions                   │   │
│  │ ☐ Undo available (30 sec)    │   │
│  │ ☐ Reduced choices            │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Reset to defaults]               │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. CALENDAR SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings     CALENDAR SETTINGS   │
├─────────────────────────────────────┤
│                                     │
│  DEFAULT VIEW                       │
│  ○ Month                           │
│  ● Week                            │
│  ○ Day                             │
│  ○ Agenda                          │
│                                     │
│  WEEK STARTS ON                     │
│  ● Monday                          │
│  ○ Sunday                          │
│                                     │
│  WORKING HOURS                      │
│  Start: [07:00]                    │
│  End:   [18:00]                    │
│  ☐ Show only during working hours  │
│                                     │
│  BUFFER TIME                        │
│  Default buffer between events:     │
│  [15 minutes ▼]                    │
│                                     │
│  CONFLICT DETECTION                 │
│  ☑ Warn if events overlap          │
│  ☐ Block overlapping events        │
│                                     │
│  SCHEDULE PROTECTOR                 │
│  ☐ Block new events when week      │
│    is overloaded                    │
│  Max events per day: [5]           │
│                                     │
│  CYCLE OVERLAY                      │
│  ☑ Show cycle phases on calendar   │
│  ☐ Show fertility window           │
│                                     │
│  FAMILY CALENDAR                    │
│  Default visible categories:        │
│  ☑ Beth                            │
│  ☑ Ant                             │
│  ☑ Evander                         │
│  ☑ Theodore                        │
│  ☑ Annabella                       │
│  ☑ Family                          │
│  ☐ Pets                            │
│  ☐ School                          │
│  ☐ Medical                         │
│                                     │
│  [Reset to defaults]               │
│                                     │
└─────────────────────────────────────┘
```

---

## 7. EVENT CATEGORIES

```
┌─────────────────────────────────────┐
│  ← Settings      EVENT CATEGORIES   │
├─────────────────────────────────────┤
│                                     │
│  Categories colour-code your        │
│  calendar and filter views.         │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  👶 Evander     ● Soft blue  [Edit] │
│  👤 Ant         ● Deep green [Edit] │
│  👤 Beth        ● Warm amber [Edit] │
│  👨‍👩‍👦 Family      ● Soft purple[Edit] │
│  💼 Work        ● Orange     [Edit] │
│  👥 Parents     ● Teal       [Edit] │
│  🎉 Social      ● Pink       [Edit] │
│  🐾 Pets        ● Brown      [Edit] │
│  🏫 School      ● Navy       [Edit] │
│  🏥 Medical     ● Red        [Edit] │
│                                     │
│  [+ Add category]                  │
│                                     │
│  Maximum 15 categories.             │
│                                     │
└─────────────────────────────────────┘
```

Tapping "Edit" or "+ Add category" opens:

```
┌─────────────────────────────────────┐
│  ← Categories     EDIT CATEGORY     │
├─────────────────────────────────────┤
│                                     │
│  Name: [Evander_______________]     │
│                                     │
│  Icon: 👶 [Change ▼]               │
│                                     │
│  Colour: ● ● ● ● ● ● ● ●           │
│          Soft blue (selected)        │
│                                     │
│  Appears in:                        │
│  ☑ Calendar                        │
│  ☑ Event filters                   │
│  ☐ Family Hub                      │
│                                     │
│  [Delete category]                  │
│                                     │
│  [Cancel]              [Save]       │
└─────────────────────────────────────┘
```

---

## 8. NOTIFICATIONS SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings    NOTIFICATION SETTINGS│
├─────────────────────────────────────┤
│                                     │
│  DELIVERY MODE                      │
│  ○ Real-Time — Send as they happen  │
│  ○ Digest — Batched summaries       │
│  ● Hybrid — Urgent real-time,       │
│    rest in digest (recommended)     │
│                                     │
│  DIGEST SETTINGS                    │
│  Digest time: [07:00 AM]           │
│  ☐ Second digest: [06:00 PM]       │
│                                     │
│  QUIET HOURS                        │
│  ☑ Enabled                         │
│  Start: [09:00 PM]                 │
│  End:   [07:00 AM]                 │
│  ☑ Allow urgent during quiet hours │
│                                     │
│  URGENT OVERRIDE                    │
│  ☑ Urgent notifications always     │
│    bypass digest and quiet hours    │
│                                     │
│  NOTIFICATION TYPES                 │
│  ☑ Calendar reminders              │
│  ☑ Task deadlines                  │
│  ☑ Medication reminders            │
│  ☑ Family updates                  │
│  ☑ Budget alerts                   │
│  ☐ Meal suggestions                │
│  ☐ Resource updates                │
│  ☐ Team activity                   │
│                                     │
│  PARTNER NOTIFICATIONS              │
│  ☐ Share urgent notifications      │
│    with Ant                         │
│                                     │
│  [Reset to defaults]               │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. STATUS SHIELD SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings     STATUS SHIELD       │
├─────────────────────────────────────┤
│                                     │
│  Status Shield lets your team       │
│  know if you're open to input       │
│  or need focus time.               │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  DEFAULT STATE                      │
│  ● Open to leads                   │
│  ○ Heads down                      │
│                                     │
│  AUTO-EXPIRY                        │
│  ● Rest of day                     │
│  ○ Custom: [4] hours               │
│  ○ Until I turn it off             │
│                                     │
│  VOICE COMMANDS                     │
│  ☑ "Heads down" / "Open to leads" │
│                                     │
│  CURRENT STATE INTEGRATION          │
│  ☑ "Overwhelmed" → Heads down     │
│  ☑ "Low energy" → Heads down       │
│  ☑ "Migraine mode" → Heads down    │
│                                     │
│  SHARING                            │
│  ☑ Share status with household     │
│  ☐ Share status with team instances│
│                                     │
└─────────────────────────────────────┘
```

---

## 10. FAMILY HUB SETTINGS — INCLUDING ADDING & DELETING FAMILY/PETS

This is the section you specifically asked about.

```
┌─────────────────────────────────────┐
│  ← Settings    FAMILY HUB SETTINGS  │
├─────────────────────────────────────┤
│                                     │
│  PEOPLE                             │
│  ┌─────────────────────────────┐   │
│  │ 👤 Beth · You               │   │
│  │ 👤 Ant · Partner      [Edit]│   │
│  │ 👶 Evander · 5mo      [Edit]│   │
│  │ 👦 Theodore · 13y     [Edit]│   │
│  │ 👧 Annabella · 16y    [Edit]│   │
│  │                             │   │
│  │ [+ Add person]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  PETS                               │
│  ┌─────────────────────────────┐   │
│  │ 🐱 Jaeger · Cat      [Edit] │   │
│  │ 🐱 Rook · Cat        [Edit] │   │
│  │                             │   │
│  │ [+ Add pet]                 │   │
│  └─────────────────────────────┘   │
│                                     │
│  DEFAULT FEATURES FOR NEW CHILDREN  │
│  ☑ Medication tracker              │
│  ☑ Calendar integration            │
│  ☑ Task list                       │
│  ☐ School hub (if school-aged)     │
│                                     │
│  DEFAULT FEATURES FOR NEW PETS      │
│  ☑ Care tasks                      │
│  ☑ Medication tracker              │
│  ☑ Vet records                     │
│  ☑ Supplies tracking               │
│                                     │
│  HOUSEHOLD                          │
│  Household name: [The Clulows___]   │
│                                     │
└─────────────────────────────────────┘
```

### 10.1 Adding a Person

From the "Add person" button:

```
┌─────────────────────────────────────┐
│  ← Settings        ADD A PERSON     │
├─────────────────────────────────────┤
│                                     │
│  Who are you adding?                │
│                                     │
│  [Child]  [Partner]  [Other adult]  │
│                                     │
│  ─── or ───                         │
│                                     │
│  Relationship: [Select ▼]           │
│  · Partner / Spouse                 │
│  · Child                            │
│  · Parent                           │
│  · Sibling                          │
│  · Housemate                        │
│  · Carer                            │
│  · Other family                     │
│  · Other                            │
│                                     │
│  [Next]                             │
└─────────────────────────────────────┘
```

If "Child" is selected → the Add Child flow (detailed in Children's Section spec).

If "Partner" or "Other adult" is selected:

```
┌─────────────────────────────────────┐
│  ← Add Person    PARTNER / ADULT    │
├─────────────────────────────────────┤
│                                     │
│  Photo (optional)      [📷]         │
│                                     │
│  Full name: [___________________]   │
│                                     │
│  Preferred name: [_______________]  │
│                                     │
│  Relationship: Partner              │
│                                     │
│  ☐ This person has their own       │
│    Tether account (connect later)   │
│                                     │
│  Features to enable:                │
│  ☑ Shared calendar                 │
│  ☑ Shared tasks                    │
│  ☑ Shared budget                   │
│  ☐ Relationship check-ins          │
│  ☐ Support prompts                 │
│                                     │
│  Notes: [_______________________]   │
│                                     │
│  [Cancel]              [Save]       │
└─────────────────────────────────────┘
```

### 10.2 Adding a Pet

```
┌─────────────────────────────────────┐
│  ← Settings         ADD A PET       │
├─────────────────────────────────────┤
│                                     │
│  Photo (optional)      [📷]         │
│                                     │
│  Name: [_________________________]  │
│                                     │
│  Species: [Cat ▼]                   │
│           Cat / Dog / Bird / Fish   │
│           Reptile / Small mammal    │
│           Other                     │
│                                     │
│  Breed (optional): [_____________]  │
│                                     │
│  Date of birth / approx age:        │
│  [YYYY] or [X years]               │
│                                     │
│  Features to enable:                │
│  ☑ Care tasks                      │
│  ☑ Medication tracker              │
│  ☑ Vet records                     │
│  ☑ Supplies tracking               │
│  ☑ Calendar integration            │
│                                     │
│  Notes: [_______________________]   │
│                                     │
│  [Cancel]              [Save]       │
└─────────────────────────────────────┘
```

### 10.3 Editing a Person or Pet

Tapping "Edit" on any person or pet opens their profile for editing. All fields are editable except DOB (which has implications for age group and privacy).

### 10.4 Deleting a Person or Pet

At the bottom of each Edit screen:

```
┌─────────────────────────────────────┐
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Delete Evander's profile]         │
│                                     │
│  This will remove all of Evander's  │
│  data, including medication logs,   │
│  feeding records, growth notes,     │
│  and activity history.              │
│                                     │
│  This cannot be undone.             │
│                                     │
│  [Cancel]         [Delete profile]  │
│                                     │
└─────────────────────────────────────┘
```

**Deletion rules:**
- Deleting a child profile removes all their data permanently. Warning is explicit about what will be lost.
- Deleting a pet profile removes all their data permanently.
- Deleting a partner or other adult removes their profile from your Family Hub but does not delete their own Tether account (if they have one). The connection is severed.
- Deleting the last child profile does not delete the Children sub-section. It remains empty, ready for future additions.
- A confirmation dialogue is required. "Delete [name]" must be typed or a secondary confirmation button pressed.
- Data export is offered before deletion: "Would you like to export [name]'s data before deleting?"

---

## 11. BUDGET SETTINGS

```
┌─────────────────────────────────────┐
│  ← Settings       BUDGET SETTINGS   │
├─────────────────────────────────────┤
│                                     │
│  BUDGET PERIOD                      │
│  ● Fortnightly                     │
│  ○ Monthly                          │
│                                     │
│  CURRENCY                           │
│  AUD ($)                           │
│                                     │
│  TIM (BUDGET AI)                    │
│  Personalise Tim:                   │
│  ☑ Spending alerts                 │
│  ☑ Savings suggestions             │
│  ☑ Bill reminders                  │
│  ☐ Cheaper alternatives            │
│  ☐ Subscription review             │
│                                     │
│  SINKING FUNDS                      │
│  ☑ Show sinking fund progress      │
│    on dashboard                     │
│                                     │
│  FINANCIAL SENSITIVITY              │
│  ☐ Require confirmation to spend   │
│  ☐ Delay big financial decisions   │
│  ☐ Bare-minimum budget mode        │
│  ☐ Simplified numbers              │
│  ☐ Visual budget bars only         │
│                                     │
│  SHARING                            │
│  ☑ Share budget with Ant           │
│  Shared categories: [Configure]     │
│                                     │
└─────────────────────────────────────┘
```

---

## 12. TASK DEFAULTS

```
┌─────────────────────────────────────┐
│  ← Settings        TASK DEFAULTS    │
├─────────────────────────────────────┤
│                                     │
│  DEFAULT PRIORITY                   │
│  ○ Urgent                           │
│  ● Important                        │
│  ○ Routine                          │
│                                     │
│  DEFAULT SNOOZE                     │
│  ● Tonight                          │
│  ○ Tomorrow                         │
│  ○ This weekend                     │
│                                     │
│  TASK LAYERS SHOWN                  │
│  ☑ Bare Minimums                   │
│  ☑ Personal Care                    │
│  ☑ House Tasks                      │
│  ☑ Care Tasks                       │
│  ☑ Life Admin                       │
│  ☐ Recovery Tasks                   │
│                                     │
│  ACTIVE TASK PACKS                  │
│  ┌─────────────────────────────┐   │
│  │ 🍼 New parent survival  [✓] │   │
│  │ 🏠 House reset           [ ] │   │
│  │ 🐾 Pet care              [✓]│   │
│  │ 🌙 Night shift worker    [ ]│   │
│  │                             │   │
│  │ [Browse task packs]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ENERGY GAUGE                       │
│  ☑ Enable energy tagging on tasks  │
│  Default energy level: [Medium ▼]  │
│                                     │
│  AI DELEGATION                      │
│  ☑ Allow task assignment to        │
│    AI instances                     │
│                                     │
│  LANGUAGE                           │
│  ☑ Shame-free language (always on) │
│                                     │
└─────────────────────────────────────┘
```

---

## 13. SHARING & PRIVACY

```
┌─────────────────────────────────────┐
│  ← Settings     SHARING & PRIVACY   │
├─────────────────────────────────────┤
│                                     │
│  HOUSEHOLD ROLES & PERMISSIONS      │
│  ┌─────────────────────────────┐   │
│  │ 👤 Beth · Owner/Admin       │   │
│  │ 👤 Ant · Partner     [Edit]│   │
│  └─────────────────────────────┘   │
│                                     │
│  DATA SENSITIVITY DEFAULTS          │
│  D1 (Low): Standard handling        │
│  D2 (Medium): Standard handling     │
│  D3 (High): Stricter sharing rules  │
│  D4 (Very High): Strictest controls │
│                                     │
│  SHARED DATA                        │
│  ┌─────────────────────────────┐   │
│  │ Calendar      [Configure]  │   │
│  │ Tasks         [Configure]  │   │
│  │ Budget        [Configure]  │   │
│  │ Children      [Configure]  │   │
│  │ Health        [Configure]  │   │
│  │ Pets          [Configure]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  TEEN PRIVACY                        │
│  ┌─────────────────────────────┐   │
│  │ Theodore (13)   [Configure] │   │
│  │ Annabella (16)  [Configure] │   │
│  └─────────────────────────────┘   │
│                                     │
│  APP LOCK                           │
│  ☐ Require PIN / biometric to open │
│                                     │
│  PRIVACY MODE                       │
│  ☐ Hide sensitive notifications    │
│    on lock screen                   │
│                                     │
└─────────────────────────────────────┘
```

Tapping "Configure" on a data type opens granular sharing:

```
┌─────────────────────────────────────┐
│  ← Sharing        CALENDAR SHARING  │
├─────────────────────────────────────┤
│                                     │
│  Share with Ant:                    │
│  ☑ All calendar events             │
│  ● Only selected categories:        │
│    ☑ Family                         │
│    ☑ Evander                        │
│    ☑ Theodore                       │
│    ☑ Annabella                      │
│    ☑ Pets                           │
│    ☐ Beth (personal)               │
│    ☐ Work                           │
│    ☐ Social                         │
│    ☐ Medical                        │
│                                     │
│  Ant can:                           │
│  ☑ View events                     │
│  ☑ Edit events                     │
│  ☑ Create events                   │
│                                     │
│  [Share all]  [Stop sharing]       │
│                                     │
└─────────────────────────────────────┘
```

---

## 14. INSTANCE PERSONALISATION

```
┌─────────────────────────────────────┐
│  ← Settings  INSTANCE PERSONALISE   │
├─────────────────────────────────────┤
│                                     │
│  Select an instance to personalise: │
│                                     │
│  🛡 Viva · Chief of Staff     [>]  │
│  📅 Val · Schedule Manager    [>]  │
│  💬 Ellory · Correspondence   [>]  │
│  💼 Joss · Employment         [>]  │
│  🔍 Hugh · Research           [>]  │
│  🌙 Sable · Dream Architect   [>]  │
│  ✨ Marlowe · Creative Editor [>]  │
│  🩺 Rae · Nurse Debrief       [>]  │
│  🎲 Kael · Dungeon Master     [>]  │
│  💰 Tim · Budget Manager      [>]  │
│                                     │
│  [Add new instance]                │
│  [Browse instance library]          │
│                                     │
└─────────────────────────────────────┘
```

Tapping an instance opens:

```
┌─────────────────────────────────────┐
│  ← Instances     EDIT — VIVA        │
├─────────────────────────────────────┤
│                                     │
│  Display name: [Viva_____________]  │
│                                     │
│  Pronouns: [she/her ▼]             │
│                                     │
│  Personality:                        │
│  Warmth:    [····●····] 80%        │
│  Formality: [··●······] 40%        │
│  Playfulness:[···●····] 60%        │
│  Directness: [··●······] 50%        │
│                                     │
│  Voice tone: [Warm & professional ▼]│
│                                     │
│  Appearance:                         │
│  Avatar style: [Illustrated ▼]      │
│  Wardrobe: [Smart casual ▼]        │
│  Colour palette: [Deep purple & gold]│
│                                     │
│  Core memory:                        │
│  [Created by Beth. I am her Chief  │
│   of Staff. I oversee the team,    │
│   provide companionship, and keep   │
│   everything running smoothly...]   │
│                                     │
│  [Save]  [Reset to default]         │
│                                     │
└─────────────────────────────────────┘
```

---

## 15. DATA EXPORT & DELETE

```
┌─────────────────────────────────────┐
│  ← Settings   DATA EXPORT & DELETE  │
├─────────────────────────────────────┤
│                                     │
│  EXPORT YOUR DATA                   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 Calendar events    [JSON]│   │
│  │ 📋 Tasks              [JSON]│   │
│  │ 💬 Chat history       [JSON]│   │
│  │ 📝 Notes & captures   [JSON]│   │
│  │ 💊 Medication logs    [JSON]│   │
│  │ 📊 Budget data        [JSON]│   │
│  │ 🏠 Family Hub data    [JSON]│   │
│  │ 📋 Full Report history[JSON]│   │
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
│  │ [Delete account & all data]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⚠ Deletion is permanent.           │
│    Export your data first if you     │
│    want to keep a copy.             │
│                                     │
└─────────────────────────────────────┘
```

---

## 16. SETTINGS INTERACTION SUMMARY

How the major systems interact:

| System A | System B | Interaction |
|----------|----------|-------------|
| **Support Presets** | **Sensitivity Toggles** | Activating a preset turns on a bundle of toggles. User can then individually adjust. |
| **Support Presets** | **Current State** | Presets can include Current State shortcuts. Current State overrides preset behaviour temporarily. |
| **Current State** | **Status Shield** | Certain states auto-set the Shield (Overwhelmed → Heads Down). |
| **Current State** | **Notifications** | Non-urgent notifications suppressed during most states. |
| **Current State** | **Tasks** | Bare Minimums emphasised. Everything else hidden or reduced. |
| **Sensitivity Toggles** | **Notifications** | Toggles like "Reduce notifications" directly affect notification delivery. |
| **Sensitivity Toggles** | **Language** | Toggles like "No shame-based wording" affect all AI instance language globally. |
| **Family Hub** | **Calendar** | Person categories added to calendar. Events auto-categorised. |
| **Family Hub** | **Tasks** | Care tasks, chores, and Bare Minimums populated from household members. |
| **Family Hub** | **Budget** | Shared budget categories. Grocery budget feeds into Meals. |
| **Family Hub** | **Meals** | Number of people, ages, allergies, dietary needs pulled from profiles. |
| **Accessibility** | **All modules** | System-wide visual, audio, interaction, and cognitive adjustments. |
| **Sharing & Privacy** | **All modules** | Controls who sees what. Data sensitivity levels (D1-D4) govern sharing rules. |
| **Instance Personalisation** | **Team** | Changes to instance personality, appearance, and core memory reflected immediately. |

---

That's the complete Settings specification. Every module, every mode, every interaction, and full detail on adding and deleting family members and pets.
