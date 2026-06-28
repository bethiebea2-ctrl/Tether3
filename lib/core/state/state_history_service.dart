import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models/state_record.dart';

class StateHistoryService {
  static const _key = 'state_history';

  Future<void> saveState(StateRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_key) ?? [];
    existing.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_key, existing);
  }

  Future<List<StateRecord>> loadStates() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data
        .map((e) => StateRecord.fromJson(jsonDecode(e)))
        .toList();
  }
}