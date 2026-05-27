/// Priority levels for resolving conflicts between state sources.
///
/// When multiple sources set the same toggle or behaviour,
/// the higher priority wins. This is deterministic — no guessing.
///
/// [systemDefault] — The app's built-in default value
/// [supportPreset] — Set by an active Support Preset
/// [currentState] — Set by an active Current State (temporary override)
/// [manualOverride] — Set manually by the user (always wins)
enum StatePriority {
  systemDefault,
  supportPreset,
  currentState,
  manualOverride,
}