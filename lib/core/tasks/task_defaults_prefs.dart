import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'task_energy.dart';
import 'task_priority.dart';

/// Per-layer default priority/energy for new tasks.
class TaskDefaultsPrefs {
  static const layerKey = 'task_defaults_layer';
  static const byLayerKey = 'task_defaults_by_layer_v1';
  static const legacyPriorityKey = 'task_defaults_priority';
  static const legacyEnergyKey = 'task_defaults_energy';

  static Future<Map<String, Map<String, String>>> _loadMap() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(byLayerKey);
    if (raw != null && raw.isNotEmpty) {
      final decoded = jsonDecode(raw);
      if (decoded is Map) {
        return decoded.map(
          (k, v) => MapEntry(
            k.toString(),
            Map<String, String>.from(v as Map),
          ),
        );
      }
    }
    // Migrate single global defaults from early builds.
    final layer = prefs.getString(layerKey) ?? 'life_admin';
    return {
      layer: {
        'priority': prefs.getString(legacyPriorityKey) ?? TaskPriority.medium.name,
        'energy': prefs.getString(legacyEnergyKey) ?? TaskEnergy.medium.name,
      },
    };
  }

  static Future<void> _persistMap(Map<String, Map<String, String>> map) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(byLayerKey, jsonEncode(map));
    await prefs.remove(legacyPriorityKey);
    await prefs.remove(legacyEnergyKey);
  }

  static TaskPriority _parsePriority(String? name) =>
      TaskPriority.values.firstWhere(
        (p) => p.name == name,
        orElse: () => TaskPriority.medium,
      );

  static TaskEnergy _parseEnergy(String? name) =>
      TaskEnergy.values.firstWhere(
        (e) => e.name == name,
        orElse: () => TaskEnergy.medium,
      );

  static Future<String> lastSelectedLayer() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(layerKey) ?? 'life_admin';
  }

  static Future<({TaskPriority priority, TaskEnergy energy})> loadForLayer(
    String layer,
  ) async {
    final map = await _loadMap();
    final entry = map[layer];
    if (entry != null) {
      return (
        priority: _parsePriority(entry['priority']),
        energy: _parseEnergy(entry['energy']),
      );
    }
    return (priority: TaskPriority.medium, energy: TaskEnergy.medium);
  }

  static Future<void> saveForLayer({
    required String layer,
    required TaskPriority priority,
    required TaskEnergy energy,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final map = await _loadMap();
    map[layer] = {'priority': priority.name, 'energy': energy.name};
    await _persistMap(map);
    await prefs.setString(layerKey, layer);
  }

  /// Defaults applied when creating a new task.
  static Future<({
    String layer,
    TaskPriority priority,
    TaskEnergy energy,
  })> loadNewTaskDefaults() async {
    final layer = await lastSelectedLayer();
    final values = await loadForLayer(layer);
    return (layer: layer, priority: values.priority, energy: values.energy);
  }
}
