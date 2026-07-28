import '../core/resolvers/notification_resolver.dart';
import '../core/resolvers/notification_resolver_target.dart';
import '../core/resolvers/resolver_context.dart';
import '../core/resolvers/resolver_engine.dart';
import '../core/resolvers/rule_registry.dart';
import '../core/enums/shared_enums.dart';
import '../providers/support_preset_provider.dart';

/// Estimates how many non-urgent notifications would be held under current context.
class NotificationHoldService {
  static final NotificationResolver _resolver = NotificationResolver(
    engine: ResolverEngine(rules: RuleRegistry.rules),
  );

  static int estimateHeldCount({
    required bool headsDown,
    SupportPresetProvider? presets,
  }) {
    final context = ResolverContext(
      activeStateIds: headsDown ? ['overwhelmed'] : [],
      activeToggleIds: presets?.activeToggleIds.toList() ?? [],
      notificationMode: NotificationMode.hybrid,
      reduceNotifications: presets?.reduceNotifications ?? false,
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
