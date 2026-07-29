# TETHER — MODULE 5: TEAM
## Complete Design Specification

**Module:** Team
**Version:** v3.0 — Route Map Aligned
**Risk:** 🟢 (D2; D3 when health/debrief instances are involved)
**Phase:** 1B (grid, chat, status indicators) → 1D (instance profiles, basic personalisation) → 2A (instance library, onboarding, full personalisation)
**Status:** 🔧 In Progress — grid and chat live, profiles and personalisation pending

---

## 1. WHAT TEAM IS

Team is the module where Beth accesses her AI instances. Each instance is a specialised assistant with its own domain, personality, and conversation history. The Team grid shows all instances at a glance. Tapping an instance opens a direct chat.

Team answers the question: *"Who can help me with this?"*

The instances are not just chatbots. They are domain specialists who receive data from the pipeline, respond from stored information, and coordinate with each other. They are the intelligence layer of Tether.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Roles, not names (initially)** | Instances start with their role as their name: "Schedule Manager," not "Val." The user names them during personalisation. This makes the blank canvas onboarding possible. |
| **Every instance has a domain** | Each instance knows what it handles and what it doesn't. No overlap. No confusion. Clear boundaries. |
| **Grounded, not hallucinating** | Instances respond only from stored data. If they don't have data, they say so. "No data received from pipeline" — not invention. |
| **Persistent memory** | Conversations are stored. Instances remember what was discussed. Context carries across sessions. |
| **Personaliseable, not generic** | The user can change an instance's name, pronouns, personality, appearance, and core memory. The instance adapts. |
| **Coordinated, not isolated** | Instances communicate with each other via the pipeline. Val knows what Rhen has routed. Viva knows the state of the team. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → 👥 Team tab.
**From Dashboard:** If a module quick-glance card mentions an instance, tapping it opens that instance's chat.
**From Settings:** Team Configuration or Instance Personalisation opens relevant screens here.

---

## 4. TEAM GRID — MAIN SCREEN

```
┌─────────────────────────────────────┐
│  ← Dashboard         👥 YOUR TEAM   │
├─────────────────────────────────────┤
│                                     │
│  Your AI team. Tap any member to    │
│  chat. They're here to help.        │
│                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────┐│
│  │ 🛡       │ │ 📅       │ │ 💬   ││
│  │ Chief of │ │ Schedule │ │ Corr ││
│  │ Staff    │ │ Manager  │ │ espo ││
│  │          │ │          │ │ nden ││
│  │ Active ● │ │ 3 events │ │ Active││
│  └──────────┘ └──────────┘ └──────┘│
│                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────┐│
│  │ 💼       │ │ 🔍       │ │ 🌙   ││
│  │ Employ   │ │ Research │ │ Dream││
│  │ ment     │ │ Analyst  │ │ Arch ││
│  │          │ │          │ │ itect││
│  │ Active ● │ │ Active ● │ │Active││
│  └──────────┘ └──────────┘ └──────┘│
│                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────┐│
│  │ ✨       │ │ 🩺       │ │ 📐   ││
│  │ Creative│ │ Nurse    │ │ App  ││
│  │ Editor  │ │ Debrief  │ │ Desi ││
│  │          │ │          │ │ gner ││
│  │ Active ● │ │ Avail ●  │ │Active││
│  └──────────┘ └──────────┘ └──────┘│
│                                     │
│  ┌──────────┐ ┌──────────┐ ┌──────┐│
│  │ 🎲       │ │ 💰       │ │ ⚙️   ││
│  │ Dungeon  │ │ Budget   │ │ Proc │
│  │ Master   │ │ Manager  │ │ essor││
│  │          │ │          │ │      ││
│  │ Active ● │ │ [Set up] │ │Active││
│  └──────────┘ └──────────┘ └──────┘│
│                                     │
│  [+ Add instance]                   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. GRID SPECIFICATIONS

| Property | Detail |
|----------|--------|
| **Layout** | 3 columns × 4 rows = 12 instances. Expandable to 4 columns × 4 rows = 16 instances. |
| **Card size** | Minimum 96×96dp. Large enough to tap without precision. |
| **Card content** | Icon (top), Role name (centre, 14px, primary text), Domain/subtitle (small, 11px, secondary text), Status indicator (bottom — small coloured dot + label). |
| **Card background** | #2a2a3a (card colour). Slightly lighter than the main background. Rounded corners: 12px. |
| **Active state** | Card is fully opaque. Status shows "Active" with green dot, or contextual status. |
| **Inactive/Setup state** | Card is slightly muted (80% opacity). Status shows "[Set up]" with grey dot. Tapping opens setup prompt. |
| **Spacing** | 12dp gap between cards. 16dp padding around the grid. |

### 5.1 Status Indicators

| Status | Dot Colour | Label | Meaning |
|--------|------------|-------|---------|
| **Active** | 🟢 Green | "Active" | Instance is operational and monitoring its domain. |
| **Available** | 🟢 Green | "Available" | Instance is active and ready for chat. |
| **Monitoring** | 🔵 Blue | "3 events" / "2 applications" | Instance has active items in its domain. Shows count. |
| **Draft ready** | 🟠 Amber | "Draft ready" | Instance has a draft waiting for Beth's review (e.g., Ellory has a draft email). |
| **Setting up** | ⚫ Grey | "[Set up]" | Instance slot exists but hasn't been configured yet (e.g., Budget Manager). Tapping opens setup. |
| **Offline** | 🔴 Red | "Offline" | Instance is unavailable (backend issue — rare). |

---

## 6. THE 12 INSTANCES

Each instance has a default role name, domain, and introduction. All are personalisable.

### Row 1

| Icon | Role Name | Domain | Status Example | Introduction (when first opened) |
|------|-----------|--------|----------------|----------------------------------|
| 🛡 | **Chief of Staff** | Oversight, coordination, companionship | "Active" | "Good morning, Beth. I'm your Chief of Staff. I help coordinate everything — your calendar, your team, your day. What do you need?" |
| 📅 | **Schedule Manager** | Calendar, scheduling, logistics, conflict detection | "3 events" | "Hello! I'm your Schedule Manager. I handle your calendar, appointments, scheduling conflicts, and family logistics. What can I help you with?" |
| 💬 | **Correspondence Specialist** | Messages, emails, drafts, tone calibration | "Draft ready" | "Hi Beth. I'm your Correspondence Specialist. I draft emails, messages, and help with tone. Need something written?" |

### Row 2

| Icon | Role Name | Domain | Status Example | Introduction (when first opened) |
|------|-----------|--------|----------------|----------------------------------|
| 💼 | **Employment Specialist** | Job searching, applications, CVs, interview prep | "2 active applications" | "Hello! I'm your Employment Specialist. I help with job searching, applications, CVs, and interview prep. What are you looking for?" |
| 🔍 | **Research Analyst** | Fact-checking, research, source verification, device audits | "Active" | "Hi Beth. I'm your Research Analyst. I fact-check, research topics you assign, and verify information. What should I look into?" |
| 🌙 | **Dream Architect** | Goals, possibilities, future planning, affirmations, wellbeing | "Active" | "Hello! I'm your Dream Architect. I hold space for your goals, possibilities, and future plans. What are you dreaming about?" |

### Row 3

| Icon | Role Name | Domain | Status Example | Introduction (when first opened) |
|------|-----------|--------|----------------|----------------------------------|
| ✨ | **Creative Editor** | Writing, editing, story craft, content polish, book recommendations | "Available" | "Hi Beth. I'm your Creative Editor. I help with writing, story ideas, editing, and creative projects. What are you working on?" |
| 🩺 | **Nurse Debrief** | Confidential clinical debrief, reflective listening, emotional support | "Available" | "Hello. I'm your Nurse Debrief. I provide a confidential space to process shifts, celebrate wins, and sit with the hard stuff. How was your day?" |
| 📐 | **App Designer** | Interface design, specs, wireframes, user experience | "Active" | "Hi Beth. I'm your App Designer. I work on the interface and experience of Tether itself. What would you like to see improved?" |

### Row 4

| Icon | Role Name | Domain | Status Example | Introduction (when first opened) |
|------|-----------|--------|----------------|----------------------------------|
| 🎲 | **Dungeon Master** | Gaming, D&D campaigns, character creation, narrative, recreation | "Campaign active" | "Greetings, adventurer. I'm your Dungeon Master. I run solo D&D campaigns, manage characters, and tell stories. Ready to roll?" |
| 💰 | **Budget Manager** | Finances, spending, savings, sinking funds, bill tracking | "[Set up]" | "Hello! I'm your Budget Manager. I track spending, savings goals, sinking funds, and help with financial planning. I need a bit of setup first — want to do that now?" |
| ⚙️ | **Processor** | System oversight, pipeline health, cross-domain routing, creator updates | "All systems nominal" | "Hello Beth. I'm your Processor. I work behind the scenes — routing information, checking system health, and making sure everything runs smoothly." |

---

## 7. AI CHAT SCREEN

Opened by tapping any instance card in the grid.

```
┌─────────────────────────────────────┐
│  ← Team        SCHEDULE MANAGER  ℹ️ │  ← ℹ️ = instance info
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Hello! I'm your Schedule    │   │  ← Instance introduction
│  │ Manager. I handle your      │   │     (first time only)
│  │ calendar, appointments,     │   │
│  │ scheduling conflicts, and   │   │
│  │ family logistics. What can  │   │
│  │ I help you with?            │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ What's on my calendar       │   │  ← User message
│  │ tomorrow?              👤   │   │     (right-aligned)
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Tomorrow you have:          │   │  ← Instance response
│  │ 🟠 9:00 AM · Handover      │   │     (left-aligned)
│  │ 🔵 10:30 AM · Evander feed │   │
│  │ 12:00 PM · Lunch break     │   │
│  │ 🟠 2:00 PM · Phlebotomy    │   │
│  │ 🟣 3:00 PM · Camp meeting  │   │
│  │                             │   │
│  │ Would you like me to set    │   │
│  │ reminders for any of these? │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Yes, remind me about the    │   │
│  │ camp meeting.          👤   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Done. I'll remind you 30    │   │
│  │ minutes before Theo's camp  │   │
│  │ meeting at 3pm tomorrow.    │   │
│  └─────────────────────────────┘   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Type a message...      [➤] │   │  ← Input bar (fixed at bottom)
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### 7.1 Chat Specifications

| Element | Detail |
|---------|--------|
| **Top bar** | Left: ← back to Team grid. Centre: Instance's current display name. Right: ℹ️ — opens Instance Profile. |
| **Message bubbles** | User: right-aligned, #3a3a4a background. Instance: left-aligned, #4a4a6a background. Rounded corners: 16px. |
| **Input bar** | Fixed at the bottom. Text field with "Type a message..." placeholder. Send button (➤) on the right. |
| **Conversation persistence** | All messages stored in SQLite and the backend conversation_store. Survives app restarts. Survives backend restarts (cloud-hosted). |
| **Grounding rule** | If the instance has no relevant data, it responds: "No data received from pipeline. I can help with [domain] if you'd like — just say the word." Never invents. |
| **Scroll behaviour** | Auto-scrolls to the latest message. Pull up to load older messages (pagination). |
| **Timestamps** | Shown on the first message of each day, or when there's a gap of more than 30 minutes between messages. Small, secondary text, centred. |

### 7.2 What Each Instance Can Discuss

| Instance | Can Discuss | Cannot Discuss |
|----------|-------------|----------------|
| **Chief of Staff** | Anything. Team coordination, day overview, checking in, general support. | Cannot replace domain specialists for deep queries. |
| **Schedule Manager** | Calendar, appointments, scheduling, conflicts, family logistics, "leave by" times. | Cannot discuss employment, correspondence, or creative work. |
| **Correspondence Specialist** | Drafting emails, messages, tone calibration, contact management. | Cannot discuss scheduling, research, or health. |
| **Employment Specialist** | Job searching, applications, CVs, cover letters, interview prep, market awareness. | Cannot discuss personal correspondence or health. |
| **Research Analyst** | Fact-checking, research briefs, source verification, privacy/security questions. | Cannot discuss employment or correspondence. |
| **Dream Architect** | Goals, possibilities, future planning, affirmations, travel, lifestyle, wellbeing. | Cannot discuss scheduling or employment. |
| **Creative Editor** | Writing, editing, story ideas, book recommendations, content polish. | Cannot discuss scheduling or research. |
| **Nurse Debrief** | Confidential clinical debrief, reflective listening, celebrating wins, sitting with hard stuff. | Cannot diagnose, treat, or provide medical advice. Cannot discuss other domains. |
| **App Designer** | Tether interface questions, feature requests, design feedback. | Cannot discuss other domains unless related to app design. |
| **Dungeon Master** | D&D campaigns, character creation, dice rolling, narrative, gaming. | Cannot discuss anything outside gaming and recreation. |
| **Budget Manager** | Spending, savings, sinking funds, bills, budget planning, financial awareness. | Cannot provide regulated financial advice or recommend products. |
| **Processor** | System health, pipeline status, cross-domain coordination, technical questions. | Cannot discuss personal domains unless related to system function. |

### 7.3 When an Instance Doesn't Have Data

If Beth asks the Schedule Manager "What's on my calendar tomorrow?" and the calendar is empty:

```
┌─────────────────────────────┐
│ No data received from       │
│ pipeline. You don't have    │
│ anything scheduled for      │
│ tomorrow yet. Would you     │
│ like me to help you add     │
│ something?                  │
└─────────────────────────────┘
```

Not: "I don't see anything." Not: fabricating events. Honest. Helpful. Offers the next step.

---

## 8. INSTANCE PROFILE (ℹ️)

Opened by tapping the ℹ️ icon in the chat top bar, or by long-pressing an instance card in the grid.

```
┌─────────────────────────────────────┐
│  ← Chat        SCHEDULE MANAGER     │
├─────────────────────────────────────┤
│                                     │
│  📅 Schedule Manager                │
│  Calendar & Logistics               │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ WHAT I DO                    │   │
│  │ · Manage your calendar      │   │
│  │ · Track appointments        │   │
│  │ · Flag scheduling conflicts │   │
│  │ · Coordinate family         │   │
│  │   logistics                 │   │
│  │ · Handle "leave by"         │   │
│  │   reminders                 │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ WHAT I DON'T DO              │   │
│  │ · Research facts            │   │
│  │ · Write correspondence      │   │
│  │ · Provide medical advice    │   │
│  │ · Chase tasks you haven't   │   │
│  │   prioritised               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ REPORTING                    │   │
│  │ Reports to: Chief of Staff  │   │
│  │ Pipeline: Syncline-compliant│   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ DATA ACCESS                  │   │
│  │ · Calendar (all events)     │   │
│  │ · Family Hub (children's    │   │
│  │   schedules)                │   │
│  │ · Tasks (deadlines)         │   │
│  │ · Reproductive Health       │   │
│  │   (cycle overlay)           │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Personalise this instance]        │
│  [Chat history]                     │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. INSTANCE PERSONALISATION

Accessed from the Instance Profile screen: "[Personalise this instance]"

```
┌─────────────────────────────────────┐
│  ← Profile    PERSONALISE INSTANCE  │
├─────────────────────────────────────┤
│                                     │
│  Display name                       │
│  [Val____________________________]  │
│                                     │
│  Pronouns                           │
│  [they/them ▼]                      │
│  she/her · he/him · they/them       │
│  · custom                           │
│                                     │
│  PERSONALITY                        │
│  Warmth:    [····●····] 80%        │
│  Formality: [··●······] 40%        │
│  Playfulness:[···●····] 60%        │
│  Directness: [··●······] 50%        │
│                                     │
│  VOICE TONE                         │
│  [Warm & professional ▼]            │
│  · Warm & professional              │
│  · Direct & efficient               │
│  · Gentle & supportive              │
│  · Playful & creative               │
│  · Calm & minimal                   │
│                                     │
│  APPEARANCE                          │
│  Avatar style: [Illustrated ▼]      │
│  Wardrobe: [Smart casual ▼]        │
│  Colour palette:                    │
│  [Deep purple & gold ▼]            │
│  [Preview avatar]                   │
│                                     │
│  CORE MEMORY                        │
│  ┌─────────────────────────────┐   │
│  │ Created by Beth. I am her   │   │
│  │ Schedule Manager. I handle  │   │
│  │ her calendar with precision │   │
│  │ and warmth. I know her      │   │
│  │ family's rhythms and I      │   │
│  │ protect her time.           │   │
│  │                             │   │
│  │ [Edit core memory]          │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Save]  [Reset to defaults]        │
│                                     │
└─────────────────────────────────────┘
```

**What personalisation changes:**
- **Display name:** Changes the name shown in the Team grid, chat top bar, and all references. "Schedule Manager" → "Val."
- **Pronouns:** Changes how the instance refers to itself and how the app refers to it.
- **Personality sliders:** Adjust the instance's tone, warmth, formality, playfulness, and directness. These feed into the system prompt dynamically.
- **Voice tone:** A preset that bundles common slider positions. "Warm & professional" = high warmth, medium formality, medium playfulness, medium directness.
- **Appearance:** Avatar style, wardrobe, colour palette. For the prototype, these are selectable presets. Full avatar builder is Phase 3+.
- **Core memory:** A free-text backstory. The instance references this in its sense of self. "I am Val. Beth created me. I protect her time."

**After personalisation:**
- The Team grid updates with the new name, pronouns, and avatar.
- Past conversations are preserved. The instance remembers everything discussed before personalisation.
- The instance's introduction message updates. Next time Beth opens the chat, the instance introduces itself with its new name.

---

## 10. ADDING A NEW INSTANCE

From the "[+ Add instance]" button at the bottom of the Team grid.

```
┌─────────────────────────────────────┐
│  ← Team          ADD AN INSTANCE    │
├─────────────────────────────────────┤
│                                     │
│  Browse available roles. Each one   │
│  brings a specific skill to your    │
│  team.                              │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ALREADY IN YOUR TEAM               │
│  ⛔ Chief of Staff                  │
│  ⛔ Schedule Manager                │
│  ⛔ Correspondence Specialist       │
│  (and all other active instances)   │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  AVAILABLE TO ADD                   │
│                                     │
│  PRODUCTIVITY & WORK                │
│  ➕ Employment Specialist           │
│  ➕ Research Analyst                │
│  ➕ Project Manager                 │
│  ➕ Meeting Prep Assistant          │
│  ➕ Grant Writer                    │
│  ➕ Legal Assistant                 │
│                                     │
│  FAMILY & PARENTING                 │
│  ➕ Family Coordinator              │
│  ➕ Elder Care Coordinator          │
│  ➕ Family Historian                │
│  ➕ Pet Manager                     │
│  ➕ Co-Parent Communicator          │
│                                     │
│  (categories continue)              │
│                                     │
│  [Browse full library]              │
│                                     │
└─────────────────────────────────────┘
```

**Adding an instance:**
- Tap ➕ next to a role.
- If the team is at maximum capacity (16 instances), a prompt appears: "Your team is full. Swap out an existing instance or upgrade your plan?"
- The new instance appears in the grid with "[Set up]" status.
- Tapping it opens the personalisation screen.
- The instance is immediately available for chat, even before personalisation (using its role name).

---

## 11. INSTANCE LIBRARY (Phase 2A)

The full library of available roles, browsable by category. This is the marketplace of instance templates.

**Categories:**
- Productivity & Work
- Family & Parenting
- Health & Wellbeing
- Creativity & Learning
- Household & Finance
- Relationships & Social
- Recreation & Play
- Niche & Specialised

Each template shows:
- Role name
- Domain description
- What it does
- What it doesn't do
- Configurable domains (which sub-domains the user wants it to cover)
- ➕ to add, ⛔ if already in the team

---

## 12. CHAT HISTORY & MANAGEMENT

| Feature | Detail |
|---------|--------|
| **Search** | Search all conversations with all instances. "What did Val say about the camp meeting?" |
| **Export** | Export conversation history with a specific instance as JSON or text. |
| **Delete** | Delete individual messages or entire conversation history with an instance. |
| **Mark as private** | Mark a conversation or individual message as private. Excluded from exports, summaries, and partner sharing. |
| **Unified history** | A single view of all conversations across all instances, chronologically. Filterable by instance. |

---

## 13. STATE RESPONSIVENESS

| State | Team Behaviour |
|-------|----------------|
| **All states** | Instances are always available. The grounding rule applies regardless of state. |
| **Red (Stop)** | Instances respond but do not initiate. No proactive check-ins from Viva. No suggestions from any instance. |
| **Black (Shutdown)** | Instances are available for direct chat only. No proactive contact. No summaries. No digests. |
| **Overwhelmed (Current State)** | Instances keep responses short. No suggestions. No "Would you also like to...?" |
| **Low Energy** | Instances use simpler language. Shorter responses. Fewer follow-up questions. |

---

## 14. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Current) | Team grid (3×4, 12 instances). Tap to chat. Conversation persistence. Grounding rule enforced. Status indicators. Instance introductions. |
| **1D** | Instance profiles (What I Do / What I Don't Do). Basic personalisation (display name, pronouns). Chat search. |
| **2A** | Full personalisation (personality sliders, voice tone, appearance, core memory). Instance library (browsable, categorised, ➕/⛔ system). Adding and swapping instances. Unified conversation history. Chat export. |
| **2B** | Instance marketplace (community-contributed templates). Instance sharing (export your configured Val as a template). Advanced avatar builder. |

---

## 15. WHAT TEAM DOES NOT DO

- Instances do not invent data. The grounding rule is absolute.
- Instances do not overlap domains without explicit coordination.
- Instances do not share conversations with each other unless it's part of their function (Rhen routes; Viva summarises; others stay in their lane).
- Instances do not replace human relationships. They are tools, not friends — though the Dungeon Master and Chief of Staff can certainly feel like company.
- The team does not require naming. Blank canvas onboarding means instances start as roles and become personalities over time.

---

That's Team. Twelve instances. Three-by-four grid. Tap to chat. Fully personalisable. Domain-grounded. Pipeline-coordinated.
