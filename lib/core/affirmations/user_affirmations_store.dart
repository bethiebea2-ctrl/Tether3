import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// User-authored affirmations saved locally (Phase 2C).
class UserAffirmationsStore {
  static const _key = 'user_affirmations_v1';

  static Future<List<String>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List) return [];
      return decoded
          .map((e) => e.toString().trim())
          .where((s) => s.isNotEmpty)
          .toList();
    } catch (_) {
      return [];
    }
  }

  static Future<void> save(List<String> items) async {
    final cleaned = items.map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(cleaned));
  }
}
