import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Local-only settings preferences for Phase 1B (SharedPreferences).
class SettingsPrefsProvider extends ChangeNotifier {
  static const _prefix = 'settings_prefs_';

  bool _loaded = false;
  bool get isLoaded => _loaded;

  // ── Current State ──────────────────────────────────────────
  String? currentStateId;
  String currentStateTimer = 'until_off'; // until_off | 2h | 4h | rest_of_day

  // ── Sensitivity toggles ────────────────────────────────────
  final Set<String> sensitivityToggleIds = {};

  // ── Accessibility ──────────────────────────────────────────
  final Set<String> accessibilityToggleIds = {};
  String fontSize = 'medium';

  // ── Calendar ───────────────────────────────────────────────
  String calendarDefaultView = 'week'; // month | week | day | agenda
  String weekStartsOn = 'monday'; // monday | sunday
  bool warnOverlap = true;
  bool blockOverlap = false;
  bool showCyclePhases = true;
  String bufferMinutes = '15';

  // ── Notifications ──────────────────────────────────────────
  String deliveryMode = 'hybrid'; // realtime | digest | hybrid
  bool quietHoursEnabled = true;
  String quietHoursStart = '21:00';
  String quietHoursEnd = '07:00';
  bool allowUrgentDuringQuiet = true;
  bool urgentBypass = true;
  final Set<String> notificationTypes = {
    'calendar',
    'tasks',
    'medication',
    'family',
    'budget',
  };

  // ── Status Shield ──────────────────────────────────────────
  String shieldDefault = 'open'; // open | heads_down
  String shieldExpiry = 'rest_of_day'; // rest_of_day | custom | until_off
  bool shieldVoiceCommands = true;
  bool shieldShareHousehold = true;

  // ── Family Hub defaults ────────────────────────────────────
  final Set<String> childDefaultFeatures = {
    'medication',
    'calendar',
    'tasks',
  };
  final Set<String> petDefaultFeatures = {
    'care',
    'medication',
    'vet',
    'supplies',
  };
  String householdName = '';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    currentStateId = prefs.getString('${_prefix}current_state_id');
    currentStateTimer = prefs.getString('${_prefix}current_state_timer') ?? 'until_off';
    sensitivityToggleIds
      ..clear()
      ..addAll(prefs.getStringList('${_prefix}sensitivity') ?? const []);
    accessibilityToggleIds
      ..clear()
      ..addAll(prefs.getStringList('${_prefix}accessibility') ?? const []);
    fontSize = prefs.getString('${_prefix}font_size') ?? 'medium';
    calendarDefaultView = prefs.getString('${_prefix}cal_view') ?? 'week';
    weekStartsOn = prefs.getString('${_prefix}week_start') ?? 'monday';
    warnOverlap = prefs.getBool('${_prefix}warn_overlap') ?? true;
    blockOverlap = prefs.getBool('${_prefix}block_overlap') ?? false;
    showCyclePhases = prefs.getBool('${_prefix}cycle_phases') ?? true;
    bufferMinutes = prefs.getString('${_prefix}buffer') ?? '15';
    deliveryMode = prefs.getString('${_prefix}delivery') ?? 'hybrid';
    quietHoursEnabled = prefs.getBool('${_prefix}quiet_on') ?? true;
    quietHoursStart = prefs.getString('${_prefix}quiet_start') ?? '21:00';
    quietHoursEnd = prefs.getString('${_prefix}quiet_end') ?? '07:00';
    allowUrgentDuringQuiet = prefs.getBool('${_prefix}quiet_urgent') ?? true;
    urgentBypass = prefs.getBool('${_prefix}urgent_bypass') ?? true;
    notificationTypes
      ..clear()
      ..addAll(prefs.getStringList('${_prefix}notif_types') ??
          ['calendar', 'tasks', 'medication', 'family', 'budget']);
    shieldDefault = prefs.getString('${_prefix}shield_default') ?? 'open';
    shieldExpiry = prefs.getString('${_prefix}shield_expiry') ?? 'rest_of_day';
    shieldVoiceCommands = prefs.getBool('${_prefix}shield_voice') ?? true;
    shieldShareHousehold = prefs.getBool('${_prefix}shield_share') ?? true;
    childDefaultFeatures
      ..clear()
      ..addAll(prefs.getStringList('${_prefix}child_defaults') ??
          ['medication', 'calendar', 'tasks']);
    petDefaultFeatures
      ..clear()
      ..addAll(prefs.getStringList('${_prefix}pet_defaults') ??
          ['care', 'medication', 'vet', 'supplies']);
    householdName = prefs.getString('${_prefix}household_name') ?? '';
    _loaded = true;
    notifyListeners();
  }

  Future<void> _setString(String key, String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value == null) {
      await prefs.remove('$_prefix$key');
    } else {
      await prefs.setString('$_prefix$key', value);
    }
  }

  Future<void> _setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('$_prefix$key', value);
  }

  Future<void> _setList(String key, Iterable<String> values) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('$_prefix$key', values.toList());
  }

  Future<void> setCurrentState(String? id) async {
    currentStateId = id;
    await _setString('current_state_id', id);
    notifyListeners();
  }

  Future<void> setCurrentStateTimer(String timer) async {
    currentStateTimer = timer;
    await _setString('current_state_timer', timer);
    notifyListeners();
  }

  Future<void> toggleSensitivity(String id) async {
    if (sensitivityToggleIds.contains(id)) {
      sensitivityToggleIds.remove(id);
    } else {
      sensitivityToggleIds.add(id);
    }
    await _setList('sensitivity', sensitivityToggleIds);
    notifyListeners();
  }

  Future<void> mergeSensitivity(Iterable<String> ids) async {
    sensitivityToggleIds.addAll(ids);
    await _setList('sensitivity', sensitivityToggleIds);
    notifyListeners();
  }

  Future<void> replaceSensitivity(Iterable<String> ids) async {
    sensitivityToggleIds
      ..clear()
      ..addAll(ids);
    await _setList('sensitivity', sensitivityToggleIds);
    notifyListeners();
  }

  Future<void> resetSensitivity() async {
    sensitivityToggleIds.clear();
    await _setList('sensitivity', sensitivityToggleIds);
    notifyListeners();
  }

  bool isSensitivityOn(String id) => sensitivityToggleIds.contains(id);

  Future<void> toggleAccessibility(String id) async {
    if (accessibilityToggleIds.contains(id)) {
      accessibilityToggleIds.remove(id);
    } else {
      accessibilityToggleIds.add(id);
    }
    await _setList('accessibility', accessibilityToggleIds);
    notifyListeners();
  }

  Future<void> resetAccessibility() async {
    accessibilityToggleIds.clear();
    fontSize = 'medium';
    await _setList('accessibility', accessibilityToggleIds);
    await _setString('font_size', fontSize);
    notifyListeners();
  }

  bool isAccessibilityOn(String id) => accessibilityToggleIds.contains(id);

  Future<void> setFontSize(String size) async {
    fontSize = size;
    await _setString('font_size', size);
    notifyListeners();
  }

  Future<void> setCalendarDefaultView(String view) async {
    calendarDefaultView = view;
    await _setString('cal_view', view);
    notifyListeners();
  }

  Future<void> setWeekStartsOn(String day) async {
    weekStartsOn = day;
    await _setString('week_start', day);
    notifyListeners();
  }

  Future<void> setWarnOverlap(bool v) async {
    warnOverlap = v;
    await _setBool('warn_overlap', v);
    notifyListeners();
  }

  Future<void> setBlockOverlap(bool v) async {
    blockOverlap = v;
    await _setBool('block_overlap', v);
    notifyListeners();
  }

  Future<void> setShowCyclePhases(bool v) async {
    showCyclePhases = v;
    await _setBool('cycle_phases', v);
    notifyListeners();
  }

  Future<void> setBufferMinutes(String v) async {
    bufferMinutes = v;
    await _setString('buffer', v);
    notifyListeners();
  }

  Future<void> setDeliveryMode(String mode) async {
    deliveryMode = mode;
    await _setString('delivery', mode);
    notifyListeners();
  }

  Future<void> setQuietHoursEnabled(bool v) async {
    quietHoursEnabled = v;
    await _setBool('quiet_on', v);
    notifyListeners();
  }

  Future<void> setAllowUrgentDuringQuiet(bool v) async {
    allowUrgentDuringQuiet = v;
    await _setBool('quiet_urgent', v);
    notifyListeners();
  }

  Future<void> setUrgentBypass(bool v) async {
    urgentBypass = v;
    await _setBool('urgent_bypass', v);
    notifyListeners();
  }

  Future<void> toggleNotificationType(String id) async {
    if (notificationTypes.contains(id)) {
      notificationTypes.remove(id);
    } else {
      notificationTypes.add(id);
    }
    await _setList('notif_types', notificationTypes);
    notifyListeners();
  }

  Future<void> setShieldDefault(String v) async {
    shieldDefault = v;
    await _setString('shield_default', v);
    notifyListeners();
  }

  Future<void> setShieldExpiry(String v) async {
    shieldExpiry = v;
    await _setString('shield_expiry', v);
    notifyListeners();
  }

  Future<void> setShieldVoiceCommands(bool v) async {
    shieldVoiceCommands = v;
    await _setBool('shield_voice', v);
    notifyListeners();
  }

  Future<void> setShieldShareHousehold(bool v) async {
    shieldShareHousehold = v;
    await _setBool('shield_share', v);
    notifyListeners();
  }

  Future<void> toggleChildDefault(String id) async {
    if (childDefaultFeatures.contains(id)) {
      childDefaultFeatures.remove(id);
    } else {
      childDefaultFeatures.add(id);
    }
    await _setList('child_defaults', childDefaultFeatures);
    notifyListeners();
  }

  Future<void> togglePetDefault(String id) async {
    if (petDefaultFeatures.contains(id)) {
      petDefaultFeatures.remove(id);
    } else {
      petDefaultFeatures.add(id);
    }
    await _setList('pet_defaults', petDefaultFeatures);
    notifyListeners();
  }

  Future<void> setHouseholdName(String name) async {
    householdName = name;
    await _setString('household_name', name);
    notifyListeners();
  }
}
