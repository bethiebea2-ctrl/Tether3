/// A Support Preset is a pre-built bundle of sensitivity toggles
/// designed for a specific support need (ADHD, autism, depression, etc.).
///
/// Presets are named by FUNCTION, not diagnosis:
///   "ADHD support" not "ADHD mode"
///   "Emotional regulation support" not "BPD mode"
///
/// Presets are LAYER 1 of the three-layer support system:
///   Layer 1: Support Presets (bundles of toggles)
///   Layer 2: Individual Sensitivity Toggles (available outside presets)
///   Layer 3: Current State (temporary override)
class SupportPreset {
  /// Unique key matching the backend preset_key
  final String id;

  /// Display name — functional, not diagnostic
  /// e.g. "ADHD support" not "ADHD mode"
  final String displayName;

  /// What this preset does and doesn't do
  final String description;

  /// Category for grouping in settings
  /// executive, emotional, sensory, health, accessibility
  final String category;

  /// Which Layer 2 toggles this preset enables by default
  /// Keys match SensitivityToggle.id
  final List<String> defaultToggleIds;

  /// Language rules: banned phrases → preferred alternatives
  /// e.g. { "You forgot": "Still on the list." }
  final Map<String, String> languageRules;

  /// Current State shortcuts linked to this preset
  /// Keys match CurrentState.id
  final List<String> currentStateShortcuts;

  /// Risk level for regulatory boundaries
  final String riskLevel; // green, amber

  /// Version for tracking updates
  final int version;

  const SupportPreset({
    required this.id,
    required this.displayName,
    required this.description,
    required this.category,
    this.defaultToggleIds = const [],
    this.languageRules = const {},
    this.currentStateShortcuts = const [],
    this.riskLevel = 'green',
    this.version = 1,
  });
}

/// An individual sensitivity toggle available to all users.
///
/// Toggles are LAYER 2 of the support system.
/// Any user can enable any toggle — presets just bundle them.
class SensitivityToggle {
  /// Unique key matching the backend toggle_key
  final String id;

  /// Display name shown in settings
  final String displayName;

  /// Category for grouping
  /// notification, language, sensory, cognitive_load, food_body,
  /// communication, financial, health, privacy
  final String category;

  /// What this toggle does when enabled
  final String description;

  /// Default value (most toggles default to off)
  final bool defaultValue;

  const SensitivityToggle({
    required this.id,
    required this.displayName,
    required this.category,
    required this.description,
    this.defaultValue = false,
  });
}

/// A temporary state that overrides normal app behaviour.
///
/// Current States are LAYER 3 — they sit on top of presets and toggles
/// and temporarily modify behaviour until the state ends or is manually cleared.
///
/// Examples: Overwhelmed, Panicking, Low Energy, Migraine, Grief Day
class CurrentState {
  /// Unique key matching the backend state_key
  final String id;

  /// Display name
  final String displayName;

  /// What this state does
  final String description;

  /// Default duration in minutes (null = indefinite)
  final int? defaultDurationMinutes;

  /// What gets suppressed when this state is active
  /// e.g. ["non_urgent_notifications", "animations", "suggestions"]
  final List<String> suppress;

  /// What gets surfaced / prioritised when this state is active
  /// e.g. ["bare_minimum_tasks", "crisis_resources", "grounding_tools"]
  final List<String> surface;

  const CurrentState({
    required this.id,
    required this.displayName,
    required this.description,
    this.defaultDurationMinutes,
    this.suppress = const [],
    this.surface = const [],
  });
}