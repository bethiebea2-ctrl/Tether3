import 'package:flutter/material.dart';
import '../models/module_definition.dart';

/// Central registry for all Tether modules.
///
/// The Module Registry is the single source of truth for which modules exist,
/// which are active, and what their configuration is. The AppShell reads from
/// this provider to build the dynamic bottom navigation bar.
///
/// Modules are registered once on app startup. Activating/deactivating modules
/// updates the UI immediately via notifyListeners().
class ModuleRegistryProvider extends ChangeNotifier {
  final List<ModuleDefinition> _modules = [
    // ============================================
    // PHASE 1A — Already built
    // ============================================
    const ModuleDefinition(
      id: 'dashboard',
      title: 'Dashboard',
      icon: 'home',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: true,
      description: 'Morning dashboard with affirmations, schedule, and status',
      phase: '1A',
    ),
    const ModuleDefinition(
      id: 'capture_notes',
      title: 'Notes',
      icon: 'edit_note',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: true,
      description: 'Voice and text capture processed by Rhen',
      phase: '1A',
    ),
    const ModuleDefinition(
      id: 'calendar',
      title: 'Calendar',
      icon: 'calendar_today',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: true,
      description: 'Month/week/day views with pipeline-driven events',
      phase: '1A',
    ),
    const ModuleDefinition(
      id: 'team',
      title: 'Team',
      icon: 'groups',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: true,
      description: 'AI instance grid with chat',
      phase: '1A',
    ),
    const ModuleDefinition(
      id: 'resolver_debug',
      title: 'Debug',
      icon: 'bug_report',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Developer tool — resolver inspection and orchestration visibility',
      phase: '1C',
    ),

    // ============================================
    // PHASE 1A — Partially built (placeholder screens exist)
    // ============================================
    const ModuleDefinition(
      id: 'children',
      title: 'Children',
      icon: 'child_care',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d3,
      enabledByDefault: true,
      description: 'Evander card with medication tracker and quick log',
      phase: '1A',
    ),

    // ============================================
    // PHASE 1B — Building now
    // ============================================
    const ModuleDefinition(
      id: 'tasks',
      title: 'Tasks',
      icon: 'check_circle',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: true,
      description: 'Urgent/Not Urgent task lists with AI delegation',
      phase: '1B',
    ),
    const ModuleDefinition(
      id: 'budget',
      title: 'Budget',
      icon: 'account_balance_wallet',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Manual budget tracker with Tim (AI instance)',
      phase: '1B',
    ),
    const ModuleDefinition(
      id: 'timeline',
      title: 'Timeline',
      icon: 'timeline',
      status: ModuleStatus.active,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Developer tool — orchestration event timeline',
      phase: '2C',
    ),
    // ============================================
    // PHASE 1C — Voice & Companion
    // ============================================
    const ModuleDefinition(
      id: 'companion',
      title: 'Companion',
      icon: 'face',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Voice-first AI companion with ambient presence',
      phase: '1C',
    ),

    // ============================================
    // PHASE 1D — Health, Food, Personalisation
    // ============================================
    const ModuleDefinition(
      id: 'family_hub',
      title: 'Family Hub',
      icon: 'home',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d3,
      enabledByDefault: false,
      description: 'People, pets, routines, care tasks, school',
      phase: '1D',
      dependsOn: ['children'],
    ),
    const ModuleDefinition(
      id: 'meals',
      title: 'Meals',
      icon: 'restaurant',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Budget-friendly, family-aware, sensory-aware meal planning',
      phase: '1D',
    ),
    const ModuleDefinition(
      id: 'health_status',
      title: 'Health',
      icon: 'favorite',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.amber,
      sensitivityCeiling: SensitivityLevel.d3,
      enabledByDefault: false,
      description: 'Health tracking, conditions, medications, doctor exports',
      phase: '1D',
    ),
    const ModuleDefinition(
      id: 'reproductive_health',
      title: 'Reproductive',
      icon: 'water_drop',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.amber,
      sensitivityCeiling: SensitivityLevel.d3,
      enabledByDefault: false,
      description: 'Cycle tracking, contraception, pregnancy, menopause',
      phase: '1D',
    ),
    const ModuleDefinition(
      id: 'mental_health_toolkit',
      title: 'Mental Health',
      icon: 'psychology',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.amber,
      sensitivityCeiling: SensitivityLevel.d4,
      enabledByDefault: false,
      description: 'Regulation toolkit — crisis plans, grounding, urge surfing',
      phase: '1D',
    ),

    // ============================================
    // PHASE 2A — Connection Layer
    // ============================================
    const ModuleDefinition(
      id: 'resource_library',
      title: 'Resources',
      icon: 'library_books',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.amber,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Cloud resource library with accredited health resources',
      phase: '2A',
    ),

    // ============================================
    // PHASE 3 — Advanced
    // ============================================
    const ModuleDefinition(
      id: 'fitness',
      title: 'Fitness',
      icon: 'fitness_center',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Workout tracking and form guidance',
      phase: '3',
    ),
    const ModuleDefinition(
      id: 'gaming',
      title: 'Gaming',
      icon: 'sports_esports',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.green,
      sensitivityCeiling: SensitivityLevel.d1,
      enabledByDefault: false,
      description: 'Kael\'s domain — D&D campaigns and recreational gaming',
      phase: '3',
    ),
    const ModuleDefinition(
      id: 'driving_mode',
      title: 'Driving',
      icon: 'directions_car',
      status: ModuleStatus.inactive,
      riskLevel: RiskLevel.amber,
      sensitivityCeiling: SensitivityLevel.d2,
      enabledByDefault: false,
      description: 'Hands-free voice mode for driving',
      phase: '3',
    ),
  ];

  /// All registered modules, regardless of status
  List<ModuleDefinition> get modules => List.unmodifiable(_modules);

  /// Only modules visible to the user (active in bottom nav)
  List<ModuleDefinition> get activeModules =>
      _modules.where((m) => m.status == ModuleStatus.active).toList();

  /// Modules that are currently inactive but available to enable
  List<ModuleDefinition> get inactiveModules =>
      _modules.where((m) => m.status == ModuleStatus.inactive).toList();

  /// Activate a module — makes it visible in navigation
  void activateModule(String id) {
    final index = _modules.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _modules[index] = _modules[index].copyWith(status: ModuleStatus.active);
    notifyListeners();
  }

  /// Deactivate a module — hides it from navigation, preserves data
  void deactivateModule(String id) {
    final index = _modules.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _modules[index] = _modules[index].copyWith(status: ModuleStatus.inactive);
    notifyListeners();
  }

  /// Get a specific module by ID
  ModuleDefinition? getModule(String id) {
    try {
      return _modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }
}