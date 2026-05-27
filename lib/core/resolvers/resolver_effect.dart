import '../enums/shared_enums.dart';

/// The output of a resolver rule.
///
/// A rule evaluates the context and a target, then produces an effect.
/// The effect tells the system what to do: show or suppress, make sound
/// or stay silent, deliver immediately or digest later.
///
/// Effects are immutable. They describe what should happen, not how.
class ResolverEffect {
  /// What decision was made
  final ResolverDecision decision;

  /// Should a visual notification be shown?
  final bool showNotification;

  /// Should sound be played?
  final bool suppressSound;

  /// Should vibration be suppressed?
  final bool suppressVibration;

  /// Should this only appear in the digest, not immediately?
  final bool digestOnly;

  /// Human-readable reason for the decision (for debugging/audit)
  final String? reason;

  const ResolverEffect({
    required this.decision,
    required this.showNotification,
    required this.suppressSound,
    required this.suppressVibration,
    required this.digestOnly,
    this.reason,
  });

  /// Default: allow everything normally
  static const allow = ResolverEffect(
    decision: ResolverDecision.allow,
    showNotification: true,
    suppressSound: false,
    suppressVibration: false,
    digestOnly: false,
    reason: 'No rules matched. Allowing normally.',
  );

  /// Suppress everything — silent, no notification, digest only
  static const suppressAll = ResolverEffect(
    decision: ResolverDecision.suppress,
    showNotification: false,
    suppressSound: true,
    suppressVibration: true,
    digestOnly: true,
    reason: 'Suppressed by resolver rule.',
  );

  /// Digest only — no immediate notification, but include in summary
  static const digestOnlyEffect = ResolverEffect(
    decision: ResolverDecision.digest,
    showNotification: false,
    suppressSound: true,
    suppressVibration: true,
    digestOnly: true,
    reason: 'Routed to digest.',
  );
}