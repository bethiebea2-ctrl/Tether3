import 'dart:convert';

class OrchestrationEventRecord {
  final String id;
  final String eventType;
  final String originModule;
  final String sessionId;
  final String? parentEventId;
  final DateTime timestamp;
  final Map<String, dynamic> payload;

  const OrchestrationEventRecord({
    required this.id,
    required this.eventType,
    required this.originModule,
    required this.sessionId,
    required this.timestamp,
    required this.payload,
    this.parentEventId,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventType': eventType,
      'originModule': originModule,
      'sessionId': sessionId,
      'parentEventId': parentEventId,
      'timestamp': timestamp.toIso8601String(),
      'payload': payload,
    };
  }

  factory OrchestrationEventRecord.fromJson(Map<String, dynamic> json) {
    return OrchestrationEventRecord(
      id: json['id'],
      eventType: json['eventType'],
      originModule: json['originModule'],
      sessionId: json['sessionId'],
      parentEventId: json['parentEventId'],
      timestamp: DateTime.parse(json['timestamp']),
      payload: Map<String, dynamic>.from(json['payload']),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}