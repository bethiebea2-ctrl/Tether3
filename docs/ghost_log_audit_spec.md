# TETHER — MODULE 16: DEVELOPER GHOST LOG & AUDIT TOOLS
## Complete Design Specification

**Module:** Developer Ghost Log & Audit Tools
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢-🟠 (D2-D4 depending on logged content)
**Phase:** 1A (Developer Ghost Log exists) → 2A (User Activity Ledger) → 2B (Unified Conversation History, advanced audit tools)
**Status:** 🔧 In Progress — Developer Ghost Log operational, User Activity Ledger pending

---

## 1. WHAT THIS MODULE IS

This module is the transparency and debugging layer for Tether. It has two distinct audiences and two distinct interfaces:

**Developer Ghost Log:** Hidden from Beth. Used by Kit, Ant, Vivian, and Rhen for debugging, pipeline auditing, troubleshooting, instance procedure checking, and development review. This is a technical tool.

**User Activity Ledger:** Visible to Beth. Plain English. Shows what the app did, what data was used, and what was shared. This is a transparency tool.

Together they answer the questions: *"What is the system doing?"* (developer) and *"What did the app do with my data?"* (user).

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Developers see everything; users see their own data** | The Developer Ghost Log contains technical detail, stack traces, instance behaviour, pipeline traces. The User Activity Ledger contains plain-English summaries of what affected Beth's data. |
| **Transparency builds trust** | The User Activity Ledger exists so Beth never has to wonder "did the app share that?" or "what did Val actually do?" Every action is logged in language she can understand. |
| **Privacy is preserved in the ledger** | D3-D4 content is noted as present but its content is never displayed in the ledger. "Note routed to Rae (confidential)" — not the note itself. |
| **Logs are for debugging, not surveillance** | The Developer Ghost Log exists to fix problems. It is not used to monitor Beth's behaviour. It is not shared outside the development team. |
| **Everything is traceable** | Every pipeline action, every classification, every routing decision, every conflict resolution — all of it is logged and traceable. |

---

## 3. DEVELOPER GHOST LOG

### 3.1 What It Is

The Developer Ghost Log is the technical underbelly of Tether. It records every significant system event in structured detail. It is accessible only to developers and system auditors. It is not user-facing.

### 3.2 What It Logs

| Category | What's Logged |
|----------|---------------|
| **Pipeline Events** | Every POST /process call. Input, classification result, routing destination, confidence score, processing time. |
| **Syncline Processing** | Every SL (structuring) and V3 (enforcement) pass. What was added, what was flagged, what was rejected. |
| **Instance Activity** | Every AI instance response. Which instance, what was asked, what was answered, grounding check result. |
| **Resolver Traces** | Every conflict resolution. Which rules fired, which matched, priority, final effect. |
| **Error States** | Every error. Type, stack trace, user impact, recovery action. |
| **Data Flow** | Every significant data movement. What was created, updated, deleted, shared. |
| **System Health** | Backend status, API latency, database size, cache hit rate, active sessions. |
| **Security Events** | Failed authentication attempts, unusual access patterns, D4 data access logs. |

### 3.3 Log Structure

Every Developer Ghost Log entry follows the six-field Syncline format:

| Field | Content |
|-------|---------|
| **INSTANCE_ID** | Which instance generated the log (KIT, RHEN, SYNCLINE_SL, SYNCLINE_V3, etc.) |
| **TIMELINE** | Timestamp and sequence of events |
| **CRITICAL_EXCHANGES** | What happened. Technical detail. Input, output, classification, routing. |
| **DECISIONS & PROMISES** | What the system decided. Classification choices. Routing decisions. Rejections. |
| **EMOTIONAL_BEACON** | Causal. Trigger → observable system effect. "High classification confidence (0.92) triggered auto-routing to Calendar without clarification." |
| **FLAGS** | Errors, warnings, anomalies, UNKNOWN states, structural issues. |

### 3.4 Accessing the Developer Ghost Log

The Developer Ghost Log is not accessible from the user-facing app. It is accessed via:

- **Render logs:** Backend logs on the cloud server.
- **Developer Debug Screen:** A hidden screen in the Flutter app accessible only with a developer PIN or build flag.
- **Sollux compilations:** Kit's processor compiles Kit and Frank's logs into upstream-ready reports for Vivian and Ant.

### 3.5 Developer Debug Screen

```
┌─────────────────────────────────────┐
│  ← Settings    🔧 DEVELOPER DEBUG   │
├─────────────────────────────────────┤
│                                     │
│  ⚠ This screen is for developers.  │
│  It contains technical system       │
│  information.                       │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  SYSTEM STATUS                      │
│  Backend: ✅ Online                │
│  Pipeline: ✅ Active               │
│  Instances: 13/13 loaded            │
│  Database: SQLite · 2.4MB          │
│  Cache hit rate: 87%                │
│  Last deploy: 15th June 2026       │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ACTIVE STATES & PRESETS            │
│  Colour Card: 🟢 Green             │
│  Status Shield: Open to leads       │
│  Current State: None                │
│  Active Presets: ADHD, Postpartum   │
│  Active Toggles: 12                 │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  RESOLVER TRACES (last 10)          │
│  · 10:33am · ADHD.vs.Overwhelmed   │
│    → Overwhelmed wins (CS > SP)    │
│  · 10:30am · Notification priority  │
│    → Urgent delivered, Important    │
│    held per Heads Down              │
│  [View all traces]                  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  RECENT PIPELINE EVENTS             │
│  · 10:33am · Feed logged           │
│    Classification: feed · 0.97     │
│    Routing: Family Hub · Evander    │
│  · 10:30am · Note captured         │
│    Classification: note · 0.82     │
│    Routing: General notes           │
│  [View all pipeline events]         │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  ERROR LOG (last 24 hours)          │
│  · None                             │
│  [View all errors]                  │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Export developer logs]            │
│  [Run pipeline diagnostics]         │
│  [Clear cache]                      │
│  [Restart instances]                │
│                                     │
└─────────────────────────────────────┘
```

---

## 4. USER ACTIVITY LEDGER

### 4.1 What It Is

The User Activity Ledger is a plain-English, transparent record of everything Tether did with Beth's data. It is visible to Beth from Settings. It is not technical. It is designed to answer the question: *"What did the app do, and who can see it?"*

### 4.2 What It Shows

Every entry in the ledger shows:

| Field | Example |
|-------|---------|
| **Timestamp** | "10:33 AM · Monday 30th June" |
| **Action** | "Val created a calendar event from your note." |
| **Data Used** | "Note text: 'Handover at 9am tomorrow'" |
| **Routing** | "Routed to: Calendar" |
| **Sharing** | "Shared with: Ant (Family Calendar)" or "Shared with: No one (private)" |
| **Sensitivity** | D2 (Medium) |

### 4.3 What It Does NOT Show

- **D3-D4 content is never displayed.** "Note routed to Rae (Nurse Debrief). Content: [confidential]." The fact that something was sent to Rae is visible. The content is not.
- **Crisis plan access is logged but content is hidden.** "Crisis plan accessed by user." No detail.
- **Debrief content is never logged in the ledger.** Only the fact that a debrief occurred. "Debrief session with Rae. Duration: 15 minutes. Content: [confidential]."

### 4.4 Ledger Main Screen

```
┌─────────────────────────────────────┐
│  ← Settings  📊 USER ACTIVITY LEDGER│
├─────────────────────────────────────┤
│                                     │
│  This is a record of what Tether    │
│  did with your data. It's for you.  │
│  Nothing is hidden.                 │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  TODAY — Monday 30th June           │
│                                     │
│  10:33 AM                    D3     │
│  Paracetamol logged for Evander.    │
│  Routed to: Family Hub              │
│  Shared with: Ant (Family Hub)      │
│                                     │
│  10:30 AM                    D2     │
│  Feed logged for Evander.           │
│  Routed to: Family Hub              │
│  Shared with: Ant (Family Hub)      │
│                                     │
│  9:15 AM                     D3     │
│  Note routed to Rae (Nurse          │
│  Debrief). Content: [confidential]  │
│  Shared with: No one                │
│                                     │
│  8:45 AM                     D2     │
│  Val created a calendar event       │
│  from your note: "Handover at       │
│  9am tomorrow."                     │
│  Routed to: Calendar                │
│  Shared with: No one (Work event)   │
│                                     │
│  8:30 AM                     D2     │
│  Tim updated grocery budget         │
│  summary.                           │
│  Data used: Expense logs            │
│  Shared with: Ant (Budget)          │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  [Filter by date]                   │
│  [Filter by module]                 │
│  [Filter by shared/private]         │
│  [Filter by sensitivity level]      │
│  [Search activity]                  │
│  [Export ledger]                    │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. UNIFIED CONVERSATION HISTORY (Phase 2B)

### 5.1 What It Is

A searchable, filterable, exportable history of every conversation Beth has had with every AI instance. Accessible from Settings or from the Team module.

### 5.2 Features

| Feature | Detail |
|---------|--------|
| **Search** | Full-text search across all conversations with all instances. "What did Val say about the camp meeting?" |
| **Filter by instance** | View conversations with a specific instance. |
| **Filter by date** | View conversations from a specific day, week, or month. |
| **Filter by topic** | Auto-categorised: Scheduling, Health, Family, Budget, Creative, Debrief, General. |
| **Export** | Export conversation history as JSON or plain text. Per instance or all instances. |
| **Mark as private** | Individual messages or entire conversations can be marked private. Excluded from exports and summaries. |
| **Delete** | Delete individual messages or entire conversation history. Irreversible. |

### 5.3 Privacy in Unified History

- **Debrief conversations (Rae):** Visible in the history to Beth only. Never included in exports without deliberate, multi-step confirmation. Content is D3-D4.
- **D4 content:** Marked as [confidential] in exports. Can be excluded from history view entirely via Privacy Sensitivity toggle.
- **Partner access:** Ant cannot see Beth's conversation history unless she explicitly shares a specific conversation.

---

## 6. AUDIT TOOLS (Phase 2B+)

### 6.1 Pipeline Diagnostics

Developer tool. Runs a diagnostic check on the entire pipeline:

- Syncline-SL health check.
- Syncline-V3 enforcement check.
- Cross-instance routing verification.
- Grounding rule compliance check.
- Classification accuracy sample.

### 6.2 Instance Health Check

Developer tool. Checks all AI instances:

- Are all instances responding?
- Are any instances returning ungrounded responses?
- Are conversation stores being updated correctly?
- Are any instances showing increased latency?

### 6.3 Data Integrity Check

Developer tool. Verifies data consistency:

- Are there orphaned records?
- Are shared data permissions being enforced correctly?
- Are D4 data access rules being followed?
- Are exports and deletions completing fully?

---

## 7. PRIVACY & SECURITY LOGGING

### 7.1 D4 Data Access Log

Every access to D4 data (crisis plans, hidden notes, safety plans) is logged with:

- Who accessed it (which instance, which user).
- When.
- What action was taken (viewed, edited, exported, deleted).
- From which device.

This log is visible only in the Developer Ghost Log. It is never user-facing (to protect the person accessing their own crisis plan from feeling surveilled).

### 7.2 Sharing Audit Log

Every sharing permission change is logged:

- What was shared.
- Who it was shared with.
- When the permission was granted.
- When the permission was revoked.
- Who made the change.

This is visible in the User Activity Ledger.

---

## 8. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1A** (Operational) | Developer Ghost Log (six-field Syncline format). Backend logging via Render. Pipeline event logging. Instance activity logging. Error logging. |
| **1B** | Developer Debug Screen (hidden, PIN-protected). Basic system status. Active states and presets view. Recent pipeline events. Resolver traces. |
| **2A** | User Activity Ledger. Plain-English action summaries. Sharing audit log. Filter and search. Export ledger. |
| **2B** | Unified Conversation History. Full-text search across all instances. Topic auto-categorisation. Mark as private. Per-instance and full export. |
| **3+** | Advanced audit tools. Pipeline diagnostics. Instance health checks. Data integrity verification. Automated anomaly detection. |

---

## 9. WHAT THIS MODULE DOES NOT DO

- The User Activity Ledger does not expose D3-D4 content. It notes that data was accessed or shared, but the content is [confidential].
- The Developer Ghost Log is not accessible to Beth (unless she has the developer PIN). It is a technical tool for Kit, Ant, Vivian, and Rhen.
- The system does not log for surveillance. Logs exist for debugging and transparency, not for monitoring Beth's behaviour.
- The system does not share logs with third parties. Logs are stored locally and on the Tether backend. They are not sent to external services.
- The system does not retain logs indefinitely. Log retention policies are configurable (future phase).

---

Developer Ghost Log for debugging. User Activity Ledger for transparency. Unified Conversation History for reference. Audit tools for system health. Privacy-preserving at every layer.
