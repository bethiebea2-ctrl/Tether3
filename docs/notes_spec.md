# TETHER — MODULE 3: NOTES
## Complete Design Specification

**Module:** Notes
**Version:** v3.0 — Route Map Aligned
**Risk:** 🟢 (D2; can capture D3-D4 data depending on content — handled by privacy rules)
**Phase:** 1A (core capture loop) → 1B (quick-log, error states, clarification) → 1D (daily timeline, auto-categorised folders, messy + clean preservation)
**Status:** ✅ Phase 1C complete — shared STT/TTS, continuous listen, optional speak-back. Timeline/folders deferred to 1D

---

## 1. WHAT NOTES IS

Notes is the primary input point for Tether. It is how Beth adds anything to the app — a task, a calendar event, a medication log, a feed for Evander, a worry, a dream, a random thought while driving.

It answers the question: *"I need to get this out of my head and into the system."*

Notes is NOT a passive notepad. It is an intelligent capture system. Everything that enters through Notes is classified by Rhen (the Processor instance) and routed to the correct module. Beth doesn't need to know where something goes. She just speaks or types. The system sorts it.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Capture in under 3 seconds** | The primary measure of success. If it takes longer than 3 seconds to start capturing, it's too slow. |
| **One entry point, many destinations** | Beth speaks or types once. Rhen routes to Calendar, Tasks, Family Hub, Budget, Health, Mental Health Toolkit, or keeps it as a general note. |
| **Preserve the messy original** | When AI tidies up a capture, the original is kept alongside the cleaned version. Context can be lost when things are made too neat. |
| **Ask, don't guess** | If Rhen is unsure about classification, it asks. The Clarification Card appears. No silent misrouting. No invented data. |
| **Forgiving, not punishing** | Undo is always available (30 seconds). Mistakes are easy to fix. Nothing is permanent until Beth confirms. |
| **Privacy-aware** | Content marked as sensitive (D3-D4) is handled with stricter rules. Debrief content goes to Rae and is confidential. |

---

## 3. HOW YOU GET HERE

**Primary:** Bottom nav → 📝 Notes tab.
**From Dashboard:** Floating action button (+) (Phase 1D — currently the bottom nav tab is the primary access).
**From Family Hub:** "Quick Log" buttons on a child's profile open Notes with that child and log type pre-selected.
**From Calendar:** "Quick-add event" opens Notes with event context pre-selected.
**Voice activation (Phase 1C+):** "Hey Tether, note..." or "Hey Tether, remind me..."
**Driving mode (Phase 3):** Full-screen voice capture. No buttons. Just speak.

---

## 4. THE TWO CAPTURE MODES

Notes has two capture modes, toggled by a segmented control at the top:

| Mode | Best For | Input Method |
|------|----------|--------------|
| **Voice** | Driving, hands-free, rambling, tired, holding a baby | Speak. Rhen transcribes and classifies. |
| **Text / Quick Log** | Typing, quiet environments, specific data entry | Type or tap quick-log buttons. |

Both modes feed into the same pipeline. The difference is only how the input enters.

---

## 5. VOICE MODE — FULL SPECIFICATION

### 5.1 Layout

```
┌─────────────────────────────────────┐
│  ← Notes                  [Voice ●] │  ← TOP BAR with mode toggle
├─────────────────────────────────────┤
│                                     │
│                                     │
│              🎤                     │  ← Large microphone button
│                                     │     (96px diameter)
│        Tap and speak freely.        │
│        I'll sort it out.            │
│                                     │
│                                     │
│  ───────────────────────────────    │
│                                     │
│  RECENT CAPTURES                    │  ← Recent captures list
│                                     │
│  ✅ Feed logged · Evander · 10:30  │
│  📅 Event · Handover · Tomorrow    │
│  📝 Note · "Research paediatric..." │
│                                     │
└─────────────────────────────────────┘
```

### 5.2 Voice Capture Flow

| Step | What Happens | Visual |
|------|--------------|--------|
| **1. Idle** | Beth sees the microphone screen. | 🎤 "Tap and speak freely." |
| **2. Listening** | Beth taps the mic. The app starts listening. | 🎙️ Pulse animation around the mic. "Listening..." |
| **3. Speaking** | Beth speaks freely. She can ramble. She can switch topics mid-sentence. She doesn't need to structure anything. | 🎙️ Waveform or level indicator showing audio input. |
| **4. Silence / Tap** | Beth stops speaking. After 2 seconds of silence, or if she taps the mic again, recording stops. | Mic returns to 🎤. |
| **5. Processing** | The audio is sent to Rhen for transcription and classification. | A subtle spinner or progress bar. "Rhen is sorting this..." |
| **6. Result** | Rhen returns structured output. Beth sees what was captured and where it's going. | Result card(s) appear. |

### 5.3 Result Display

After processing, Rhen returns a structured result. It may contain multiple items (Beth rambled about several things).

```
┌─────────────────────────────────────┐
│  ← Notes                            │
├─────────────────────────────────────┤
│                                     │
│  Here's what I caught:              │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ✅ Feed logged              │   │
│  │ Evander · 10:30am           │   │
│  │ Routed to: Family Hub       │   │
│  │ [Undo]                      │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📅 Event created            │   │
│  │ Evander paediatric checkup  │   │
│  │ Tuesday · Need time?        │   │
│  │ Routed to: Calendar         │   │
│  │ [Confirm] [Edit] [Cancel]   │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 📝 Note saved               │   │
│  │ "Feeling tired today, just  │   │
│  │  a lot on my mind."         │   │
│  │ Routed to: Rae (Debrief)    │   │
│  │ [Edit] [Delete]             │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ⚠ CLARIFICATION NEEDED     │   │
│  │ "Book something for next    │   │
│  │  Tuesday"                   │   │
│  │ What kind of event?         │   │
│  │ [__________] [Submit]       │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Done]                             │
│                                     │
└─────────────────────────────────────┘
```

### 5.4 Result Types

| Classification | Destination | Auto-Action | Requires Confirmation? |
|----------------|-------------|------------------------|------------------------|
| **Feed** | Family Hub → Child | Auto-logged with timestamp | No (30-sec undo) |
| **Medication** | Family Hub → Medication Tracker | Auto-logged with timestamp + "last given" updated | No (30-sec undo) |
| **Nap** | Family Hub → Child | Auto-logged with timestamp | No (30-sec undo) |
| **Nappy** | Family Hub → Child | Auto-logged with timestamp | No (30-sec undo) |
| **Task** | Tasks module | Created as Not Urgent. Title extracted. | Yes (confirm or edit) |
| **Event / Schedule** | Calendar | Created with extracted date/time. If incomplete → Clarification Card. | Yes (confirm or edit) |
| **Budget** | Budget module | Logged as expense or note. | Yes (confirm or edit) |
| **Health** | Health Status | Logged as symptom or note. | Yes (confirm or edit) |
| **Note / General** | Notes archive | Saved as general note. Rhen may suggest a category. | No (can recategorise later) |
| **Debrief / Emotional** | Rae (confidential) | Routed to Rae's conversation store. Flagged as confidential. | No |
| **Dream / Goal** | Sable (Dream Architect) | Routed to Sable's conversation store and Dream Board. | No |

### 5.5 Clarification Card

When Rhen is unsure about classification or missing required information, the Clarification Card appears. It does NOT replace the original input. It threads below it.

```
┌─────────────────────────────────────┐
│  ⚠ NEEDS MORE DETAILS              │
│                                     │
│  You said: "Book something for      │
│  next Tuesday."                     │
│                                     │
│  I need to know:                    │
│  What kind of event is this?        │
│                                     │
│  [______________________________]   │
│                                     │
│  [Submit]                           │
│                                     │
│  ─────────────────────────────      │
│  💡 Examples:                       │
│  "Evander's paediatric checkup"     │
│  "Team meeting"                     │
│  "Dinner with Ant"                  │
└─────────────────────────────────────┘
```

**Clarification Card rules:**
- Amber background (#4a3a20). White text. ⚠ icon.
- Asks ONE specific question. Never multiple questions at once.
- Provides examples of what to say (helps with decision fatigue).
- After Beth submits the clarification, the result updates and the card collapses to: "✓ Clarified: 'Evander paediatric checkup'" — greyed out, checkmark.
- If Beth ignores the card, the incomplete item is stored in a "Pending" state and appears in the Notes daily timeline as "⚠ Incomplete — tap to clarify."

---

## 6. TEXT / QUICK LOG MODE

### 6.1 Layout

```
┌─────────────────────────────────────┐
│  ← Notes                  [Text ●]  │  ← TOP BAR with mode toggle
├─────────────────────────────────────┤
│                                     │
│  Type a note or use quick log...    │
│  ┌─────────────────────────────┐   │
│  │                             │   │
│  │  (text input area)          │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│  [Save Note]                        │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  QUICK LOG                          │  ← Context-sensitive buttons
│                                     │
│  ┌─────────┐ ┌─────────┐ ┌───────┐ │
│  │  🍼     │ │  💊     │ │  😴   │ │
│  │  Feed   │ │  Meds   │ │  Nap   │ │
│  └─────────┘ └─────────┘ └───────┘ │
│  ┌─────────┐ ┌─────────┐ ┌───────┐ │
│  │  🧷     │ │  🛁     │ │  🏃   │ │
│  │  Nappy  │ │  Bath   │ │  Tummy │ │
│  └─────────┘ └─────────┘ └───────┘ │
│  ┌─────────┐ ┌─────────┐ ┌───────┐ │
│  │  ✅     │ │  📝     │ │  📅   │ │
│  │  Task   │ │  Note   │ │  Event │ │
│  └─────────┘ └─────────┘ └───────┘ │
│                                     │
│  RECENT CAPTURES                    │
│  (same as voice mode)               │
│                                     │
└─────────────────────────────────────┘
```

### 6.2 Text Input

- Free text field. No character limit.
- Tapping "Save Note" sends the text to Rhen for classification (same pipeline as voice).
- If Beth doesn't classify it, Rhen will. If Rhen is unsure, the Clarification Card appears.
- Text can also be edited after classification.

### 6.3 Quick Log Buttons — Context-Sensitive

The quick-log buttons change depending on context. When Beth opens Notes from the bottom nav, the buttons default to a general set. When Notes is opened from Family Hub (with a child pre-selected), the buttons adapt.

#### Default Quick Log (No Context)

| Row | Buttons |
|-----|---------|
| Row 1 | ✅ Task | 📝 Note | 📅 Event |
| Row 2 | 💊 Meds (personal) | 🩺 Symptom | 🧠 Worry |
| Row 3 | 💰 Expense | 🌙 Dream | 📋 General |

#### Baby Context (e.g., opened from Evander's profile)

| Row | Buttons |
|-----|---------|
| Row 1 | 🍼 Feed | 💊 Meds | 😴 Nap |
| Row 2 | 🧷 Nappy | 🛁 Bath | 🏃 Tummy Time |
| Row 3 | 📝 Note | 📅 Event | ... More |

#### Child Context (e.g., opened from Theodore's profile)

| Row | Buttons |
|-----|---------|
| Row 1 | ✅ Chore | 📅 School Event | 💊 Meds |
| Row 2 | 💬 Check-in | 📝 Note | 🏫 Homework |
| Row 3 | ... More | | |

#### Teen Context (e.g., opened from Annabella's profile)

| Row | Buttons |
|-----|---------|
| Row 1 | 📅 Event | 💊 Meds | 💬 Check-in |
| Row 2 | ✅ Chore | 📝 Note | 🏫 School |
| Row 3 | ... More | | |

**Button behaviour:**
- Each button is large (minimum 96×96dp). Tappable with one hand. ADHD-friendly.
- Tapping a button opens a minimal confirmation screen with auto-timestamp.
- Confirmation screens are NOT modal dialogs. They are small overlays that don't block further action.
- After confirmation: toast notification appears ("Feed logged"). Item appears in Recent Captures. 30-second undo available.

### 6.4 Quick Log Confirmation Screens

#### Feed

```
┌─────────────────────────────────────┐
│  Log feed for Evander?              │
│                                     │
│  🍼 Feed                           │
│  🕐 10:30 AM (auto)                │
│                                     │
│  Amount: [____] ml (optional)       │
│                                     │
│  [Cancel]              [Log Feed]   │
└─────────────────────────────────────┘
```

#### Medication

```
┌─────────────────────────────────────┐
│  Log medication for Evander         │
│                                     │
│  Select medication:                 │
│  ○ Paracetamol (2.5ml)             │
│  ○ Ibuprofen (2.5ml)               │
│  ○ Antihistamine (2ml)             │
│                                     │
│  🕐 10:33 AM (auto)                │
│                                     │
│  [Cancel]            [Log Dose]     │
└─────────────────────────────────────┘
```

If the minimum interval hasn't passed, a warning appears: "⚠ Paracetamol not available until 2:33pm. Log anyway?"

#### Task

```
┌─────────────────────────────────────┐
│  Add a task                         │
│                                     │
│  Title: [_____________________]     │
│                                     │
│  Deadline: [Optional ▼]            │
│  Today / Tomorrow / This week /     │
│  Custom date                        │
│                                     │
│  Priority: ○ Urgent  ● Not urgent  │
│                                     │
│  [Cancel]            [Save Task]    │
└─────────────────────────────────────┘
```

#### Event

```
┌─────────────────────────────────────┐
│  Add an event                       │
│                                     │
│  Title: [_____________________]     │
│                                     │
│  Date: [Today ▼]                   │
│  Time: [10:40 AM]                  │
│                                     │
│  Category: [None ▼]                │
│                                     │
│  [Cancel]          [Save Event]     │
└─────────────────────────────────────┘
```

---

## 7. ERROR STATES

All error states appear as coloured cards below the input area. They do not block further input. Beth can retry immediately.

| Condition | Message | Visual |
|-----------|---------|--------|
| **Empty voice input** | "No speech detected. Try again or type below." | Amber card (#4a3a20), ⚠ icon, white text |
| **Empty text input** | "Type something or use the microphone." | Amber card |
| **Network error (POST fails)** | "Couldn't reach the server. Check your connection." | Red card (#4a2020), white text, persistent until dismissed |
| **Pipeline rejection (HTTP 400)** | "Couldn't process that. Try rewording?" | Amber card |
| **Timeout (no response)** | "Taking longer than expected. Still trying..." | Amber card, auto-dismisses when response arrives |

---

## 8. DAILY TIMELINE (Phase 1D)

A scrollable history of every capture from today, displayed in Notes below the capture area.

```
┌─────────────────────────────────────┐
│  ─── TODAY — Thursday 12th June ───│
│                                     │
│  10:33 AM                          │
│  ✅ Feed logged · Evander          │
│  🍼 180ml                          │
│  [Undo]                            │
│  ─────────────────────────────      │
│                                     │
│  10:30 AM                          │
│  💊 Paracetamol given · Evander   │
│  2.5ml · Next available: 2:30 PM  │
│  [Undo]                            │
│  ─────────────────────────────      │
│                                     │
│  9:15 AM                           │
│  📝 Note saved                     │
│  "Feeling tired today, just a lot  │
│   on my mind."                     │
│  Routed to: Rae                    │
│  [Edit] [Delete]                   │
│  ─────────────────────────────      │
│                                     │
│  8:45 AM                           │
│  📅 Event created                  │
│  Handover · 9:00 AM · Work        │
│  [View in Calendar]               │
│  ─────────────────────────────      │
│                                     │
│  8:30 AM                           │
│  ⚠ Incomplete — tap to clarify    │
│  "Book something for Tuesday"      │
│  [Clarify]                         │
│  ─────────────────────────────      │
│                                     │
│  [View all captures]               │
│                                     │
└─────────────────────────────────────┘
```

**Daily Timeline features:**
- Chronological. Most recent at the top.
- Each capture shows: time, type, summary, destination.
- 30-second undo on auto-logged items (Feed, Medication, Nap, Nappy).
- Edit/Delete on manual items (Notes, Tasks, Events).
- Incomplete items (from Clarification Cards not yet resolved) show at the top with ⚠.
- "View all captures" opens a full-screen searchable, filterable history.

---

## 9. AUTO-CATEGORISED FOLDERS (Phase 1D)

All captures are automatically sorted into folders based on Rhen's classification. Beth can also manually recategorise.

The folders are accessible from a dropdown or tab at the top of the Notes screen.

| Folder | What Goes Here |
|--------|----------------|
| **📅 Scheduling** | Calendar events, appointments, reminders |
| **🛒 Shopping** | Grocery items, supplies, shopping lists |
| **✅ Tasks** | Tasks, to-dos, chores |
| **🩺 Health** | Symptoms, medications (personal), health notes |
| **👨‍👩‍👦 Family** | Feeds, naps, nappies, child medications, check-ins |
| **💰 Budget** | Expenses, income, savings notes, bill reminders |
| **💡 Ideas** | Brainstorms, creative thoughts, dreams, goals |
| **💬 Correspondence** | Draft messages, emails to send, call reminders |
| **📋 Random / Unsorted** | Everything that doesn't fit elsewhere. Rhen's default if unsure. |

**Folder behaviour:**
- Folders are auto-populated by Rhen's classification.
- Beth can move any item to any folder manually.
- Folders are searchable.
- "All" view shows everything chronologically across all folders (the Daily Timeline).

---

## 10. MESSY ORIGINAL + CLEANED RESULT PRESERVATION

When Rhen processes a capture, both versions are preserved:

| Version | What It Is | Where It's Visible |
|---------|------------|---------------------|
| **Messy Original** | Beth's raw input. The exact text or transcript. Rambling, unstructured, real. | Visible in the Daily Timeline. Tappable to expand. |
| **Cleaned Result** | Rhen's structured output. The event, task, log, or note that was created. | Visible in the destination module (Calendar, Tasks, Family Hub, etc.) and in the Notes result card. |

**Why both are kept:**
- Context can be lost when AI tidies things up. The messy original preserves Beth's actual words, tone, and intent.
- If the cleaned result is wrong, Beth can compare it to the original and fix it.
- For debrief content (Rae), the messy original IS the content. It shouldn't be cleaned.

**Visual distinction:**
- In the Daily Timeline, the cleaned result is shown first (prominent).
- Below it, in smaller, italic text: "Original: 'I need to... and also... if that makes sense?'"
- Tapping "Original" expands it fully.

---

## 11. PIPELINE INTEGRATION

```
Beth speaks/types → Notes screen → POST /process →
Rhen classifies → Syncline-SL → Syncline-V3 →
Structured log → SQLite → Routed to destination module →
UI updates (confirmation in Notes, data in Calendar/Tasks/Family Hub/etc.)
```

**Every capture goes through the pipeline.** There is no direct-to-module shortcut that bypasses Rhen. This ensures:
- Consistent classification.
- Structured logging for the User Activity Ledger.
- Privacy filtering (D3-D4 content handled correctly).
- The messy original is always preserved alongside the cleaned result.

---

## 12. PRIVACY HANDLING

| Content Type | Sensitivity | Handling |
|--------------|-------------|----------|
| General note, task, event, shopping | D2 | Standard pipeline. Visible in Daily Timeline. Exportable. |
| Health symptom, medication log | D3 | Pipeline processed. Visible in Daily Timeline. Export restricted. Not shared with partner without explicit toggle. |
| Debrief content (routed to Rae) | D3-D4 | Routed directly to Rae's confidential conversation store. NOT visible in Daily Timeline. NOT exportable by default. NOT shared. Marked as confidential. |
| Crisis/safety content | D4 | Routed to Mental Health Toolkit. Flagged. Visible only to Beth. NOT shared. NOT exportable. Strictest handling. |

---

## 13. STATE RESPONSIVENESS

| State | Notes Behaviour |
|-------|-----------------|
| **ADHD Support** | Quick-log buttons more prominent. Voice mode is the default. One-tap logging emphasised. Fewer fields on confirmation screens. |
| **Depression Support** | "Start tiny" prompts. Bare Minimums emphasised in quick-log. Voice mode uses gentler language. |
| **Low-Stimulation** | Simplified interface. Fewer quick-log buttons visible. Text mode default (quieter). |
| **Overwhelmed (Current State)** | Only urgent capture buttons visible (Meds, Task, Note). Everything else hidden. Voice mode: "Just say what you need." |
| **Sparkle (Productive)** | Do not disturb. Notes available but no suggestions. No "What would you like to capture?" prompts. Just the tools. |

---

## 14. USER ACTIVITY LEDGER ENTRIES

Every capture generates an entry in the User Activity Ledger (Phase 2A). Examples:

- "Note captured at 10:33am. Classified as 'Feed.' Routed to Family Hub → Evander."
- "Note captured at 10:35am. Classification uncertain. Clarification Card shown."
- "Note captured at 8:30am. Routed to Rae (confidential). Not shared with any other instance."

---

## 15. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1A** (Live) | Voice input (basic), text input, Rhen classification pipeline, clarification card, structured log output. |
| **1B** (Current) | Quick-log buttons (context-sensitive), error states (5 types), 30-second undo, recent captures list, clarification card improvements (threaded, collapsible, one question at a time). |
| **1C** ✅ | Shared STT service wired to /process. Continuous listen mode. Optional TTS confirmation when accessibility TTS is on. Wake word deferred to 2A. |
| **1D** | Daily timeline view. Auto-categorised folders. Messy original + cleaned result preservation. Incomplete item tracking. "View all captures" searchable history. |
| **2A** | User Activity Ledger entries for every capture. Privacy filtering for shared views. |
| **2B** | Full state responsiveness for all 25 Support Presets. Current State integration. |

---

## 16. WHAT NOTES DOES NOT DO

- It does not require Beth to know where something goes. She speaks. Rhen sorts.
- It does not lose the original. The messy version is always kept alongside the cleaned version.
- It does not guess silently. If Rhen is unsure, the Clarification Card asks.
- It does not make things permanent without undo. 30-second window on all auto-logged items.
- It does not share debrief content. Rae's conversations are confidential.
- It does not judge. There is no "wrong" thing to capture. A worry is as valid as a task.

---

That's Notes. The single input point for everything. Voice or text. Rhen classifies. The system routes. The messy original is preserved. The cleaned result is delivered. One entry point, many destinations.
