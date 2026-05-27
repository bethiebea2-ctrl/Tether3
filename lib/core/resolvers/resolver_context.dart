import '../../models/support_preset.dart';
import '../enums/shared_enums.dart';

/// The runtime context passed to every resolver rule.
///
/// This object is immutable and contains everything a resolver rule
/// needs to evaluate: what presets are active, what toggles are on,
/// what state the user is in, what notification mode they're using,
/// and what accessibility settings are enabled.
///
/// Rules read from this context. They do NOT modify it.
class ResolverContext {
  /// Active support presets (e.g. ADHD support, Low-Stimulation)
  final List<SupportPreset> activePresets;

  /// Active current states (e.g. Overwhelmed, Low Energy)
  final List<String> activeStateIds;

  /// Active sensitivity toggle IDs
  final List<String> activeToggleIds;

  /// Current notification mode
  final NotificationMode notificationMode;

  /// Accessibility: reduce motion
  final bool reduceMotion;

  /// Accessibility / sensitivity: reduce notifications
  final bool reduceNotifications;

  /// Accessibility / sensitivity: low stimulus mode
  final bool lowStimulusMode;

  /// Current time for time-based rules
  final DateTime currentTime;

  const ResolverContext({
    this.activePresets = const [],
    this.activeStateIds = const [],
    this.activeToggleIds = const [],
    this.notificationMode = NotificationMode.hybrid,
    this.reduceMotion = false,
    this.reduceNotifications = false,
    this.lowStimulusMode = false,
    required this.currentTime,
  });

  /// Quick check: is any overwhelm-related state active?
  bool get isOverwhelmed =>
      activeStateIds.any((id) =>
          id == 'overwhelmed' || id == 'panicking' || id == 'shutdown_meltdown');

  /// Quick check: is any low-energy state active?
  bool get isLowEnergy =>
      activeStateIds.any((id) =>
          id == 'low_energy' || id == 'sleep_deprived' || id == 'flare_day');

  /// Quick check: is the user in any kind of reduced-capacity state?
  bool get isReducedCapacity => isOverwhelmed || isLowEnergy;

  /// Quick check: are notifications suppressed by any toggle or state?
  bool get notificationsSuppressed =>
      reduceNotifications ||
      activeToggleIds.contains('reduce_notifications') ||
      isOverwhelmed;
}