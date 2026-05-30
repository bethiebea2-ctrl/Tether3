import 'dart:convert';

class ResolverDecisionRecord {
  final String decisionId;
  final String timestamp;
  final String target;
  final String winningRuleId;
  final String winningRuleName;
  final String effect;
  final int traceCount;
  final String? sessionId;
  final String? originEventId;

  const ResolverDecisionRecord({
    required this.decisionId,
    required this.timestamp,
    required this.target,
    required this.winningRuleId,
    required this.winningRuleName,
    required this.effect,
    required this.traceCount,
    this.sessionId,
    this.originEventId,
  });

  Map<String, dynamic> toJson() {
    return {
      'decisionId': decisionId,
      'timestamp': timestamp,
      'target': target,
      'winningRuleId': winningRuleId,
      'winningRuleName': winningRuleName,
      'effect': effect,
      'traceCount': traceCount,
      'sessionId': sessionId,
      'originEventId': originEventId,
    };
  }

  factory ResolverDecisionRecord.fromJson(Map<String, dynamic> json) {
    return ResolverDecisionRecord(
      decisionId: json['decisionId'] ?? '',
      timestamp: json['timestamp'] ?? '',
      target: json['target'] ?? '',
      winningRuleId: json['winningRuleId'] ?? '',
      winningRuleName: json['winningRuleName'] ?? '',
      effect: json['effect'] ?? '',
      traceCount: json['traceCount'] ?? 0,
      sessionId: json['sessionId'],
      originEventId: json['originEventId'],
    );
  }

  String encode() => jsonEncode(toJson());

  factory ResolverDecisionRecord.decode(String source) {
    return ResolverDecisionRecord.fromJson(jsonDecode(source));
  }
}