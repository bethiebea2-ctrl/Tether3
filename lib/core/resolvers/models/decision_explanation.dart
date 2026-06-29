class DecisionExplanation {
  final String decisionId;
  final String reason;
  final double confidence;
  final List<String> triggeredRules;
  final List<String> supportingEvents;
  final String? recommendation;
  final String timestamp;

  const DecisionExplanation({
    required this.decisionId,
    required this.reason,
    required this.confidence,
    this.triggeredRules = const [],
    this.supportingEvents = const [],
    this.recommendation,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'decisionId': decisionId,
      'reason': reason,
      'confidence': confidence,
      'triggeredRules': triggeredRules,
      'supportingEvents': supportingEvents,
      'recommendation': recommendation,
      'timestamp': timestamp,
    };
  }

  factory DecisionExplanation.fromJson(Map<String, dynamic> json) {
    return DecisionExplanation(
      decisionId: json['decisionId'] ?? '',
      reason: json['reason'] ?? '',
      confidence: (json['confidence'] ?? 0.0).toDouble(),
      triggeredRules: List<String>.from(json['triggeredRules'] ?? []),
      supportingEvents: List<String>.from(json['supportingEvents'] ?? []),
      recommendation: json['recommendation'],
      timestamp: json['timestamp'] ?? '',
    );
  }
}