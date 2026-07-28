import 'package:flutter/material.dart';
import '../models/support_preset.dart';

/// Layer 1 support presets — architecture for Phase 1B.
class SupportPresetProvider extends ChangeNotifier {
  static const List<SupportPreset> catalog = [
    SupportPreset(
      id: 'adhd_support',
      displayName: 'ADHD support',
      description: 'Reduces overwhelm and supports executive function.',
      category: 'executive',
      defaultToggleIds: ['reduce_notifications', 'one_next_step'],
      currentStateShortcuts: ['low_energy', 'overwhelmed'],
    ),
    SupportPreset(
      id: 'low_stimulation',
      displayName: 'Low-stimulation support',
      description: 'Quieter visuals and fewer interruptions.',
      category: 'sensory',
      defaultToggleIds: ['reduce_notifications', 'reduce_motion'],
      currentStateShortcuts: ['overwhelmed'],
    ),
    SupportPreset(
      id: 'depression_support',
      displayName: 'Depression support',
      description: 'Gentle language and bare-minimum focus.',
      category: 'emotional',
      defaultToggleIds: ['shame_free_language'],
      languageRules: {'You forgot': 'Still on the list.'},
      currentStateShortcuts: ['low_energy', 'grief_day'],
    ),
  ];

  final Set<String> _activePresetIds = {};
  final Set<String> _activeToggleIds = {};

  List<SupportPreset> get activePresets =>
      catalog.where((p) => _activePresetIds.contains(p.id)).toList();

  Set<String> get activeToggleIds => Set.unmodifiable(_activeToggleIds);

  bool get reduceNotifications =>
      _activeToggleIds.contains('reduce_notifications') ||
      activePresets.any((p) => p.defaultToggleIds.contains('reduce_notifications'));

  bool get simplifiedDashboard =>
      _activeToggleIds.contains('simplified_dashboard') ||
      activePresets.any((p) => p.defaultToggleIds.contains('simplified_dashboard'));

  void togglePreset(String id) {
    if (_activePresetIds.contains(id)) {
      _activePresetIds.remove(id);
    } else {
      _activePresetIds.add(id);
      final preset = catalog.firstWhere((p) => p.id == id);
      _activeToggleIds.addAll(preset.defaultToggleIds);
    }
    notifyListeners();
  }

  void toggleSensitivity(String toggleId) {
    if (_activeToggleIds.contains(toggleId)) {
      _activeToggleIds.remove(toggleId);
    } else {
      _activeToggleIds.add(toggleId);
    }
    notifyListeners();
  }

  bool isPresetActive(String id) => _activePresetIds.contains(id);
}
