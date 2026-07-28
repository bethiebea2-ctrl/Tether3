import 'package:flutter/material.dart';
import 'support_preset_provider.dart';
import '../services/notification_hold_service.dart';

class DashboardProvider extends ChangeNotifier {
  String _statusShield = 'Open to leads';
  DateTime? _statusShieldExpiry;
  int _heldNotificationCount = 0;
  String _affirmation = 'You have everything you need for today.';
  SupportPresetProvider? _presets;

  String get statusShield => _statusShield;
  DateTime? get statusShieldExpiry => _statusShieldExpiry;
  int get heldNotificationCount => _heldNotificationCount;
  String get affirmation => _affirmation;
  bool get isHeadsDown => _statusShield == 'Heads down today';

  void attachPresets(SupportPresetProvider presets) {
    _presets = presets;
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

  void _refreshHeldCount() {
    _heldNotificationCount = NotificationHoldService.estimateHeldCount(
      headsDown: isHeadsDown,
      presets: _presets,
    );
  }

  void refreshNotificationHold() => _refreshHeldCount();

  void setAffirmation(String text) {
    _affirmation = text;
    notifyListeners();
  }
}
