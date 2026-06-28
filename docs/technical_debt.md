# Technical Debt Register

## TD-001 — EventBus Reset Mechanism

**Description:** Singleton EventBus cannot be fully isolated in tests. Broadcast stream doesn't deliver events to listeners subscribed after emission in test isolation. Works correctly in live app.

**Status:** Tracked

---

## TD-002 — Resolver Persistence Abstraction

**Description:** Resolver decision persistence currently depends directly on SharedPreferences. The `saveDecision()` call in `ResolverEngine` is wrapped in a try-catch as a workaround for test environments where SharedPreferences is unavailable.

**Future Interface:** `IResolverDecisionStore`

**Possible Implementations:**
- `SharedPreferencesDecisionStore`
- `SqliteDecisionStore`
- `CloudDecisionStore`

**Status:** Tracked