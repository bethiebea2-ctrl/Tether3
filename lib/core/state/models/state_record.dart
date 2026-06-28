class StateRecord {
  final String stateId;
  final String stateName;
  final String status;
  final String timestamp;
  final String sessionId;
  final String? originEventId;

  const StateRecord({
    required this.stateId,
    required this.stateName,
    required this.status,
    required this.timestamp,
    required this.sessionId,
    this.originEventId,
  });

  Map<String, dynamic> toJson() {
    return {
      'stateId': stateId,
      'stateName': stateName,
      'status': status,
      'timestamp': timestamp,
      'sessionId': sessionId,
      'originEventId': originEventId,
    };
  }

  factory StateRecord.fromJson(Map<String, dynamic> json) {
    return StateRecord(
      stateId: json['stateId'] ?? '',
      stateName: json['stateName'] ?? '',
      status: json['status'] ?? '',
      timestamp: json['timestamp'] ?? '',
      sessionId: json['sessionId'] ?? '',
      originEventId: json['originEventId'],
    );
  }

  String encode() => toJson().toString();
}