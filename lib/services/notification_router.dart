import '../core/enums/shared_enums.dart';
import '../core/resolvers/notification_resolver.dart';
import '../core/resolvers/notification_resolver_target.dart';
import '../core/resolvers/resolver_context.dart';
import '../core/resolvers/resolver_engine.dart';
import '../core/resolvers/rule_registry.dart';
import '../providers/settings_prefs_provider.dart';
import '../providers/support_preset_provider.dart';

enum NotificationTier { urgent, important, forLater }

/// Phase 1D hybrid notification routing.
class NotificationRouter {
  static final NotificationResolver _resolver = NotificationResolver(
    engine: ResolverEngine(rules: RuleRegistry.rules),
  );

  /// Returns whether to show now, hold for digest, or suppress.
  static ({bool showNow, bool digestOnly, bool suppressed}) route({
    required NotificationTier tier,
    required SettingsPrefsProvider prefs,
    SupportPresetProvider? presets,
    bool headsDown = false,
    String? colourMood,
  }) {
    final reduce = presets?.reduceNotifications == true ||
        prefs.isSensitivityOn('reduce_notifications');
    final mode = prefs.deliveryMode;

    // Status shield / colour card / current state suppress non-urgent
    final protectiveState = headsDown ||
        prefs.currentStateId == 'overwhelmed' ||
        prefs.currentStateId == 'panicking' ||
        prefs.currentStateId == 'shutdown' ||
        colourMood == 'red' ||
        colourMood == 'black';

    if (tier == NotificationTier.urgent) {
      if (prefs.quietHoursEnabled && _inQuietHours(prefs) && !prefs.allowUrgentDuringQuiet) {
        return (showNow: false, digestOnly: true, suppressed: false);
      }
      return (showNow: true, digestOnly: false, suppressed: false);
    }

    if (protectiveState && tier != NotificationTier.urgent) {
      return (showNow: false, digestOnly: tier == NotificationTier.important, suppressed: tier == NotificationTier.forLater);
    }

    if (mode == 'realtime') {
      return (showNow: true, digestOnly: false, suppressed: false);
    }
    if (mode == 'digest') {
      return (showNow: false, digestOnly: true, suppressed: false);
    }

    // Hybrid default
    if (tier == NotificationTier.important) {
      if (reduce || prefs.isSensitivityOn('digest_mode')) {
        return (showNow: false, digestOnly: true, suppressed: false);
      }
      return (showNow: true, digestOnly: false, suppressed: false);
    }

    // For later
    return (showNow: false, digestOnly: true, suppressed: false);
  }

  static bool _inQuietHours(SettingsPrefsProvider prefs) {
    try {
      final now = TimeOfDay.fromDateTime(DateTime.now());
      final startParts = prefs.quietHoursStart.split(':');
      final endParts = prefs.quietHoursEnd.split(':');
      final start = TimeOfDay(hour: int.parse(startParts[0]), minute: int.parse(startParts[1]));
      final end = TimeOfDay(hour: int.parse(endParts[0]), minute: int.parse(endParts[1]));
      final nowMins = now.hour * 60 + now.minute;
      final startMins = start.hour * 60 + start.minute;
      final endMins = end.hour * 60 + end.minute;
      if (startMins <= endMins) {
        return nowMins >= startMins && nowMins < endMins;
      }
      return nowMins >= startMins || nowMins < endMins;
    } catch (_) {
      return false;
    }
  }

  static int estimateHeldCount({
    required bool headsDown,
    SupportPresetProvider? presets,
    SettingsPrefsProvider? prefs,
  }) {
    final context = ResolverContext(
      activeStateIds: headsDown ? ['overwhelmed'] : [],
      activeToggleIds: presets?.activeToggleIds.toList() ??
          prefs?.sensitivityToggleIds.toList() ??
          [],
      notificationMode: NotificationMode.hybrid,
      reduceNotifications: presets?.reduceNotifications ??
          prefs?.isSensitivityOn('reduce_notifications') ??
          false,
      currentTime: DateTime.now(),
    );

    const sampleUrgencies = ['low', 'normal', 'normal', 'low', 'normal'];
    var held = 0;
    for (var i = 0; i < sampleUrgencies.length; i++) {
      final result = _resolver.resolveNotification(
        context: context,
        target: NotificationResolverTarget(id: 'sample_$i', urgency: sampleUrgencies[i]),
      );
      if (!result.effect.showNotification || result.effect.digestOnly) {
        held++;
      }
    }
    return held;
  }
}

// Avoid importing material for TimeOfDay in a service file — use simple int parse above.
class TimeOfDay {
  final int hour;
  final int minute;
  const TimeOfDay({required this.hour, required this.minute});
  factory TimeOfDay.fromDateTime(DateTime dt) => TimeOfDay(hour: dt.hour, minute: dt.minute);
}
