# TETHER — MODULE 4: FAMILY HUB / HOME BASE
## Complete Design Specification

**Module:** Family Hub  
**Version:** v3.0 — Route Map Aligned  
**Risk:** 🟢-🟠 (D1-D3; child health and partner support = D3)  
**Phase:** 1B (Evander profile, basic people list, medication tracker) → 1D (multi-person, pets, growth charts, foods log) → 2A (partner sharing, school hub, teen privacy, graduated autonomy)  
**Status:** 🔧 In Progress — Evander profile live, multi-person and pets pending

---

## Implementation status (code)

| Section | Status |
|---------|--------|
| Family Hub main screen (People / Pets / Household / School sections) | Live (Household status & chores = stubs) |
| Dashboard Family Summary Card | Live (urgency lines; module-gated) |
| Add person wizard (Child / Partner / Other / Pet) | Live |
| DOB → age group + birthday calendar sync | Live |
| User / partner profile screens (mood, sharing, relationship) | Partial (person tile → generic detail; partner features deferred 2A) |
| Baby profile (Evander): meds, quick log, activity, 7-day feed chart | Live |
| Medication tracker (min-interval colours + one-tap Given) | Live (no visual cup timer; no scheduled mode yet) |
| Growth notes / WHO charts / foods tried | Deferred 1D |
| Nap chart / nappy chart tabs | Deferred 1D |
| Teen profile (upcoming, chores, check-ins, privacy UI) | Partial (privacy switches local-only; school link stub) |
| Pet profile (care tasks, meds, vet, supplies) | Stub (name/species/breed only) |
| Household chores / shopping / maintenance / vehicles | Stub / deferred 1D–2B |
| School Hub | Placeholder (1D/2A) |
| Partner sharing toggles / graduated teen privacy sync | Deferred 2A |
| Delete person + export confirmation | Deferred |
| Poly-friendly multiple partners | Live (no single-partner constraint) |

See: `lib/screens/family_hub/`, `lib/providers/family_hub_provider.dart`, `lib/database/family_care_dao.dart`, `docs/children_spec.md`.

---

## 1. WHAT FAMILY HUB IS

Family Hub is the module that manages every person, pet, routine, care task, meal, school commitment, and household responsibility connected to Beth's life. It answers the question: *"Who depends on me, and what do they need today?"*

It replaces the original "Children" module. Children are now a sub-section within a broader household management system that includes partner, pets, other adults, and the shared infrastructure of the home itself.

Family Hub does not replace the Dashboard. The Dashboard surfaces the most urgent items from Family Hub. Family Hub is where Beth goes to manage everything in detail.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **One place for everyone** | Children, partner, pets, other household members — all in one module. No separate apps. No separate logins (until teens have their own). |
| **Age-appropriate, always** | A baby profile looks different from a teen profile. Features, language, and privacy change with age. |
| **Care without pressure** | Medication reminders are gentle. Task completion is celebrated, not demanded. "Still on the list" not "You forgot." |
| **Privacy by default, shared by choice** | Nothing is shared outside the household unless Beth explicitly toggles it. Teens have graduated privacy. Partner sharing is per-item. |
| **The household is a system** | Chores, shopping, maintenance, vehicles, school — these aren't separate apps. They're part of the same household. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → 👨‍👩‍👦 Family tab.
**From Dashboard:** Tapping any person in the Family Summary Card opens their profile here. Tapping "[View Family Hub]" opens the main Family Hub screen.
**From Notes:** Logging a feed, medication, or nappy automatically routes to the relevant child's activity feed here.
**From Calendar:** Tapping a person-categorised event opens that person's profile.

---

## 4. FAMILY HUB MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard    👨‍👩‍👦 FAMILY HUB   + │  ← + = add person/pet
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏠 HOUSEHOLD STATUS         │   │
│  │                             │   │
│  │ 👤 Beth · 🟢 Green          │   │
│  │ 👤 Ant · At work            │   │
│  │ ⚠ Evander · Ibuprofen      │   │
│  │    overdue                  │   │
│  │ 📅 Theo · Camp meeting 3pm │   │
│  │ 🐱 Jaeger · Flea treatment │   │
│  │    due                      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 👶 PEOPLE                   │   │
│  │                             │   │
│  │ 👤 Beth · You               │   │
│  │ 👤 Ant · Partner            │   │
│  │ 👶 Evander · 5 months  [>] │   │
│  │ 👦 Theodore · 13 years [>] │   │
│  │ 👧 Annabella · 16 years[>] │   │
│  │                             │   │
│  │ [+ Add person]              │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🐾 PETS                     │   │
│  │                             │   │
│  │ 🐱 Jaeger · Cat · 4y  [>]  │   │
│  │ 🐱 Rook · Cat · 3y    [>]  │   │
│  │                             │   │
│  │ [+ Add pet]                 │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏠 HOUSEHOLD                │   │
│  │                             │   │
│  │ 📋 Chores · 3 pending  [>] │   │
│  │ 🛒 Shopping list · 5   [>] │   │
│  │ 📅 Family calendar     [>] │   │
│  │ 🍽 Meals · No plan     [>] │   │
│  │ 🔧 Maintenance · 1 due [>] │   │
│  │ 🚗 Vehicles · Rego due [>] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏫 SCHOOL                   │   │
│  │                             │   │
│  │ 👦 Theo · Camp meeting 3pm │   │
│  │   Permission slip due       │   │
│  │ 👧 Bella · Drama rehearsal │   │
│  │   Form due Friday           │   │
│  │                             │   │
│  │ [View School Hub]      [>] │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. PEOPLE SECTION

### 5.1 The User (Beth)

Beth has her own profile within Family Hub. This is where her personal context lives.

```
┌─────────────────────────────────────┐
│  ← Family Hub    👤 BETH · YOU      │
├─────────────────────────────────────┤
│                                     │
│  Bethany · 25 years                 │
│  Role: Owner / Admin                │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ CURRENT STATE                │   │
│  │ 🟢 Green · Open to talk     │   │
│  │ ⚡ Energy: 70%              │   │
│  │ Active supports: ADHD,      │   │
│  │ Postpartum                  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ QUICK ACTIONS                │   │
│  │ [Update mood] [Log win]     │   │
│  │ [Personal care] [Rest]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ HOUSEHOLD ROLE               │   │
│  │ Owner · Full access          │   │
│  │ Manages: All people, pets,   │   │
│  │ household, budget, calendar  │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Edit profile]                    │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.2 Partner (Ant)

```
┌─────────────────────────────────────┐
│  ← Family Hub    👤 ANT · PARTNER   │
├─────────────────────────────────────┤
│                                     │
│  Anthony · 38 years                 │
│  Role: Partner / Adult              │
│  Status: At work                    │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ SHARED WITH ANT              │   │
│  │ 📅 Calendar: Family, Evander│   │
│  │ 📋 Tasks: Bare Minimums,    │   │
│  │    Car projects              │   │
│  │ 💰 Budget: Groceries, Bills,│   │
│  │    Baby, Date Night         │   │
│  │ [Manage sharing]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ RELATIONSHIP                 │   │
│  │ Last check-in: 3 days ago   │   │
│  │ [Start check-in]            │   │
│  │ [Send appreciation]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ SUPPORT PREFERENCES          │   │
│  │ "When I'm stressed, give me │   │
│  │  space then check in."      │   │
│  │ [Edit preferences]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Edit profile]                    │
│                                     │
└─────────────────────────────────────┘
```

**Partner features (Phase 2A):**
- **Shared calendar:** Events in shared categories visible to Ant on his own Tether app.
- **Shared tasks:** Bare Minimums, Optional But Required, Car projects — assigned and visible.
- **Shared budget:** Selected categories visible. Both can log expenses.
- **Relationship check-ins:** Optional prompts for connection. "When did you last have a conversation that wasn't about logistics?"
- **Support preferences:** Ant can set how he wants Beth to support him. "When I'm stressed, give me space then check in." "I appreciate physical affection when I'm down."
- **Appreciation:** One-tap "Send appreciation" opens a quick message to Ant. "I noticed you [did X]. Thank you."

---

### 5.3 Children

*Children are detailed in their own full specification. Here is the summary for context within Family Hub.*

Each child has a profile accessed by tapping their name in the People section. The profile adapts to their age group.

| Child | Age | Age Group | Key Features |
|-------|-----|-----------|--------------|
| **Evander** | 5 months | Baby | Medication tracker (min-interval + scheduled), Quick Log (Feed, Nap, Nappy, Bath, Tummy Time), Activity feed, Feeding chart (7-day bar), Nap chart, Growth notes (WHO percentiles), Foods tried log |
| **Theodore** | 13 years | Teen | Shared calendar, Chores, Check-ins, School Hub, Medication (self-managed with parent visibility), Graduated privacy |
| **Annabella** | 16 years | Teen | Shared calendar, Chores, Check-ins, School Hub, Medication (self-managed, more privacy), Graduated privacy (increased defaults), Driving milestones, Part-time work |

---

### 5.4 Child Profile — Baby (Evander)

```
┌─────────────────────────────────────┐
│  ← Family Hub  👶 EVANDER · 5mo     │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 MEDICATIONS               │   │
│  │                             │   │
│  │ Paracetamol (2.5ml)        │   │
│  │ Last: 10:33am              │   │
│  │ Next available: 2:33pm     │   │
│  │ 🟢 Available now           │   │
│  │                             │   │
│  │ Ibuprofen (2.5ml)           │   │
│  │ Last: 8:15am               │   │
│  │ Next available: 2:15pm     │   │
│  │ 🟡 Wait — 1h 42m           │   │
│  │                             │   │
│  │ Antihistamine (2ml)         │   │
│  │ Last: Yesterday 4:45pm     │   │
│  │ 🟢 Available now           │   │
│  │                             │   │
│  │ [+ Add medication]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🍼 QUICK LOG                 │   │
│  │ [Feed] [Nap] [Nappy]        │   │
│  │ [Bath] [Tummy Time] [Other] │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 TODAY'S ACTIVITY          │   │
│  │ 10:30am · Feed · 180ml     │   │
│  │ 10:35am · Nap started       │   │
│  │ 10:36am · Nappy · Wet       │   │
│  │ 9:15am  · Feed · 150ml     │   │
│  │ [View all activity]         │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📊 FEEDING · Last 7 Days     │   │
│  │ Mon  ██░░░░ 6 feeds         │   │
│  │ Tue  ███░░░ 7 feeds         │   │
│  │ Wed  ██░░░░ 5 feeds         │   │
│  │ [Feeding] [Naps] [Nappies]  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📏 GROWTH NOTES              │   │
│  │ Weight: 7.2kg (15th May)    │   │
│  │ Length: 65cm (15th May)     │   │
│  │ Head: 42cm (15th May)       │   │
│  │ [View growth charts]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🥄 FOODS TRIED               │   │
│  │ Pumpkin · 1st June · ✅     │   │
│  │ Avocado · 3rd June · 👅     │   │
│  │ Banana · 5th June · ✅      │   │
│  │ [+ Log new food]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Edit profile] [Share settings]    │
│                                     │
└─────────────────────────────────────┘
```

---

### 5.5 Child Profile — Teen (Theodore)

```
┌─────────────────────────────────────┐
│  ← Family Hub  👦 THEODORE · 13y    │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 UPCOMING                  │   │
│  │ Mon · Camp meeting 3pm      │   │
│  │ Wed · Camp departure         │   │
│  │ Fri · Camp return            │   │
│  │ 15th · Permission slip due   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ CHORES                    │   │
│  │ ☐ Bins · Due tonight        │   │
│  │ ☐ Homework · Maths due Tue  │   │
│  │ ☑ Science · Submitted       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 RECENT CHECK-IN           │   │
│  │ Monday · 😊 "Good day"      │   │
│  │ [Ask how he's doing]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏫 SCHOOL HUB                │   │
│  │ Camp meeting · Permission   │   │
│  │ slip due                    │   │
│  │ [View School Hub]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔒 PRIVACY                   │   │
│  │ Parents can see:            │   │
│  │ ☑ Calendar (shared events) │   │
│  │ ☑ Chores                    │   │
│  │ ☑ Check-ins (if shared)    │   │
│  │ ☐ Messages with AI team     │   │
│  │ ☐ Personal notes            │   │
│  │ [Manage privacy]            │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Edit profile]                    │
│                                     │
└─────────────────────────────────────┘
```

---

## 6. ADDING A PERSON

From the "+" button on the Family Hub main screen, or "[+ Add person]" in the People section.

```
┌─────────────────────────────────────┐
│  ← Family Hub     ADD A PERSON      │
├─────────────────────────────────────┤
│                                     │
│  Who are you adding?                │
│                                     │
│  [👶 Child]  [👤 Partner]  [👤 Other] │
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

**If "Child" is selected:**

```
┌─────────────────────────────────────┐
│  ← Add Person     ADD A CHILD       │
├─────────────────────────────────────┤
│                                     │
│  Photo (optional)      [📷]         │
│                                     │
│  Full name: [___________________]   │
│  Preferred name: [_______________]  │
│                                     │
│  Date of birth: [DD / MM / YYYY]   │
│  Age group: Baby (0-2) ← auto      │
│                                     │
│  Features to enable:                │
│  ☑ Medication tracker              │
│  ☑ Calendar integration            │
│  ☑ Task list (chores, routines)    │
│  ☐ School hub (if school-aged)     │
│  ☐ Independent app access (teen)   │
│                                     │
│  Notes: [_______________________]   │
│                                     │
│  [Cancel]              [Save]       │
└─────────────────────────────────────┘
```

**If "Partner" or "Other" is selected:**

```
┌─────────────────────────────────────┐
│  ← Add Person  PARTNER / ADULT      │
├─────────────────────────────────────┤
│                                     │
│  Photo (optional)      [📷]         │
│                                     │
│  Full name: [___________________]   │
│  Preferred name: [_______________]  │
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
│  ☐ Support preferences             │
│                                     │
│  Notes: [_______________________]   │
│                                     │
│  [Cancel]              [Save]       │
└─────────────────────────────────────┘
```

---

## 7. DELETING A PERSON

From the Edit Profile screen for any person:

```
┌─────────────────────────────────────┐
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Delete Evander's profile]         │
│                                     │
│  This will permanently remove all   │
│  of Evander's data, including:      │
│  · Medication logs                  │
│  · Feeding records                  │
│  · Nap records                      │
│  · Nappy logs                       │
│  · Growth notes                     │
│  · Foods tried log                  │
│  · Activity history                 │
│                                     │
│  This cannot be undone.             │
│                                     │
│  [Export data first]                │
│                                     │
│  [Cancel]         [Delete profile]  │
│                                     │
└─────────────────────────────────────┘
```

**Deletion rules:**
- A confirmation dialogue is required. The user must type "DELETE" or press a secondary confirmation button.
- Data export is offered before deletion.
- Deleting a partner or other adult severs the connection but does not delete their own Tether account (if they have one).
- Deleting the last child does not delete the Children sub-section. It remains empty.

---

## 8. PETS SECTION

### 8.1 Pet Profile

```
┌─────────────────────────────────────┐
│  ← Family Hub   🐱 JAEGER · Cat     │
├─────────────────────────────────────┤
│                                     │
│  Domestic Shorthair · 4 years       │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 CARE TASKS                │   │
│  │ ☐ Feed (morning)            │   │
│  │ ☐ Feed (evening)            │   │
│  │ ☐ Fresh water               │   │
│  │ ☐ Litter box                │   │
│  │ ⚠ Flea treatment · Overdue  │   │
│  │ ⚠ Worming · Due in 3 days   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💊 MEDICATIONS (if any)      │   │
│  │ [+ Add medication]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏥 VET                       │   │
│  │ Last: 15th March 2026       │   │
│  │ Next: Annual checkup due    │   │
│  │ Vet: Cairns Veterinary      │   │
│  │ Phone: (07) 40XX XXXX      │   │
│  │ [+ Log vet visit]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 NOTES                     │   │
│  │ Microchip: 9560XXXXXXXXXXX  │   │
│  │ Desexed: Yes                │   │
│  │ Insurance: PetPlan #XXXX    │   │
│  │ Dietary: Grain-free dry +   │   │
│  │ wet food. No fish.          │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🛒 SUPPLIES                  │   │
│  │ Dry food · Low              │   │
│  │ Wet food · OK               │   │
│  │ Litter · OK                 │   │
│  │ Flea treatment · Need       │   │
│  │ [+ Add to shopping list]    │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Edit profile] [Share settings]    │
│                                     │
└─────────────────────────────────────┘
```

---

### 8.2 Adding a Pet

```
┌─────────────────────────────────────┐
│  ← Family Hub       ADD A PET       │
├─────────────────────────────────────┤
│                                     │
│  Photo (optional)      [📷]         │
│                                     │
│  Name: [_________________________]  │
│                                     │
│  Species: [Cat ▼]                   │
│  Cat / Dog / Bird / Fish            │
│  Reptile / Small mammal / Other     │
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

---

## 9. HOUSEHOLD SECTION

The household is the shared infrastructure — the home itself.

### 9.1 Household Main Screen

```
┌─────────────────────────────────────┐
│  ← Family Hub   🏠 HOUSEHOLD        │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 CHORES                    │   │
│  │ Bare Minimums: 2 of 4 done  │   │
│  │ Optional: 1 of 9 done today │   │
│  │ [View all chores]           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🛒 SHOPPING LIST             │   │
│  │ 5 items · 2 stores          │   │
│  │ ⚠ 2 items needed tonight    │   │
│  │ [View shopping list]        │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🔧 MAINTENANCE               │   │
│  │ ⚠ Car rego · Due 15/7      │   │
│  │ ☐ Clean gutters             │   │
│  │ ☐ Replace air filters       │   │
│  │ [View all maintenance]      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🚗 VEHICLES                  │   │
│  │ 🚙 Ute · Rego due 15/7/26  │   │
│  │ 🚗 Car · Rego due 3/12/26  │   │
│  │ [View vehicle details]      │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. SCHOOL HUB

Accessible from the Family Hub main screen or from any school-aged child's profile.

```
┌─────────────────────────────────────┐
│  ← Family Hub     🏫 SCHOOL HUB     │
├─────────────────────────────────────┤
│                                     │
│  👦 Theodore · Year 8               │
│  🏫 Cairns State High School        │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 UPCOMING                  │   │
│  │ Mon · Camp meeting · 3pm    │   │
│  │ Wed · Camp departure         │   │
│  │ Fri · Camp return            │   │
│  │ 15th · Permission slip due   │   │
│  │ 20th · Fees due ($120)       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 HOMEWORK                  │   │
│  │ ☐ Maths · Due Tuesday       │   │
│  │ ☐ English essay · Draft     │   │
│  │ ☑ Science · Submitted       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📋 ADMIN                     │   │
│  │ School contact: [View]      │   │
│  │ Uniform shop: [View]        │   │
│  │ Term dates: [View]          │   │
│  │ Fees: $120 due 20th July    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 🏃 ACTIVITIES                │   │
│  │ 📅 Soccer · Tue/Thu 4pm     │   │
│  │ 📅 Music · Wed 3:30pm       │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  👧 Annabella · Year 11             │
│  (same structure)                   │
│                                     │
└─────────────────────────────────────┘
```

---

## 11. MEDICATION TRACKER

The medication tracker appears in child profiles, pet profiles, and the user's own Health Status. It works the same way everywhere.

### 11.1 Two Modes

**Mode 1: Minimum Interval (As-Needed)**
- Used for: Panadol, Neurofen, Antihistamine — given when needed, not on a schedule.
- Tracks: last given time. Calculates: next available time.
- Status colours: 🟢 Available now. 🟡 Available within 1 hour. 🔴 Not yet — shows remaining time.
- One tap logs "Given." Timestamps automatically. Undo for 30 seconds.
- **No alarms.** No "time to give" prompts. User decides if medication is needed.

**Mode 2: Scheduled**
- Used for: antibiotics, regular prescriptions.
- Schedule: specific times or intervals.
- Reminders: optional. Configurable.
- Missed dose: logged without shame.

### 11.2 Medication Visual Timer (Val's Suggestion)

Instead of text-only "Next available: 2:33pm," a small medicine cup icon fills or empties:

```
Paracetamol · Last 10:33am
[🪻🪻🪻🪻🪻⬜⬜⬜⬜⬜] 2h 18m remaining
```

Full cup = just given. Empty cup = available now. Half cup = halfway through interval. Faster to parse at 2am than text.

---

## 12. SHARING & PRIVACY

| Relationship | Default Sharing | Can See | Cannot See |
|--------------|-----------------|---------|------------|
| **Partner (Ant)** | Shared calendar, shared tasks, shared budget, children's medication and care logs, pet care | Anything Beth marks as shared. Children's data. | Beth's personal messages, private notes, debrief content, cycle data, personal spending (unless toggled) |
| **Teen (13-16)** | Shared calendar, chores, medication (safety), school events | What parents share. Their own data. | Parents' personal data. Siblings' private data. |
| **Teen (16-17)** | Shared calendar, chores, medication (negotiable), school events | What parents share. Their own data. More privacy defaults. | Parents' personal data. Siblings' private data. |
| **Child profile (parent-managed)** | N/A — parent manages everything | N/A | N/A |
| **Housemate** | As configured. Minimal by default. | Shared bills, shared chores. | Everything else. |
| **Carer** | As configured. Can be broad for medical support. | Health data, appointments, medications if relevant. | Personal messages, finances (unless needed). |
| **Pet sitter (temporary)** | Time-limited. Pet care only. | Pet tasks, vet info, feeding instructions. | Everything else. |

---

## 13. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Current) | Evander profile with medication tracker, quick log, activity feed, feeding chart. Basic people list (Beth, Ant, Evander, Theo, Bella — parent-managed). Pet profiles (basic). |
| **1D** | Multi-person profiles (Theo teen, Bella teen). Growth charts (WHO + CDC). Foods tried log. Nap chart. Pet care tasks. Household chores section. Family calendar categories. |
| **2A** | Partner profile with sharing. Ant's View. School Hub. Teen graduated privacy. Connectable Accounts sync. Collaborative shopping lists. Real-time shared lists. Temporary pet sitter access. Relationship check-ins. Support preferences. |
| **2B** | Full School Hub. Activities. Maintenance tracking. Vehicle management. Household contacts. |

---

That's Family Hub. People, pets, household, school, vehicles, chores, and medication — all in one place, with age-appropriate features and graduated privacy at every layer.
