import 'package:flutter/material.dart';
import '../models/module_definition.dart';
import '../core/storage/module_storage_service.dart';

/// Central registry for all Tether modules.
class ModuleRegistryProvider extends ChangeNotifier {
  final ModuleStorageService _storage = ModuleStorageService();
  bool _initialized = false;
  bool get isInitialized => _initialized;

  static const Set<String> _alwaysActive = {'dashboard', 'capture_notes'};

  final List<ModuleDefinition> _modules = _buildTemplates();

  static List<ModuleDefinition> _buildTemplates() => [
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
          description: 'Voice and text notes processed by Rhen',
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
          status: ModuleStatus.hidden,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Developer tool — resolver inspection',
          phase: '1C',
        ),
        const ModuleDefinition(
          id: 'family_hub',
          title: 'Family Hub',
          icon: 'family_restroom',
          status: ModuleStatus.active,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d3,
          enabledByDefault: true,
          description: 'People, partners, pets, and household care',
          phase: '1B',
        ),
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
          description: 'Manual budget tracker with Tim',
          phase: '1B',
        ),
        const ModuleDefinition(
          id: 'timeline',
          title: 'Timeline',
          icon: 'timeline',
          status: ModuleStatus.hidden,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Developer tool — orchestration timeline',
          phase: '2B',
        ),
        const ModuleDefinition(
          id: 'state_history',
          title: 'State History',
          icon: 'history',
          status: ModuleStatus.hidden,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'State activation history',
          phase: '2B',
        ),
        const ModuleDefinition(
          id: 'decision_inspector',
          title: 'Decision Inspector',
          icon: 'psychology',
          status: ModuleStatus.hidden,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Developer tool — decision explainability',
          phase: '3',
        ),
        const ModuleDefinition(
          id: 'companion',
          title: 'Companion',
          icon: 'face',
          status: ModuleStatus.inactive,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Voice-first AI companion',
          phase: '1C',
        ),
        const ModuleDefinition(
          id: 'meals',
          title: 'Meals',
          icon: 'restaurant',
          status: ModuleStatus.inactive,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Family-aware meal planning',
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
          description: 'Health tracking and medications',
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
          description: 'Cycle tracking and reproductive health',
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
          description: 'Regulation toolkit',
          phase: '1D',
        ),
        const ModuleDefinition(
          id: 'resource_library',
          title: 'Resources',
          icon: 'library_books',
          status: ModuleStatus.inactive,
          riskLevel: RiskLevel.amber,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Cloud resource library',
          phase: '2B',
        ),
        const ModuleDefinition(
          id: 'fitness',
          title: 'Fitness',
          icon: 'fitness_center',
          status: ModuleStatus.inactive,
          riskLevel: RiskLevel.green,
          sensitivityCeiling: SensitivityLevel.d2,
          enabledByDefault: false,
          description: 'Workout tracking',
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
          description: 'Recreational gaming',
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
          description: 'Hands-free voice mode',
          phase: '3',
        ),
      ];

  List<ModuleDefinition> get modules => List.unmodifiable(_modules);

  List<ModuleDefinition> get activeModules =>
      _modules.where((m) => m.status == ModuleStatus.active).toList();

  List<ModuleDefinition> get inactiveModules =>
      _modules.where((m) => m.status == ModuleStatus.inactive).toList();

  List<ModuleDefinition> get manageableModules =>
      _modules.where((m) => m.status != ModuleStatus.hidden).toList();

  Future<void> initialize() async {
    if (_initialized) return;
    var saved = await _storage.loadActiveModules();
    saved = saved.map((id) => id == 'children' ? 'family_hub' : id).toList();

    if (saved.isEmpty) {
      saved = _modules
          .where((m) => m.enabledByDefault)
          .map((m) => m.id)
          .toList();
    }

    _applyActiveIds(saved);
    await _persist();
    _initialized = true;
    notifyListeners();
  }

  void _applyActiveIds(List<String> activeIds) {
    for (var i = 0; i < _modules.length; i++) {
      final m = _modules[i];
      if (m.status == ModuleStatus.hidden) continue;
      final active = _alwaysActive.contains(m.id) || activeIds.contains(m.id);
      _modules[i] = m.copyWith(
        status: active ? ModuleStatus.active : ModuleStatus.inactive,
      );
    }
  }

  Future<void> _persist() async {
    final ids = _modules
        .where((m) => m.status == ModuleStatus.active && !_alwaysActive.contains(m.id))
        .map((m) => m.id)
        .toList();
    await _storage.saveActiveModules(ids);
  }

  String? activateModule(String id) {
    if (_alwaysActive.contains(id)) return null;
    final index = _modules.indexWhere((m) => m.id == id);
    if (index == -1) return 'Unknown module';

    final module = _modules[index];
    if (module.status == ModuleStatus.hidden) return 'Module not available';

    final deps = module.dependsOn ?? [];
    for (final dep in deps) {
      final depModule = getModule(dep);
      if (depModule == null || depModule.status != ModuleStatus.active) {
        return 'Turn on ${depModule?.title ?? dep} first';
      }
    }

    _modules[index] = module.copyWith(status: ModuleStatus.active);
    _persist();
    notifyListeners();
    return null;
  }

  void deactivateModule(String id) {
    if (_alwaysActive.contains(id)) return;
    final index = _modules.indexWhere((m) => m.id == id);
    if (index == -1) return;

    _modules[index] = _modules[index].copyWith(status: ModuleStatus.inactive);
    _persist();
    notifyListeners();
  }

  ModuleDefinition? getModule(String id) {
    try {
      return _modules.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  bool isModuleActive(String id) => getModule(id)?.status == ModuleStatus.active;
}
