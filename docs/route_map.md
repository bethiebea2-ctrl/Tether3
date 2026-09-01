// ============================================================
// FILE: lib/route_map.dart
// PURPOSE: Complete navigation scaffold for Tether App
// STATUS: Planning document — NOT functional code
// BUILDER: Kit 2.0
// DATE: 25th May 2026
// VERSION: 2.0 — Post Support Presets & Module Restructure
// ============================================================
//
// This file maps every planned screen, module, and mode.
// Stubs are placeholders. They return basic Container widgets.
// As each feature is built, its stub is replaced with real code.
//
// PHASE LEGEND:
//   1A — Complete (backend, pipeline, instances, capture screen)
//   1B — Complete (core life coordination modules)
//   1C — Complete (Voice & Companion foundation)
//   1D — Complete (basic health, food, personalisation — stubs remain)
//   2A — Connection Layer (auth, accounts, household, instance library) (next)
//   2B — Full Support Presets, Current State, Accessibility, Resource Library
//   3  — Advanced (driving mode, full voice nav, gaming, fitness)
//   4+ — Platform (marketplace, cross-platform, family plan)
//
// DEPENDENCY LEGEND:
//   → Requires X to be built first
//
// RISK CLASSIFICATION:
//   🟢 Green  — Lifestyle Support (low regulatory risk)
//   🟠 Amber  — Health Support / Education (needs sourcing, disclaimers)
//   🔴 Red    — Clinical-Adjacent (do not build without expert review)
//
// DATA SENSITIVITY:
//   D1 — Low       (meal preferences, household tasks, generic routines)
//   D2 — Medium    (calendar, budget, family notes, school info)
//   D3 — High      (health, reproductive, mental health, medication, child health)
//   D4 — Very High (crisis plans, hidden notes, DV info, self-harm logs, safety plans)
// ============================================================

// ============================================================
// APP ENTRY POINT STRUCTURE
// ============================================================
//
// main.dart
//   └─ App (MaterialApp)
//       └─ AppShell (Scaffold with dynamic bottom nav)
//           ├─ DashboardScreen                   (home)
//           ├─ CaptureNotesScreen                (always present)
//           ├─ CalendarScreen                    (when active)
//           ├─ TasksScreen                       (when active)
//           ├─ FamilyHubScreen                   (when active)
//           ├─ MealsScreen                       (when active)
//           ├─ BudgetScreen                      (when active)
//           ├─ HealthStatusScreen                (when active)
//           ├─ ReproductiveHealthScreen          (when active)
//           ├─ MentalHealthToolkitScreen         (when active)
//           ├─ ResourceLibraryScreen             (when active)
//           ├─ TeamScreen                        (when active)
//           ├─ CompanionScreen                   (toggle from Dashboard)
//           └─ MoreMenuSheet                     (overflow — inactive modules)
//
// SETTINGS (pushed from Dashboard or AppBar)
//   └─ SettingsScreen
//       ├─ ModuleManagementScreen
//       ├─ SupportPresetsScreen
//       ├─ SensitivityTogglesScreen
//       ├─ CurrentStateScreen
//       ├─ NotificationSettingsScreen
//       ├─ CalendarSettingsScreen
//       ├─ FamilyHubSettingsScreen
//       ├─ MealsSettingsScreen
//       ├─ BudgetSettingsScreen
//       ├─ HealthStatusSettingsScreen
//       ├─ ReproductiveHealthSettingsScreen
//       ├─ MentalHealthToolkitSettingsScreen
//       ├─ CompanionSettingsScreen
//       ├─ InstancePersonalisationScreen
//       ├─ AccessibilitySettingsScreen
//       ├─ SharingPrivacySettingsScreen
//       ├─ UserActivityLedgerScreen
//       ├─ DataExportDeleteScreen
//       ├─ GhostLogSettingsScreen       (Developer only)
//       └─ AboutScreen
//
// ONBOARDING (first launch)
//   └─ OnboardingFlow
//       ├─ FullCustomPath
//       ├─ DefaultLearningPath          (Quick Start)
//       └─ InstanceGrowthPath
//
// ============================================================

// ============================================================
// SECTION 1: APP SHELL
// ============================================================

// PHASE 1B
// → Requires: ModuleRegistry Provider
// Dynamic bottom nav reads from ModuleRegistry.
// Only active modules appear as tabs.

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 2: DASHBOARD
// ============================================================
// 🟢 D2

// PHASE 1B — Morning Dashboard
// Assembles from active modules only.
// Layout sections (all conditional on module active + user prefs):
//   - Affirmation card (top)
//   - Status Shield
//   - Current State indicator (if active)
//   - Colour Card dot (if enabled)
//   - Capacity indicator (if enabled)
//   - Family Hub summary card (children, partner, pets — if module active)
//   - Today's schedule (if calendar module active)
//   - Bare Minimums (if tasks module active)
//   - Urgent tasks surfaced
//   - Medication reminders (if Health Status active + meds due)
//   - Snoozed items section
//   - Companion mode toggle button

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 3: CAPTURE / NOTES
// ============================================================
// 🟢 D2

// PHASE 1A — Capture Screen (exists, refining)
// 7-button quick-log grid
// Voice input (Android SpeechRecognizer)
// Error states (5 types)
// Clarification Card (amber, threaded)
// PHASE 1B additions:
//   - Prominent buttons shift based on active Support Presets
//   - Ghost Log command recognition for developers
//   - User Activity Ledger logging (transparent: "Val created an event from this note")
// PHASE 1D additions:
//   - Daily timeline view of captures
//   - Auto-categorised folders: Scheduling, Shopping, Tasks, Health, Family, Budget, Ideas, Correspondence, Random
//   - Preserves both cleaned result AND original messy capture

// ============================================================
// SECTION 4: CALENDAR MODULE
// ============================================================
// 🟢 D2

// PHASE 1B — Full Calendar
// Views: Month (collapsible grid), Week, Day, Agenda
// Features:
//   - Pipeline-driven + manual events
//   - Source tags (who created the event)
//   - Priority badges (⚠ Urgent, 📋 Important)
//   - 7 default event categories, expandable to 15
//   - Emoji on events
//   - Cycle overlay (phase shading) — Phase 1D, via Reproductive Health
//   - Conflict detection (warn, not block)
//   - Filtering by category (person categories, school, medical, family, partner, pet)
//   - Quick-add from day view (+ button)
//   - Schedule Protector (Phase 2A)
//   - Person categories for Family Hub integration

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class WeekView extends StatelessWidget {
  const WeekView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DayView extends StatelessWidget {
  const DayView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AgendaView extends StatelessWidget {
  const AgendaView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 5: TASKS MODULE
// ============================================================
// 🟢 D2

// PHASE 1B — Tasks Module
// Task layers (available to all users, not locked behind presets):
//   - Bare Minimums: eat, drink, medication, baby fed, rest, one critical task
//   - Personal Care: shower, teeth, clothes, skincare, eat, drink, rest
//   - House Tasks: dishes, washing, bins, kitchen, bathroom, floors, groceries
//   - Care Tasks: baby, child, teen, partner, pet, parent, school, medication
//   - Life Admin: bills, forms, calls, emails, appointments, renewals, documents
//   - Recovery Tasks: grounding, journaling, rest, step outside, message support
//
// Preset task packs (editable, removable):
//   - ADHD support, Depression support, Postpartum support
//   - Chronic pain, New parent survival, Pet care, House reset
//   - Night shift worker, Student/placement, Grief day
//   - Migraine day, Flare day, Sick day, Low-energy day
//
// Features:
//   - Urgent / Not Urgent sections
//   - Task creation: priority, deadline, category
//   - AI delegation to specific instances
//   - Snooze presets (Tonight, Tomorrow, Weekend, Custom)
//   - Overdue auto-escalation
//   - Energy gauge tagging: low/medium/high
//   - Win logging: quick-capture (Phase 1D)
//   - Body doubling prompts (when ADHD support active)
//   - One next step mode (when overwhelm active)
//   - Shame-free language always
//
// Language rules:
//   - "Still on the list." not "You forgot."
//   - "Want the smallest version?" not "You're behind."
//   - "This can wait." not "You should have..."

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TaskDetailScreen extends StatelessWidget {
  const TaskDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TaskPackLibraryScreen extends StatelessWidget {
  const TaskPackLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 6: FAMILY HUB
// ============================================================
// 🟢-🟠 D2-D3 (child health = D3)

// PHASE 1B — Family Hub (expanded from Children module)
// Manages: people, pets, routines, care tasks, meals, school, household
//
// People profiles:
//   - User
//   - Partner
//   - Children (Baby, Toddler, Child, Teen — age-specific)
//   - Other household members
//   - Carers/family contacts
//
// Children (age-specific):
//   Baby: feeds, naps, nappies, growth charts, medication timer,
//         foods tried, reactions, textures, baby-led weaning support
//   Toddler: meals, routines, development notes, safe food list
//   Child: school, activities, chores, check-ins
//   Teen: shared calendar, chores, check-ins, graduated privacy
//
// Partner:
//   - Shared calendar
//   - Support preferences
//   - Household tasks
//   - Relationship check-ins
//   - Privacy/consent rules
//
// Pets:
//   - Feed, water, medication, litter/enclosure
//   - Vet appointments, grooming, supply reminders
//
// School / Childcare:
//   - Events, childcare days, uniforms, homework, excursions
//   - Admin, permission slips, fees, contact info
//
// Household Tasks (connected to Tasks module):
//   - Dishes, washing, bins, floors, tidying, groceries
//   - Maintenance, car/rego reminders, shared responsibilities
//
// Features:
//   - Colour-coded statuses (green/amber/red)
//   - Quick Log (age-specific buttons)
//   - Activity Log (timestamped, filterable)
//   - Feeding/Nap 7-day bar charts
//   - Growth notes with WHO/CDC percentiles (Phase 1D)
//   - Medication tracker — dependent medication
//   - Add Person/Child/Pet flow

class FamilyHubScreen extends StatelessWidget {
  const FamilyHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PersonDetailScreen extends StatelessWidget {
  const PersonDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ChildDetailScreen extends StatelessWidget {
  const ChildDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PetDetailScreen extends StatelessWidget {
  const PetDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MedicationTrackerWidget extends StatelessWidget {
  const MedicationTrackerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class QuickLogWidget extends StatelessWidget {
  const QuickLogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FeedingChart extends StatelessWidget {
  const FeedingChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GrowthChart extends StatelessWidget {
  const GrowthChart({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class AddPersonFlow extends StatelessWidget {
  const AddPersonFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SchoolHubScreen extends StatelessWidget {
  const SchoolHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 7: MEALS MODULE
// ============================================================
// 🟢 D1-D2 (allergies = D3)

// PHASE 1D — Meals Module (connected to Family Hub)
// Purpose: realistic, budget-friendly, family-aware, sensory-aware meals
//
// Considers:
//   - Number of people, ages, baby-led weaning needs
//   - Allergies, intolerances, dislikes, safe foods, sensory preferences
//   - ARFID support
//   - Cooking equipment, budget, time, energy level
//   - Leftovers, batch cooking preferences
//
// Structure: Base meal + variations
//   Adult version → Child adaptation → Baby/toddler adaptation
//   Allergy rule: avoid allergen across household unless user overrides
//
// Baby-led weaning support:
//   - Foods tried, date first tried, reaction notes, texture notes
//   - Accepted/refused (framed neutrally)
//   - Gagging/choking education, allergy sign education
//   - Safe preparation guidance, repeated exposure encouragement
//
// Language:
//   - "Food exposure logged." not "They refused it."
//   - "Some children need multiple exposures." not "They don't like it."

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MealDetailScreen extends StatelessWidget {
  const MealDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BabyLedWeaningScreen extends StatelessWidget {
  const BabyLedWeaningScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FoodLogScreen extends StatelessWidget {
  const FoodLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 8: BUDGET MODULE
// ============================================================
// 🟢 D2

// PHASE 1B — Budget Module (Tim, not Frank)
// SMART budget format (reference provided separately)
// Manual tracker (no bank integration)
//
// Features:
//   - Manual income + expense tracking
//   - User-defined categories (colour-coded)
//   - Fortnightly/monthly budget views
//   - Visual category bars (green/amber/red)
//   - Bill planning + upcoming bill warnings
//   - Sinking funds (rego, insurance, vet, Christmas, birthdays, school, medical,
//     dental, travel, baby/kids, emergency repairs, home/moving, vehicle maintenance,
//     holidays, big bills)
//   - Emergency fund planning
//   - Savings goals
//   - Debt repayment planning
//   - Category review + subscription review
//   - Cheaper alternative suggestions
//   - Bare-minimum budget mode
//   - "What can wait?" mode
//   - Big expense planning
//   - Travel budget planning
//
// Tim:
//   - Personalisable AI instance
//   - Provides insights, not regulated financial advice
//   - Does not recommend financial products
//   - Does not shame spending
//
// Financial Sensitivity toggles:
//   - Require confirmation before spending
//   - Delay big financial decisions
//   - Avoid shame spending language
//   - Simplified numbers
//   - Visual budget bars

class BudgetScreen extends StatelessWidget {
  const BudgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BudgetCategoryScreen extends StatelessWidget {
  const BudgetCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SinkingFundScreen extends StatelessWidget {
  const SinkingFundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 9: HEALTH STATUS
// ============================================================
// 🟠 D3 (some D4)

// PHASE 1D (basic) / PHASE 2B (full)
// Purpose: health tracking, condition support, readings, documents,
//          appointment prep, medication overview, "Discuss with Doctor" exports
//
// Does NOT: diagnose, interpret results, recommend treatments, adjust medications
//
// Condition Categories:
//
// Cardiovascular / Circulation:
//   Hypertension, hypotension, heart disease, heart failure, arrhythmias,
//   POTS/dysautonomia, stroke/TIA history, DVT/PE history, high cholesterol
//   Trackers: BP log, HR log, dizziness/fainting notes, swelling notes,
//             chest symptom notes (with emergency disclaimer)
//
// Respiratory:
//   Asthma, COPD, sleep apnoea, allergies affecting breathing
//   Trackers: inhaler reminders, asthma action plan storage, peak flow log,
//             CPAP cleaning/maintenance reminders, trigger notes
//
// Endocrine / Metabolic:
//   T1D, T2D, gestational diabetes, prediabetes, thyroid conditions,
//   PCOS, iron/B12/vitamin D deficiency, insulin resistance
//   Trackers: glucose log, HbA1c history, pathology storage, food/symptom notes
//
// Neurological:
//   Epilepsy, migraine, chronic headache, MS, Parkinson's, FND, ABI/TBI,
//   stroke recovery, neuropathy, restless legs, narcolepsy, vertigo
//   Trackers: seizure log, migraine trigger log, aura notes,
//             post-seizure recovery mode, medication reminders
//   NOTE: Seizure features live HERE, not under Mental Health.
//
// Pain / Musculoskeletal:
//   Chronic pain, fibromyalgia, arthritis, back pain, hypermobility/EDS,
//   osteoporosis, injury recovery, sciatica
//   Trackers: pain scale, flare mode, mobility notes, physio reminders
//
// Gastrointestinal / Digestive:
//   IBS, IBD, Crohn's, UC, coeliac, reflux/GERD, food intolerances,
//   gallbladder history, liver disease, bariatric surgery history
//   Trackers: symptom/food trigger notes, safe food list, flare tracking
//
// Immune / Autoimmune / Inflammatory:
//   Lupus, RA, coeliac, MS, psoriasis/PsA, IBD, Hashimoto's/Graves',
//   immunosuppression, long COVID, recurrent infections
//   Trackers: flare tracking, fatigue tracking, infection-risk notes
//
// Kidney / Urinary:
//   CKD, kidney stones, recurrent UTIs, incontinence, bladder pain/IC,
//   prostate-related urinary symptoms
//   Trackers: fluid intake, UTI symptom notes, pathology tracking
//
// Skin / Allergy / Immune Reactions:
//   Eczema, psoriasis, acne, hives, anaphylaxis risk, food allergy,
//   hay fever, medication allergies, contact dermatitis
//   Trackers: allergy list, reaction log, EpiPen/action plan storage
//
// Cancer / Serious Illness Support:
//   Cancer history, active treatment, remission/survivorship, palliative
//   Trackers: appointment timeline, medication reminders, symptom diary,
//             questions for doctor, caregiver task sharing, fatigue mode
//
// Oral / Dental Health:
//   Dental anxiety, gum disease, braces, dentures, TMJ pain
//   Trackers: appointment reminders, brushing support toggle, pain notes
//
// Sleep:
//   Insomnia, sleep apnoea, narcolepsy, restless legs, shift work disruption,
//   postpartum sleep deprivation, nightmares/PTSD sleep disturbance
//   Trackers: sleep notes, CPAP reminders, wind-down routine, shift-work mode
//
// Sensory / Accessibility / Disability Support:
//   Low vision/blindness, deaf/HoH, mobility disability, cognitive disability,
//   speech impairment, auditory processing disorder, sensory processing
//
// Health Status Trackers:
//   BP, glucose, symptoms, pain, seizures, migraine, sleep, medication,
//   pathology/bloodwork, appointments, allergies/reactions, flares,
//   fatigue, dizziness/fainting, bowel symptoms, urinary symptoms,
//   skin reactions, respiratory symptoms
//
// Health Status Support Modes (Current States):
//   Flare day, low energy, high pain, post-seizure recovery, migraine mode,
//   sick day, post-op/recovery, infection risk, sleep deprived,
//   dizziness/fainting day, respiratory flare, GI flare
//
// Health Status Documents:
//   Medication list, allergies, action plans, test results, discharge summaries,
//   imaging reports, doctor letters, specialist letters, pathology results,
//   vaccination records, "Discuss with Doctor" exports
//
// Medication Screen (split):
//   Personal Medication: user/adult/teen managing own meds
//     - Name, dose (as entered), schedule, time-sensitive toggle
//     - Medication window, refill reminder, side effect notes
//     - Missed dose note, medication list export
//     - Link to Reproductive Health if contraception
//   Dependent Medication: children, partner, pets
//     - Who it's for, name, instructions (as entered)
//     - Last given time, next eligible time (if interval entered)
//     - Max daily doses (if entered by user)
//     - Second-person confirmation option, medication log
//   ⚠️ Dose calculators = RED. Do not build without expert/regulatory review.
//   ✅ Medication reminders = AMBER. Safe with disclaimers.

class HealthStatusScreen extends StatelessWidget {
  const HealthStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BloodWorkScreen extends StatelessWidget {
  const BloodWorkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BloodWorkGraph extends StatelessWidget {
  const BloodWorkGraph({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MedicalConditionTrackerScreen extends StatelessWidget {
  const MedicalConditionTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MedicationScreen extends StatelessWidget {
  const MedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PersonalMedicationScreen extends StatelessWidget {
  const PersonalMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DependentMedicationScreen extends StatelessWidget {
  const DependentMedicationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DiscussWithDoctorScreen extends StatelessWidget {
  const DiscussWithDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SeizureLogScreen extends StatelessWidget {
  const SeizureLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PostSeizureRecoveryMode extends StatelessWidget {
  const PostSeizureRecoveryMode({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HealthDocumentsScreen extends StatelessWidget {
  const HealthDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 10: REPRODUCTIVE HEALTH
// ============================================================
// 🟠 D3 (some D4 — pregnancy loss, DV-adjacent)

// PHASE 1D — Reproductive Health (expanded from Cycle Tracker)
// Covers reproductive health across life stages and body types.
//
// Sub-sections:
//
// Period / Cycle Tracking:
//   - Period dates, flow, symptoms, pain, mood, energy
//   - Cycle predictions ("may be" phrasing)
//   - Calendar overlay with phase shading
//   - Symptom trends, irregular cycle notes
//
// Contraception:
//   - Pill reminders, ring replacement reminders, injection appointments
//   - Implant/IUD replacement dates, patch reminders
//   - Barrier method notes, emergency contraception resources
//   - Side effect notes, missed contraception resource links
//   - Pipeline to Medication and Calendar
//
// Fertility / Trying to Conceive:
//   - Cycle notes, ovulation signs (if tracked), fertility appointments
//   - Pregnancy test dates, supplements/medications (if entered)
//   - Doctor questions, body-neutral non-pressuring language
//
// Pregnancy:
//   - Gestation tracking, appointments, symptoms, medications/supplements
//   - Baby growth resources (accredited), red-flag resources
//   - Birth plan notes, hospital bag checklist
//   - Partner support tasks, pregnancy loss sensitivity option
//
// Pregnancy Loss Recovery:
//   - Grief-sensitive mode, hide pregnancy/baby prompts if enabled
//   - Follow-up appointments, memory dates, support resources
//   - Partner support prompts (if consented), mental health support link
//
// Postpartum:
//   - Physical recovery notes, bleeding/pain notes, appointments
//   - Feeding support, sleep deprivation support
//   - PPD/anxiety/rage/OCD/intrusive thoughts support
//   - Birth trauma support, partner support prompts
//   - Personal care prompts, baby care integration
//   - Emergency resources for postpartum psychosis (🔴 high-risk — accredited only)
//
// Breastfeeding / Lactation:
//   - Feeds, pumping, supply notes, mastitis resource links
//   - Nipple pain notes, medication questions for clinician
//   - Feeding preferences, weaning notes
//
// Perimenopause / Menopause:
//   - Symptom tracking, hot flushes, sleep, mood, cycle changes
//   - Libido changes, vaginal/urinary symptoms, appointment prep
//   - HRT notes (if entered), resources
//   - Menopause mode: shifts app away from period prediction if needed
//
// Prostate / Testicular / Sperm / Sexual Health (Men's):
//   - Prostate health reminders, testicular self-check education
//   - Fertility/sperm health notes, vasectomy reminders/follow-up
//   - Erectile dysfunction tracking/support, libido changes
//   - Testosterone-related symptoms, pelvic pain
//   - STI/sexual health testing reminders, urinary symptoms
//   - Reproductive/sexual health appointment prep
//
// Conditions / Sensitivities:
//   - Endometriosis, PCOS, PMDD, adenomyosis, fibroids
//   - Heavy bleeding, irregular cycles, pelvic pain
//   - Migraine with cycle, menopause symptoms, postpartum cycle return
//
// Everyone:
//   - Contraception reminders, STI testing reminders
//   - Sexual health notes, consent/intimacy preferences
//   - Fertility goals, reproductive appointments
//   - Medication questions for clinician
//   - Body-neutral education, relationship/intimacy check-ins

class ReproductiveHealthScreen extends StatelessWidget {
  const ReproductiveHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CycleTrackerScreen extends StatelessWidget {
  const CycleTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ContraceptionScreen extends StatelessWidget {
  const ContraceptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PregnancyScreen extends StatelessWidget {
  const PregnancyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PregnancyLossScreen extends StatelessWidget {
  const PregnancyLossScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PostpartumScreen extends StatelessWidget {
  const PostpartumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BreastfeedingScreen extends StatelessWidget {
  const BreastfeedingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MenopauseScreen extends StatelessWidget {
  const MenopauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MensReproductiveHealthScreen extends StatelessWidget {
  const MensReproductiveHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 11: MENTAL HEALTH & REGULATION TOOLKIT
// ============================================================
// 🟠 D3 (some D4 — crisis plans, self-harm logs)

// PHASE 1D (basic) / PHASE 2B (full)
// NOT one big "Mental Health Mode." A toolkit.
//
// Contains:
//   - Crisis/safety plan (D4)
//   - Worry log
//   - Panic support
//   - Grounding tools
//   - Urge surfing timer
//   - Relapse prevention support
//   - Sobriety tracker (optional, shame-free, recovery-without-streaks mode)
//   - Intrusive thought support
//   - Dissociation support + orientation card
//   - Grief day mode
//   - Low-capacity mode
//   - Emotional regulation support
//   - Trusted contact check-in
//   - Therapy notes
//   - GP/psych discussion export
//
// Does NOT contain:
//   - Seizure features (→ Health Status / Neurology)
//   - Post-seizure recovery (→ Health Status / Current State)
//   - Pleasure Log (→ TBD — Sexual Wellbeing, Relationships/Intimacy, or Wellbeing)
//
// Language:
//   - Does not label: "You've turned on emotional regulation support."
//     Not "Because you have BPD..."
//   - Does not diagnose
//   - Does not interpret
//   - Crisis resources always accessible

class MentalHealthToolkitScreen extends StatelessWidget {
  const MentalHealthToolkitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CrisisPlanWidget extends StatelessWidget {
  const CrisisPlanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class WorryLogScreen extends StatelessWidget {
  const WorryLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class PanicSupportScreen extends StatelessWidget {
  const PanicSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GroundingToolsScreen extends StatelessWidget {
  const GroundingToolsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UrgeSurfingTimer extends StatelessWidget {
  const UrgeSurfingTimer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SobrietyTracker extends StatelessWidget {
  const SobrietyTracker({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class IntrusiveThoughtSupport extends StatelessWidget {
  const IntrusiveThoughtSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DissociationSupportScreen extends StatelessWidget {
  const DissociationSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class EmotionalRegulationScreen extends StatelessWidget {
  const EmotionalRegulationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 12: SUPPORT PRESETS SYSTEM
// ============================================================
// 🟢-🟠 (depends on preset)

// PHASE 1B — Architecture only (SupportPreset data class + Provider)
// PHASE 1D — First presets (ADHD, Depression, Anxiety, Low-Stimulation)
// PHASE 2B — Full preset suite
//
// THREE-LAYER SYSTEM:
//
// LAYER 1: Support Presets
//   Pre-built bundles of sensitivity toggles (from Layer 2).
//   User can: activate, see what changed, customise, turn parts on/off,
//             create custom presets, run multiple simultaneously.
//   No hidden behaviour. Every toggle visible.
//   Named by function, not diagnosis:
//     "ADHD support" not "ADHD mode"
//     "Emotional regulation support" not "BPD mode"
//     "Food & body neutrality support" not "Eating disorder mode"
//     "Psychosis / Reality support" not "Schizophrenia mode"
//
// LAYER 2: Individual Sensitivity / Need-Based Toggles
//   Available outside presets. Anyone can toggle any.
//   Categories:
//     Notification Sensitivity, Language Sensitivity, Sensory Sensitivity,
//     Cognitive Load Sensitivity, Food/Body Sensitivity, Communication Sensitivity,
//     Financial Sensitivity, Health Sensitivity, Privacy Sensitivity
//
// LAYER 3: Current State
//   Temporary. Activated based on how the user is doing right now.
//   Overrides normal app behaviour temporarily.
//   Examples: Overwhelmed, Panicking, Dissociating, In pain, Exhausted,
//             Triggered, Relapse-risk, Intrusive thoughts, Shutdown/meltdown,
//             Need human support, Grief day, Low energy, Sleep deprived,
//             Migraine mode, Flare day, Post-seizure recovery, Sick day
//   Integrates with: Status Shield, Capacity Check-In, Colour Card, Notifications
//
// CONFLICT RESOLUTION:
//   More protective setting wins.
//   Least intrusive setting wins when both are equally protective.
//   User manual override always respected.
//
// PRESET LIST (editable, expandable):
//   ADHD, Autism, Dyslexia, Dyscalculia, Dyspraxia/Motor Planning,
//   Depression, Anxiety, PTSD/Trauma-Informed, Emotional Regulation,
//   Food & Body Neutrality, Addiction Recovery, Psychosis/Reality,
//   Bipolar, OCD, Panic, Dissociation, Postpartum, Chronic Health,
//   Epilepsy, Blind/Low Vision, Deaf/Hard of Hearing,
//   Accessibility/Mobility, Low-Stimulation, Executive Function,
//   Trauma-Informed
//
// PRESET CONTENTS: Each preset defines defaults for Layer 2 toggles,
// language rules, useful features, and Current State shortcuts.
// Full details in spec document. Not duplicated here for brevity.

class SupportPreset {
  // Data class — PHASE 1B
  // Full definition in support_presets.dart
}

class SupportPresetsScreen extends StatelessWidget {
  const SupportPresetsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class SensitivityTogglesScreen extends StatelessWidget {
  const SensitivityTogglesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CurrentStateScreen extends StatelessWidget {
  const CurrentStateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 13: CLOUD RESOURCE LIBRARY
// ============================================================
// 🟢-🟠 (🟠 for high-risk topics)

// PHASE 2B — Cloud Resource Library
// Cloud-based source of truth. Updates without app updates.
// App caches for performance/offline. Server is authoritative.
//
// Every resource has metadata:
//   Title, topic, module, source type, author/reviewer,
//   Source organisation, country/region, age relevance,
//   Condition relevance, risk level, source link,
//   Last reviewed date, next review date, content version,
//   Plain-language summary, emergency/red-flag notes if relevant
//
// Resource labels:
//   🏛️ Accredited Resource — Gov health body, professional body,
//      clinical guideline, hospital/health service
//   ✅ Expert-Reviewed Article — Written/reviewed by qualified professional
//   💬 Lived Experience — Parent/carer/patient experience. Helpful, not medical advice.
//   🏠 Community Idea — Meal ideas, routines, home organisation, lived hacks
//
// High-risk topics (must be accredited or expert-reviewed):
//   CPR, choking, anaphylaxis, medication, fever in infants,
//   safe sleep, seizures, diabetes, blood pressure,
//   pregnancy complications, postpartum psychosis,
//   suicidal ideation/self-harm, DV/coercive control safety

class ResourceLibraryScreen extends StatelessWidget {
  const ResourceLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ResourceDetailScreen extends StatelessWidget {
  const ResourceDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 14: TEAM MODULE
// ============================================================
// 🟢 D2

// PHASE 1B — Team Grid (3x4, expandable to 4x4 = 16)
// Instance cards: icon, name, domain, status
// Tap to chat with instance
// Status indicators: Active, Monitoring, Draft ready
// Instance profile (Phase 2A): role, boundaries, reporting chain
// Instance personalisation (Phase 2A): name, appearance, setting, decor
// Team chats saved, searchable, exportable, markable as private

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InstanceChatScreen extends StatelessWidget {
  const InstanceChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InstanceProfileScreen extends StatelessWidget {
  const InstanceProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 15: COMPANION MODE
// ============================================================
// 🟢 D2

// PHASE 1C — Companion Mode
// Toggle from Dashboard: Dashboard Mode ↔ Companion Mode
// Voice-first interface (speech → text → AI → TTS)
// Companion = user's personalised Head of Staff instance
// Access to calendar, tasks, family hub, health data (permissioned)
// Optional ambient presence (minimised on other screens)
// Avatar + chat bubble UI
// Changes with time of day, user mood
// Interactive life system (optional, user-configurable)
// 2D visual setting (3D future consideration)

class CompanionScreen extends StatelessWidget {
  const CompanionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CompanionAmbientWidget extends StatelessWidget {
  const CompanionAmbientWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CompanionLifeSystem extends StatelessWidget {
  const CompanionLifeSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 16: NOTIFICATIONS SYSTEM
// ============================================================
// 🟢 D2

// PHASE 1B — Notifications System
// Three modes:
//
// Real-Time Mode:
//   For: medication, appointments, school pickup, urgent tasks,
//        baby medication interval, time-sensitive contraception,
//        safety plan prompts, leave-now reminders
//
// Digest Mode:
//   Batches non-urgent: general tasks, meal ideas, budget summaries,
//   low-priority articles, for-later reminders, weekly planning
//
// Hybrid Mode (default):
//   Urgent = real-time
//   Important = digest unless time-bound
//   For Later = digest only
//   Current State can suppress non-urgent notifications
//   Status Shield can hold notifications until expiry
//
// If "Heads Down" or "Overwhelmed":
//   Urgent medication → still comes through
//   Critical family events → still come through
//   Non-urgent tasks → wait
//   Suggestions → move to digest
//   Dashboard → shows only what matters now

// ============================================================
// SECTION 17: STATUS SHIELD
// ============================================================
// 🟢 D2

// PHASE 1B — Status Shield Widget
// Visual status indicator on Dashboard
// Auto-expiry (user-configurable)
// Integration with Current State and Support Presets
// Custom statuses
// Shareable per person (Phase 2A)
// If "Overwhelmed" → auto Heads Down
// If "Low Energy" → auto reduced expectations

class StatusShieldWidget extends StatelessWidget {
  const StatusShieldWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 18: COLOUR CARD MOOD SYSTEM
// ============================================================
// 🟢 D2

// PHASE 1D — Colour Card Mood System
// 8-colour selector: Red, Purple, Orange, Yellow, Brown, Green, Black, Sparkle
// Dashboard display as coloured dot
// Status Shield auto-integration
// Shareable per person (Phase 2A)
// No AI interpretation — user preference only

class ColourCardSelector extends StatelessWidget {
  const ColourCardSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 19: CAPACITY CHECK-IN
// ============================================================
// 🟢 D2

// PHASE 1D — Capacity Check-In
// % Energy slider (0-100%)
// Dashboard display
// Colour card integration
// Shareable (Phase 2A)
// No AI interpretation — user preference only

class CapacitySlider extends StatelessWidget {
  const CapacitySlider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 20: GHOST LOG SYSTEM
// ============================================================
// 🟢-🟠 D2-D4 (depends on content)

// Two distinct layers:
//
// DEVELOPER GHOST LOG (hidden, Phase 1A exists):
//   For: debugging, pipeline auditing, troubleshooting,
//        checking instance procedure, development review,
//        Ant & Beth reviewing instance rule-following during dev
//   NOT user-facing.
//
// USER ACTIVITY LEDGER (visible, Phase 2A):
//   For: transparency, trust, privacy clarity
//   Shows in plain English:
//     - What the app did
//     - What data was used
//     - What was shared between instances
//   Examples:
//     "Val created a calendar event from your capture note."
//     "Tim used your grocery preferences to suggest meals."
//     "Viva received a summary that you activated Low Energy mode."
//     "Rae did not access this note."
//     "Ellory drafted a message using the context you provided."
//     "This health note was not shared with any other instance."
//   Rule: Instances access only domains they need, based on user permissions.
//         Viva receives system-level summaries for coordination.

class UserActivityLedgerScreen extends StatelessWidget {
  const UserActivityLedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class UnifiedHistoryScreen extends StatelessWidget {
  const UnifiedHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 21: CORRESPONDENCE (ELLORY)
// ============================================================
// 🟢 D2

// PHASE 2A — Correspondence Dashboard
// One-tap handoff with context card
// One draft only (not multiple options)
// Three-action review: Approve & Send / Edit / Ask for different version
// Tone presets (quick-tags)
// Template library (approved recurring messages)
// Android Share Sheet integration
// Communication sensitivity toggles:
//   - Pause before sending
//   - Require confirmation before sending
//   - Cooling-off timer
//   - Draft only, don't send

class CorrespondenceScreen extends StatelessWidget {
  const CorrespondenceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 22: INSTANCE LIBRARY & ONBOARDING
// ============================================================
// 🟢 D2

// PHASE 2A — Instance Library
// Browsable library of role templates by category
// Configurable domains per template
// ➕️/⛔️ system for adding/swapping instances
// Minimum 4 instances covering base domains:
//   Schedule, Oversight, Correspondence, +1 (user choice)
// Up to 16 total (4 required + 12 optional)
// Bundle suggestions
//
// Onboarding (three tiers):
//   Full Custom: user picks everything
//   Default Learning: pre-named defaults, user edits later, instances adapt
//   Instance Growth: instances self-customise over time

class InstanceLibraryScreen extends StatelessWidget {
  const InstanceLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class OnboardingFlow extends StatelessWidget {
  const OnboardingFlow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class FullCustomOnboarding extends StatelessWidget {
  const FullCustomOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DefaultLearningOnboarding extends StatelessWidget {
  const DefaultLearningOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InstanceGrowthOnboarding extends StatelessWidget {
  const InstanceGrowthOnboarding({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InstancePersonalisationScreen extends StatelessWidget {
  const InstancePersonalisationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 23: CONNECTABLE ACCOUNTS & SHARING
// ============================================================
// 🟢-🟠 D2-D4 (depends on data shared)

// PHASE 2A — Connectable Accounts
// → Requires: Authentication layer
// Partner sync, parent sync, sibling sync
// Teen own app with graduated privacy
// Share toggles per item per relationship with master toggle
//
// Privacy rules:
//   - Owner/admin, Partner/adult, Teen, Child profile, Carer,
//     Viewer only, Emergency contact
//   - Who owns each data item, who can view, edit, receive reminders
//   - Private by default
//   - What happens when teen ages up, partner disconnects,
//     someone leaves household
//   - What data is in summaries, excluded, exportable, deletable
//
// Data sensitivity levels:
//   D1 Low: meal preferences, household tasks, pet reminders
//   D2 Medium: calendar, budget, family notes, school info
//   D3 High: health, reproductive, mental health, medication, child health
//   D4 Very High: crisis plans, hidden notes, DV info, self-harm logs, safety plans
//   D4 requires stricter sharing, visibility, deletion, access, export, summary rules

class SharingPrivacySettingsScreen extends StatelessWidget {
  const SharingPrivacySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class HouseholdScreen extends StatelessWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class GiftRegisterScreen extends StatelessWidget {
  const GiftRegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 24: ACCESSIBILITY FEATURES
// ============================================================
// 🟢

// PHASE 1C (Dyslexia, Epilepsy, Deaf/HoH basics)
// PHASE 2B (Blind/Low Vision, full suite)
// System-wide settings. Controlled from AccessibilitySettingsScreen.
// Sensitivity toggles available to all users.

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 25: CREATIVE & WELLBEING CORNERS
// ============================================================
// 🟢 D1-D2

// PHASE 1D — Win Logging, Dream Board, Creative Corner, Book Tracker
// PHASE 1D — Celebration Log, Session Mood Indicator
// PHASE 2A — Schedule Protector, Energy Gauge, Ant's View
// PHASE 3  — Research Library, Friction-to-Feature Pipeline

class WinLogScreen extends StatelessWidget {
  const WinLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DreamBoardScreen extends StatelessWidget {
  const DreamBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CreativeCornerScreen extends StatelessWidget {
  const CreativeCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class BookTrackerScreen extends StatelessWidget {
  const BookTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class CelebrationLogScreen extends StatelessWidget {
  const CelebrationLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 26: ADVANCED MODULES (Phase 3)
// ============================================================

// PHASE 3 — Fitness Module
// 🟢-🟠 (🟠 if PT form correction)
class FitnessScreen extends StatelessWidget {
  const FitnessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// PHASE 3 — Gaming Section
// 🟢
class GamingScreen extends StatelessWidget {
  const GamingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// PHASE 3 — Driving Mode
// 🟠 (distraction risk, legal disclaimer required)
class DrivingModeScreen extends StatelessWidget {
  const DrivingModeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 27: SETTINGS
// ============================================================
// 🟢 D2

// PHASE 1B — Settings Screen
// Full settings tree:
//   - Module Management (toggle modules on/off)
//   - Support Presets (activate/configure/customise)
//   - Sensitivity Toggles
//   - Calendar Defaults + Event Categories
//   - Family Hub Management
//   - Meals Preferences
//   - Notification Preferences (Real-Time / Digest / Hybrid)
//   - Status Shield Auto-Expiry
//   - Reproductive Health Defaults
//   - Health Status Defaults
//   - Mental Health Toolkit Preferences
//   - Budget Categories + Tim Preferences
//   - Task Defaults
//   - Team Configuration
//   - Companion Settings + Life System Toggle
//   - Instance Personalisation
//   - Accessibility
//   - Sharing & Privacy (permissions, household roles, data sensitivity)
//   - User Activity Ledger
//   - Data Export / Delete
//   - Developer Ghost Log (hidden, dev only)
//   - Affirmations Source
//   - User Profile (context encoding)
//   - What's New Changelog
//   - About / Licences

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class ModuleManagementScreen extends StatelessWidget {
  const ModuleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class DataExportDeleteScreen extends StatelessWidget {
  const DataExportDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

// ============================================================
// SECTION 28: DOMESTIC VIOLENCE / COERCIVE CONTROL
// ============================================================
// 🔴 D4 — ON HOLD

// Do not build without specialist DV/coercive-control consultation.
// Poorly implemented safety features can increase risk.
//
// Possible future features (pending expert review):
//   - Disguised app name/icon
//   - Quick exit
//   - Hidden notes
//   - Safe contact storage
//   - Privacy masking
//   - Emergency exit pathway
//
// NOT STUBBED. Noted for future architecture only.

// ============================================================
// SECTION 29: PHASE 4+ — PLATFORM FEATURES
// ============================================================

// Instance Marketplace
// Cross-Platform (iOS + Desktop)
// Cloud Backup & Restore
// Family Plan
// Advanced Automation (IFTTT-style)
// Location-Based Features
// Full Platform Release

// Not stubbed. Noted for future architecture.
// → Requires: Authentication, platform infrastructure, moderation systems

// ============================================================
// REVISED MODULE LIST (CLEAN VIEW)
// ============================================================
//
//  1. Dashboard
//  2. Capture / Notes
//  3. Calendar
//  4. Tasks
//  5. Family Hub / Home Base
//  6. Meals
//  7. Budget (Tim)
//  8. Health Status
//  9. Reproductive Health
// 10. Mental Health & Regulation Toolkit
// 11. Cloud Resource Library
// 12. Team / AI Instances
// 13. Notifications & Status Shield
// 14. Support Presets & Accessibility
// 15. Settings / Privacy / Sharing
// 16. Developer Ghost Log / Audit Tools
//
// ============================================================
// BUILD PRIORITY SUMMARY
// ============================================================
//
// PHASE 1B (Complete) — Life Coordination Core:
//   Dashboard, Capture/Notes, Calendar, Tasks,
//   Family Hub basics, Budget basics, Team chats/history,
//   Notifications, Status Shield, Module Registry,
//   Support Preset architecture (data class + Provider only)
//
// PHASE 1C (Complete) — Voice & Companion foundation:
//   Shared STT/TTS, Companion UI + Dashboard toggle,
//   Viva chat with calendar/task context, Companion settings.
//   Ambient presence / wake word deferred to 2A.
//
// PHASE 1D (Complete — basic) — Health, Food, Personalisation:
//   Health Status (basic trackers), Reproductive Health (basic),
//   Mental Health Toolkit (basic), Meals module, Notes timeline,
//   First Support Presets (five wired), Current State layer,
//   Colour Card, Capacity Check-In, Win Logging, Dream Board,
//   Notification router (hybrid), editable quiet hours,
//   Family Hub UX (AU DOB, self profile, contacts vs hub, note dialog)
//
// PHASE 1D REMAINING STUBS (not blockers — polish or defer to 2B):
//   School Hub (placeholder), growth notes / WHO-CDC percentiles,
//   Support Preset per-toggle configure UI, inactive module stubs,
//   full condition categories (Health Status), full Repro/MH suites,
//   Creative Corner / Book Tracker / Celebration Log (partial or unbuilt)
//
// PHASE 2A (Next) — Connection:
//   Authentication, Connectable Accounts, Household,
//   Instance Library, Onboarding (3 tiers),
//   Correspondence Dashboard, User Activity Ledger,
//   Sharing/Privacy system
//
// PHASE 2B — Full Support & Resources:
//   Full Support Preset suite, Sensitivity toggles complete,
//   Health Status (full condition categories),
//   Reproductive Health (full), Cloud Resource Library,
//   Accessibility (Blind/Low Vision), Mental Health Toolkit (full)
//
// 🔴 RED FEATURES — Do not build without expert review:
//   Dose calculators, AI diagnosis, AI treatment recommendations,
//   AI blood work interpretation, emergency triage,
//   DV escape/safety tooling, child protection risk workflows
//
// ============================================================
// END OF ROUTE MAP v2.0
// ============================================================