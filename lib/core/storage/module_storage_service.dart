import 'package:shared_preferences/shared_preferences.dart';

/// Persists module activation state so the user's
/// module preferences survive app restarts.
class ModuleStorageService {
  static const String _modulesKey = 'active_modules';

  /// Save the list of active module IDs
  Future<void> saveActiveModules(List<String> moduleIds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_modulesKey, moduleIds);
  }

  /// Load the list of active module IDs
  /// Returns empty list if nothing saved yet (first launch)
  Future<List<String>> loadActiveModules() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_modulesKey) ?? [];
  }
}