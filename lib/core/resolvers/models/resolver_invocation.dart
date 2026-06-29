class ResolverInvocation {
  final String invocationId;
  final String? stateRecordId;
  final String resolverName;
  final String triggerTimestamp;
  final int? executionDurationMs;
  final String? decisionId;
  final double? confidence;
  final Map<String, dynamic>? metadata;

  const ResolverInvocation({
    required this.invocationId,
    this.stateRecordId,
    required this.resolverName,
    required this.triggerTimestamp,
    this.executionDurationMs,
    this.decisionId,
    this.confidence,
    this.metadata,
  });

  Map<String, dynamic> toJson() {
    return {
      'invocationId': invocationId,
      'stateRecordId': stateRecordId,
      'resolverName': resolverName,
      'triggerTimestamp': triggerTimestamp,
      'executionDurationMs': executionDurationMs,
      'decisionId': decisionId,
      'confidence': confidence,
      'metadata': metadata,
    };
  }

  factory ResolverInvocation.fromJson(Map<String, dynamic> json) {
    return ResolverInvocation(
      invocationId: json['invocationId'] ?? '',
      stateRecordId: json['stateRecordId'],
      resolverName: json['resolverName'] ?? '',
      triggerTimestamp: json['triggerTimestamp'] ?? '',
      executionDurationMs: json['executionDurationMs'],
      decisionId: json['decisionId'],
      confidence: json['confidence'],
      metadata: json['metadata'] != null
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }
}