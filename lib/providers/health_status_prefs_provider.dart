import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Reads the same keys as [HealthStatusSettingsScreen].
class HealthStatusPrefsProvider extends ChangeNotifier {
  static const prefix = 'health_status_prefs_';

  bool _loaded = false;
  bool medRemindersNote = true;
  bool showBp = true;
  bool showGlucose = true;
  bool showSymptoms = true;
  bool showPain = true;
  bool showSleep = true;
  bool showSeizure = true;
  bool showAllergies = true;
  bool showDocuments = true;

  bool get isLoaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    medRemindersNote = prefs.getBool('${prefix}med_reminders_note') ?? true;
    showBp = prefs.getBool('${prefix}show_bp') ?? true;
    showGlucose = prefs.getBool('${prefix}show_glucose') ?? true;
    showSymptoms = prefs.getBool('${prefix}show_symptoms') ?? true;
    showPain = prefs.getBool('${prefix}show_pain') ?? true;
    showSleep = prefs.getBool('${prefix}show_sleep') ?? true;
    showSeizure = prefs.getBool('${prefix}show_seizure') ?? true;
    showAllergies = prefs.getBool('${prefix}show_allergies') ?? true;
    showDocuments = prefs.getBool('${prefix}show_documents') ?? true;
    _loaded = true;
    notifyListeners();
  }

  Future<void> reload() => load();
}
