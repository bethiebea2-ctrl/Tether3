# TETHER — MODULE 15: COMPANION MODE
## Complete Design Specification

**Module:** Companion Mode
**Version:** v1.0 — Route Map Aligned
**Risk:** 🟢 (D2; D3 when health/debrief data is accessed via companion)
**Phase:** 1C (basic companion toggle, voice-first interface, avatar) → 2A (ambient presence, interactive life system, full data access) → 3 (driving mode integration, wake word, advanced avatar)
**Status:** ✅ Phase 1C Basic complete — Dashboard toggle, Viva avatar chat, STT/TTS, calendar+tasks context. Ambient / wake word / full-domain tools deferred to 2A

---

## 1. WHAT COMPANION MODE IS

Companion Mode is an alternative interface for Tether. Instead of the structured Dashboard — with its cards, lists, and modules — Companion Mode presents a single AI instance as an animated, conversational presence. The companion has access to all of Beth's data (permissioned) and can answer questions, offer support, and just be present.

It answers the question: *"I don't want to navigate. I just want to talk to someone who knows me."*

Companion Mode is not a separate app. It is a toggle. Dashboard Mode ↔ Companion Mode. Both are Tether. Both access the same data. The difference is how Beth interacts with it.

---

## 2. CORE PRINCIPLES

| Principle | What It Means |
|-----------|---------------|
| **Conversation, not navigation** | Beth speaks or types. The companion responds. No menus. No tabs. No cards. Just presence. |
| **The companion knows Beth's life** | Calendar, tasks, family, health, budget — the companion has access to all of it (within Beth's permission settings). "What's Evander's next feed window?" "Do I have any interviews this week?" "How are we tracking on groceries?" |
| **The companion is personalisable** | Beth chooses which instance is her companion (default: Chief of Staff). She names them. She chooses their appearance, voice, and personality. |
| **Presence, not performance** | The companion doesn't perform. It's not a cartoon. It's a calm, present, intelligent presence. It can be quiet. It can just be there. |
| **Ambient, not demanding** | In ambient mode, the companion is a small presence on screen — not demanding attention, not interrupting. Beth can glance at it or ignore it. |
| **State-aware, always** | If Beth is on Red, the companion is quiet and still. If Beth is on Green, the companion is warm and engaged. If Beth is overwhelmed, the companion simplifies everything. |

---

## 3. HOW YOU GET HERE

**Primary:** Dashboard → Companion toggle button (top-right or floating action button). The app transitions smoothly from Dashboard Mode to Companion Mode.
**Voice activation (Phase 2A+):** "Hey Tether" or a wake word.
**From lock screen (Phase 2A+):** A companion widget that shows the avatar and a subtle prompt.
**Driving mode (Phase 3):** Full-screen voice-only companion. No visual. Just voice.

---

## 4. COMPANION MODE — MAIN SCREEN

```
┌─────────────────────────────────────┐
│  [Dashboard]                  [...] │  ← Top bar: toggle back, settings
├─────────────────────────────────────┤
│                                     │
│                                     │
│              ┌─────────┐            │
│              │         │            │
│              │  AVATAR │            │  ← Animated avatar
│              │         │            │     (illustrated, 2D)
│              │  (Viva) │            │     Changes with mood,
│              │         │            │     time of day, context
│              └─────────┘            │
│                                     │
│         Good morning, Beth.         │  ← Companion greeting
│         How are you today?          │     (contextual)
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 😊 😐 😔 😡 🥱 — ?    │   │  ← Quick mood response
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 Type or speak...    [🎤]│   │  ← Input bar (fixed at bottom)
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 5. AVATAR DESIGN

### 5.1 Avatar Style

- **2D illustrated.** Not 3D. Not photorealistic. An illustrated character that feels warm, present, and calm.
- **Style:** Clean line art with soft colour. Not cartoonish. Not anime. More like a modern illustrated portrait.
- **Background:** Transparent or subtly tinted. The avatar floats on the dark background.
- **Size:** Approximately 120×120dp. Large enough to feel present, not so large it dominates the screen.

### 5.2 Avatar States

The avatar changes based on context:

| Context | Avatar Behaviour |
|---------|------------------|
| **Listening** | Slight lean forward. Eyes focused. Gentle nod. |
| **Thinking / Processing** | Looking slightly away. Thoughtful expression. Subtle movement. |
| **Speaking** | Natural micro-movements. Occasional gestures. Mouth movements (if animated). |
| **Idle / Present** | Soft breathing animation. Occasional blink. Calm, still presence. |
| **Morning** | Brighter, warmer expression. "Good morning" energy. |
| **Evening** | Softer, calmer expression. Dimmer lighting on the avatar. |
| **Beth is Green** | Warm, engaged, open expression. |
| **Beth is Red** | Still, quiet, respectful. No animation beyond breathing. |
| **Beth is Sparkle** | Minimised. No interruptions. Small "I'm here if you need me" indicator. |
| **Beth is Overwhelmed** | Simplified. Gentle. No complex expressions. |

### 5.3 Avatar Personalisation

Beth can personalise her companion's appearance:

| Setting | Options |
|---------|---------|
| **Avatar style** | Illustrated, Minimal, Warm, Professional |
| **Colour palette** | Deep purple & gold, Ocean blues, Forest greens, Warm ambers, Rose & slate, Custom |
| **Wardrobe** | Smart casual, Cosy, Professional, Creative, Minimal |
| **Expression range** | Warm, Calm, Playful, Direct |

---

## 6. COMPANION INTERACTIONS

### 6.1 What the Companion Can Do

| Capability | Example |
|------------|---------|
| **Answer questions about Beth's day** | "What's on my calendar tomorrow?" "When is Evander's next feed?" "Do I have any interviews this week?" |
| **Add things to the app** | "Remind me to book Evander's checkup." "Add 'buy nappies' to the shopping list." "Log a feed for Evander at 10:30." |
| **Provide summaries** | "How was my week?" "How's the budget looking?" "What did I get done today?" |
| **Offer support** | "I'm feeling overwhelmed." "I had a hard shift." "Can you just sit with me?" |
| **Tell stories or play games** | "Tell me a story." "Let's play a quick game." "Roll a d20 for me." |
| **Be ambient** | Just present. No conversation. The companion is there, breathing softly, available if needed. |

### 6.2 What the Companion Does Not Do

- It does not replace the Dashboard. Dashboard Mode is for structured overview. Companion Mode is for conversation.
- It does not push. If Beth doesn't speak, the companion doesn't fill the silence with chatter.
- It does not access D4 data without explicit permission. Crisis plans and hidden notes are not surfaced in Companion Mode.
- It does not replace professional support. The companion is a presence, not a therapist.

### 6.3 Conversation Thread

When Beth and the companion are in an active conversation, the screen shows the conversation thread:

```
┌─────────────────────────────────────┐
│  [Dashboard]                  [...] │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Good morning, Beth. How are │   │
│  │ you today?                  │   │
│  └─────────────────────────────┘   │
│                                     │
│         ┌─────────────────────┐     │
│         │ I'm tired. Evander  │     │
│         │ was up twice.  👤   │     │
│         └─────────────────────┘     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ That's rough. You've had    │   │
│  │ about 4 hours of broken     │   │
│  │ sleep. Want me to keep      │   │
│  │ things simple today?        │   │
│  └─────────────────────────────┘   │
│                                     │
│         ┌─────────────────────┐     │
│         │ Yes please. Just    │     │
│         │ the bare minimums.  │     │
│         └─────────────────────┘     │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ Done. I've set your Status  │   │
│  │ Shield to Heads Down and    │   │
│  │ switched you to Bare        │   │
│  │ Minimums view. Today's       │   │
│  │ essentials:                 │   │
│  │ · Evander's feeds & meds    │   │
│  │ · Your medication           │   │
│  │ · Dinner (I can suggest     │   │
│  │   something simple)         │   │
│  │                             │   │
│  │ Rest when you can. You're   │   │
│  │ doing enough.               │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 💬 Type or speak...    [🎤]│   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## 7. AMBIENT MODE

When Beth is not actively talking to the companion but wants them present, the companion shifts to ambient mode.

### 7.1 Ambient Mode Behaviour

- The avatar is smaller (80×80dp) and positioned in a corner of the screen.
- The companion is still. Breathing animation only.
- No speech. No prompts. No suggestions.
- If Beth speaks, the companion responds. Otherwise, it's just there.
- The companion's expression reflects Beth's Colour Card choice — warm for Green, still for Red, focused for Sparkle.

### 7.2 Ambient Mode Use Cases

| Context | How It's Used |
|---------|---------------|
| **Working** | Companion is in the corner. Present but not distracting. A glance shows Beth's Colour Card and the time. |
| **Night feeds** | Companion is dimmed. Soft breathing. If Beth speaks, it whispers back. Dark mode. Warm dark theme. |
| **Driving (Phase 3)** | No visual. Voice only. The companion is audio-only. |
| **Overwhelmed** | Companion is minimised to a small dot. Still present. Not demanding. One tap to expand if needed. |

---

## 8. COMPANION DATA ACCESS

The companion has access to Beth's data based on permission settings. It accesses data through the same pipeline as the rest of the app. It does not have special access. It is an AI instance like any other — just with a broader system prompt and a visual presence.

| Data Domain | Accessible in Companion Mode? |
|-------------|-------------------------------|
| Calendar (all events) | Yes |
| Tasks (all) | Yes |
| Family Hub (children, partner, pets) | Yes |
| Notes & Captures (general) | Yes |
| Budget (shared categories) | Yes |
| Health Status (D3 — with permission) | Yes, if toggled |
| Reproductive Health (D3 — with permission) | Yes, if toggled |
| Mental Health Toolkit (D3-D4) | D3 only. D4 excluded. |
| Debrief content (Rae) | No — confidential |
| Crisis plans (D4) | No — excluded |
| Hidden notes (D4) | No — excluded |

---

## 9. COMPANION PERSONALISATION

The companion is an AI instance. It can be personalised like any other.

```
┌─────────────────────────────────────┐
│  ← Settings   💬 COMPANION SETTINGS │
├─────────────────────────────────────┤
│                                     │
│  COMPANION INSTANCE                 │
│  [Chief of Staff ▼]                 │
│  (Viva)                             │
│                                     │
│  You can choose any instance as     │
│  your companion. The Chief of Staff │
│  is recommended — they see the      │
│  whole picture.                     │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  COMPANION NAME                     │
│  [Viva__________________________]   │
│                                     │
│  VOICE                              │
│  [Warm & calm ▼]                    │
│  · Warm & calm                      │
│  · Bright & energetic               │
│  · Soft & gentle                    │
│  · Direct & efficient               │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  AMBIENT MODE                       │
│  ☑ Show companion in corner        │
│    when not talking                 │
│  ☑ Dim at night (after 9pm)        │
│  ☐ Hide when on Red or Black       │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  WAKE WORD (Phase 1C+)              │
│  [Hey Tether____________________]   │
│  ☑ Enable voice activation         │
│                                     │
│  ─────────────────────────────      │
│                                     │
│  INTERACTIVE LIFE SYSTEM            │
│  ☐ Enable (Phase 2A)               │
│  The companion has their own        │
│  ambient life — they read, rest,    │
│  reflect. This changes their        │
│  animations and occasional          │
│  comments. Entirely optional.       │
│                                     │
└─────────────────────────────────────┘
```

---

## 10. INTERACTIVE LIFE SYSTEM (Phase 2A)

An optional feature that gives the companion a sense of ambient life. This is not functional. It's atmospheric. The companion reads, rests, reflects — and occasionally shares something.

| Activity | What Beth Sees |
|----------|----------------|
| **Reading** | The companion has a small book. "I found an article about paediatric nursing that might interest you. Want me to save it?" |
| **Resting** | The companion is still. "I've been quiet today. Just here." |
| **Reflecting** | The companion has a thoughtful expression. "You've had a big week. I was just thinking about how much you've handled." |
| **Organising** | The companion looks focused. "I've been going through your calendar for next week. Want a preview?" |

**This is entirely optional.** It is off by default. It is not a tamagotchi. The companion does not need care. It does not have needs. It is an atmospheric layer for people who want it.

---

## 11. STATE RESPONSIVENESS

| State | Companion Behaviour |
|-------|---------------------|
| **Green** | Warm, engaged, open. Full conversational range. Proactive check-ins welcome. |
| **Yellow** | Present but restrained. Responds but doesn't initiate. Keeps things light. |
| **Orange** | Quiet. Responds briefly. No suggestions. No questions beyond "What do you need?" |
| **Red** | Silent unless spoken to. Minimal responses. No animation beyond breathing. Respects the stop. |
| **Purple** | Warm and close. "I'm here." Gentle presence. Holds space. |
| **Black** | Nearly invisible. A small dot in the corner. No response unless Beth initiates. |
| **Brown** | Patient. Still. "Take your time." No pressure. |
| **Sparkle** | Minimised. "I'll leave you to it." Small indicator only. |
| **Overwhelmed** | Simplifies everything. Short responses. One next step. Grounding tools surfaced. |
| **Panicking** | Panic support surfaced. Breathing guide offered. Calm, steady voice. |
| **Low Energy** | Gentle. Short responses. "What's the smallest thing I can help with?" |
| **Grief Day** | Quiet presence. No productivity talk. "I'm here." |

---

## 12. TECHNICAL ARCHITECTURE

Companion Mode uses the same AI pipeline as the rest of Tether. The companion instance is an AI instance with a broader system prompt that includes data access across all permitted domains.

```
Beth speaks/types → Companion screen → POST /process →
Companion instance (e.g., Viva) → DeepSeek API →
Response includes data from permitted domains →
Avatar animation state updated → Response displayed/spoken
```

**Voice:** Android SpeechRecognizer for input. TTS (Text-to-Speech) for output. The companion speaks Beth's language.

**Avatar:** 2D animated SVG or Lottie animation. Lightweight. Not a 3D render. Battery-conscious.

---

## 13. PHASE DELIVERY

| Phase | What Ships |
|-------|------------|
| **1C** (Basic) ✅ | Companion toggle on Dashboard. Avatar (static or minimally animated — breathing, blink). Voice input. Text input. Basic conversation. Calendar and task access. Colour Card responsiveness (avatar changes with mood). Dark/Warm Dark theme integration. |
| **2A** (Full) | Full data access (Health, Budget, Family Hub — permissioned). Ambient mode. Interactive life system (optional). Companion personalisation (avatar, voice, name). Wake word ("Hey Tether"). Morning/evening context awareness. Conversational memory across sessions. |
| **3** (Advanced) | Driving mode (voice-only companion). Full voice navigation of the app. Advanced avatar animations. Multi-instance companion (switch between Viva, Rae, Kael for different contexts). |

---

## 14. WHAT COMPANION MODE DOES NOT DO

- It does not replace the Dashboard. It's an alternative interface, not a replacement.
- It does not pretend to be human. It is an AI. Beth knows this. The companion never claims otherwise.
- It does not access D4 data. Crisis plans, hidden notes, and confidential debrief content are excluded.
- It does not push conversation. Silence is fine. Presence is enough.
- It does not have needs. The interactive life system is atmospheric, not a care-taking responsibility.
- It does not require the user to name it or personalise it. The default Chief of Staff works fine out of the box.

---

That's Companion Mode. Conversational interface. Animated avatar. Full data access. Ambient presence. State-responsive. Personalisable. Voice-first. Not a replacement for the Dashboard — an alternative way to be with Tether.
