/// Sensitivity level for data privacy and sharing rules.
///
/// [d1] — Low: meal preferences, household tasks, pet reminders, generic routines
/// [d2] — Medium: calendar, budget, family notes, school info, task lists
/// [d3] — High: health, reproductive, mental health, medication, child health
/// [d4] — Very High: crisis plans, hidden notes, DV info, self-harm logs, safety plans
enum SensitivityLevel {
  d1,
  d2,
  d3,
  d4,
}

/// Privacy scope for data visibility.
///
/// [private] — Only the owner can see this item
/// [household] — All household members can see this item
/// [selectedPersons] — Only specific persons can see this item
enum PrivacyScope {
  private,
  household,
  selectedPersons,
}

/// Priority level for tasks.
///
/// [urgent] — Requires immediate attention, bypasses quiet hours
/// [important] — Should be done soon, included in digest
/// [normal] — Standard priority
/// [low] — Can be deferred, low priority in digest
enum TaskPriority {
  urgent,
  important,
  normal,
  low,
}

/// Priority level for calendar events.
///
/// [urgent] — Critical event, highlighted
/// [important] — Significant event, badge
/// [normal] — Standard event
enum EventPriority {
  urgent,
  important,
  normal,
}

/// Energy level required for a task.
///
/// Tasks can be filtered by energy level so users only see what they have
/// capacity for based on their current state.
///
/// [low] — Minimal energy required (e.g. take medication, drink water)
/// [medium] — Moderate energy required (e.g. do dishes, make a call)
/// [high] — Significant energy required (e.g. deep cleaning, exercise)
enum EnergyLevel {
  low,
  medium,
  high,
}

/// Decision output from a resolver rule.
///
/// [allow] — Proceed normally
/// [suppress] — Block this item entirely
/// [delay] — Hold and release later
/// [digest] — Include in next digest, not immediate
/// [escalate] — Increase priority/urgency
enum ResolverDecision {
  allow,
  suppress,
  delay,
  digest,
  escalate,
}

/// Notification delivery mode.
///
/// [realtime] — Deliver notifications as they occur
/// [digest] — Batch notifications at configured time
/// [hybrid] — Urgent = realtime, Important = digest unless time-bound
enum NotificationMode {
  realtime,
  digest,
  hybrid,
}