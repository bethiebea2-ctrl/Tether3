import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/state_record.dart';
import 'models/state_transition.dart';

class StateHistoryService {
  static const _stateKey = 'state_history';
  static const _transitionKey = 'state_transitions';

  String? _lastKnownState;

  Future<void> saveState(StateRecord record) async {
    final prefs = await SharedPreferences.getInstance();

    // Persist state record
    final existing = prefs.getStringList(_stateKey) ?? [];
    existing.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_stateKey, existing);

    // Record transition if state changed
    if (_lastKnownState != null && _lastKnownState != record.stateName) {
      final transition = StateTransition(
        fromState: _lastKnownState!,
        toState: record.stateName,
        timestamp: record.timestamp,
        triggerEvent: record.originEventId,
      );
      await _saveTransition(transition, prefs);
    }

    _lastKnownState = record.stateName;
  }

  Future<void> _saveTransition(
    StateTransition transition,
    SharedPreferences prefs,
  ) async {
    final existing = prefs.getStringList(_transitionKey) ?? [];
    existing.add(jsonEncode(transition.toJson()));
    await prefs.setStringList(_transitionKey, existing);
  }

  Future<List<StateRecord>> loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_stateKey) ?? [];
    return data
        .map((e) => StateRecord.fromJson(jsonDecode(e)))
        .toList();
  }

  Future<List<StateTransition>> loadTransitions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_transitionKey) ?? [];
    return data
        .map((e) => StateTransition.fromJson(jsonDecode(e)))
        .toList();
  }
}