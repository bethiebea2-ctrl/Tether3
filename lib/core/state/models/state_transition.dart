class StateTransition {
  final String fromState;
  final String toState;
  final String timestamp;
  final String? triggerEvent;
  final String? resolverDecisionId;
  final int? durationMs;

  const StateTransition({
    required this.fromState,
    required this.toState,
    required this.timestamp,
    this.triggerEvent,
    this.resolverDecisionId,
    this.durationMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'fromState': fromState,
      'toState': toState,
      'timestamp': timestamp,
      'triggerEvent': triggerEvent,
      'resolverDecisionId': resolverDecisionId,
      'durationMs': durationMs,
    };
  }

  factory StateTransition.fromJson(Map<String, dynamic> json) {
    return StateTransition(
      fromState: json['fromState'] ?? '',
      toState: json['toState'] ?? '',
      timestamp: json['timestamp'] ?? '',
      triggerEvent: json['triggerEvent'],
      resolverDecisionId: json['resolverDecisionId'],
      durationMs: json['durationMs'],
    );
  }
}