class ResolverDecisionRecord {
  final String id;
  final String resolverTarget;
  final String sessionId;
  final String? originEventId;
  final String? winningRuleId;
  final String finalDecision;
  final DateTime timestamp;

  const ResolverDecisionRecord({
    required this.id,
    required this.resolverTarget,
    required this.sessionId,
    required this.finalDecision,
    required this.timestamp,
    this.originEventId,
    this.winningRuleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'resolverTarget': resolverTarget,
      'sessionId': sessionId,
      'originEventId': originEventId,
      'winningRuleId': winningRuleId,
      'finalDecision': finalDecision,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ResolverDecisionRecord.fromJson(Map<String, dynamic> json) {
    return ResolverDecisionRecord(
      id: json['id'],
      resolverTarget: json['resolverTarget'],
      sessionId: json['sessionId'],
      originEventId: json['originEventId'],
      winningRuleId: json['winningRuleId'],
      finalDecision: json['finalDecision'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
}