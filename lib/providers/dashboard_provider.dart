import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/affirmations/affirmation_library.dart';
import '../models/colour_mood.dart';
import 'support_preset_provider.dart';
import '../services/notification_hold_service.dart';

class DashboardProvider extends ChangeNotifier {
  static const _moodKey = 'dashboard_colour_mood';
  static const _capacityKey = 'dashboard_capacity';
  static const _affirmationsSourceKey = 'affirmations_source';
  static const _affirmationsFrequencyKey = 'affirmations_frequency';
  static const _affirmationsShownKey = 'affirmations_shown_date';

  String _statusShield = 'Open to leads';
  DateTime? _statusShieldExpiry;
  int _heldNotificationCount = 0;
  String _affirmation = AffirmationLibrary.builtIn.first;
  String _affirmationsSource = 'built_in';
  String _affirmationsFrequency = 'daily';
  String? _affirmationsShownDate;
  ColourMood _mood = ColourMood.green;
  double _capacity = 70;
  bool _loaded = false;
  SupportPresetProvider? _presets;

  String get statusShield => _statusShield;
  DateTime? get statusShieldExpiry => _statusShieldExpiry;
  int get heldNotificationCount => _heldNotificationCount;
  String get affirmation => _affirmation;
  String get affirmationsSource => _affirmationsSource;
  String get affirmationsFrequency => _affirmationsFrequency;
  bool get showAffirmation => _affirmationsFrequency != 'off';
  bool get isHeadsDown => _statusShield == 'Heads down today';
  ColourMood get mood => _mood;
  double get capacity => _capacity;
  bool get isLoaded => _loaded;

  /// Affirmation adjusted for mood / low capacity (local heuristics).
  String get displayAffirmation {
    if (_mood == ColourMood.red || _mood == ColourMood.black) {
      return 'One thing at a time. That\'s enough.';
    }
    if (_capacity <= 30) {
      return 'Rest is productive.';
    }
    if (_mood == ColourMood.orange) {
      return 'You\'re allowed to take it gently today.';
    }
    return _affirmation;
  }

  bool get minimiseDashboard =>
      _mood == ColourMood.red ||
      _mood == ColourMood.black ||
      _mood == ColourMood.sparkle;

  bool get bareMinimumsOnly =>
      _mood == ColourMood.orange ||
      _mood == ColourMood.red ||
      _mood == ColourMood.brown ||
      _capacity <= 30;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _mood = ColourMoodX.fromId(prefs.getString(_moodKey));
    _capacity = prefs.getDouble(_capacityKey) ?? 70;
    _affirmationsSource = prefs.getString(_affirmationsSourceKey) ?? 'built_in';
    _affirmationsFrequency = prefs.getString(_affirmationsFrequencyKey) ?? 'daily';
    _affirmationsShownDate = prefs.getString(_affirmationsShownKey);
    _affirmation = AffirmationLibrary.pickForDay(source: _affirmationsSource);
    _loaded = true;
    notifyListeners();
  }

  Future<void> reloadAffirmationPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _affirmationsSource = prefs.getString(_affirmationsSourceKey) ?? 'built_in';
    _affirmationsFrequency = prefs.getString(_affirmationsFrequencyKey) ?? 'daily';
    _affirmation = AffirmationLibrary.pickForDay(source: _affirmationsSource);
    notifyListeners();
  }

  /// Call when dashboard opens — honours "on open" frequency.
  Future<void> markAffirmationShown() async {
    if (_affirmationsFrequency != 'on_open') return;
    final today = _todayKey();
    if (_affirmationsShownDate == today) return;
    _affirmationsShownDate = today;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_affirmationsShownKey, today);
  }

  bool get shouldShowAffirmationOnOpen {
    if (!showAffirmation) return false;
    if (_affirmationsFrequency == 'daily') return true;
    if (_affirmationsFrequency == 'on_open') {
      return _affirmationsShownDate != _todayKey();
    }
    return false;
  }

  static String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  void attachPresets(SupportPresetProvider presets) {
    _presets = presets;
  }

  Future<void> setMood(ColourMood mood) async {
    _mood = mood;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_moodKey, mood.id);
    if (mood == ColourMood.red ||
        mood == ColourMood.black ||
        mood == ColourMood.sparkle) {
      setHeadsDownFromCurrentState(true);
    }
    _refreshHeldCount();
    notifyListeners();
  }

  Future<void> setCapacity(double value) async {
    _capacity = value.clamp(0, 100);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_capacityKey, _capacity);
    notifyListeners();
  }

  void toggleStatusShield() {
    if (_statusShield == 'Open to leads') {
      _statusShield = 'Heads down today';
      final now = DateTime.now();
      final hoursLeft = now.hour < 12 ? 12 - now.hour : 24 - now.hour;
      _statusShieldExpiry = now.add(Duration(hours: hoursLeft > 0 ? hoursLeft : 12));
    } else {
      _statusShield = 'Open to leads';
      _statusShieldExpiry = null;
    }
    _refreshHeldCount();
    notifyListeners();
  }

  void setHeadsDownFromCurrentState(bool headsDown) {
    if (headsDown == isHeadsDown) return;
    if (headsDown) {
      _statusShield = 'Heads down today';
      final now = DateTime.now();
      final hoursLeft = now.hour < 12 ? 12 - now.hour : 24 - now.hour;
      _statusShieldExpiry = now.add(Duration(hours: hoursLeft > 0 ? hoursLeft : 12));
    } else {
      _statusShield = 'Open to leads';
      _statusShieldExpiry = null;
    }
    _refreshHeldCount();
    notifyListeners();
  }

  void _refreshHeldCount() {
    _heldNotificationCount = NotificationHoldService.estimateHeldCount(
      headsDown: isHeadsDown,
      presets: _presets,
    );
  }

  void refreshNotificationHold() {
    _refreshHeldCount();
    notifyListeners();
  }

  void setAffirmation(String text) {
    _affirmation = text;
    notifyListeners();
  }

  static String timeGreeting({String name = 'Beth'}) {
    final hour = DateTime.now().hour;
    final part = hour < 12
        ? 'Good morning'
        : hour < 17
            ? 'Good afternoon'
            : 'Good evening';
    return '$part, $name';
  }
}
