# TETHER — MODULE 8: HEALTH STATUS
## Complete Design Specification

**Module:** Health Status
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟠 (D3; some D4 for crisis-related health data)
**Phase:** 1D (basic trackers, medication screen) → 2B (full condition categories, doctor exports, cloud resource integration)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT HEALTH STATUS IS

Health Status is the module for tracking health data, managing conditions, storing documents, preparing for medical appointments, and surfacing patterns. It is NOT a diagnostic tool. It is NOT a medical device. It does NOT interpret results, recommend treatments, adjust medications, or replace clinical judgement.

It answers the question: *"What's going on with my health, and what do I need to tell my doctor?"*

Health Status connects to Family Hub (for dependent medication tracking), Reproductive Health (for cycle-related symptoms), Mental Health Toolkit (for crisis plans and therapy notes), and the Cloud Resource Library (for accredited health resources). It does not stand alone — it is part of the broader health ecosystem within Tether.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Track, don't diagnose** | The app logs what the user enters. It does not interpret. It does not suggest causes. It surfaces patterns: "You've logged headaches on 5 of the last 7 days." Not "You may have a migraine condition." |
| **Support, don't treat** | Medication reminders, appointment prep, symptom logging. No dose calculations. No treatment recommendations. |
| **Export for your doctor** | Everything is structured for a "Discuss with Doctor" export. Clear summaries. Trend lines where applicable. No AI interpretation — just the data the user entered. |
| **Privacy is paramount** | Health data is D3 (High sensitivity) by default. Some items (crisis plans, certain mental health data) are D4 (Very High). Sharing is per-item, opt-in only. Nothing is shared with partners, family, or insurers without explicit consent. |
| **Accredited resources only** | Health resources linked from this module must be accredited or expert-reviewed. No influencer content. No unverified claims. Red-flag symptoms link to official guidance. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 🩺 Health Status (once added from Module Management).
**From Dashboard:** Module quick-glance card: "💊 Ibuprofen: Wait until 2:15pm" — tappable.
**From Notes:** Capturing a symptom or health note via Notes routes here.
**From Family Hub:** Child medication tracker links to dependent medication section.
**From Reproductive Health:** Cycle symptoms can be viewed in both modules.

---

## 4. HEALTH STATUS MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard     🩺 HEALTH STATUS   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚡ AT A GLANCE               │   │
│  │                             │   │
│  │ 💊 Medications: 2 active    │   │
│  │    Paracetamol · Available  │   │
│  │    Ibuprofen · Wait 1h 42m  │   │
│  │                             │   │
│  │ 📅 Next appointment:        │   │
│  │    GP · 15th July · 2pm     │   │
│  │                             │   │
│  │ 📊 Recent: BP 118/76 (3rd   │   │
│  │    June) · Glucose 5.2      │   │
│  │    (1st June)               │   │
│  │                             │   │
│  │ ⚠ 1 result pending review   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 MY CONDITIONS             │   │
│  │                             │   │
│  │ [View all] [+ Add]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 TRACKERS                  │   │
│  │                             │   │
│  │ 🫀 Blood Pressure   [Log]  │   │
│  │ 🩸 Glucose          [Log]  │   │
│  │ 🩺 Symptoms         [Log]  │   │
│  │ 💢 Pain             [Log]  │   │
│  │ 😴 Sleep            [Log]  │   │
│  │ ⚡ Seizures         [Log]  │   │
│  │ 🤕 Migraine         [Log]  │   │
│  │ 🔥 Flares           [Log]  │   │
│  │ 🥱 Fatigue          [Log]  │   │
│  │ 🌀 Dizziness        [Log]  │   │
│  │ [+ Add tracker]             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 MEDICATIONS               │   │
│  │                             │   │
│  │ Personal: 2 active          │   │
│  │ Dependent: Evander (3)      │   │
│  │ [View all medications]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📁 DOCUMENTS                 │   │
│  │                             │   │
│  │ Blood work · 15th April     │   │
│  │ Discharge summary · 2nd Mar │   │
│  │ Vaccination record · Current│   │
│  │ [+ Upload document]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 APPOINTMENTS              │   │
│  │                             │   │
│  │ GP · 15th July · 2pm        │   │
│  │ [Prepare for this appt]     │   │
│  │ [+ Add appointment]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📤 DOCTOR EXPORT             │   │
│  │ [Generate summary for GP]   │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. CONDITION CATEGORIES

Health Status organises health data by condition category. This helps with doctor exports and pattern detection.

### 5.1 Condition Categories

| Category | Conditions Tracked | Risk |
|----------|-------------------|------|
| **🫀 Cardiovascular / Circulation** | Hypertension, hypotension, heart disease, heart failure, arrhythmias, POTS/dysautonomia, stroke/TIA history, DVT/PE history, high cholesterol | 🟠 |
| **🫁 Respiratory** | Asthma, COPD, sleep apnoea, allergies affecting breathing, recurrent chest infections | 🟠 |
| **🩸 Endocrine / Metabolic** | Type 1 diabetes, type 2 diabetes, gestational diabetes, prediabetes, thyroid conditions, PCOS, iron/B12/vitamin D deficiency, insulin resistance | 🟠 |
| **🧠 Neurological** | Epilepsy, migraine, chronic headache, multiple sclerosis, Parkinson's, functional neurological disorder, ABI/TBI, stroke recovery, neuropathy, restless legs, narcolepsy, vertigo | 🟠 |
| **💢 Pain / Musculoskeletal** | Chronic pain, fibromyalgia, arthritis, back pain, hypermobility/EDS, osteoporosis, injury recovery, sciatica | 🟠 |
| **🔬 Gastrointestinal / Digestive** | IBS, IBD, Crohn's, ulcerative colitis, coeliac disease, reflux/GERD, food intolerances, gallbladder history, liver disease | 🟠 |
| **🛡 Immune / Autoimmune** | Lupus, rheumatoid arthritis, coeliac disease, multiple sclerosis, psoriasis/PsA, IBD, Hashimoto's/Graves', immunosuppression, long COVID | 🟠 |
| **🫘 Kidney / Urinary** | CKD, kidney stones, recurrent UTIs, incontinence, bladder pain/IC, prostate-related urinary symptoms | 🟠 |
| **🧴 Skin / Allergy / Immune Reactions** | Eczema, psoriasis, acne, hives, anaphylaxis risk, food allergy, hay fever, medication allergies, contact dermatitis | 🟠 |
| **🎗 Cancer / Serious Illness** | Cancer history, active treatment, remission/survivorship, palliative care, chemo/radiotherapy tracking | 🟠 |
| **🦷 Oral / Dental** | Dental anxiety, gum disease, braces/orthodontics, dentures, TMJ pain | 🟢 |
| **😴 Sleep** | Insomnia, sleep apnoea, narcolepsy, restless legs, shift-work disruption, postpartum sleep deprivation, nightmares/PTSD sleep disturbance | 🟠 |
| **♿ Sensory / Accessibility / Disability** | Low vision/blindness, deaf/HoH, mobility disability, cognitive disability, speech impairment, sensory processing sensitivity | 🟢 |

### 5.2 Adding a Condition

```
┌─────────────────────────────────────┐
│  ← Health        ADD A CONDITION    │
├─────────────────────────────────────┤
│                                     │
│  Category                           │
│  [Neurological ▼]                   │
│                                     │
│  Condition name                     │
│  [Migraine____________________]     │
│                                     │
│  Diagnosed by                       │
│  [Dr Sarah Chen · Neurologist___]   │
│                                     │
│  Date diagnosed                     │
│  [March 2024 ____________]          │
│                                     │
│  Active trackers to enable:         │
│  ☑ Migraine log                    │
│  ☑ Trigger tracking                │
│  ☑ Medication reminders            │
│  ☐ Pain scale                      │
│                                     │
│  Notes                             │
│  [Typically 2-3 per month._______] │
│  [Aura 30 min before._____________]│
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. TRACKERS

### 6.1 Available Trackers

| Tracker | What It Logs | Best For |
|---------|--------------|----------|
| **🫀 Blood Pressure** | Systolic, diastolic, heart rate, date/time, notes | Hypertension, POTS, general monitoring |
| **🩸 Glucose** | Reading, context (fasting/before meal/after meal/bedtime), date/time, notes | Diabetes, prediabetes, gestational diabetes |
| **🩺 Symptoms** | Symptom description, severity (1-10), duration, triggers, notes | General health, chronic conditions |
| **💢 Pain** | Location, intensity (1-10), type (sharp/dull/throbbing/etc.), duration, triggers, relief measures | Chronic pain, injury recovery, migraines |
| **😴 Sleep** | Hours slept, quality (1-5), disruptions, notes | Insomnia, sleep apnoea, shift work |
| **⚡ Seizures** | Type, duration, triggers, aura, recovery time, notes | Epilepsy |
| **🤕 Migraine** | Intensity (1-10), aura, triggers, medication taken, duration, notes | Migraine |
| **🔥 Flares** | Condition, severity (1-10), triggers, duration, notes | Autoimmune, chronic illness |
| **🥱 Fatigue** | Level (1-10), context, duration, notes | Chronic fatigue, long COVID, general |
| **🌀 Dizziness** | Type (spinning/lightheaded/unsteady), duration, triggers, notes | POTS, vertigo, dysautonomia |
| **🫁 Respiratory** | Peak flow, symptoms, triggers, inhaler use, notes | Asthma, COPD |
| **🔬 Bowel** | Type, frequency, symptoms, triggers, notes | IBS, IBD, general |
| **🫘 Urinary** | Frequency, urgency, pain, colour, notes | UTIs, kidney, prostate |
| **🧴 Skin** | Location, type (rash/lesion/dryness), itch, triggers, notes | Eczema, psoriasis, allergies |

### 6.2 Logging a Reading

Example: Blood Pressure

```
┌─────────────────────────────────────┐
│  ← Trackers       LOG BLOOD PRESSURE│
├─────────────────────────────────────┤
│                                     │
│  Systolic *                         │
│  [118_________________________]     │
│                                     │
│  Diastolic *                        │
│  [76__________________________]     │
│                                     │
│  Heart rate (optional)              │
│  [72__________________________]     │
│                                     │
│  Date/time                          │
│  [Today · 9:15 AM             ]     │
│                                     │
│  Context (optional)                 │
│  ○ Resting                          │
│  ● After activity                   │
│  ○ After medication                 │
│                                     │
│  Notes (optional)                   │
│  [After morning walk___________]    │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

### 6.3 Tracker History & Trends

Each tracker has a history view with simple trend visualisation.

```
┌─────────────────────────────────────┐
│  ← Trackers    🫀 BLOOD PRESSURE    │
├─────────────────────────────────────┤
│                                     │
│  Last 30 days                       │
│                                     │
│  130 ┤                              │
│  120 ┤    · ·  ·                    │
│  110 ┤  · · ··· ··  · ·            │
│  100 ┤                              │
│   90 ┤                              │
│   80 ┤  · ·  ·· ··  · · ·          │
│   70 ┤ ·  · ·     ·· ·             │
│   60 ┤                              │
│      └──────────────────────        │
│      1st                    30th    │
│                                     │
│  · Systolic    · Diastolic          │
│                                     │
│  Average (30 days): 118/76          │
│  Highest: 128/82 (5th June)        │
│  Lowest: 108/70 (18th June)        │
│                                     │
│  [View all readings]                │
│  [Export for doctor]                │
│                                     │
└─────────────────────────────────────┘
```

**Trend notes:**
- Simple visual trends. No AI interpretation.
- "Your systolic readings have been between 108-128 over the last 30 days."
- NOT: "Your blood pressure is normal." NOT: "Your blood pressure is concerning."
- The user and their doctor interpret. The app presents the data.

---

## 7. MEDICATION SCREEN

The medication screen is split into Personal and Dependent. This is the same medication tracker used in Family Hub, accessible from both modules.

### 7.1 Personal Medication

```
┌─────────────────────────────────────┐
│  ← Health       💊 MY MEDICATIONS   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 Sertraline · 50mg        │   │
│  │ Scheduled · Daily · 8am     │   │
│  │ Last: Today 8:05am ✅       │   │
│  │ Next: Tomorrow 8am          │   │
│  │ Refill: 15th July           │   │
│  │ [Log dose] [Missed dose]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 Sumatriptan · 50mg       │   │
│  │ As-needed · Migraine        │   │
│  │ Last: 5th June · 2pm        │   │
│  │ [Log dose]                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 Iron · 100mg              │   │
│  │ Scheduled · Daily · 8am     │   │
│  │ With food recommended       │   │
│  │ Last: Today 8:05am ✅       │   │
│  │ Notes: Take with vitamin C  │   │
│  │ for absorption              │   │
│  │ [Log dose] [Missed dose]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  [+ Add medication]                │
│                                     │
└─────────────────────────────────────┘
```

### 7.2 Dependent Medication

Shows medications for children, partner, pets — anyone Beth manages medication for.

```
┌─────────────────────────────────────┐
│  ← Health    💊 DEPENDENT MEDS      │
├─────────────────────────────────────┤
│                                     │
│  👶 EVANDER                         │
│  ┌─────────────────────────────┐   │
│  │ 💊 Paracetamol · 2.5ml      │   │
│  │ As-needed · Min 4h interval │   │
│  │ Last: 10:33am               │   │
│  │ 🟢 Available now            │   │
│  │ [Log dose]                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 Ibuprofen · 2.5ml        │   │
│  │ As-needed · Min 6h interval │   │
│  │ Last: 8:15am                │   │
│  │ 🟡 Wait — 1h 42m remaining  │   │
│  └─────────────────────────────┘   │
│                                     │
│  🐱 JAEGER                          │
│  ┌─────────────────────────────┐   │
│  │ 💊 Flea treatment           │   │
│  │ Scheduled · Monthly         │   │
│  │ ⚠ Overdue — 3 days         │   │
│  │ [Log given]                 │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 7.3 Adding a Medication

Same flow whether personal or dependent. The "For" field determines where it appears.

```
┌─────────────────────────────────────┐
│  ← Medications    ADD MEDICATION    │
├─────────────────────────────────────┤
│                                     │
│  For: [Beth ▼]                      │
│       Beth / Evander / Theodore     │
│       / Annabella / Ant / Jaeger    │
│                                     │
│  Medication name *                  │
│  [Sertraline__________________]     │
│                                     │
│  Dose *                             │
│  [50mg________________________]     │
│                                     │
│  Type *                             │
│  ● Scheduled                        │
│  ○ As-needed (minimum interval)     │
│                                     │
│  Schedule                           │
│  [Daily ▼] at [8:00 AM]            │
│                                     │
│  Refill reminder (optional)         │
│  ☑ Remind me 5 days before         │
│    running out                      │
│  Quantity: [30] days supply        │
│                                     │
│  Notes (optional)                   │
│  [Take with food_______________]    │
│                                     │
│  ⚠ This app does not calculate     │
│  doses. Enter exactly as            │
│  prescribed by your doctor.         │
│                                     │
│  [Cancel]              [Save]       │
│                                     │
└─────────────────────────────────────┘
```

**🔴 Red Rule:** The app does not calculate doses. It stores what the user enters. Dose calculators are clinical-adjacent and must not be built without expert/regulatory review.

**✅ Medication reminders are Amber.** Safe with disclaimers. "Remind me to take Sertraline at 8am."

---

## 8. HEALTH STATUS SUPPORT MODES (CURRENT STATES)

These are temporary states accessible from the Current State selector. They adjust the app for acute health situations.

| Mode | What It Does |
|------|--------------|
| **🔥 Flare Day** | Reduces non-urgent notifications. Surfaces symptom tracker. Reduces task expectations to Bare Minimums. Gentle language. |
| **🥱 Low Energy** | Same as general Low Energy state — health-specific framing. |
| **💢 High Pain** | Minimises app demands. Surfaces pain tracker. Offers grounding and distraction. Suppresses non-urgent notifications. |
| **⚡ Post-Seizure Recovery** | Dims screen. Suppresses all non-urgent notifications. Shows recovery timer. Option to notify trusted contact. Low-stimulation mode forced. |
| **🤕 Migraine Mode** | Dark theme forced. Low-stimulation forced. All colours muted. Brightness suggestion. Notifications suppressed. |
| **🤒 Sick Day** | Bare Minimums only. Hydration reminders. Medication reminders. "Rest is productive." |
| **🏥 Post-Op / Recovery** | Medication schedule prominent. Activity restrictions noted. Appointment reminders. Low-energy mode. |
| **🦠 Infection Risk** | Symptom tracker prominent. Temperature logging. Appointment prep. |
| **😴 Sleep Deprived** | Fewer notifications. No heavy decisions. Simplified dashboard. |
| **🌀 Dizziness/Fainting Day** | Safety prompts. "Move slowly. Stay hydrated. Contact GP if worsening." Quick-access trusted contact. |
| **🫁 Respiratory Flare** | Inhaler reminders. Peak flow logging. Trigger notes. |
| **🔬 GI Flare** | Bathroom symptom tracker. Safe food list accessible. Hydration reminders. |

---

## 9. HEALTH DOCUMENTS

### 9.1 Documents Screen

```
┌─────────────────────────────────────┐
│  ← Health       📁 HEALTH DOCUMENTS │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 ALLERGIES & REACTIONS     │   │
│  │ Penicillin · Anaphylaxis    │   │
│  │ Latex · Contact dermatitis  │   │
│  │ [Edit allergy list]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩸 PATHOLOGY RESULTS         │   │
│  │ Blood work · 15th April 2026│   │
│  │ Iron studies · 2nd March    │   │
│  │ [+ Upload result]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏥 DISCHARGE SUMMARIES       │   │
│  │ Cairns Hospital · 2nd Mar   │   │
│  │ [+ Upload document]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩻 IMAGING REPORTS           │   │
│  │ Chest X-ray · 10th Jan 2026 │   │
│  │ [+ Upload report]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💉 VACCINATION RECORD        │   │
│  │ COVID · 3 doses · Last:     │   │
│  │   12th December 2025        │   │
│  │ Influenza · Annual · Last:  │   │
│  │   5th April 2026            │   │
│  │ [+ Add vaccination]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 ACTION PLANS              │   │
│  │ Asthma action plan · Current│   │
│  │ Seizure response plan       │   │
│  │ [+ Add action plan]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👨‍⚕️ DOCTOR & SPECIALIST LIST  │   │
│  │ GP: Dr Sarah Chen           │   │
│  │ Neuro: Dr James Lee         │   │
│  │ Paed: Dr Emily Carter       │   │
│  │ [+ Add contact]             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. DOCTOR EXPORT

The "Discuss with Doctor" export generates a structured summary for medical appointments.

```
┌─────────────────────────────────────┐
│  ← Health     📤 DOCTOR EXPORT      │
├─────────────────────────────────────┤
│                                     │
│  For: Dr Sarah Chen · GP            │
│  Appointment: 15th July · 2pm       │
│                                     │
│  Include sections:                  │
│  ☑ Current medications             │
│  ☑ Recent symptoms (30 days)       │
│  ☑ Tracker summaries               │
│  ☑ Questions for doctor            │
│  ☐ Full history (all time)         │
│                                     │
│  Format: [PDF ▼]                    │
│  PDF · Print-friendly · Email       │
│                                     │
│  [Generate export]                  │
│                                     │
│  ⚠ This export contains your       │
│  data as you entered it. It does    │
│  not contain AI interpretation.     │
│  Your doctor interprets results.    │
│                                     │
└─────────────────────────────────────┘
```

**Export content:**
- Current medication list with dosages and schedules.
- Recent symptoms (last 30 days) with dates and severity.
- Tracker summaries (BP trends, glucose readings, pain levels — visual where helpful).
- Questions Beth has saved for the doctor.
- No AI interpretation. No suggestions. No "possible causes." Just the data.

---

## 11. RED-FLAG SYMPTOM RESOURCES

For certain symptoms, the app provides accredited guidance on when to seek urgent care. These are links to official resources, not AI-generated advice.

| Symptom | Resource Link |
|---------|---------------|
| Chest pain | "Chest pain: when to call 000" — Healthdirect Australia |
| Severe headache with stiff neck | "Meningitis symptoms" — Healthdirect Australia |
| Sudden confusion or difficulty speaking | "Stroke symptoms — FAST" — Stroke Foundation |
| Heavy bleeding postpartum | "Postpartum haemorrhage warning signs" — PANDA/COPE |
| Fever in infant under 3 months | "Fever in babies" — Raising Children Network |
| Seizure lasting more than 5 minutes | "When to call an ambulance for a seizure" — Epilepsy Action Australia |
| Anaphylaxis symptoms | "Anaphylaxis: signs and symptoms" — ASCIA |
| Suicidal thoughts with plan | "If you're thinking about suicide" — Lifeline Australia |

**These resources are cloud-based (from the Cloud Resource Library). They are updated centrally. They do not require app updates.**

---

## 12. STATE RESPONSIVENESS

| State | Health Status Behaviour |
|-------|-------------------------|
| **All states** | Health Status data is never used to push notifications or suggestions without user configuration. |
| **Chronic Health Support Preset** | Trackers more prominent. Flare day Current State accessible. Appointment prep reminders. |
| **Low Energy / Exhausted** | Simplified tracker logging. Fewer fields. Quick-log options. |
| **Anxiety Support** | "What to expect at your appointment" summaries. Symptom logging framed gently. No catastrophic language. |
| **Depression Support** | Medication reminders gentle. Self-care prompts alongside health data. |

---

## 13. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1D** (Basic) | Personal and dependent medication screen. Basic trackers (BP, glucose, symptoms, pain, sleep). Health documents storage. Allergy list. Doctor export (basic). Red-flag symptom resources (links to accredited sources). Seizure log and post-seizure recovery mode (moved from Mental Health — belongs here under Neurology). |
| **2B** (Full) | Full condition categories with individualised trackers. Condition-specific support modes. Advanced trend visualisation. "Discuss with Doctor" export with custom date ranges and section selection. Integration with Cloud Resource Library for condition-specific resources. Specialist and doctor contact management. Action plan storage (asthma, seizure, anaphylaxis). Vaccination record with reminders. |
| **3+** | Integration with wearable data (if user opts in). Advanced pattern detection with clear limitations. |

---

## 14. WHAT HEALTH STATUS DOES NOT DO

- It does not diagnose. Ever. It presents data. The doctor interprets.
- It does not calculate medication doses. 🔴 Red — do not build.
- It does not interpret blood work, imaging, or pathology results.
- It does not recommend treatments or adjust medications.
- It does not perform emergency triage. "If you are experiencing chest pain, call 000." — that's a resource link, not a triage tool.
- It does not share health data with anyone without explicit opt-in consent.
- It does not replace a medical record. It is a personal tracking tool.
- It does not provide medical advice. Resources are from accredited sources. AI instances do not give health advice.

---

That's Health Status. Track, don't diagnose. Export for your doctor. Medication management. Condition-specific trackers. Red-flag resources from accredited sources. Privacy paramount.
