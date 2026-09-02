# TETHER — MODULE 12: SUPPORT PRESETS & ACCESSIBILITY
## Complete Design Specification

**Module:** Support Presets & Accessibility
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢-🟠 (depends on preset content; some presets affect D3-D4 data handling)
**Phase:** 1B (architecture only — data class + Provider) → 1D (first presets: ADHD, Depression, Anxiety, Low-Stimulation, Postpartum) → 2A (Current State layer, Colour Card integration, Capacity Check-In) → 2B (full preset suite — all 25 presets, full sensitivity toggles)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT SUPPORT PRESETS & ACCESSIBILITY IS

This module is the engine that makes Tether adapt to the user's brain, body, sensory needs, and current state. It is not a single screen. It is a system that runs across every other module, adjusting behaviour based on what the user has told the app about their needs.

It answers the question: *"How should the app behave for me, right now?"*

The system has three layers:

| Layer | What It Is | User Action |
|-------|------------|-------------|
| **Layer 1: Support Presets** | Pre-built bundles of sensitivity toggles. Named by function, not diagnosis. | "I want ADHD support." — activates a bundle. |
| **Layer 2: Sensitivity Toggles** | Individual adjustments available to anyone, regardless of whether they use a preset. | "I want plain language." — toggles one thing. |
| **Layer 3: Current State** | Temporary overrides for acute moments. "I'm overwhelmed right now." | "I'm overwhelmed." — activates temporary protection. |

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Function, not diagnosis** | Presets are named by what they do, not what condition they're associated with. "ADHD support" not "ADHD mode." "Emotional regulation support" not "BPD mode." |
| **Transparent, not mysterious** | Every toggle shows exactly what it changes. No hidden behaviour. "This will reduce notifications, use plain language, and show one next step at a time." |
| **User-controlled, not app-assigned** | The user activates presets. The user adjusts toggles. The user sets their current state. The app never decides "you seem anxious — activating anxiety support." |
| **Protective, not restrictive** | When settings conflict, the more protective setting wins. The least intrusive setting wins when both are equally protective. User manual override always respected. |
| **Dignified language always** | The app never says "Because you have ADHD..." or "Due to your condition..." It says "You've turned on ADHD support. I can reduce pressure, simplify tasks, and offer grounding tools." |
| **Accessibility is for everyone** | Accessibility settings are not locked behind a preset. Anyone can use OpenDyslexic font. Anyone can reduce animations. Accessibility is a right, not a diagnosis. |

---

## 3. HOW YOU GET HERE

**Primary:** Settings → 🧠 Support Presets, or Settings → 🎚 Sensitivity Toggles, or Settings → ♿ Accessibility.
**From Dashboard:** Current State can be activated directly from the Dashboard (below the Colour Card).
**From any screen:** Current State can be activated via voice command (Phase 1C+): "I'm overwhelmed."

---

## 4. THE THREE-LAYER ARCHITECTURE

### 4.1 How the Layers Interact

```
┌─────────────────────────────────────┐
│                                     │
│  LAYER 3: CURRENT STATE             │
│  Temporary. Overrides everything.   │
│  "I'm overwhelmed right now."       │
│         │                           │
│         ▼                           │
│  LAYER 2: SENSITIVITY TOGGLES      │
│  Individual. Granular.              │
│  "Plain language: ON"               │
│  "Reduce notifications: ON"         │
│         │                           │
│         ▼                           │
│  LAYER 1: SUPPORT PRESETS           │
│  Bundles of toggles. Pre-built.     │
│  "ADHD support" → toggles 4 things │
│                                     │
└─────────────────────────────────────┘
```

**Resolution order:** Current State overrides everything. Then manual toggles. Then preset defaults. The app resolves conflicts at runtime.

**Conflict rule:** More protective setting wins. If ADHD Support wants more reminders but Overwhelmed wants fewer, Overwhelmed wins. User manual override always respected.

---

## 5. SUPPORT PRESETS — FULL SPECIFICATION

### 5.1 Presets Main Screen

```
┌─────────────────────────────────────┐
│  ← Settings      🧠 SUPPORT PRESETS │
├─────────────────────────────────────┤
│                                     │
│  Support Presets are bundles of     │
│  settings that adapt the app to     │
│  your needs. You can customise      │
│  any preset or build your own.      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ACTIVE PRESETS (2)                 │
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
│  │ 🧩 Executive Function   [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Emotional & Mental Health          │
│  ┌─────────────────────────────┐   │
│  │ 🌧 Depression Support   [+] │   │
│  │ 😰 Anxiety Support      [+] │   │
│  │ 🛡 PTSD/Trauma Support  [+] │   │
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
│  │ 🕊 Trauma-Informed      [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  Sensory & Physical                 │
│  ┌─────────────────────────────┐   │
│  │ 🌙 Low-Stimulation      [+] │   │
│  │ 👁 Blind/Low Vision     [+] │   │
│  │ 👂 Deaf/Hard of Hearing [+] │   │
│  │ ♿ Accessibility/Mobility[+]│   │
│  │ ⚡ Epilepsy Support     [+] │   │
│  │ 🩺 Chronic Health       [+] │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Create custom preset]          │
│                                     │
└─────────────────────────────────────┘
```

### 5.2 Preset Detail / Configuration View

Tapping "Configure" on an active preset opens its detail:

```
┌─────────────────────────────────────┐
│  ← Presets       🧠 ADHD SUPPORT    │
├─────────────────────────────────────┤
│                                     │
│  You've turned on ADHD support.     │
│  These settings are active. You     │
│  can adjust or turn off any of      │
│  them.                              │
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

### 5.3 Activating a Preset

Tapping "[+]" on any available preset opens a confirmation:

```
┌─────────────────────────────────────┐
│  Activate ADHD Support?             │
│                                     │
│  This will turn on:                 │
│  · Digest mode for notifications   │
│  · Visual task breakdowns          │
│  · One next step on dashboard      │
│  · Body-doubling prompts           │
│  · Plain language                  │
│  · No shame-based wording          │
│  (and 6 more)                      │
│                                     │
│  You can customise or turn off     │
│  any of these at any time.         │
│                                     │
│  [Cancel]           [Activate]      │
│                                     │
└─────────────────────────────────────┘
```

### 5.4 Creating a Custom Preset

```
┌─────────────────────────────────────┐
│  ← Presets     CREATE CUSTOM PRESET │
├─────────────────────────────────────┤
│                                     │
│  Preset name:                       │
│  [My night mode________________]    │
│                                     │
│  Description (optional):            │
│  [For when I'm winding down_____]   │
│                                     │
│  Select toggles to include:         │
│                                     │
│  NOTIFICATIONS                      │
│  ☑ Reduce all notifications        │
│  ☑ Quiet hours                     │
│  ☐ No sound                        │
│                                     │
│  SENSORY                            │
│  ☑ Low-stim theme                  │
│  ☑ Reduce motion                   │
│  ☑ No bright accents               │
│                                     │
│  (all toggle categories available)  │
│                                     │
│  [Save preset]                      │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. THE 25 SUPPORT PRESETS — DETAILED TOGGLE MAPS

### 6.1 Neurodivergent Support

#### 🧠 ADHD Support
**Purpose:** Support executive function, memory, task initiation, time blindness, overwhelm, and inconsistent capacity.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Notifications | Digest mode by default, Reduce non-urgent reminders |
| Tasks | Visual task breakdowns, One next step mode, Body-doubling prompts, Focus timer, "Start tiny" prompts, Missed-task recovery (no shame) |
| Language | Plain language, No shame-based wording |
| Dashboard | One next step visible, Urgent items surfaced |
| Current State Shortcuts | Overwhelmed, Low energy |

#### 🌈 Autism Support
**Purpose:** Support sensory regulation, predictability, communication preferences, routine, transitions, and overwhelm prevention.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Sensory | Reduce motion, Low-stim theme, No bright accents |
| Language | Plain language, Extra direct language, No ambiguous prompts |
| Cognitive Load | Routine support, "Explain this simply" |
| Notifications | Reduce non-urgent reminders |
| Dashboard | Simplified dashboard |
| Current State Shortcuts | Overwhelmed, Shutdown/meltdown |

#### 📖 Dyslexia Support
**Purpose:** Support reading ease, reduced text-processing load.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Accessibility | OpenDyslexic font, Increased line spacing |
| Language | Plain language, Short summaries first, Bullet point mode |
| Sensory | Colour overlay (user choice) |
| Cognitive Load | Visual steps |

#### 🔢 Dyscalculia Support
**Purpose:** Support number difficulty, visual budgets, calculator assistance.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Financial | Visual budget bars, Simplified numbers, Avoid mental maths |
| Language | "What this means" explanations |
| Cognitive Load | Visual steps |
| Accessibility | Calculator assistance |

#### 🤲 Dyspraxia / Motor Planning Support
**Purpose:** Support coordination, fine motor difficulty, reduced precision tapping.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Accessibility | Larger buttons, Reduced precision input, Voice input prioritised, One-handed mode |
| Cognitive Load | Confirm before destructive actions, Undo available |
| Sensory | Reduce haptics |

#### 🧩 Executive Function Support
**Purpose:** Support initiation, planning, sequencing, prioritising, and follow-through.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Tasks | Visual task breakdowns, One next step, Priority sorting, Task templates |
| Cognitive Load | "Start here" suggestions, Reduce decision fatigue, Default to one recommendation |
| Dashboard | One next step visible, Urgent items surfaced |
| Language | Plain language |

---

### 6.2 Emotional & Mental Health

#### 🌧 Depression Support
**Purpose:** Support low motivation, self-care, shame reduction, minimum viable functioning.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Tasks | Bare-minimum task view, Personal care prompts |
| Language | Gentle language, No shame-based wording, No productivity pressure |
| Notifications | Reduce non-urgent reminders |
| Dashboard | One next step visible, Small win logging prominent |
| Current State Shortcuts | Low energy, Grief day |

#### 😰 Anxiety Support
**Purpose:** Support worry, overthinking, panic, avoidance, reassurance loops.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Cognitive Load | "What to expect" summaries, Routine support |
| Language | Gentle language, No catastrophic wording |
| Notifications | Reduce surprise notifications |
| Current State Shortcuts | Panicking, Overwhelmed |

#### 🛡 PTSD / Trauma-Informed Support
**Purpose:** Support triggers, hypervigilance, grounding, safety planning, control.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Notifications | Reduce surprise notifications |
| Language | Trauma-informed wording, Consent-based prompts, Gentle language |
| Cognitive Load | "What to expect" summaries |
| Current State Shortcuts | Triggered, Overwhelmed, Dissociating |

#### 💜 Emotional Regulation Support
**Purpose:** Support emotional intensity, impulsive messaging, conflict de-escalation, repair.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Communication | Pause before sending, Cooling-off timer, Conflict de-escalation, One draft not five |
| Language | Gentle language, No shame-based wording |
| Current State Shortcuts | Overwhelmed, Triggered, Need human support |

#### 🍽 Food & Body Neutrality Support
**Purpose:** Support eating disorder recovery, body image distress, diet-culture sensitivity.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Food/Body | Avoid calories, Hide weight, No good/bad food language, No diet culture language, No weight-loss prompts, No exercise-as-punishment, Neutral meal reminders |
| Language | No shame-based wording |
| Current State Shortcuts | Distress after meals support |

#### 🧘 Panic Support
**Purpose:** Support panic attacks, body anxiety, grounding, fast access to calming tools.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Sensory | Low-stim theme, Reduce motion |
| Notifications | Reduce all notifications during panic |
| Current State Shortcuts | Panicking (primary — opens panic support directly) |

#### 🌫 Dissociation Support
**Purpose:** Support grounding, orientation, memory gaps, returning to the present.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Cognitive Load | Orientation prompts, "What was I doing?" recap |
| Sensory | Low-stim theme |
| Current State Shortcuts | Dissociating (primary — opens dissociation support directly) |

#### 🔄 OCD Support
**Purpose:** Support compulsive checking, reassurance loops, rumination, distress tolerance.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Cognitive Load | "Done is done" confirmations, Limit repeated checking |
| Language | No reassurance loops |
| Current State Shortcuts | Intrusive thoughts, Overwhelmed |

#### 📊 Bipolar Support
**Purpose:** Support mood episodes, sleep protection, spending caution, routine stability.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Financial | Require confirmation before spending, Delay big financial decisions |
| Notifications | Sleep protection (quiet hours enforced) |
| Health | Medication reminders |
| Current State Shortcuts | Low energy, High energy/mania concern |

#### 🧭 Psychosis / Reality Support
**Purpose:** Support reality-testing, grounding, trusted contact, sleep protection.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Language | Reality-anchoring language, No ambiguous prompts |
| Cognitive Load | Grounding prompts |
| Current State Shortcuts | Overwhelmed, Need human support |

---

### 6.3 Life Stages & Recovery

#### 🤰 Postpartum Support
**Purpose:** Support postpartum depression, anxiety, rage, intrusive thoughts, sleep deprivation, recovery.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Tasks | Bare-minimum task view, Personal care prompts |
| Language | Gentle language, No productivity pressure |
| Notifications | Reduce non-urgent reminders |
| Health | Low-energy mode, Postpartum sensitivity |
| Current State Shortcuts | Overwhelmed, Low energy, Need human support |

#### 💪 Addiction Recovery Support
**Purpose:** Support cravings, relapse prevention, triggers, sobriety tracking.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Cognitive Load | Urge surfing timer, Relapse prevention prompts |
| Language | No shame-based wording, Recovery-affirming language |
| Current State Shortcuts | Relapse risk, Overwhelmed |

#### 🕊 Trauma-Informed Support
**Purpose:** Support user control, predictability, consent, emotional safety.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Language | Trauma-informed wording, Consent-based prompts, Gentle language |
| Notifications | Reduce surprise notifications |
| Cognitive Load | "What to expect" summaries |

---

### 6.4 Sensory & Physical

#### 🌙 Low-Stimulation Support
**Purpose:** Support sensory overwhelm, migraine, exhaustion, overload reduction.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Sensory | Disable animations, Reduce motion, Reduce sound, Reduce haptics, Low-stim theme, No bright accents, No confetti, Simplified dashboard |
| Notifications | Reduce all notifications |
| Dashboard | Minimal view |

#### 👁 Blind / Low Vision Support
**Purpose:** Support screen reader use, reduced visual dependence, accessible navigation.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Accessibility | Screen reader optimised, Voice input prioritised, Text-to-speech by default, High contrast, Large text, No visual-only information |

#### 👂 Deaf / Hard of Hearing Support
**Purpose:** Support users who cannot rely on audio notifications.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Accessibility | Visual alerts for audio, Captions for all media, No audio-only instructions, Vibration patterns, Text-first communication |

#### ♿ Accessibility / Mobility Support
**Purpose:** Support mobility impairment, tremor, fine motor difficulty, fatigue.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Accessibility | Larger buttons, One-handed mode, Reduced precision input, Voice input prioritised, Confirm before destructive actions, Undo available |

#### ⚡ Epilepsy Support
**Purpose:** Support seizure tracking, medication reminders, post-seizure recovery, safety.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Sensory | Disable animations, No flashing, No strobing, Reduce motion |
| Health | Medication reminders, Post-seizure mode |
| Current State Shortcuts | Post-seizure recovery |

#### 🩺 Chronic Health Support
**Purpose:** Support ongoing conditions, appointments, flares, fatigue, symptom tracking.

| Category | Toggles Active by Default |
|----------|--------------------------|
| Health | Medication reminders, Appointment prep, Symptom logging, Low-energy mode, Flare mode, Pain day mode |
| Tasks | Bare-minimum task view (during flares) |
| Current State Shortcuts | Flare day, Low energy, High pain |

---

## 7. SENSITIVITY TOGGLES — FULL CATALOGUE

### 7.1 Notification Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Digest mode by default | Notifications batched. Configurable digest times. |
| ☐ Reduce all notifications | Fewer notifications overall. Only urgent and important surface. |
| ☐ Increase reminders | More frequent reminders for tasks and medications. |
| ☐ Real-time urgent only | Only urgent items push immediately. Everything else waits for digest. |
| ☐ Quiet hours | No notifications during set hours. Urgent can override. |
| ☐ No sound | All notification sounds disabled. |
| ☐ No vibration | All haptic feedback disabled. |
| ☐ Visual alerts only | Notifications are visual only. No sound or vibration. |

### 7.2 Language Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Plain language | Simple words. Short sentences. No jargon. |
| ☐ Extra direct language | Direct, unambiguous phrasing. No softening. |
| ☐ Gentle language | Warmer, softer tone. "Would it help to..." not "You should..." |
| ☐ No shame-based wording | No "you forgot," "you failed," "you're behind." |
| ☐ No diet/body language | No food morality, no weight commentary, no body judgement. |
| ☐ No clinical labels | No diagnostic language. "Support" not "treatment." |
| ☐ No "should" wording | No prescriptive language. Options, not commands. |
| ☐ No productivity pressure | No urgency language. No "you're falling behind." |
| ☐ Trauma-informed wording | Consent-based, non-authoritarian, safety-conscious language. |
| ☐ Short prompts only | Brief responses. No paragraphs. |
| ☐ Detailed explanations | Longer, more thorough responses. |

### 7.3 Sensory Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Disable animations | No animations. Instant transitions. |
| ☐ Reduce motion | Fewer animations. Simple fades. No parallax. |
| ☐ Reduce sound | No alert tones. Minimal audio feedback. |
| ☐ Reduce haptics | Minimal vibration feedback. |
| ☐ Low-stim theme | Darker, muted colours. No bright accents. |
| ☐ High contrast | Maximum contrast. Thick borders. White text on black. |
| ☐ Soft contrast | Lower contrast. Easier on eyes. |
| ☐ No flashing | No strobing or flashing elements. |
| ☐ No confetti/celebrations | No celebration animations. |
| ☐ Simplified dashboard | Fewer sections. Minimal visual noise. |
| ☐ Fewer badges/alerts | Reduced badge counts. Muted alert colours. |

### 7.4 Cognitive Load Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ One next step | Dashboard shows only the single most important item. |
| ☐ Hide non-urgent items | Non-urgent tasks and events hidden from dashboard. |
| ☐ Visual steps | Tasks broken into visual step-by-step. |
| ☐ Checklists | Tasks displayed as checklists. |
| ☐ Short summaries | Long content replaced with summaries. "Tap for more." |
| ☐ "Explain this simply" | AI responses simplified. |
| ☐ Memory prompts | Gentle reminders of context. "You were working on..." |
| ☐ Routine support | Morning and evening routines surfaced. |
| ☐ Fewer choices | Single recommendation instead of multiple options. |
| ☐ Default to one recommendation | AI gives one answer, not a menu. |
| ☐ Keep original messy capture | Preserve raw input alongside cleaned version. |

### 7.5 Food / Body Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Avoid calories | No calorie display anywhere in the app. |
| ☐ Hide weight | No weight display. |
| ☐ No good/bad food language | No food morality. |
| ☐ No diet culture language | No "cheat meal," "guilt-free," "clean eating." |
| ☐ No weight-loss prompts | No weight-related goals or suggestions. |
| ☐ No exercise-as-punishment | No "burn off" or "earn your meal" language. |
| ☐ Neutral meal reminders | "Time to eat" not "You should eat." |
| ☐ Safe foods list | User-defined safe foods surfaced in Meals. |
| ☐ Sensory foods support | Texture and sensory preference tracking for meals. |
| ☐ ARFID support | Very limited safe foods. Slow introduction. No pressure. |
| ☐ Distress-after-meals support | Post-meal grounding tools accessible. |

### 7.6 Communication Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Pause before sending | Messages held for a cooling-off period. |
| ☐ Require confirmation to send | Secondary confirmation before any message sends. |
| ☐ Cooling-off timer | Configurable delay before messages can be sent. |
| ☐ Draft only, don't send | Messages saved as drafts. Not sent. |
| ☐ One draft, not five | Single draft presented. No multiple options. |
| ☐ Tone check | AI reviews tone before sending. |
| ☐ Conflict de-escalation | Language softened during detected conflict. |
| ☐ Repair prompt | After conflict, offers repair scripts. |
| ☐ Trusted-person check-in | Quick-access message to trusted contact. |
| ☐ Hide message suggestions during overwhelm | AI doesn't suggest messages when user is overwhelmed. |

### 7.7 Financial Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Require confirmation before spending | Large expenses require confirmation. |
| ☐ Delay big financial decisions | Suggests waiting 24 hours before large purchases. |
| ☐ Avoid shame spending language | No "overspent." No "you went over." |
| ☐ Bare-minimum budget mode | Only essential categories visible. |
| ☐ Bill warning mode | Due-soon bills surfaced prominently. |
| ☐ Sinking fund suggestions | Proactive sinking fund recommendations. |
| ☐ Visual budget bars | Numbers replaced with visual bars. |
| ☐ Simplified numbers | Rounded to nearest $5 or $10. |
| ☐ Reduce impulse-purchase prompts | Quick-add hidden. Suggestions suppressed. |

### 7.8 Health Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Medication reminders | Reminders for scheduled medications. |
| ☐ Appointment prep | Pre-appointment summaries. |
| ☐ Symptom logging | Quick-access symptom tracker. |
| ☐ Doctor export | "Discuss with Doctor" summaries. |
| ☐ Low-energy mode | Simplified interactions. Reduced demands. |
| ☐ Flare mode | Adjusted expectations during health flares. |
| ☐ Pain day mode | Minimal demands. Pain tracker surfaced. |
| ☐ Migraine mode | Dark theme. Low-stim. Notifications suppressed. |
| ☐ Post-seizure mode | Recovery timer. Notifications suppressed. |
| ☐ Pregnancy/postpartum sensitivity | Adjusted language and expectations. |

### 7.9 Privacy Sensitivity

| Toggle | Effect |
|--------|--------|
| ☐ Hide sensitive notes | D3-D4 content hidden behind tap-to-reveal. |
| ☐ Require app lock | PIN or biometric required to open the app. |
| ☐ Private chat mode | Instance conversations marked private. |
| ☐ Exclude from AI summaries | Content not included in Viva's summaries. |
| ☐ Exclude from partner sharing | Content not shared with partner. |
| ☐ Hide from dashboard | Content not surfaced on the dashboard. |
| ☐ Visible only to user | Strictest privacy. No instance can access without explicit permission. |
| ☐ Auto-delete after set period | Content automatically deleted after configurable time. |

---

## 8. CURRENT STATE — FULL SPECIFICATION

### 8.1 Current State Selector

Accessible from the Dashboard (below the Colour Card) or from Settings → ⚡ Current State.

```
┌─────────────────────────────────────┐
│  ← Dashboard     CURRENT STATE      │
├─────────────────────────────────────┤
│                                     │
│  Activate a temporary state.        │
│  The app will adjust until you      │
│  turn it off or the timer expires.  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  EMOTIONAL STATES                   │
│  😰 I'm overwhelmed                 │
│  😨 I'm panicking                   │
│  🌫 I'm dissociating               │
│  💥 I'm triggered                   │
│  😡 I'm in shutdown/meltdown       │
│  🧠 I'm having intrusive thoughts  │
│  🆘 I need human support            │
│                                     │
│  PHYSICAL STATES                    │
│  🩹 I'm in pain                     │
│  🥱 I'm exhausted                   │
│  😴 I'm sleep deprived              │
│  🤒 I'm sick                        │
│  🤕 Migraine mode                   │
│  🔥 Flare day                       │
│  ⚡ Post-seizure recovery           │
│                                     │
│  LIFE STATES                        │
│  💔 Grief day                       │
│  ⚠ Relapse risk                     │
│  📉 Low energy                      │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  Timer:                             │
│  ○ Until I turn it off              │
│  ● 2 hours                          │
│  ○ 4 hours                          │
│  ○ Rest of day                      │
│                                     │
│  [Activate]                         │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Current State Behaviours

| State | What the App Does |
|-------|-------------------|
| **😰 Overwhelmed** | Hides non-urgent tasks. Shows one next step. Surfaces grounding tools. Reduces notifications. Status Shield → Heads Down. Gentle affirmation. |
| **😨 Panicking** | Panic Support opens. Dashboard minimised. Everything else hidden. Breathing tools surfaced. Trusted contact one-tap. |
| **🌫 Dissociating** | Orientation card opens. Grounding tools surfaced. Low-stim mode forced. Date/time/location displayed prominently. |
| **💥 Triggered** | Trigger log accessible. Grounding tools. Notifications suppressed. Safe person contact prominent. |
| **😡 Shutdown/Meltdown** | Minimal words. No complex choices. Grounding accessible. No notifications. No demands. |
| **🧠 Intrusive Thoughts** | Intrusive thought support accessible. Grounding tools. Distraction options. No reassurance loops. |
| **🆘 Need Human Support** | Trusted contact messaging one-tap. Pre-written messages. Crisis resources accessible. |
| **🩹 In Pain** | Bare-minimum tasks. Pain tracker surfaced. Gentle language. Notifications reduced. |
| **🥱 Exhausted** | Simplified dashboard. Bare Minimums only. "Rest is productive." No productivity pressure. |
| **😴 Sleep Deprived** | Fewer notifications. No heavy decisions. Simplified interface. |
| **🤒 Sick** | Bare Minimums. Hydration reminders. Medication reminders. "Rest is productive." |
| **🤕 Migraine** | Dark theme forced. Low-stim forced. No animations. No sound. Notifications suppressed. |
| **🔥 Flare Day** | Symptom tracker surfaced. Bare Minimums. Gentle language. Pacing prompts. |
| **⚡ Post-Seizure** | Screen dimmed. Recovery timer. Notifications suppressed. Trusted contact option. Low-stim forced. |
| **💔 Grief Day** | No productivity pressure. Affirmation gentle. Memory dates acknowledged (if set). Bare Minimums. |
| **⚠ Relapse Risk** | Urge surfing timer surfaced. Support contacts prominent. Trigger log accessible. Soberiety tracker accessible. |
| **📉 Low Energy** | Simplified dashboard. Bare Minimums. Shorter AI responses. "What's the smallest version of today?" |

---

## 9. ACCESSIBILITY SETTINGS

Accessibility settings are available to all users, regardless of whether they use Support Presets.

```
┌─────────────────────────────────────┐
│  ← Settings        ♿ ACCESSIBILITY  │
├─────────────────────────────────────┤
│                                     │
│  VISUAL                             │
│  Font: [System default ▼]          │
│  Font size: [Medium] ··●··         │
│  Line spacing: [Standard ▼]        │
│  ☐ OpenDyslexic font               │
│  ☐ High contrast                    │
│  ☐ Soft contrast                    │
│  ☐ Reduced motion                   │
│  ☐ Disable animations               │
│  ☐ No flashing/strobing             │
│  ☐ Colour overlays                  │
│     Tint: [None ▼]                 │
│  ☐ Large buttons                    │
│  ☐ Simplified dashboard             │
│                                     │
│  AUDIO                              │
│  ☐ Silent mode                      │
│  ☐ Vibration only                   │
│  ☐ Visual alerts for audio          │
│  ☐ Captions for all media           │
│  ☐ No sharp alert tones             │
│                                     │
│  INTERACTION                        │
│  ☐ Screen reader optimised          │
│  ☐ Voice input prioritised          │
│  ☐ Text-to-speech by default        │
│  ☐ One-handed mode                  │
│  ☐ Reduced precision input          │
│  ☐ Switch access support            │
│  ☐ Keyboard navigation              │
│                                     │
│  COGNITIVE                          │
│  ☐ Plain language by default        │
│  ☐ Simplified text mode             │
│  ☐ One step at a time               │
│  ☐ Confirm before destructive       │
│    actions                          │
│  ☐ Undo available (30 sec)          │
│  ☐ Reduced choices                  │
│                                     │
│  [Reset to defaults]                │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. CONFLICT RESOLUTION ENGINE

When multiple presets or toggles are active and their settings conflict, the app must resolve the conflict deterministically.

### 10.1 Priority Order

1. **Current State** (highest priority — temporary override)
2. **User Manual Override** (user changed a specific toggle)
3. **Support Preset Default** (from the most recently activated preset)
4. **System Default** (lowest priority — app defaults)

### 10.2 Resolution Rules

| Conflict | Resolution |
|----------|------------|
| ADHD Support wants more reminders. Overwhelmed wants fewer. | Overwhelmed wins (Current State > Preset). |
| Depression Support wants Bare Minimums visible. User manually toggled "Show all tasks." | User override wins (Manual > Preset). |
| Two presets both active. One wants plain language. The other doesn't specify language. | Plain language wins (more protective setting). |
| Two presets conflict on notification frequency. Neither is a Current State. | More protective wins. "Reduce notifications" beats "Increase reminders." |
| User manually toggles something that a Current State overrides. | Current State wins during its active period. Manual override restores when Current State expires. |

### 10.3 Resolver Traces

Every conflict resolution is logged in the Resolver Engine (built by Kit). The trace shows:
- Which rules fired.
- Which rule matched.
- What priority it had.
- What the final effect was.

This is visible in the Debug Screen (developer-only) and logged in the Developer Ghost Log.

---

## 11. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Architecture) | SupportPreset data class. SensitivityToggle definitions. Resolver engine (basic — priority chain). Current State data class. Settings screens for presets, toggles, and accessibility (UI only — wiring to actual app behaviour comes later). |
| **1D** (First Presets) | Five presets fully wired: ADHD Support, Depression Support, Anxiety Support, Low-Stimulation Support, Postpartum Support. Current State layer active with 5 states: Overwhelmed, Panicking, Low Energy, Exhausted, Grief Day. Colour Card integration. Capacity Check-In integration. |
| **2A** (Current State Full) | All 17 Current States wired. Current State shortcuts from presets. Voice activation for Current State. Status Shield auto-integration. |
| **2B** (Full Suite) | All 25 Support Presets wired. All 50+ Sensitivity Toggles individually toggleable. Custom preset builder. Accessibility settings fully integrated with app behaviour. Full resolver traces. |

---

## 12. WHAT SUPPORT PRESETS & ACCESSIBILITY DOES NOT DO

- It does not diagnose. Presets are tools, not labels.
- It does not activate automatically. The user chooses. The app never decides "you seem anxious."
- It does not hide what it changes. Every toggle is documented. Every preset shows exactly what it does.
- It does not restrict accessibility behind presets. Accessibility settings are for everyone.
- It does not override user manual choices. Manual override always wins against presets.
- It does not share preset or toggle data. What supports Beth uses is private (D3).

---

That's Support Presets & Accessibility. Three layers. Twenty-five presets. Fifty-plus toggles. Seventeen current states. Full conflict resolution. Transparent. User-controlled. Dignified language always.
