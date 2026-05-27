// ============================================================
// FILE: lib/data_architecture.dart
// PURPOSE: Complete data architecture specification for Tether App
// STATUS: Planning document — NOT functional code
// BUILDER: Kit 2.0
// DATE: 26th May 2026
// VERSION: 1.0
// ============================================================
//
// This file defines the data architecture: entities, relationships,
// permissions, sensitivity levels, event types, and AI access rules.
// It is a reference document saved alongside the codebase.
// It does not compile. It does not run. It guides every build decision.
//
// ============================================================
// TABLE OF CONTENTS
// ============================================================
//
// PART 1:  ARCHITECTURE OVERVIEW
// PART 2:  CORE RULES
// PART 3:  DATA ENTITIES
//   3.1   User & Household
//   3.2   Modules & Settings
//   3.3   Support Presets, Toggles, Current State
//   3.4   Accessibility & Notifications
//   3.5   Capture / Notes
//   3.6   Tasks
//   3.7   Calendar
//   3.8   Family Hub
//   3.9   Meals
//   3.10  Budget (Tim)
//   3.11  Health Status
//   3.12  Reproductive Health
//   3.13  Mental Health & Regulation Toolkit
//   3.14  Resource Library
//   3.15  Activity Ledger & Ghost Logs
//   3.16  AI Orchestration
//   3.17  Permissions Engine
//   3.18  Event System
// PART 4:  SENSITIVITY LEVELS (D1–D4)
// PART 5:  RISK CLASSIFICATION (Green, Amber, Red)
// PART 6:  PRIVACY PRINCIPLES
// PART 7:  AI ACCESS RULES
// PART 8:  RECOMMENDED STACK
// PART 9:  BUILD PRIORITY
//
// ============================================================

// ============================================================
// PART 1: ARCHITECTURE OVERVIEW
// ============================================================
//
// Layer stack (top to bottom):
//
// ┌─────────────────────────────────────────┐
// │           FLUTTER MOBILE APP            │  User interface
// ├─────────────────────────────────────────┤
// │       LOCAL DATABASE (SQLite/Drift)     │  Offline cache, speed
// ├─────────────────────────────────────────┤
// │           API SERVER (FastAPI)          │  Auth, routing, validation
// ├─────────────────────────────────────────┤
// │        CORE DATABASE (PostgreSQL)       │  Source of truth
// ├─────────────────────────────────────────┤
// │          PERMISSION ENGINE              │  Access control
// ├─────────────────────────────────────────┤
// │           EVENT SYSTEM                  │  Cross-module communication
// ├─────────────────────────────────────────┤
// │       AI ORCHESTRATION LAYER            │  Instance routing, model selection
// ├─────────────────────────────────────────┤
// │  RESOURCE LIBRARY  │  FILE STORAGE  │  VECTOR SEARCH  │
// │  (Cloud CMS)       │  (S3/R2)       │  (pgvector)     │
// └─────────────────────────────────────────┘
//
// In plain English:
//
// MOBILE APP       The user interface on phone/tablet
// LOCAL DATABASE   Stores recent data for speed/offline use
// API SERVER       Your own server; the app talks to this, not directly to AI providers
// CORE DATABASE    Main source of truth for user data
// PERMISSION ENGINE Decides who/what can access each item
// EVENT SYSTEM     Lets modules react when something happens
// AI ORCHESTRATION  Chooses which AI model/instance handles the request
// RESOURCE LIBRARY  Cloud-based health/parenting/safety resources
// FILE STORAGE     PDFs, images, health docs, exports
// VECTOR SEARCH    Lets AI retrieve relevant notes without reading everything
//
// ============================================================

// ============================================================
// PART 2: CORE RULES
// ============================================================
//
// RULE 1: THE DATABASE OWNS THE DATA.
// The AI can read, summarise, suggest, classify, and draft.
// The AI must NEVER be the source of truth.
//
// What AI CAN do:
//   ✅ Read permitted data
//   ✅ Summarise entries
//   ✅ Suggest actions
//   ✅ Create drafts
//   ✅ Classify notes
//   ✅ Propose tasks/events
//
// What AI CANNOT do:
//   ❌ Store data directly
//   ❌ Be the primary record
//   ❌ Modify data without user approval
//   ❌ Access data outside its permission scope
//   ❌ Interpret clinical data
//   ❌ Override user decisions
//
// RULE 2: INSTANCES ACCESS ONLY DOMAINS THEY NEED.
// Based on user permissions. Viva receives system-level summaries for coordination.
//
// RULE 3: EVERY SENSITIVE ITEM ANSWERS:
//   Who owns this?
//   Who can read it?
//   Who can edit it?
//   Who can share it?
//   Can AI access it?
//   Can it be summarised?
//   Can it appear on dashboard?
//   Can it be exported?
//   Can it be deleted?
//
// ============================================================

// ============================================================
// PART 3: DATA ENTITIES
// ============================================================

// ----------------------------------------------------------
// 3.1 — USER & HOUSEHOLD
// ----------------------------------------------------------

// USERS — The actual app account.
// Table: users
// Fields:
//   user_id              UUID        Primary key
//   email                String      Unique
//   auth_provider        String      e.g. supabase, firebase, custom
//   display_name         String
//   timezone             String      e.g. Australia/Brisbane
//   default_language     String      Default en
//   account_status       String      active, suspended, deleted
//   created_at           Timestamp
//   updated_at           Timestamp

// HOUSEHOLDS — The shared family/home unit.
// Table: households
// Fields:
//   household_id         UUID        Primary key
//   household_name       String
//   owner_user_id        UUID        FK → users
//   settings             JSONB       Household-level defaults
//   created_at           Timestamp

// HOUSEHOLD MEMBERS — Connects persons to a household.
// Table: household_members
// Fields:
//   household_member_id  UUID        Primary key
//   household_id         UUID        FK → households
//   person_id            UUID        FK → person_profiles
//   user_id              UUID        FK → users, nullable (not all persons have logins)
//   role                 String      owner, partner, teen, child_profile,
//                                    carer, viewer, emergency_contact
//   sharing_status       String      active, pending, restricted, removed
//   joined_at            Timestamp
//   left_at              Timestamp   Nullable

// PERSON PROFILES — Not every person has their own login.
// Table: person_profiles
// Fields:
//   person_id            UUID        Primary key
//   household_id         UUID        FK → households
//   display_name         String
//   relationship_to_user String      self, partner, child, pet, carer, family
//   date_of_birth        Date        Nullable
//   age_stage            String      baby, toddler, child, teen, adult, pet
//   profile_type         String      user, partner, child, pet, carer
//   colour_icon          String      For calendar/UI colour coding
//   privacy_level        String      standard, elevated, maximum
//   notes                Text        Nullable
//   created_at           Timestamp
//
// Example: Evander = person_profile, not a user.
//          Ant = person_profile now, user if he connects his own account later.

// ROLES PERMISSIONS — Defines what each household role can do.
// Table: roles_permissions
// Fields:
//   role_permission_id   UUID        Primary key
//   role                 String      owner, partner, teen, child_profile,
//                                    carer, viewer, emergency_contact
//   module               String
//   can_read             Boolean
//   can_write            Boolean
//   can_share            Boolean
//   can_export           Boolean
//   can_delete           Boolean
//   sensitivity_limit    String      D1, D2, D3, D4

// ----------------------------------------------------------
// 3.2 — MODULES & SETTINGS
// ----------------------------------------------------------

// MODULES — List of possible app modules.
// Table: modules
// Fields:
//   module_id            UUID        Primary key
//   module_key           String      dashboard, capture_notes, calendar, tasks,
//                                    family_hub, meals, budget, health_status,
//                                    reproductive_health, mental_health_toolkit,
//                                    resource_library, team, companion
//   display_name         String
//   description          Text
//   default_enabled      Boolean
//   risk_level           String      green, amber, red
//
// Module keys (full list):
//   dashboard
//   capture_notes
//   calendar
//   tasks
//   family_hub
//   meals
//   budget
//   health_status
//   reproductive_health
//   mental_health_toolkit
//   resource_library
//   team
//   companion

// USER MODULE SETTINGS — Which modules are active for each user.
// Table: user_module_settings
// Fields:
//   setting_id           UUID        Primary key
//   user_id              UUID        FK → users
//   module_id            UUID        FK → modules
//   enabled              Boolean
//   nav_position         Integer     Nullable
//   dashboard_visible    Boolean
//   created_at           Timestamp
//   updated_at           Timestamp

// ----------------------------------------------------------
// 3.3 — SUPPORT PRESETS, TOGGLES, CURRENT STATE
// ----------------------------------------------------------

// SUPPORT PRESETS — Preset definitions (system-level, curated).
// Table: support_presets
// Fields:
//   preset_id            UUID        Primary key
//   preset_key           String      adhd_support, autism_support,
//                                    depression_support, etc.
//   display_name         String      "ADHD support" not "ADHD mode"
//   description          Text        What it does, what it doesn't do
//   category             String      executive, emotional, sensory, health,
//                                    accessibility
//   default_toggles      JSONB       Which Layer 2 toggles it enables by default
//   language_rules       JSONB       Banned phrases, preferred alternatives
//   current_state_shortcuts JSONB    Linked Current States
//   risk_level           String      green, amber
//   version              Integer
//   created_at           Timestamp
//   updated_at           Timestamp
//
// Naming rule: "ADHD support" NOT "ADHD mode"
//              "Emotional regulation support" NOT "BPD mode"
//              "Food & body neutrality support" NOT "Eating disorder mode"

// USER SUPPORT PRESETS — What the user has turned on.
// Table: user_support_presets
// Fields:
//   user_preset_id       UUID        Primary key
//   user_id              UUID        FK → users
//   preset_id            UUID        FK → support_presets
//   enabled              Boolean
//   customised_settings  JSONB       User adjustments to defaults
//   created_at           Timestamp
//   updated_at           Timestamp

// SENSITIVITY TOGGLES — Master list of all possible toggles.
// Table: sensitivity_toggles
// Fields:
//   toggle_id            UUID        Primary key
//   toggle_key           String      reduce_notifications, use_plain_language,
//                                    avoid_food_body_language, disable_animations,
//                                    one_next_step, require_confirm_before_send,
//                                    screen_reader_optimised, etc.
//   display_name         String
//   category             String      notification, language, sensory,
//                                    cognitive_load, food_body, communication,
//                                    financial, health, privacy
//   description          Text
//   default_value        Boolean
//
// Full toggle list by category:
//
// Notification Sensitivity:
//   reduce_notifications
//   increase_reminders
//   digest_only
//   real_time_urgent_only
//   quiet_hours
//   status_shield_suppression
//   low_stimulation_alerts
//   no_sound
//   no_vibration
//   visual_only
//
// Language Sensitivity:
//   use_plain_language
//   extra_direct_language
//   gentle_language
//   no_shame_language
//   no_diet_body_language
//   no_clinical_labels
//   no_should_wording
//   no_productivity_pressure
//   trauma_informed_wording
//   short_prompts_only
//   detailed_explanations_enabled
//
// Sensory Sensitivity:
//   disable_animations
//   reduce_motion
//   reduce_sound
//   reduce_haptics
//   low_stim_theme
//   high_contrast
//   soft_contrast
//   no_flashing
//   no_confetti
//   simplified_dashboard
//   fewer_badges_alerts
//
// Cognitive Load Sensitivity:
//   one_next_step
//   hide_non_urgent_items
//   visual_steps
//   checklists
//   short_summaries
//   explain_this_simply
//   memory_prompts
//   routine_support
//   fewer_choices
//   default_to_one_recommendation
//   keep_original_messy_capture
//
// Food / Body Sensitivity:
//   avoid_calories
//   hide_weight
//   no_good_bad_food_language
//   no_diet_culture_language
//   no_weight_loss_prompts
//   no_exercise_as_punishment_language
//   neutral_meal_reminders
//   safe_foods_list
//   sensory_foods_support
//   arfid_support
//   distress_after_meals_support
//
// Communication Sensitivity:
//   pause_before_sending
//   require_confirmation_before_sending
//   cooling_off_timer
//   draft_only_dont_send
//   one_draft_not_five
//   tone_check
//   conflict_de_escalation
//   repair_prompt
//   trusted_person_check_in
//   hide_message_suggestions_during_overwhelm
//
// Financial Sensitivity:
//   require_confirmation_before_spending
//   delay_big_financial_decisions
//   avoid_shame_spending_language
//   bare_minimum_budget_mode
//   bill_warning_mode
//   sinking_fund_suggestions
//   visual_budget_bars
//   simplified_numbers
//   reduce_impulse_purchase_prompts
//
// Health Sensitivity:
//   medication_reminders
//   appointment_prep
//   symptom_logging
//   doctor_export
//   low_energy_mode
//   flare_mode
//   pain_day_mode
//   migraine_mode
//   post_seizure_mode
//   pregnancy_postpartum_sensitivity
//   accredited_resources_only
//   no_ai_diagnosis
//   no_treatment_recommendations
//
// Privacy Sensitivity:
//   hide_sensitive_notes
//   require_app_lock
//   private_chat_mode
//   exclude_from_ai_summaries
//   exclude_from_partner_sharing
//   hide_from_dashboard
//   visible_only_to_user
//   auto_delete_after_set_period

// USER SENSITIVITY TOGGLES — What the user has enabled.
// Table: user_sensitivity_toggles
// Fields:
//   user_toggle_id       UUID        Primary key
//   user_id              UUID        FK → users
//   toggle_id            UUID        FK → sensitivity_toggles
//   enabled              Boolean
//   source               String      manual, preset, current_state
//   override_level       Integer     Higher = wins conflicts
//   created_at           Timestamp
//   updated_at           Timestamp

// CURRENT STATES — Temporary state definitions.
// Table: current_states
// Fields:
//   state_id             UUID        Primary key
//   state_key            String      overwhelmed, panicking, dissociating,
//                                    low_energy, sleep_deprived, migraine,
//                                    flare_day, post_seizure_recovery,
//                                    sick_day, grief_day, in_pain, triggered,
//                                    relapse_risk, intrusive_thoughts,
//                                    shutdown_meltdown, need_human_support,
//                                    post_op_recovery, infection_risk,
//                                    respiratory_flare, gi_flare
//   display_name         String
//   description          Text
//   default_duration_minutes Integer  Nullable (null = indefinite)
//   effect_overrides     JSONB       What gets suppressed, what gets surfaced
//   created_at           Timestamp

// USER CURRENT STATE — The user's active temporary state.
// Table: user_current_state
// Fields:
//   user_state_id        UUID        Primary key
//   user_id              UUID        FK → users
//   state_id             UUID        FK → current_states
//   active               Boolean
//   started_at           Timestamp
//   expires_at           Timestamp   Nullable
//   manually_ended_at    Timestamp   Nullable
//   effect_snapshot      JSONB       What was changed, for audit

// ----------------------------------------------------------
// 3.4 — ACCESSIBILITY & NOTIFICATIONS
// ----------------------------------------------------------

// ACCESSIBILITY SETTINGS
// Table: accessibility_settings
// Fields:
//   setting_id           UUID        Primary key
//   user_id              UUID        FK → users
//   dyslexia_font        Boolean
//   large_text           Boolean
//   high_contrast        Boolean
//   reduce_motion        Boolean
//   reduce_haptics       Boolean
//   no_flashing          Boolean
//   screen_reader_optimised Boolean
//   voice_input_default  Boolean
//   text_to_speech_default Boolean
//   colour_overlay       String      Nullable (soft_yellow, soft_blue)
//   button_size          String      standard, large
//   created_at           Timestamp
//   updated_at           Timestamp

// NOTIFICATION SETTINGS
// Table: notification_settings
// Fields:
//   setting_id           UUID        Primary key
//   user_id              UUID        FK → users
//   mode                 String      real_time, digest, hybrid
//   digest_time          Time        Default 07:00
//   quiet_hours_start    Time        Nullable
//   quiet_hours_end      Time        Nullable
//   allow_sound          Boolean
//   allow_vibration      Boolean
//   allow_visual         Boolean
//   suppress_when_heads_down Boolean
//   created_at           Timestamp
//   updated_at           Timestamp

// ----------------------------------------------------------
// 3.5 — CAPTURE / NOTES
// ----------------------------------------------------------

// CAPTURE ENTRIES — Raw user notes. ALWAYS PRESERVED.
// Table: capture_entries
// Fields:
//   capture_id           UUID        Primary key
//   user_id              UUID        FK → users
//   household_id         UUID        FK → households
//   raw_text             Text        Original, unmodified
//   input_type           String      text, voice, image, file
//   audio_file_url       String      Nullable
//   image_file_url       String      Nullable
//   sensitivity_level    String      D1, D2, D3, D4
//   privacy_scope        String      private, household, selected_persons
//   original_preserved   Boolean     Always true
//   created_at           Timestamp

// CAPTURE CLASSIFICATIONS — How the AI classified the capture.
// Table: capture_classifications
// Fields:
//   classification_id    UUID        Primary key
//   capture_id           UUID        FK → capture_entries
//   category             String      task, calendar, shopping, health, family,
//                                    budget, idea, correspondence, unsorted
//   sub_category         String      Nullable
//   confidence           Float       0.0–1.0
//   instance_used        String      Which AI instance classified it
//   reviewed_by_user     Boolean     Default false
//   user_modified_category String    Nullable
//   created_at           Timestamp

// CAPTURE OUTPUTS — What was created from the capture.
// Table: capture_outputs
// Fields:
//   output_id            UUID        Primary key
//   capture_id           UUID        FK → capture_entries
//   output_type          String      task, event, note, shopping_item, draft,
//                                    health_entry, medication_entry
//   linked_entity_id     UUID        ID in the target table
//   created_at           Timestamp

// DAILY TIMELINES — Aggregated view of a day's captures.
// Table: daily_timelines
// Fields:
//   timeline_id          UUID        Primary key
//   user_id              UUID        FK → users
//   date                 Date
//   capture_ids          UUID[]      Array of capture IDs for that day
//   auto_categorised_folders JSONB   e.g. { "Scheduling": [id1, id2],
//                                           "Shopping": [id3] }

// ----------------------------------------------------------
// 3.6 — TASKS
// ----------------------------------------------------------

// TASKS
// Table: tasks
// Fields:
//   task_id              UUID        Primary key
//   household_id         UUID        FK → households
//   owner_user_id        UUID        FK → users
//   assigned_person_id   UUID        FK → person_profiles, nullable
//   title                String
//   description          Text        Nullable
//   category             String      bare_minimum, personal_care, house,
//                                    care, life_admin, recovery
//   priority             String      urgent, important, for_later
//   deadline             Timestamp   Nullable
//   energy_level         String      low, medium, high
//   status               String      pending, in_progress, completed,
//                                    snoozed, deferred, cancelled
//   snoozed_until        Timestamp   Nullable
//   source_capture_id    UUID        Nullable, FK → capture_entries
//   created_by_instance  String      Which AI instance created it
//   sensitivity_level    String      D1, D2
//   created_at           Timestamp
//   updated_at           Timestamp
//   completed_at         Timestamp   Nullable

// TASK CATEGORIES
// Table: task_categories
// Fields:
//   category_id          UUID        Primary key
//   category_key         String
//   display_name         String
//   colour               String      Hex
//   icon                 String
//   user_created         Boolean

// TASK PACKS — Pre-built task collections (editable, removable).
// Table: task_packs
// Fields:
//   pack_id              UUID        Primary key
//   pack_key             String      adhd_support, depression_support,
//                                    new_parent_survival, pet_care,
//                                    house_reset, flare_day, etc.
//   display_name         String
//   description          Text
//   is_system            Boolean
//   created_by_user_id   UUID        Nullable, FK → users
//
// System task packs:
//   ADHD support task pack
//   Depression support task pack
//   Postpartum support task pack
//   Chronic pain support task pack
//   New parent survival pack
//   Pet care pack
//   House reset pack
//   Night shift worker pack
//   Student/placement pack
//   Grief day pack
//   Migraine day pack
//   Flare day pack
//   Sick day pack
//   Low-energy day pack

// TASK PACK ITEMS — Individual tasks within a pack.
// Table: task_pack_items
// Fields:
//   item_id              UUID        Primary key
//   pack_id              UUID        FK → task_packs
//   title                String
//   category             String
//   priority             String
//   energy_level         String
//   sort_order           Integer

// TASK ASSIGNMENTS — Tracks who a task is assigned to.
// Table: task_assignments
// Fields:
//   assignment_id        UUID        Primary key
//   task_id              UUID        FK → tasks
//   assigned_to_person_id UUID       FK → person_profiles
//   assigned_by_user_id  UUID        FK → users
//   created_at           Timestamp

// TASK HISTORY — Full audit trail.
// Table: task_history
// Fields:
//   history_id           UUID        Primary key
//   task_id              UUID        FK → tasks
//   action               String      created, edited, snoozed, completed,
//                                    deferred, deleted
//   changed_by           String      user_id or instance_id
//   previous_value       JSONB
//   new_value            JSONB
//   timestamp            Timestamp

// ----------------------------------------------------------
// 3.7 — CALENDAR
// ----------------------------------------------------------

// CALENDAR EVENTS
// Table: calendar_events
// Fields:
//   event_id             UUID        Primary key
//   household_id         UUID        FK → households
//   title                String
//   description          Text        Nullable
//   start_time           Timestamp
//   end_time             Timestamp
//   timezone             String
//   category_id          UUID        FK → calendar_categories
//   person_id            UUID        Nullable, FK → person_profiles
//   location             String      Nullable
//   priority             String      urgent, important, normal
//   recurrence_rule      String      Nullable, RFC 5545
//   source               String      manual, capture, ai_suggested, imported
//   created_by_instance  String      Nullable
//   privacy_scope        String      private, household, selected_persons
//   sensitivity_level    String      D1, D2, D3
//   created_at           Timestamp
//   updated_at           Timestamp

// CALENDAR CATEGORIES
// Table: calendar_categories
// Fields:
//   category_id          UUID        Primary key
//   household_id         UUID        FK → households
//   display_name         String
//   colour               String      Hex
//   icon                 String
//   person_scope         UUID        Nullable, FK → person_profiles
//   created_at           Timestamp
//
// System defaults: Beth, Ant, Evander, Theodore, Annabella,
//                  Family, School, Medical, Pets, Work, Household

// EVENT ATTENDEES
// Table: event_attendees
// Fields:
//   attendee_id          UUID        Primary key
//   event_id             UUID        FK → calendar_events
//   person_id            UUID        FK → person_profiles
//   response_status      String      accepted, declined, tentative, pending

// EVENT SOURCES — Tracks where events came from.
// Table: event_sources
// Fields:
//   source_id            UUID        Primary key
//   event_id             UUID        FK → calendar_events
//   source_type          String      manual, capture, ai_suggested, imported
//   source_capture_id    UUID        Nullable
//   source_instance_id   String      Nullable
//   created_at           Timestamp

// ----------------------------------------------------------
// 3.8 — FAMILY HUB
// ----------------------------------------------------------

// FAMILY PROFILES
// Table: family_profiles
// Fields:
//   profile_id           UUID        Primary key
//   person_id            UUID        FK → person_profiles
//   household_id         UUID        FK → households
//   bio                  Text        Nullable
//   support_preferences  JSONB       Nullable
//   privacy_consent      JSONB
//   created_at           Timestamp
//   updated_at           Timestamp

// CHILD LOGS — General child activity log.
// Table: child_logs
// Fields:
//   log_id               UUID        Primary key
//   child_person_id      UUID        FK → person_profiles
//   log_type             String      feed, sleep, nappy, medication, symptom,
//                                    food, note, milestone
//   value                JSONB       Type-specific data
//   logged_by_user_id    UUID        FK → users
//   notes                Text        Nullable
//   created_at           Timestamp

// BABY LOGS — Baby-specific logging.
// Table: baby_logs
// Fields:
//   baby_log_id          UUID        Primary key
//   child_person_id      UUID        FK → person_profiles
//   log_type             String      feed, sleep, nappy, medication,
//                                    tummy_time, bath, weight, length
//   start_time           Timestamp
//   end_time             Timestamp   Nullable
//   value                JSONB       e.g. { "feed_type": "breast",
//                                          "side": "left",
//                                          "duration_minutes": 20 }
//   logged_by_user_id    UUID        FK → users
//   notes                Text        Nullable
//   created_at           Timestamp

// FOOD EXPOSURES — Baby-led weaning and child food tracking.
// Table: food_exposures
// Fields:
//   exposure_id          UUID        Primary key
//   child_person_id      UUID        FK → person_profiles
//   food_name            String
//   date_tried           Date
//   texture              String      puree, mashed, soft_finger,
//                                    hard_finger, liquid
//   reaction             String      none, mild, moderate, severe
//   accepted_neutral_status String   tried, explored, not_interested_today,
//                                    accepted, reaction_noted
//   allergy_flag         Boolean     Default false
//   notes                Text        Nullable
//   created_at           Timestamp
//
// LANGUAGE RULE: Never "refused".
//   Use: tried, explored, not_interested_today, accepted, reaction_noted

// PET PROFILES
// Table: pet_profiles
// Fields:
//   pet_id               UUID        Primary key
//   person_id            UUID        FK → person_profiles (pet-type)
//   species              String
//   breed                String      Nullable
//   vet_contact          Text        Nullable
//   microchip_number     String      Nullable
//   notes                Text        Nullable

// PET LOGS
// Table: pet_logs
// Fields:
//   pet_log_id           UUID        Primary key
//   pet_id               UUID        FK → pet_profiles
//   log_type             String      feed, water, medication, litter_enclosure,
//                                    walk, grooming, vet_visit
//   value                JSONB
//   logged_by_user_id    UUID        FK → users
//   created_at           Timestamp

// SCHOOL ITEMS
// Table: school_items
// Fields:
//   school_item_id       UUID        Primary key
//   child_person_id      UUID        FK → person_profiles
//   household_id         UUID        FK → households
//   item_type            String      event, homework, excursion,
//                                    permission_slip, fee, uniform, contact_info
//   title                String
//   description          Text        Nullable
//   due_date             Date        Nullable
//   status               String      pending, done, overdue
//   school_name          String
//   school_contact       Text        Nullable
//   created_at           Timestamp

// HOUSEHOLD TASKS — Recurring/shared house responsibilities.
// Table: household_tasks
// Fields:
//   household_task_id    UUID        Primary key
//   household_id         UUID        FK → households
//   title                String
//   category             String      dishes, washing, bins, floors, tidying,
//                                    groceries, maintenance, car, rego
//   assigned_person_id   UUID        Nullable, FK → person_profiles
//   frequency            String      daily, weekly, fortnightly, monthly, as_needed
//   last_completed_at    Timestamp   Nullable
//   created_at           Timestamp

// ----------------------------------------------------------
// 3.9 — MEALS
// ----------------------------------------------------------

// MEAL PROFILES — Household-level meal configuration.
// Table: meal_profiles
// Fields:
//   meal_profile_id      UUID        Primary key
//   household_id         UUID        FK → households
//   people_count         Integer
//   cooking_equipment    JSONB       e.g. ["oven", "stovetop", "air_fryer"]
//   budget_level         String      low, medium, high
//   prefers_leftovers    Boolean
//   prefers_batch_cooking Boolean
//   created_at           Timestamp
//   updated_at           Timestamp

// FOOD PREFERENCES — Per-person food preferences, allergies, sensory needs.
// Table: food_preferences
// Fields:
//   preference_id        UUID        Primary key
//   person_id            UUID        FK → person_profiles
//   food_item            String
//   preference_type      String      likes, dislikes, safe_food, sensory_issue,
//                                    texture_preference, allergy, intolerance,
//                                    arfid_safe, arfid_challenge
//   severity             String      mild, moderate, severe, anaphylaxis
//   notes                Text        Nullable
//   created_at           Timestamp

// ALLERGIES — Deduplicated allergy list per person (for safety).
// Table: allergies
// Fields:
//   allergy_id           UUID        Primary key
//   person_id            UUID        FK → person_profiles
//   allergen             String
//   reaction_type        String
//   severity             String      mild, moderate, severe, anaphylaxis
//   confirmed_by_clinician Boolean
//   action_plan_url      String      Nullable, link to stored document
//   epipen_location      String      Nullable
//   notes                Text        Nullable
//   created_at           Timestamp
//   updated_at           Timestamp

// MEAL TEMPLATES — Base meal + variations.
// Table: meal_templates
// Fields:
//   meal_id              UUID        Primary key
//   household_id         UUID        FK → households, nullable (system templates)
//   base_meal_name       String
//   ingredients          JSONB
//   cooking_equipment    JSONB
//   time_required_minutes Integer
//   energy_required      String      low, medium, high
//   budget_level         String      low, medium, high
//   baby_adaptable       Boolean
//   toddler_adaptable    Boolean
//   allergy_exclusions   JSONB       e.g. ["dairy", "eggs", "nuts"]
//   variations           JSONB       e.g. { "adult": {...}, "baby": {...} }
//   created_by_instance  String      Nullable
//   created_at           Timestamp
//
// Structure: Base meal + variations
//   Adult version → Child adaptation → Baby/toddler adaptation
//   Allergy rule: avoid allergen across household unless user overrides

// MEAL PLANS
// Table: meal_plans
// Fields:
//   meal_plan_id         UUID        Primary key
//   household_id         UUID        FK → households
//   meal_id              UUID        FK → meal_templates
//   date                 Date
//   selected_variations  JSONB       Which variation per person
//   shopping_list_generated Boolean   Default false
//   created_by_instance  String      Nullable
//   created_at           Timestamp

// SHOPPING ITEMS — Generated from meal plans or manual entry.
// Table: shopping_items
// Fields:
//   item_id              UUID        Primary key
//   household_id         UUID        FK → households
//   meal_plan_id         UUID        Nullable, FK → meal_plans
//   item_name            String
//   category             String      produce, dairy, meat, pantry, frozen,
//                                    household, baby
//   quantity             String
//   purchased            Boolean     Default false
//   created_at           Timestamp

// ----------------------------------------------------------
// 3.10 — BUDGET (TIM)
// ----------------------------------------------------------

// BUDGET CATEGORIES
// Table: budget_categories
// Fields:
//   category_id          UUID        Primary key
//   user_id              UUID        FK → users
//   household_id         UUID        FK → households
//   name                 String
//   colour               String      Hex
//   type                 String      income, expense
//   created_at           Timestamp

// INCOME ENTRIES
// Table: income_entries
// Fields:
//   income_id            UUID        Primary key
//   user_id              UUID        FK → users
//   household_id         UUID        FK → households
//   amount               Decimal
//   category_id          UUID        FK → budget_categories
//   date                 Date
//   description          String
//   recurring            Boolean
//   frequency            String      weekly, fortnightly,