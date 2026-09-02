# TETHER — MODULE 13: NOTIFICATIONS & STATUS SHIELD
## Complete Design Specification

**Module:** Notifications & Status Shield
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢 (D2; can surface D3 content — handled by privacy rules)
**Phase:** 1B (basic notifications, Status Shield toggle) → 1D (three-tier system, hybrid mode) → 2A (partner notifications, household sharing)
**Status:** ⬜ Not yet built — spec ready

---

## 1. WHAT NOTIFICATIONS & STATUS SHIELD IS

This module controls how Tether communicates with Beth and how Beth communicates her availability to the app and her household. It has two parts:

**Notifications:** How the app tells Beth things. What surfaces, when, and how urgently.

**Status Shield:** How Beth tells the app and her household whether she's available for new input.

Together they answer the questions: *"What needs my attention?"* and *"Am I available for this right now?"*

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Urgent is urgent, everything else can wait** | Medication overdue, appointment in 30 minutes, baby's next feed window opening — these are urgent. A new job listing, a meal suggestion, a weekly budget summary — these can wait for the digest. |
| **Beth controls the threshold** | She sets what's urgent. She sets quiet hours. She sets digest times. The system does not decide for her. |
| **State-responsive, not state-ignorant** | If Beth is Overwhelmed, notifications reduce. If she's on Red, they stop. If she's on Sparkle, they wait. The app respects her state. |
| **One notification, not five** | Related items are batched. "You have 3 events this afternoon" — not three separate pings. |
| **Privacy-aware** | Notifications on the lock screen can be masked. D3-D4 content is never shown in notification previews unless the user explicitly allows it. |

---

## 3. HOW YOU GET HERE

**Notifications:** Accessible from the Dashboard bell icon (🔔). Also from Settings → 🔔 Notifications.
**Status Shield:** Visible on the Dashboard below the Snoozed section. Configurable in Settings → 🛡 Status Shield.

---

## 4. NOTIFICATIONS — THE THREE DELIVERY MODES

### 4.1 Real-Time Mode

```
┌─────────────────────────────────────┐
│  ← Settings    NOTIFICATION SETTINGS│
├─────────────────────────────────────┤
│                                     │
│  DELIVERY MODE                      │
│  ● Real-Time — Send as they happen  │
│  ○ Digest — Batched summaries       │
│  ○ Hybrid — Urgent real-time,       │
│    rest in digest (recommended)     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  In Real-Time mode, all             │
│  notifications are sent as soon     │
│  as they occur.                     │
│                                     │
│  Best for: people who want to       │
│  stay on top of everything as       │
│  it happens.                        │
│                                     │
│  ⚠ May be overwhelming for some    │
│  users. Hybrid mode is              │
│  recommended for most people.       │
│                                     │
└─────────────────────────────────────┘
```

**Real-Time behaviour:** Every notification is pushed immediately. No batching. No digest. Beth sees everything as it happens.

### 4.2 Digest Mode

```
┌─────────────────────────────────────┐
│  DELIVERY MODE                      │
│  ○ Real-Time — Send as they happen  │
│  ● Digest — Batched summaries       │
│  ○ Hybrid — Urgent real-time,       │
│    rest in digest (recommended)     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  DIGEST SETTINGS                    │
│  Morning digest: [07:00 AM]         │
│  ☐ Evening digest: [06:00 PM]       │
│                                     │
│  In Digest mode, non-urgent         │
│  notifications are held and         │
│  delivered as a single summary      │
│  at your chosen times.              │
│                                     │
│  Urgent items still come through    │
│  immediately.                       │
│                                     │
│  Best for: reducing interruptions.  │
│                                     │
└─────────────────────────────────────┘
```

**Digest behaviour:** All non-urgent notifications are held. At the configured digest time(s), a single summary notification is delivered: "Good morning, Beth. You have 4 tasks due today, 2 upcoming appointments, and 1 medication reminder."

### 4.3 Hybrid Mode (Default — Recommended)

```
┌─────────────────────────────────────┐
│  DELIVERY MODE                      │
│  ○ Real-Time — Send as they happen  │
│  ○ Digest — Batched summaries       │
│  ● Hybrid — Urgent real-time,       │
│    rest in digest (recommended)     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  HYBRID SETTINGS                    │
│  Urgent: Real-time                  │
│  Important: Digest unless           │
│    time-bound (within 2 hours)      │
│  For Later: Digest only             │
│                                     │
│  Digest times:                      │
│  [07:00 AM] [06:00 PM]              │
│                                     │
│  Best for: most people. Urgent      │
│  things get through. Everything     │
│  else waits for a sensible time.    │
│                                     │
└─────────────────────────────────────┘
```

**Hybrid behaviour:** This is the default. Urgent items push immediately. Important items are held for the next digest unless they're time-bound within 2 hours. For Later items are digest-only.

---

## 5. URGENCY TIERS — WHAT GOES WHERE

### 5.1 Urgent — Push Immediately

| Source | Trigger |
|--------|---------|
| **Medication** | Dose window opening (scheduled meds). Overdue dose. Dependent medication time-sensitive (Evander's thrush medication). |
| **Calendar** | Event starting within 30 minutes. "Leave by" reminder. Appointment in 1 hour with no prep logged. |
| **Tasks** | Deadline today with Urgent priority. Overdue task. |
| **Family Hub** | Child's medication overdue. Baby's next feed window opening. |
| **Safety** | Crisis plan activation prompt (if user has enabled check-ins). |
| **Budget** | Bill due today. |

### 5.2 Important — Digest Unless Time-Bound

| Source | Trigger |
|--------|---------|
| **Calendar** | Event tomorrow. New event created by partner. Schedule change. |
| **Tasks** | Deadline this week. Task assigned by partner. |
| **Employment (Joss)** | New job listing matching criteria. Application status change. Interview offered (this escalates to Urgent if within 48 hours). |
| **Family Hub** | Child's medication available now (not urgent — informational). Pet care task due. |
| **Budget** | Bill due within 7 days. Subscription renewing in 3 days. Budget category approaching limit. |
| **Team** | Instance has a draft ready (Ellory). Instance has completed a task (Hugh finished research). |

### 5.3 For Later — Digest Only

| Source | Trigger |
|--------|---------|
| **Employment** | Weekly job market roundup. |
| **Meals** | Meal plan generated. "Cook with what you have" suggestion. |
| **Budget** | Weekly summary. Savings goal milestone. Subscription review suggestion. |
| **Health** | "You haven't logged blood pressure in 2 weeks." (if user has enabled reminders). |
| **Team** | System health status (all nominal). |
| **Resources** | New resource added to library. Resource updated. |
| **General** | App update available. Weekly roundup. Affirmation changed. |

---

## 6. NOTIFICATION CONTENT & FORMAT

### 6.1 Context-Rich Snippets

Every notification is specific. No vague "Something needs your attention."

| Vague (Banned) | Specific (Required) |
|----------------|---------------------|
| "You have a new notification." | "Ibuprofen: Available now for Evander." |
| "Task due soon." | "Submit application — Kuranda MC. Due tomorrow 5pm." |
| "Calendar event coming up." | "Handover at Cairns Base Hospital. 9:00 AM. Leave by 8:35." |
| "Budget alert." | "Groceries: $340 of $400 spent. 5 days remaining." |

### 6.2 Voice-Friendly Format

All notifications are formatted to be readable by screen readers and voice assistants. Critical information is front-loaded.

| Text Notification | Voice-Friendly Version |
|-------------------|------------------------|
| "Ibuprofen — Available now for Evander. Last given 8:15am. Next available 2:15pm." | "Ibuprofen available now for Evander. Last dose was at 8:15am." |
| "Handover at Cairns Base Hospital. 9:00 AM. Leave by 8:35." | "Handover at 9am. Leave by 8:35am." |

**Voice format rules:**
- Critical info in first 5-7 words.
- No markdown. No emoji in voice readout (visual notification can still have emoji).
- Natural sentence structure.
- Time in spoken format: "9am" not "09:00."

---

## 7. QUIET HOURS

```
┌─────────────────────────────────────┐
│  QUIET HOURS                        │
│  ☑ Enabled                         │
│  Start: [09:00 PM]                 │
│  End:   [07:00 AM]                 │
│                                     │
│  During quiet hours:                │
│  ☑ Allow urgent notifications      │
│  ☐ Allow important if time-bound   │
│  ☐ Allow all                        │
│                                     │
│  ☐ Different hours for weekends    │
│                                     │
└─────────────────────────────────────┘
```

**Quiet hours behaviour:**
- Non-urgent notifications are silenced during quiet hours.
- Urgent notifications can bypass quiet hours (configurable).
- If Beth is on shift overnight, quiet hours can be temporarily disabled or have different settings for work nights.

---

## 8. NOTIFICATION CHANNELS & TYPES

Users can toggle entire categories of notifications on or off.

```
┌─────────────────────────────────────┐
│  NOTIFICATION TYPES                 │
│                                     │
│  ☑ Calendar reminders              │
│  ☑ Task deadlines                  │
│  ☑ Medication reminders            │
│  ☑ Family updates                  │
│  ☑ Budget alerts                   │
│  ☐ Meal suggestions                │
│  ☐ Resource updates                │
│  ☐ Team activity                   │
│  ☑ Partner activity                │
│  ☐ Employment updates              │
│  ☐ Health reminders                │
│  ☐ App tips & suggestions          │
│                                     │
└─────────────────────────────────────┘
```

---

## 9. PARTNER & HOUSEHOLD NOTIFICATIONS (Phase 2A)

When Connectable Accounts are active, notifications can be shared with household members.

| Notification | Shared with Ant? |
|--------------|------------------|
| Evander's medication overdue | Yes (default) |
| Evander's medication available | Yes (default) |
| Shared task completed | Yes (default) |
| Shared calendar event coming up | Yes (default) |
| Beth's personal medication reminder | No |
| Beth's debrief session with Rae | Never |
| Budget category shared with Ant | Yes (per category) |

**Partner notification rules:**
- Beth controls what Ant receives.
- Ant can opt out of specific notification types.
- D3-D4 content is never shared via partner notifications.
- "Ant logged a $45 expense to Groceries" — informational, not urgent.

---

## 10. STATUS SHIELD

### 10.1 What Status Shield Is

The Status Shield is Beth's availability indicator. It tells the app and her household: *"Am I open to new input right now?"*

It is separate from the Colour Card (which communicates mood and approach) and the Current State (which is a temporary override for acute situations). The Status Shield is specifically about availability for tasks, leads, and notifications.

### 10.2 The Two States

| State | Display | Meaning |
|-------|---------|---------|
| **Open to leads** | 🛡 Open to leads · Green left border | Beth is available for new tasks, job listings, suggestions, and normal notification delivery. |
| **Heads Down** | 🛡 Heads Down · Amber left border · "Until [time]" | Beth is not available for new input. Non-urgent notifications are held. No proactive suggestions. Urgent items still come through. |

### 10.3 Dashboard Display

```
┌─────────────────────────────────────┐
│  🛡 Open to leads                   │
│  Auto-expires: Rest of day          │
└─────────────────────────────────────┘
```

Or when Heads Down:

```
┌─────────────────────────────────────┐
│  🛡 Heads Down · Until 3:00 PM      │
│  Non-urgent notifications held.     │
│  Urgent items will still come       │
│  through.                           │
│  [Extend] [Deactivate]             │
└─────────────────────────────────────┘
```

### 10.4 Status Shield Settings

```
┌─────────────────────────────────────┐
│  ← Settings     🛡 STATUS SHIELD    │
├─────────────────────────────────────┤
│                                     │
│  Status Shield lets your team       │
│  and household know if you're       │
│  open to new input.                 │
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
│  ☑ Overwhelmed → Heads Down       │
│  ☑ Low Energy → Heads Down         │
│  ☑ Migraine → Heads Down           │
│  ☑ Sparkle → Heads Down            │
│  ☑ Post-Seizure → Heads Down       │
│                                     │
│  COLOUR CARD INTEGRATION            │
│  ☑ Red → Heads Down                │
│  ☑ Black → Heads Down              │
│  ☑ Orange → Heads Down (optional)  │
│                                     │
│  SHARING                            │
│  ☑ Visible to household            │
│  ☑ Visible to AI instances         │
│                                     │
└─────────────────────────────────────┘
```

### 10.5 What Heads Down Does

When Status Shield is set to Heads Down:

| System | Behaviour |
|--------|-----------|
| **Notifications** | Non-urgent held. Important held unless time-bound within 2 hours. Urgent still delivered. |
| **Dashboard** | Simplified. Fewer quick-glance cards. No proactive suggestions. |
| **Team Instances** | Instances do not initiate contact. No proactive check-ins from Viva. No suggestions from any instance. Direct questions are still answered. |
| **Employment (Joss)** | New job listings held. Application updates held unless urgent (interview in 48 hours). |
| **Budget (Tim)** | No proactive insights. No subscription review suggestions. |
| **Tasks** | No new task suggestions. Bare Minimums visible. |
| **Meals** | No "What's for dinner?" prompts. |
| **Partner** | Ant sees Beth is Heads Down. He can still send urgent items. |

---

## 11. NOTIFICATION INTERACTIONS WITH SUPPORT PRESETS & CURRENT STATE

| State | Notification Behaviour |
|-------|------------------------|
| **ADHD Support** | Digest mode is the default (not opt-in). Morning digest at 7am. Snooze is prominent. |
| **Depression Support** | Non-urgent reduced. No productivity-pressure notifications. |
| **Anxiety Support** | Ambiguous notifications banned. Every notification says exactly what it is. "Something needs your attention" is blocked. |
| **PTSD Support** | Surprise notifications reduced. Tomorrow's schedule previewed the night before (not a notification — a gentle dashboard card). |
| **Low-Stimulation** | Notifications reduced to urgent only. No sound. No vibration. |
| **Overwhelmed (Current State)** | Non-urgent held. Important held unless time-bound. Urgent only. |
| **Panicking (Current State)** | All notifications suppressed except safety-critical. |
| **Migraine (Current State)** | All notifications suppressed. |
| **Sparkle (Current State)** | All notifications suppressed. "Let them cook." |
| **Red (Colour Card)** | Notifications suppressed entirely except crisis/safety and critical medication. |
| **Black (Colour Card)** | All non-critical notifications suppressed. |

---

## 12. SNOOZE BEHAVIOUR

Notifications can be snoozed. Snoozed items reappear at the snooze expiry.

| Snooze Option | Duration |
|---------------|----------|
| Remind tonight | 6:00 PM |
| Remind tomorrow | 8:00 AM |
| Remind this weekend | Saturday 9:00 AM |
| Custom | User-selected date and time |

Snoozed items appear in the Dashboard Snoozed section. They do not generate notifications until they return from snooze.

---

## 13. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1B** (Current) | Status Shield toggle (Open to leads / Heads Down). Auto-expiry (rest of day). Basic notification display on Dashboard (urgent section, snoozed section). Notification bell with badge count. |
| **1D** | Three delivery modes (Real-Time, Digest, Hybrid). Hybrid as default. Urgency tiers (Urgent, Important, For Later). Context-rich snippets. Voice-friendly format. Quiet hours. Snooze presets. Status Shield auto-integration with Current State and Colour Card. |
| **2A** | Partner notifications. Household sharing. Notification channels toggle. Lock screen privacy settings. Voice commands for Status Shield. |
| **2B** | Full state responsiveness for all 25 Support Presets. Advanced notification batching. "You have 3 events this afternoon" — grouped notifications. |

---

## 14. WHAT NOTIFICATIONS & STATUS SHIELD DOES NOT DO

- It does not send vague notifications. Every notification is specific.
- It does not override Beth's state. If she's on Red, it respects Red.
- It does not share D3-D4 content in notification previews unless explicitly allowed.
- It does not notify about everything. "For Later" items wait for the digest. Some things don't notify at all (general system health, resource updates unless opted in).
- It does not force Real-Time mode. Hybrid is the default. Beth chooses.
- It does not make Status Shield and Colour Card the same thing. They serve different purposes. One is about availability. One is about mood and approach.

---

That's Notifications & Status Shield. Three delivery modes. Three urgency tiers. Quiet hours. Snooze. Status Shield with auto-expiry. State-responsive. Partner-aware. Privacy-respecting.
