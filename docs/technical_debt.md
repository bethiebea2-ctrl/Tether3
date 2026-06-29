# Technical Debt Register

## TD-001 — EventBus Reset Mechanism

**Priority:** Medium
**Description:** Singleton EventBus cannot be fully isolated in tests. Broadcast stream doesn't deliver events to listeners subscribed after emission in test isolation. Works correctly in live app.
**Risk:** Low — affects test isolation only, not production behaviour.
**Proposed Solution:** Add a `reset()` method to EventBus for test teardown. Consider IEventBus mock implementation for integration tests.
**Target Phase:** Phase 3 (Integration Testing)
**Status:** Tracked

---

## TD-002 — Resolver Persistence Abstraction

**Priority:** Medium
**Description:** Resolver decision persistence currently depends directly on SharedPreferences. The `saveDecision()` call in `ResolverEngine` uses `.catchError()` as a workaround for test environments where SharedPreferences is unavailable.
**Risk:** Low for MVP — SharedPreferences is sufficient for single-user. Becomes a limitation with multi-user sync (Phase 2A) and large audit datasets.
**Future Interface:** `IResolverDecisionStore`
**Possible Implementations:**
- `SharedPreferencesDecisionStore` (current)
- `SqliteDecisionStore` (Phase 2B+)
- `CloudDecisionStore` (Phase 3+)
**Target Phase:** Phase 2B (SQLite migration)
**Status:** Tracked

---

## TD-003 — Async Persistence in Resolver Engine

**Priority:** Low
**Description:** The `saveDecision()` and `record()` calls in `ResolverEngine.resolve()` are fire-and-forget async operations. They use `.catchError()` to silently handle failures in test environments. In production, if SharedPreferences fails, the error is silently swallowed.
**Risk:** Low — SharedPreferences failures are extremely rare on Android. The resolver's primary output (the `ResolverResult`) is returned synchronously and unaffected.
**Proposed Solution:** Implement a proper error callback or logging hook for persistence failures. Consider a buffered retry mechanism for write failures.
**Target Phase:** Phase 3 (Performance Metrics)
**Status:** Tracked

---

## TD-004 — State Transition Duration Tracking

**Priority:** Low
**Description:** `StateTransition.durationMs` field exists in the model but is not yet populated. The `StateHistoryService` records transitions but doesn't calculate how long the previous state was active.
**Risk:** Low — affects state analytics only, not core functionality.
**Proposed Solution:** When recording a transition, calculate duration from the previous state record's timestamp. Store in `durationMs`.
**Target Phase:** Phase 3 (Causal Intelligence)
**Status:** Tracked

---

## TD-005 — ResolverInvocation Not Persisted

**Priority:** Medium
**Description:** `ResolverInvocation` objects are constructed in `ResolverEngine.resolve()` with full causal traceability data but are not yet persisted. The TODO on line ~118 of resolver_engine.dart notes this. The data exists in memory during resolution but is lost after the call completes.
**Risk:** Medium — invocation data is the bridge between state, trace, and decision. Without persistence, causal queries cannot be answered from stored data.
**Proposed Solution:** Create `ResolverInvocationService` to persist invocations alongside decisions. Wire into the engine after `.catchError()` pattern.
**Target Phase:** Phase 3 (Integration Testing)
**Status:** Tracked

---

## TD-006 — DecisionExplanation Not Persisted

**Priority:** Medium
**Description:** `DecisionExplanation` objects are constructed with reason, confidence, triggered rules, and recommendation but are not persisted. Same pattern as TD-005.
**Risk:** Medium — explanation data is needed for the Decision Inspector screen and for GPTV's explainability standard (Priority 10).
**Proposed Solution:** Persist alongside `ResolverDecisionRecord` or as a separate store. Display in Decision Inspector.
**Target Phase:** Phase 3 (Developer Diagnostics)
**Status:** Tracked

---

## TD-007 — SharedPreferences for Audit Records

**Priority:** Medium
**Description:** Event records, resolver decisions, and state history are all stored in SharedPreferences as JSON strings. This is not designed for structured queries or large datasets. The 90-day retention with JSON string lists will grow if pruning is not regular.
**Risk:** Medium — acceptable for MVP. Becomes limiting with multi-user and large audit datasets.
**Proposed Solution:** Migration path planned in Data Architecture v2.0 Section 8. Create SQLite tables for orchestration_events, resolver_decisions, state_history. Maintain SharedPreferences as write-through cache.
**Target Phase:** Phase 2B+
**Status:** Tracked