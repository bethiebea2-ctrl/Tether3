import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Health Status defaults (Phase 1D) — local SharedPreferences.
class HealthStatusSettingsScreen extends StatefulWidget {
  const HealthStatusSettingsScreen({super.key});

  @override
  State<HealthStatusSettingsScreen> createState() =>
      _HealthStatusSettingsScreenState();
}

class _HealthStatusSettingsScreenState extends State<HealthStatusSettingsScreen> {
  static const _prefix = 'health_status_prefs_';

  bool _loaded = false;
  bool _medRemindersNote = true;
  bool _showBp = true;
  bool _showGlucose = true;
  bool _showSymptoms = true;
  bool _showPain = true;
  bool _showSleep = true;
  bool _showSeizure = true;
  bool _showAllergies = true;
  bool _showDocuments = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _medRemindersNote = prefs.getBool('${_prefix}med_reminders_note') ?? true;
      _showBp = prefs.getBool('${_prefix}show_bp') ?? true;
      _showGlucose = prefs.getBool('${_prefix}show_glucose') ?? true;
      _showSymptoms = prefs.getBool('${_prefix}show_symptoms') ?? true;
      _showPain = prefs.getBool('${_prefix}show_pain') ?? true;
      _showSleep = prefs.getBool('${_prefix}show_sleep') ?? true;
      _showSeizure = prefs.getBool('${_prefix}show_seizure') ?? true;
      _showAllergies = prefs.getBool('${_prefix}show_allergies') ?? true;
      _showDocuments = prefs.getBool('${_prefix}show_documents') ?? true;
      _loaded = true;
    });
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$key', value);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Health Status settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Health Status settings')),
      body: ListView(
        children: [
          _header('Reminders'),
          SwitchListTile(
            title: const Text('Medication reminders'),
            subtitle: const Text(
              'Note only for Phase 1D — local notifications ship later. '
              'When on, Health Status treats reminders as desired.',
            ),
            value: _medRemindersNote,
            onChanged: (v) async {
              setState(() => _medRemindersNote = v);
              await _setBool('med_reminders_note', v);
            },
          ),
          _header('Tracker visibility'),
          CheckboxListTile(
            title: const Text('Blood pressure'),
            value: _showBp,
            onChanged: (v) async {
              setState(() => _showBp = v ?? true);
              await _setBool('show_bp', _showBp);
            },
          ),
          CheckboxListTile(
            title: const Text('Glucose'),
            value: _showGlucose,
            onChanged: (v) async {
              setState(() => _showGlucose = v ?? true);
              await _setBool('show_glucose', _showGlucose);
            },
          ),
          CheckboxListTile(
            title: const Text('Symptoms'),
            value: _showSymptoms,
            onChanged: (v) async {
              setState(() => _showSymptoms = v ?? true);
              await _setBool('show_symptoms', _showSymptoms);
            },
          ),
          CheckboxListTile(
            title: const Text('Pain'),
            value: _showPain,
            onChanged: (v) async {
              setState(() => _showPain = v ?? true);
              await _setBool('show_pain', _showPain);
            },
          ),
          CheckboxListTile(
            title: const Text('Sleep'),
            value: _showSleep,
            onChanged: (v) async {
              setState(() => _showSleep = v ?? true);
              await _setBool('show_sleep', _showSleep);
            },
          ),
          CheckboxListTile(
            title: const Text('Seizure log'),
            value: _showSeizure,
            onChanged: (v) async {
              setState(() => _showSeizure = v ?? true);
              await _setBool('show_seizure', _showSeizure);
            },
          ),
          CheckboxListTile(
            title: const Text('Allergies'),
            value: _showAllergies,
            onChanged: (v) async {
              setState(() => _showAllergies = v ?? true);
              await _setBool('show_allergies', _showAllergies);
            },
          ),
          CheckboxListTile(
            title: const Text('Documents'),
            value: _showDocuments,
            onChanged: (v) async {
              setState(() => _showDocuments = v ?? true);
              await _setBool('show_documents', _showDocuments);
            },
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title,
        style: BethTypography.caption.copyWith(color: BethColours.textMuted),
      ),
    );
  }
}
