# TETHER — MODULE 10: MENTAL HEALTH & REGULATION TOOLKIT
## Complete Design Specification

**Module:** Mental Health & Regulation Toolkit
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟠 (D3; D4 for crisis plans, self-harm/suicidal ideation logs)
**Phase:** 1D (basic tools — grounding, breathing, crisis plan, worry log) → 2B (full toolkit — all tools, therapy integration, full state responsiveness)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT THE MENTAL HEALTH & REGULATION TOOLKIT IS

This module is a collection of tools for emotional regulation, mental health support, crisis planning, and therapy integration. It is NOT one big "Mental Health Mode." It is a toolkit. Beth chooses which tools she uses, when she uses them, and how.

It answers the question: *"What do I need right now to feel steadier?"*

The toolkit does not diagnose. It does not treat. It does not replace professional mental healthcare. It is a support layer — scaffolding, not a substitute for a psychologist, psychiatrist, or crisis service.

Seizure-related features live in Health Status (Neurology), not here. The Pleasure Log placement is still to be decided (possibly Sexual Wellbeing, Relationships/Intimacy, or Wellbeing).

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Tools, not diagnoses** | The module offers tools. It does not label the user. "You've turned on grounding tools" — not "Because you have PTSD." |
| **Crisis-aware, not crisis-driven** | Crisis resources are always accessible. But the module does not assume crisis. It supports everyday regulation, not just emergencies. |
| **Privacy is sacrosanct** | Crisis plans, self-harm logs, and therapy notes are D4 (Very High sensitivity). They are not shared. They are not exported without explicit, deliberate action. They are not visible on the Dashboard unless the user chooses. |
| **No AI diagnosis. No AI treatment.** | The AI instances in the team do not diagnose, interpret symptoms, or recommend treatments. Rae (Nurse Debrief) listens and reflects. She does not advise. The toolkit provides tools, not clinical guidance. |
| **Always accessible, never pushed** | Tools are available from the Dashboard (if the user has surfaced them), from the Current State selector, and from this module. They are never forced. No "You seem anxious — would you like to try a breathing exercise?" unless the user has enabled proactive suggestions. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 🧠 Mental Health Toolkit (once added from Module Management).
**From Dashboard:** If the user has surfaced specific tools (grounding, breathing) on their Dashboard quick-access area.
**From Current State:** Activating "Panicking," "Overwhelmed," "Triggered," or "Dissociating" can open relevant tools directly.
**From Team:** Chatting with Rae (Nurse Debrief) can link to toolkit resources.
**From Reproductive Health:** Postpartum mental health links here.

---

## 4. TOOLKIT MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard   🧠 MENTAL HEALTH     │
│               & REGULATION TOOLKIT   │
├─────────────────────────────────────┤
│                                     │
│  These are tools for when you need  │
│  them. Nothing here labels you.     │
│  Nothing here diagnoses you. Pick   │
│  what helps. Leave the rest.        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🛡 CRISIS & SAFETY            │   │
│  │                             │   │
│  │ Crisis / Safety Plan   [>] │   │
│  │ Trusted Contact        [>] │   │
│  │ Emergency Resources    [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧘 GROUNDING & CALMING       │   │
│  │                             │   │
│  │ Grounding Tools (5-4-3-2-1)│   │
│  │ Breathing Exercises    [>] │   │
│  │ Safe Place Visualisation[>]│   │
│  │ Orientation Card        [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 LOGS & TRACKING           │   │
│  │                             │   │
│  │ Worry Log              [>] │   │
│  │ Mood Tracker           [>] │   │
│  │ Trigger Log            [>] │   │
│  │ Intrusive Thought Log  [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⏱ REGULATION TOOLS          │   │
│  │                             │   │
│  │ Urge Surfing Timer     [>] │   │
│  │ Cooling-Off Timer      [>] │   │
│  │ Relapse Prevention Plan[>]│   │
│  │ Sobriety Tracker       [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💆 STATE SUPPORT             │   │
│  │                             │   │
│  │ Panic Support           [>] │   │
│  │ Dissociation Support    [>] │   │
│  │ Grief Day Mode          [>] │   │
│  │ Low-Capacity Mode       [>] │   │
│  │ Emotional Regulation    [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👤 CONNECTION                │   │
│  │                             │   │
│  │ Trusted Contact Check-In[>]│   │
│  │ Therapy Notes           [>] │   │
│  │ GP/Psych Discussion     [>] │   │
│  │ Rae (Nurse Debrief)     [>] │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. CRISIS & SAFETY

### 5.1 Crisis / Safety Plan

```
┌─────────────────────────────────────┐
│  ← Toolkit    🛡 CRISIS/SAFETY PLAN │
├─────────────────────────────────────┤
│                                     │
│  This plan is for you. It is not    │
│  shared with anyone unless you      │
│  choose to.                         │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 1. WARNING SIGNS             │   │
│  │ I know I'm struggling when:  │   │
│  │ · I stop responding to       │   │
│  │   messages                   │   │
│  │ · I feel numb or empty       │   │
│  │ · I have thoughts of         │   │
│  │   harming myself             │   │
│  │ [Edit]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 2. COPING STRATEGIES         │   │
│  │ Things I can do alone:       │   │
│  │ · Grounding (5-4-3-2-1)     │   │
│  │ · Hold ice cubes             │   │
│  │ · Breathe — box breathing    │   │
│  │ · Write in my notes app      │   │
│  │ [Edit]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 3. PEOPLE I CAN CONTACT      │   │
│  │ · Ant — 04XX XXX XXX        │   │
│  │ · Mum — 04XX XXX XXX        │   │
│  │ · Rae (Nurse Debrief)       │   │
│  │ [Edit]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 4. PROFESSIONAL SUPPORT      │   │
│  │ · GP: Dr Sarah Chen         │   │
│  │ · Psychologist: [Name]      │   │
│  │ [Edit]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 5. EMERGENCY CONTACTS        │   │
│  │ · Lifeline: 13 11 14        │   │
│  │ · Suicide Call Back:        │   │
│  │   1300 659 467              │   │
│  │ · 000 (Ambulance/Police)    │   │
│  │ · Cairns Hospital ED        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 6. MAKING MY ENVIRONMENT SAFE│   │
│  │ · [User's own notes]        │   │
│  │ [Edit]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⚠ This plan is stored locally.    │
│  It is not shared. It is not        │
│  visible to anyone else unless      │
│  you choose to share it.            │
│                                     │
└─────────────────────────────────────┘
```

**Crisis plan privacy:**
- D4 (Very High sensitivity).
- Stored locally. Not synced to cloud unless the user explicitly enables backup.
- Not shared with partner, family, or AI instances without explicit opt-in.
- The user can choose to make it accessible from the Dashboard with one tap.

### 5.2 Trusted Contact

A quick-access button that can be placed on the Dashboard. Tapping it opens a pre-written message to a trusted person.

```
┌─────────────────────────────────────┐
│  ← Toolkit    👤 TRUSTED CONTACT    │
├─────────────────────────────────────┤
│                                     │
│  Send a message to:                 │
│  [Ant ▼]                            │
│                                     │
│  Pre-written messages:              │
│  ┌─────────────────────────────┐   │
│  │ "I'm struggling. Can you    │   │
│  │  check in on me?"      [>] │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ "I need space. I'll reach   │   │
│  │  out when I'm ready."  [>] │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ "Can you sit with me? I     │   │
│  │  don't need to talk."  [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Or write your own:                 │
│  [______________________________]   │
│  [Send]                             │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. GROUNDING & CALMING

### 6.1 Grounding Tools (5-4-3-2-1)

```
┌─────────────────────────────────────┐
│  ← Toolkit    🧘 GROUNDING          │
├─────────────────────────────────────┤
│                                     │
│  5-4-3-2-1 Grounding Exercise       │
│                                     │
│  👁 SEE: Name 5 things you can see  │
│  ┌─────────────────────────────┐   │
│  │ 1. [___________________]    │   │
│  │ 2. [___________________]    │   │
│  │ 3. [___________________]    │   │
│  │ 4. [___________________]    │   │
│  │ 5. [___________________]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ✋ TOUCH: Name 4 things you can    │
│  feel                                │
│  ┌─────────────────────────────┐   │
│  │ 1. [___________________]    │   │
│  │ 2. [___________________]    │   │
│  │ 3. [___________________]    │   │
│  │ 4. [___________________]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  👂 HEAR: Name 3 things you can     │
│  hear                                │
│  ┌─────────────────────────────┐   │
│  │ 1. [___________________]    │   │
│  │ 2. [___________________]    │   │
│  │ 3. [___________________]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  👃 SMELL: Name 2 things you can    │
│  smell                               │
│  ┌─────────────────────────────┐   │
│  │ 1. [___________________]    │   │
│  │ 2. [___________________]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  👅 TASTE: Name 1 thing you can     │
│  taste                               │
│  ┌─────────────────────────────┐   │
│  │ 1. [___________________]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  Take a slow breath. You're here.   │
│  You're safe. This feeling will     │
│  pass.                              │
│                                     │
└─────────────────────────────────────┘
```

The grounding tool guides Beth through each step. She can type her answers or just think them. There's no "submit" — it's a guide, not a test.

### 6.2 Breathing Exercises

```
┌─────────────────────────────────────┐
│  ← Toolkit    🫁 BREATHING          │
├─────────────────────────────────────┤
│                                     │
│  Select an exercise:                │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📦 BOX BREATHING        [>] │   │
│  │ In 4 · Hold 4 · Out 4 ·    │   │
│  │ Hold 4                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🌊 4-7-8 BREATHING     [>] │   │
│  │ In 4 · Hold 7 · Out 8      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 😤 PURSED LIP BREATHING[>] │   │
│  │ In through nose · Out       │   │
│  │ through pursed lips          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👶 DIAPHRAGMATIC BREATHING  │   │
│  │ (Belly breathing)      [>] │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

Each breathing exercise opens an animated guide. A circle expands (breathe in) and contracts (breathe out). Simple. Calm. No music unless the user enables it.

### 6.3 Orientation Card (for Dissociation)

```
┌─────────────────────────────────────┐
│  ← Toolkit    📍 ORIENTATION        │
├─────────────────────────────────────┤
│                                     │
│  You are here.                      │
│                                     │
│  📅 Today is Monday 30th June 2026 │
│  🕐 The time is 2:45 PM            │
│  📍 You are in [Cairns, Australia] │
│                                     │
│  The last thing you were doing was: │
│  "Logging Evander's feed"          │
│                                     │
│  You are safe. This feeling will    │
│  pass. Your brain is trying to      │
│  protect you.                       │
│                                     │
│  [Grounding exercise]               │
│  [Contact trusted person]           │
│                                     │
└─────────────────────────────────────┘
```

The location is user-set. The last action is pulled from the User Activity Ledger. The card is simple, present-focused, and non-judgemental.

---

## 7. LOGS & TRACKING

### 7.1 Worry Log

```
┌─────────────────────────────────────┐
│  ← Toolkit      📝 WORRY LOG        │
├─────────────────────────────────────┤
│                                     │
│  What's on your mind?               │
│  ┌─────────────────────────────┐   │
│  │ [___________________________]│   │
│  │ [___________________________]│   │
│  │ [___________________________]│   │
│  └─────────────────────────────┘   │
│                                     │
│  This worry is:                     │
│  ○ Something I can control          │
│  ● Something I can influence        │
│  ○ Something outside my control     │
│                                     │
│  What's the most likely outcome?    │
│  ┌─────────────────────────────┐   │
│  │ [___________________________]│   │
│  └─────────────────────────────┘   │
│                                     │
│  What's one thing I can do?         │
│  ┌─────────────────────────────┐   │
│  │ [___________________________]│   │
│  └─────────────────────────────┘   │
│                                     │
│  [Save worry]  [This can wait]      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  RECENT WORRIES                     │
│  · 28th June · "The camp meeting"  │
│  · 25th June · "Evander's cough"   │
│  [View all]                         │
│                                     │
└─────────────────────────────────────┘
```

The worry log is not a task list. Worries logged here are not turned into action items unless Beth explicitly chooses to. They exist. They're noted. They're not problems to solve.

### 7.2 Trigger Log

```
┌─────────────────────────────────────┐
│  ← Toolkit      ⚡ TRIGGER LOG      │
├─────────────────────────────────────┤
│                                     │
│  What happened?                     │
│  ┌─────────────────────────────┐   │
│  │ [___________________________]│   │
│  └─────────────────────────────┘   │
│                                     │
│  How did it feel? (1-10)           │
│  [7/10]                             │
│                                     │
│  What did you need?                 │
│  ○ Space                            │
│  ● Grounding                        │
│  ○ Someone to talk to               │
│  ○ Distraction                      │
│                                     │
│  What helped?                       │
│  ┌─────────────────────────────┐   │
│  │ [___________________________]│   │
│  └─────────────────────────────┘   │
│                                     │
│  [Save]                             │
│                                     │
└─────────────────────────────────────┘
```

---

## 8. REGULATION TOOLS

### 8.1 Urge Surfing Timer

```
┌─────────────────────────────────────┐
│  ← Toolkit    🌊 URGE SURFING       │
├─────────────────────────────────────┤
│                                     │
│  Urges typically peak for 20-30     │
│  minutes. You can ride this out.    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │         ⏱ 18:42             │   │
│  │      time remaining          │   │
│  │                             │   │
│  │  ████████████░░░░░░░░░░░░   │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  While you wait:                    │
│  · [Grounding exercise]            │
│  · [Message a support person]      │
│  · [Distract yourself — ideas]     │
│  · [Just breathe with me]          │
│                                     │
│  This urge will pass. You've        │
│  surfed urges before. You can do    │
│  it again.                          │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Sobriety Tracker

```
┌─────────────────────────────────────┐
│  ← Toolkit    💪 SOBRIETY TRACKER   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Current streak: 47 days     │   │
│  │ Started: 14th May 2026      │   │
│  │                             │   │
│  │ Longest streak: 89 days     │   │
│  │ Total days this year: 142   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚙ TRACKING OPTIONS           │   │
│  │ ☐ Count streaks             │   │
│  │ ☐ Recovery without streaks  │   │
│  │ ☐ Private (not on dashboard)│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 LOG                        │   │
│  │ [Log a win]                  │   │
│  │ [Log a lapse — no judgement] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Language: You used today. That's   │
│  data, not defeat. Your next choice │
│  matters more than your last one.   │
│                                     │
└─────────────────────────────────────┘
```

**Sobriety tracker language rules:**
- Never "You failed." Never "You lost your streak." Never "You ruined your progress."
- "You used today. That's data, not defeat. Your next choice matters more than your last one."
- "Recovery without streaks" mode available — tracks total days, not consecutive.
- Private by default. Not on the Dashboard unless the user chooses.

---

## 9. STATE SUPPORT

### 9.1 Panic Support

```
┌─────────────────────────────────────┐
│  ← Toolkit      😨 PANIC SUPPORT    │
├─────────────────────────────────────┤
│                                     │
│  You are having a panic attack.     │
│  This is your body's alarm system.  │
│  It is uncomfortable but it is not  │
│  dangerous. It will pass.           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ TRY THIS:                    │   │
│  │                             │   │
│  │ 🫁 Box breathing        [>]│   │
│  │ 🧘 5-4-3-2-1 grounding  [>]│   │
│  │ ✋ Hold something cold  [>]│   │
│  │ 👤 Contact trusted person[>]│   │
│  └─────────────────────────────┘   │
│                                     │
│  Your heart is beating fast. That's │
│  adrenaline. It's not a heart       │
│  attack. You are safe.              │
│                                     │
│  Panic attacks typically peak at    │
│  10 minutes and subside within      │
│  20-30 minutes. You're doing the    │
│  right thing by riding it out.      │
│                                     │
└─────────────────────────────────────┘
```

### 9.2 Dissociation Support

```
┌─────────────────────────────────────┐
│  ← Toolkit    🌫 DISSOCIATION       │
├─────────────────────────────────────┤
│                                     │
│  You may be dissociating. This is   │
│  your brain's way of protecting you │
│  from overwhelm.                    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ TRY THIS:                    │   │
│  │                             │   │
│  │ 📍 Orientation card     [>]│   │
│  │ 🧘 5-4-3-2-1 grounding  [>]│   │
│  │ ✋ Hold ice or cold water[>]│   │
│  │ 👤 Contact trusted person[>]│   │
│  └─────────────────────────────┘   │
│                                     │
│  📍 You are in [Cairns, Australia].│
│  📅 Today is Monday 30th June.      │
│  🕐 The time is 2:45 PM.           │
│                                     │
│  You are safe. This will pass.      │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. CONNECTION

### 10.1 Therapy Notes

```
┌─────────────────────────────────────┐
│  ← Toolkit    📋 THERAPY NOTES      │
├─────────────────────────────────────┤
│                                     │
│  Private notes for your therapy     │
│  sessions. Not shared. Not visible  │
│  anywhere else.                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ TOPICS FOR NEXT SESSION      │   │
│  │ · [Add topic]               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ BETWEEN-SESSION NOTES        │   │
│  │ · 25th June · "Felt really  │   │
│  │   anxious after work —      │   │
│  │   same pattern as last time"│   │
│  │ [+ Add note]                │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ SESSION NOTES                │   │
│  │ · 18th June · Session notes │   │
│  │ [+ Add session notes]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ HOMEWORK / THINGS TO TRY     │   │
│  │ · Try grounding when I      │   │
│  │   notice early anxiety      │   │
│  │ [+ Add]                     │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Export for psychologist]          │
│                                     │
└─────────────────────────────────────┘
```

### 10.2 GP / Psych Discussion Export

Similar to the Health Status Doctor Export. Generates a structured summary for mental health appointments.

- Current medications.
- Mood trends (from tracked data).
- Topics the user wants to discuss.
- Recent triggers or patterns.
- Questions for the clinician.
- No AI interpretation. Just the data the user entered.

---

## 11. STATE RESPONSIVENESS

The toolkit is always available. How it behaves depends on the user's state.

| State | Toolkit Behaviour |
|-------|-------------------|
| **Panicking (Current State)** | Panic Support opens immediately. Dashboard minimised. Everything else hidden. |
| **Overwhelmed** | Grounding tools surfaced. One next step. Crisis plan accessible. |
| **Dissociating** | Orientation card opened. Grounding tools prominent. |
| **Triggered** | Trigger log accessible. Grounding tools. Trusted contact. |
| **Grief Day** | Toolkit available but not pushed. No "How are you feeling?" prompts. Crisis plan accessible. |
| **Low Energy** | Simplified tools. Breathing exercises only (low cognitive load). |
| **Depression Support Preset** | Small win logging prominent. Crisis plan accessible. Gentle language throughout. |
| **PTSD / Trauma-Informed Preset** | Grounding tools surfaced on Dashboard (if user chooses). Trigger log accessible. Safe person contact prominent. Reduced surprise notifications. |
| **Emotional Regulation Preset** | Cooling-off timer for messages. Urge surfing timer. Conflict de-escalation prompts. |
| **Addiction Recovery Preset** | Urge surfing timer prominent. Sobriety tracker accessible. Relapse prevention plan. Support contacts. |

---

## 12. CRISIS RESOURCES — ALWAYS ACCESSIBLE

At the bottom of the Toolkit main screen, and accessible from the Dashboard (if the user has surfaced it):

- **Lifeline Australia:** 13 11 14 — 24/7 crisis support.
- **Suicide Call Back Service:** 1300 659 467.
- **Beyond Blue:** 1300 22 4636.
- **PANDA National Helpline:** 1300 726 306 (perinatal mental health).
- **1800RESPECT:** 1800 737 732 (domestic violence, sexual assault).
- **Kids Helpline:** 1800 55 1800 (for young people up to 25).
- **000** — Emergency (Ambulance, Police, Fire).
- **Cairns Hospital ED:** [local address and phone].

These resources are cloud-based (from the Cloud Resource Library). Updated centrally. No app update required.

---

## 13. WHAT THIS MODULE DOES NOT CONTAIN

- **Seizure features** — These live in Health Status (Neurology). Seizure log, post-seizure recovery mode, medication reminders for anti-epileptics — all in Health Status.
- **Pleasure Log** — Placement TBD. Possibly Sexual Wellbeing (Reproductive Health), Relationships/Intimacy (Family Hub), or Wellbeing (a new section). Not here.
- **Diagnosis tools** — Nothing in this module diagnoses. Nothing suggests a condition. Nothing labels the user.
- **AI therapy** — Rae listens and reflects. She does not provide therapy. The tools are self-guided. Resources are from accredited sources.
- **Risk scoring** — The app does not assess suicide risk. It provides crisis resources. It does not score, rank, or predict.

---

## 14. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1D** | Crisis/Safety Plan builder. Grounding tools (5-4-3-2-1). Breathing exercises (box breathing, 4-7-8). Worry log. Orientation card. Trusted contact messaging. Panic support screen. Emergency resources (always accessible). |
| **2B** | Full toolkit: Urge surfing timer. Sobriety tracker. Relapse prevention plan. Trigger log. Intrusive thought log. Dissociation support. Grief day mode. Emotional regulation tools. Cooling-off timer for messages. Therapy notes. GP/Psych discussion export. Mood tracker. Full state responsiveness. |

---

## 15. PRIVACY SUMMARY

| Data | Sensitivity | Shared? | Exportable? | Dashboard-Visible? |
|------|-------------|---------|-------------|---------------------|
| Crisis/Safety Plan | D4 | No (opt-in only) | Yes (user-initiated) | Optional (user chooses) |
| Worry Log | D3 | No | Yes | Optional |
| Trigger Log | D3 | No | Yes | No |
| Therapy Notes | D4 | No | Yes (user-initiated) | No |
| Sobriety Tracker | D3 | No | Yes | Optional |
| Intrusive Thought Log | D4 | No | No | No |
| Trusted Contact List | D3 | No | No | No |
| Breathing/Grounding (usage) | D2 | No | No | No |

---

That's the Mental Health & Regulation Toolkit. Tools, not diagnoses. Crisis-aware, not crisis-driven. Always accessible, never pushed. Privacy sacrosanct.
