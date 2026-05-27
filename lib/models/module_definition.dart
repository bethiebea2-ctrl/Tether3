/// Status of a module in the Tether app.
///
/// [active] — visible in navigation and dashboard, fully functional
/// [inactive] — not visible, but data preserved, can be re-enabled
/// [hidden] — not visible to user, developer-only (e.g. Ghost Log)
enum ModuleStatus {
  active,
  inactive,
  hidden,
}

/// Risk classification for regulatory and ethical boundaries.
///
/// [green] — lifestyle support, low regulatory risk
/// [amber] — health support / education, needs disclaimers and sourcing
/// [red] — clinical-adjacent, do not build without expert review
enum RiskLevel {
  green,
  amber,
  red,
}

/// Data sensitivity level for privacy and sharing rules.
///
/// [d1] — low: meal preferences, household tasks, pet reminders, generic routines
/// [d2] — medium: calendar, budget, family notes, school info, task lists
/// [d3] — high: health, reproductive, mental health, medication, child health
/// [d4] — very high: crisis plans, hidden notes, DV info, self-harm logs, safety plans
enum SensitivityLevel {
  d1,
  d2,
  d3,
  d4,
}

/// Defines a module in the Tether app.
///
/// Each module is a self-contained feature domain (Calendar, Tasks, Family Hub, etc.)
/// that can be toggled on/off, has a risk classification, and carries a sensitivity
/// ceiling for data it handles.
class ModuleDefinition {
  /// Unique identifier matching the backend module key
  final String id;

  /// Display name shown in navigation and settings
  final String title;

  /// Material icon name for bottom nav
  final String icon;

  /// Whether the module is active, inactive, or hidden
  final ModuleStatus status;

  /// Risk classification
  final RiskLevel riskLevel;

  /// Highest sensitivity level of data this module handles
  final SensitivityLevel sensitivityCeiling;

  /// Whether this module is enabled by default for new users
  final bool enabledByDefault;

  /// Brief description for settings screen
  final String description;

  /// Phase when this module is built (for roadmap visibility)
  final String phase;

  /// Whether this module depends on other modules being active first
  final List<String>? dependsOn;

  const ModuleDefinition({
    required this.id,
    required this.title,
    required this.icon,
    required this.status,
    this.riskLevel = RiskLevel.green,
    this.sensitivityCeiling = SensitivityLevel.d2,
    this.enabledByDefault = false,
    this.description = '',
    this.phase = '',
    this.dependsOn,
  });

  /// Create a copy with modified fields
  ModuleDefinition copyWith({
    String? id,
    String? title,
    String? icon,
    ModuleStatus? status,
    RiskLevel? riskLevel,
    SensitivityLevel? sensitivityCeiling,
    bool? enabledByDefault,
    String? description,
    String? phase,
    List<String>? dependsOn,
  }) {
    return ModuleDefinition(
      id: id ?? this.id,
      title: title ?? this.title,
      icon: icon ?? this.icon,
      status: status ?? this.status,
      riskLevel: riskLevel ?? this.riskLevel,
      sensitivityCeiling: sensitivityCeiling ?? this.sensitivityCeiling,
      enabledByDefault: enabledByDefault ?? this.enabledByDefault,
      description: description ?? this.description,
      phase: phase ?? this.phase,
      dependsOn: dependsOn ?? this.dependsOn,
    );
  }
}