# TETHER — MODULE 9: REPRODUCTIVE HEALTH
## Complete Design Specification

**Module:** Reproductive Health
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟠 (D3; some D4 — pregnancy loss, postpartum psychosis resources)
**Phase:** 1D (basic cycle tracking, contraception, pregnancy) → 2B (full lifecycle: menopause, men's health, full postpartum suite)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT REPRODUCTIVE HEALTH IS

Reproductive Health is the module that covers reproductive health across all life stages and body types. It replaces the original "Cycle Tracker" — cycle tracking is now one sub-section within a broader module that includes contraception, fertility, pregnancy, pregnancy loss, postpartum recovery, breastfeeding, perimenopause, menopause, and men's reproductive health.

It answers the question: *"What's happening with my reproductive health, across my whole life?"*

Reproductive Health connects to Calendar (for cycle overlay), Health Status (for shared symptoms and medications), Family Hub (for postpartum and baby care integration), and Mental Health Toolkit (for PMDD, postpartum mental health, and pregnancy loss support). It is body-neutral, non-pressuring, and designed for all genders.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **All bodies, all stages** | This module serves people who menstruate, people who don't, people who are pregnant, people who are postpartum, people in perimenopause, people with testes and prostates. No assumptions. |
| **"May be," never "is"** | Cycle predictions use tentative language. "Your period may start around Thursday." Not "Your period starts Thursday." Bodies are not machines. |
| **No baby pressure** | Fertility tracking is available but never pushed. Pregnancy content is factual. No "your biological clock" language. No assumptions about family goals. |
| **Postpartum sensitivity** | After a birth is logged, the module does not predict periods. It does not ask "when will you try again?" It tracks recovery. It offers support. |
| **Privacy is paramount** | Reproductive health data is D3 (High sensitivity). Pregnancy loss data is D4. Nothing is shared without explicit opt-in. Partner sharing is per-item only. |
| **Accredited resources for high-risk topics** | Postpartum psychosis, pregnancy complications, pregnancy loss — all linked resources are accredited. No unverified content. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → ⋯ More → 🩸 Reproductive Health (once added from Module Management).
**From Dashboard:** Cycle indicator — tapping opens the Cycle Tracker sub-section.
**From Calendar:** Tapping the cycle overlay opens the Cycle Tracker.
**From Health Status:** Linked symptoms, medications, and appointments.
**From Family Hub:** Postpartum section links to recovery tracking.
**From Mental Health Toolkit:** PMDD resources, postpartum mental health links.

---

## 4. REPRODUCTIVE HEALTH MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard  🩸 REPRODUCTIVE HEALTH│
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩸 CYCLE TRACKING            │   │
│  │ Day 14 · Follicular phase    │   │
│  │ Next period may start:       │   │
│  │ 2nd July                     │   │
│  │ [View cycle]            [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 CONTRACEPTION             │   │
│  │ Pill · Active · 8am reminder│   │
│  │ [View details]          [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🌱 FERTILITY                 │   │
│  │ No active tracking           │   │
│  │ [Set up]                [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🤰 PREGNANCY                 │   │
│  │ Not currently pregnant       │   │
│  │ [Log pregnancy]         [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍼 POSTPARTUM                │   │
│  │ Week 8 · Recovery tracking   │   │
│  │ [View recovery]         [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🤱 BREASTFEEDING             │   │
│  │ Mixed feeding · 6 feeds/day │   │
│  │ [View log]              [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔥 PERIMENOPAUSE / MENOPAUSE│   │
│  │ Not active                   │   │
│  │ [Set up]                [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩺 SEXUAL HEALTH             │   │
│  │ Last STI test: 15th March    │   │
│  │ [View details]          [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ EMERGENCY RESOURCES       │   │
│  │ Postpartum psychosis        │   │
│  │ Pregnancy complications     │   │
│  │ Pregnancy loss support      │   │
│  │ [View resources]            │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. PERIOD / CYCLE TRACKING

### 5.1 Cycle Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🩸 CYCLE TRACKING  │
├─────────────────────────────────────┤
│                                     │
│  Day 14 · Follicular phase          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ CURRENT CYCLE                │   │
│  │ Day 14 of ~28 days          │   │
│  │ Started: 18th June          │   │
│  │ Next may start: ~2nd July   │   │
│  │                             │   │
│  │ 🩸 Follicular · Energy may  │   │
│  │ feel higher today           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 CYCLE CALENDAR            │   │
│  │ [Mini month view with phase  │   │
│  │  shading — tappable to open  │   │
│  │  full Calendar]             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 LOG TODAY                 │   │
│  │ Flow: ○ Light ● Medium ○ Heavy│   │
│  │ Symptoms: ☑ Cramps ☐ Headache│   │
│  │ Pain: [3/10]                │   │
│  │ Mood: 😊 😐 😔 😡 🥱       │   │
│  │ Energy: [Medium ▼]          │   │
│  │ Notes: [_______________]    │   │
│  │ [Save]                      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 CYCLE HISTORY             │   │
│  │ Last 3 cycles:              │   │
│  │ · 28 days · 18th June       │   │
│  │ · 27 days · 21st May        │   │
│  │ · 29 days · 22nd April      │   │
│  │ Average: 28 days            │   │
│  │ [View full history]         │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 5.2 Cycle Predictions

Predictions use "may be" phrasing. Never definitive.

- "Your next period may start around 2nd July."
- "You may be in your fertile window from 28th June to 2nd July." (if fertility tracking is enabled)
- "Ovulation may occur around 30th June."

**Prediction accuracy disclaimer:** "Predictions are estimates based on your logged data. Cycles can vary for many reasons including stress, illness, postpartum recovery, perimenopause, and hormonal changes."

### 5.3 Cycle Overlay on Calendar

Covered in the Calendar module spec. Phase shading on the month grid. Menstrual: soft red. Follicular: very subtle blue or none. Ovulation: soft purple. Luteal: soft amber. Opacity 15-20%.

### 5.4 Irregular Cycles

If cycles are irregular (varying by more than 5 days), the app:
- Does not show firm predictions.
- Shows a range: "Based on your last 6 cycles, your period may start between 28th June and 5th July."
- Offers: "Would you like to track symptoms that might help identify patterns?"
- Does not push for regularity. Irregular is normal for many people.

### 5.5 Conditions That Affect Cycles

The user can log conditions that affect their cycle:

| Condition | How It's Tracked |
|-----------|------------------|
| **Endometriosis** | Pain levels, bleeding patterns, symptom correlation with cycle phase |
| **PCOS** | Cycle length variability, symptom tracking, medication notes |
| **PMDD** | Mood symptoms mapped to cycle phases, severity tracking, coping strategies |
| **Adenomyosis** | Pain levels, bleeding heaviness |
| **Fibroids** | Symptom tracking, size/location notes from scans |
| **Pelvic pain** | Location, intensity, correlation with cycle |
| **Migraine with cycle** | Migraine log linked to cycle days |

---

## 6. CONTRACEPTION

### 6.1 Contraception Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  💊 CONTRACEPTION   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ACTIVE CONTRACEPTION         │   │
│  │                             │   │
│  │ 💊 Combined oral pill       │   │
│  │ Active · Take at 8am        │   │
│  │ Current pack started:       │   │
│  │   18th June                 │   │
│  │ Next pack starts:           │   │
│  │   9th July                  │   │
│  │                             │   │
│  │ ☑ Today's pill taken        │   │
│  │    8:05am ✅                │   │
│  │                             │   │
│  │ Reminders: ON · 8am daily   │   │
│  │ [Log missed pill]           │   │
│  │ [Edit] [Stop method]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ OTHER METHODS (inactive)     │   │
│  │ [+ Add method]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 RESOURCES                 │   │
│  │ · Missed pill guidance      │   │
│  │ · Emergency contraception   │   │
│  │ · Contraception options     │   │
│  │    (accredited sources)     │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 6.2 Contraception Methods Supported

| Method | Tracking |
|--------|----------|
| **Combined oral pill** | Daily reminder. Pack tracking. Missed pill guidance. |
| **Progestin-only pill** | Daily reminder. Time-sensitive (within 3-hour window). |
| **Contraceptive ring** | Insertion date. Removal date. Replacement reminder. |
| **Contraceptive patch** | Weekly change reminder. |
| **Injection (Depo-Provera)** | 12-week reminder. Next appointment date. |
| **Implant (Implanon)** | Insertion date. Expiry/replacement date (3 years). |
| **IUD (hormonal)** | Insertion date. Expiry date (5 years). Check-string reminder. |
| **IUD (copper)** | Insertion date. Expiry date (5-10 years). |
| **Barrier methods** | No tracking needed. Notes only. |
| **Fertility awareness** | Links to cycle tracking. Ovulation awareness. |
| **Emergency contraception** | Resource links. Pharmacy finder. No tracking — one-time event. |

### 6.3 Missed Contraception

If a pill is missed:
- The app logs the missed dose (no shame).
- Provides accredited guidance based on the method type and how many pills were missed.
- Links to the Cloud Resource Library: "Missed pill guidance — Family Planning Australia."
- Does NOT provide its own guidance. Always links to accredited sources.

---

## 7. FERTILITY / TRYING TO CONCEIVE

### 7.1 Fertility Tracking

```
┌─────────────────────────────────────┐
│  ← Repro Health  🌱 FERTILITY       │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ CYCLE AWARENESS              │   │
│  │ Day 14 · May be ovulating   │   │
│  │ Fertile window: ~28th June  │   │
│  │   to 2nd July               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 LOG                        │   │
│  │ Ovulation signs:             │   │
│  │ ☐ Cervical mucus             │   │
│  │ ☐ BBT (basal body temp)     │   │
│  │ ☐ Ovulation test result     │   │
│  │ Intercourse: [Log]           │   │
│  │ [Save]                       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 APPOINTMENTS              │   │
│  │ Fertility specialist · 5th   │   │
│  │   August · 10am              │   │
│  │ [+ Add appointment]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 QUESTIONS FOR DOCTOR      │   │
│  │ [Add question]               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ⚠ Fertility tracking is for      │
│  personal awareness only. It is    │
│  not a medical tool. If you have   │
│  concerns about fertility, speak   │
│  with your GP.                     │
│                                     │
└─────────────────────────────────────┘
```

**Language rules for fertility:**
- Body-neutral. No "your biological clock." No assumptions about goals.
- "You may be in your fertile window" — not "You're fertile — act now!"
- No pressure. No urgency. Information only.

---

## 8. PREGNANCY

### 8.1 Pregnancy Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🤰 PREGNANCY       │
├─────────────────────────────────────┤
│                                     │
│  Week 28 · Third trimester          │
│  Due date: 15th September 2026      │
│  12 weeks until your due date       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👶 BABY GROWTH               │   │
│  │ This week: Baby is about     │   │
│  │ the size of an eggplant.     │   │
│  │ Lungs are developing.        │   │
│  │ [Read more] (accredited)    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 UPCOMING APPOINTMENTS     │   │
│  │ Midwife · 2nd July · 10am   │   │
│  │ Glucose test · 5th July     │   │
│  │ Antenatal class · 8th July  │   │
│  │ [+ Add appointment]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 SYMPTOMS & NOTES          │   │
│  │ [Log symptom]                │   │
│  │ [Log kick count]             │   │
│  │ [Log weight/blood pressure]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 BIRTH PLAN                │   │
│  │ [View / Edit birth plan]     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏥 HOSPITAL BAG              │   │
│  │ ☐ Maternity pads            │   │
│  │ ☐ Comfortable clothes       │   │
│  │ ☐ Phone charger             │   │
│  │ ☑ Snacks                    │   │
│  │ [View full checklist]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👤 PARTNER SUPPORT           │   │
│  │ ☐ Ant: Read about third     │   │
│  │    trimester                 │   │
│  │ ☐ Ant: Pack hospital bag    │   │
│  │ [+ Add partner task]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ RED FLAGS — CONTACT YOUR  │   │
│  │    MIDWIFE OR HOSPITAL IF:   │   │
│  │ · Reduced fetal movement    │   │
│  │ · Vaginal bleeding          │   │
│  │ · Severe headache           │   │
│  │ · Sudden swelling           │   │
│  │ [View all red flags]        │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 8.2 Pregnancy Onboarding

When pregnancy is logged, the app:
- Switches the Cycle Tracker to pregnancy mode (no period predictions).
- Sets up gestational age tracking from the last period date or conception date.
- Offers to add standard milestone appointments (12-week scan, 20-week scan, GD test, etc.).
- Offers pregnancy sensitivity options: "Would you like to hide baby/pregnancy content from the Dashboard? This is useful if you've experienced loss and find pregnancy content difficult."
- Does NOT push weight tracking. If the user wants to log weight, they can. No "recommended weight gain" calculators.

### 8.3 Pregnancy Loss Sensitivity

If a previous pregnancy loss has been logged:
- The app is gentle. No "Congratulations!" banners. No assumptions about excitement.
- Anniversary dates are remembered (if the user wants).
- Resources for pregnancy after loss are available but not pushed.
- The user can toggle "hide pregnancy content from Dashboard" at any time.

---

## 9. PREGNANCY LOSS

### 9.1 Pregnancy Loss Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🕊 PREGNANCY LOSS  │
├─────────────────────────────────────┤
│                                     │
│  This section is private. It is     │
│  not shared with anyone unless      │
│  you choose to.                     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ LOSS HISTORY                 │   │
│  │ 12th January 2026           │   │
│  │ 8 weeks                     │   │
│  │ [View details] [Edit]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 MEMORY DATES              │   │
│  │ ☐ Remember due date         │   │
│  │    (15th August)             │   │
│  │ ☐ Remember loss date        │   │
│  │    (12th January)            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 FOLLOW-UP APPOINTMENTS    │   │
│  │ GP review · 2nd February    │   │
│  │ [+ Add appointment]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🤝 SUPPORT                   │   │
│  │ · Sands Australia           │   │
│  │ · Red Nose Grief & Loss     │   │
│  │ · PANDA National Helpline   │   │
│  │ · Your GP or midwife        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚙ SETTINGS                   │   │
│  │ ☑ Hide pregnancy/baby       │   │
│  │    content from Dashboard    │   │
│  │ ☑ Disable pregnancy-related │   │
│  │    notifications             │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Privacy for pregnancy loss:**
- D4 (Very High sensitivity).
- Not shared with partner without explicit opt-in.
- Not included in any exports or summaries.
- Memory dates are private. They appear only if the user chooses.
- The app is gentle on anniversaries — no notifications unless the user has set them.

---

## 10. POSTPARTUM

### 10.1 Postpartum Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🍼 POSTPARTUM      │
├─────────────────────────────────────┤
│                                     │
│  Week 8 postpartum                  │
│  Evander born: 24th November 2025   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩸 PHYSICAL RECOVERY         │   │
│  │                             │   │
│  │ Bleeding: Light/spotting    │   │
│  │ Pain: 1/10 · Occasional     │   │
│  │ Perineum: Healed            │   │
│  │ C-section incision: N/A     │   │
│  │                             │   │
│  │ [Log today] [View history]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🩸 POSTPARTUM BLEEDING LOG   │   │
│  │ Week 1: Heavy/red           │   │
│  │ Week 2: Moderate/brown      │   │
│  │ Week 3: Light/pink          │   │
│  │ Week 4-6: Spotting/clear    │   │
│  │ Week 7-8: None              │   │
│  │                             │   │
│  │ ⚠ Bleeding that soaks a     │   │
│  │ pad in an hour? Call your    │   │
│  │ midwife or go to ED.         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧠 MENTAL HEALTH             │   │
│  │ How are you feeling?         │   │
│  │ 😊 😐 😔 😡 🥱 😨          │   │
│  │                             │   │
│  │ Support available:           │   │
│  │ · PANDA National Helpline   │   │
│  │ · COPE — Centre of Perinatal│   │
│  │   Excellence                │   │
│  │ · Your GP or midwife        │   │
│  │ · Postpartum Companion AI   │   │
│  │   (tap to chat)             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ POSTPARTUM WARNING SIGNS   │   │
│  │ · Heavy bleeding (soaking   │   │
│  │   a pad in an hour)         │   │
│  │ · Large clots (golf ball+)  │   │
│  │ · Foul-smelling discharge   │   │
│  │ · Fever or chills           │   │
│  │ · Severe headache           │   │
│  │ · Thoughts of harming       │   │
│  │   yourself or your baby     │   │
│  │                             │   │
│  │ If you experience any of     │   │
│  │ these, contact your midwife  │   │
│  │ or go to ED immediately.     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 6-WEEK CHECK-UP           │   │
│  │ ✅ Completed · 5th January   │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 10.2 Postpartum Bleeding Tracker (Lochia)

- Tracks bleeding from birth through approximately 6 weeks.
- Normal progression: bright red → pink → brown → clear/white.
- Flags: heavy clots (larger than a golf ball), foul smell, sudden increase in bleeding, bleeding beyond 6 weeks, return to bright red bleeding after it had tapered.
- Does NOT push for periods. Postpartum mode suppresses period predictions. Breastfeeding can delay menstruation for months — the app understands this.

### 10.3 Postpartum Mental Health

Postpartum mental health is in the Mental Health Toolkit, but linked from here.

- **Postpartum depression** — Screening questions (Edinburgh Postnatal Depression Scale reference), support links, partner notification option.
- **Postpartum anxiety** — Worry tracking, grounding tools, reassurance.
- **Postpartum rage** — Validation ("This is common and treatable"), coping strategies, support links.
- **Postpartum OCD / intrusive thoughts** — Normalising ("Many new parents experience intrusive thoughts. This does not make you a danger to your baby."), support links, when to seek help.
- **Postpartum psychosis** — 🔴 High-risk. Emergency resources only. "Postpartum psychosis is a medical emergency. If you or someone you know is experiencing confusion, hallucinations, or unusual behaviour after birth, call 000 or go to ED immediately." Links to PANDA, COPE, and emergency services.

---

## 11. BREASTFEEDING / LACTATION

### 11.1 Breastfeeding Log

```
┌─────────────────────────────────────┐
│  ← Repro Health  🤱 BREASTFEEDING   │
├─────────────────────────────────────┤
│                                     │
│  Mixed feeding · 6 feeds/day avg    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ TODAY'S LOG                  │   │
│  │ 10:30am · Left · 15 min     │   │
│  │ 8:15am · Right · 20 min     │   │
│  │ 6:00am · Both · 25 min      │   │
│  │ [+ Log feed] [+ Log pump]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 RECENT TREND              │   │
│  │ Mon ██████ 7 feeds          │   │
│  │ Tue ██████ 6 feeds          │   │
│  │ Wed ██████ 6 feeds          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 NOTES                     │   │
│  │ · Right side still tender   │   │
│  │ · Supply feels good          │   │
│  │ [+ Add note]                 │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 RESOURCES                 │   │
│  │ · Mastitis signs & symptoms │   │
│  │ · Nipple care                │   │
│  │ · Supply concerns            │   │
│  │ · Medication & breastfeeding │   │
│  │ · Weaning guidance           │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Feeding log options:**
- Breast (left / right / both, duration in minutes).
- Pump (left / right / both, amount in ml).
- Formula (amount in ml).
- Combination feed (breast + formula top-up).

**No pressure. No targets.** The log is for tracking, not performance review.

---

## 12. PERIMENOPAUSE / MENOPAUSE

### 12.1 Menopause Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🔥 MENOPAUSE       │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ CURRENT STAGE                │   │
│  │ Perimenopause               │   │
│  │ Last period: 45 days ago    │   │
│  │ Cycles: Irregular           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 SYMPTOM TRACKING          │   │
│  │                             │   │
│  │ 🔥 Hot flushes · 3/day     │   │
│  │ 😴 Sleep disruption · Mild  │   │
│  │ 🥱 Fatigue · Moderate       │   │
│  │ 🧠 Brain fog · Mild         │   │
│  │ 💢 Joint pain · Mild        │   │
│  │ ❤️ Mood changes · Tracking  │   │
│  │                             │   │
│  │ [Log today's symptoms]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 HRT / MEDICATIONS         │   │
│  │ [Add to medication tracker]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 APPOINTMENTS              │   │
│  │ GP menopause review · 5th    │   │
│  │   August                     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 RESOURCES                 │   │
│  │ · Jean Hailes for Women's   │   │
│  │   Health                    │   │
│  │ · Australasian Menopause   │   │
│  │   Society                   │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

**Menopause mode behaviour:**
- When activated, the Cycle Tracker shifts away from period prediction. Cycles are irregular by nature during perimenopause.
- Symptom tracking takes priority over cycle tracking.
- The app does not assume fertility status. Contraception reminders continue if applicable.
- Language is neutral. No "you're still young" or "it's not that bad." Just facts and support.

---

## 13. MEN'S REPRODUCTIVE HEALTH

### 13.1 Men's Health Main Screen

```
┌─────────────────────────────────────┐
│  ← Repro Health  🩺 MEN'S HEALTH    │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🫘 PROSTATE HEALTH            │   │
│  │ Last PSA test: 15th March    │   │
│  │ Next due: March 2027         │   │
│  │ [Log result] [Add reminder]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥜 TESTICULAR HEALTH         │   │
│  │ Self-check reminder:         │   │
│  │    Monthly · Next: 1st July │   │
│  │ [Log check]                  │   │
│  │ [How to do a self-check]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🌱 FERTILITY / SPERM HEALTH  │   │
│  │ [Log semen analysis result] │   │
│  │ [Fertility appointment]     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✂ VASECTOMY                  │   │
│  │ Date: 10th January 2026     │   │
│  │ Follow-up test: ✅ Clear    │   │
│  │    (15th April 2026)        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔥 SEXUAL HEALTH             │   │
│  │ · Erectile function notes   │   │
│  │ · Libido changes            │   │
│  │ · Testosterone symptoms     │   │
│  │ · STI testing reminders     │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 RESOURCES                 │   │
│  │ · Healthy Male — Andrology  │   │
│  │   Australia                 │   │
│  │ · Prostate Cancer Foundation│   │
│  │ · Family Planning Australia │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 14. SEXUAL HEALTH (FOR EVERYONE)

```
┌─────────────────────────────────────┐
│  ← Repro Health  🩺 SEXUAL HEALTH   │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🧪 STI TESTING               │   │
│  │ Last test: 15th March 2026  │   │
│  │ Results: All clear ✅        │   │
│  │ Next test: September 2026   │   │
│  │ [Log test] [Set reminder]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 CONSENT & INTIMACY        │   │
│  │ [Private notes]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📚 RESOURCES                 │   │
│  │ · Sexual Health Australia   │   │
│  │ · Family Planning Australia │   │
│  │ · ACON (LGBTQIA+ health)    │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 15. EMERGENCY RESOURCES

A dedicated section accessible from the Reproductive Health main screen.

- **Postpartum psychosis** — "Call 000 or go to ED. This is a medical emergency."
- **Pregnancy complications** — "Reduced fetal movement, vaginal bleeding, severe pain — contact your midwife or hospital immediately."
- **Pregnancy loss** — "If you are experiencing heavy bleeding, severe pain, or fever, seek medical attention."
- **Contraception failure** — "Emergency contraception is available from pharmacies, GPs, and sexual health clinics."
- **STI exposure** — "Contact your GP or sexual health clinic for testing and advice."

All resources link to accredited sources. No AI-generated guidance. 🔴 Red — clinical-adjacent information must be from accredited sources only.

---

## 16. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1D** | Cycle tracking (period, symptoms, predictions with "may be" phrasing). Calendar overlay. Contraception tracking (pill reminders, method management). Pregnancy tracking (gestational age, appointments, symptoms, red-flag resources). Postpartum recovery (bleeding log, 6-week check-up reminder, warning signs). Breastfeeding log. Men's health (basic — prostate, testicular, STI). Emergency resources (accredited links only). |
| **2B** | Full lifecycle: perimenopause/menopause tracking. Fertility awareness. Pregnancy loss support. Postpartum mental health integration. Full breastfeeding/pumping log. Men's health full (fertility, vasectomy, erectile function, libido, testosterone). Sexual health notes. Partner support tasks. Birth plan builder. Hospital bag checklist. |
| **3+** | Integration with wearable temperature sensors for BBT tracking (if user opts in). Advanced cycle analysis. |

---

## 17. WHAT REPRODUCTIVE HEALTH DOES NOT DO

- It does not diagnose fertility problems. It tracks data. A doctor diagnoses.
- It does not predict ovulation with certainty. "May be" always.
- It does not push pregnancy. Fertility tracking is available, not assumed.
- It does not pressure about periods postpartum. No "your period is late" after a birth.
- It does not provide medical advice about contraception. It reminds. It links to accredited guidance.
- It does not interpret pregnancy symptoms. Red-flag resources link to official guidance.
- It does not share reproductive data without explicit opt-in consent.
- It does not assume gender. Men have reproductive health. Non-binary people have reproductive health. The module serves bodies, not gender identities.

---

That's Reproductive Health. All bodies. All life stages. Cycle tracking. Contraception. Fertility. Pregnancy. Pregnancy loss. Postpartum. Breastfeeding. Perimenopause. Menopause. Men's health. Sexual health. "May be" phrasing. Body-neutral. Privacy paramount.
