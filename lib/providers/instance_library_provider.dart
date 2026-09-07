import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';

/// Active instance selection for the team grid (Phase 2A).
class InstanceLibraryProvider extends ChangeNotifier {
  static const _key = 'library_active_instances';
  static const minInstances = 4;
  static const maxInstances = 16;

  static const defaultLearningIds = ['viva', 'val', 'ellory', 'tim', 'rae'];

  final Set<String> _activeIds = {};
  bool _loaded = false;

  bool get isLoaded => _loaded;
  Set<String> get activeIds => Set.unmodifiable(_activeIds);

  List<Map<String, dynamic>> get activeInstances => InstanceRegistry.instances
      .where((i) => _activeIds.contains(i['id'] as String))
      .toList();

  List<Map<String, dynamic>> get availableTemplates => InstanceRegistry.instances;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(_key);
    _activeIds
      ..clear()
      ..addAll(stored ?? defaultLearningIds);
    _loaded = true;
    notifyListeners();
  }

  Future<void> applyDefaultLearning() async {
    _activeIds
      ..clear()
      ..addAll(defaultLearningIds);
    await _save();
  }

  Future<void> applyFullCustom(Set<String> ids) async {
    if (ids.length < minInstances) return;
    _activeIds
      ..clear()
      ..addAll(ids.take(maxInstances));
    await _save();
  }

  Future<String?> toggleInstance(String id, bool active) async {
    if (active) {
      if (_activeIds.length >= maxInstances) {
        return 'Maximum $maxInstances instances allowed.';
      }
      _activeIds.add(id);
    } else {
      if (_activeIds.length <= minInstances) {
        return 'Keep at least $minInstances instances active.';
      }
      _activeIds.remove(id);
    }
    await _save();
    return null;
  }

  Future<void> swapInstance({required String removeId, required String addId}) async {
    if (!_activeIds.contains(removeId) || _activeIds.contains(addId)) return;
    _activeIds.remove(removeId);
    _activeIds.add(addId);
    await _save();
  }

  bool isActive(String id) => _activeIds.contains(id);

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, _activeIds.toList());
    notifyListeners();
  }
}
