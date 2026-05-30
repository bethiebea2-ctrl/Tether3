import 'dart:convert';
import '../events/event_category.dart';
import '../events/event_persistence_policy.dart';

class OrchestrationEventRecord {
  final String eventId;
  final String eventType;
  final EventCategory category;
  final EventPersistencePolicy persistencePolicy;
  final bool replayable;
  final String originModule;
  final String sessionId;
  final String? parentEventId;
  final String? causationId;
  final String? correlationId;
  final String timestamp;
  final Map<String, dynamic> payload;

  const OrchestrationEventRecord({
    required this.eventId,
    required this.eventType,
    required this.category,
    required this.persistencePolicy,
    required this.replayable,
    required this.originModule,
    required this.sessionId,
    required this.timestamp,
    required this.payload,
    this.parentEventId,
    this.causationId,
    this.correlationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'eventId': eventId,
      'eventType': eventType,
      'category': category.name,
      'persistencePolicy': persistencePolicy.name,
      'replayable': replayable,
      'originModule': originModule,
      'sessionId': sessionId,
      'parentEventId': parentEventId,
      'causationId': causationId,
      'correlationId': correlationId,
      'timestamp': timestamp,
      'payload': payload,
    };
  }

  factory OrchestrationEventRecord.fromJson(Map<String, dynamic> json) {
    return OrchestrationEventRecord(
      eventId: json['eventId'] ?? '',
      eventType: json['eventType'] ?? '',
      category: EventCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => EventCategory.system,
      ),
      persistencePolicy: EventPersistencePolicy.values.firstWhere(
        (e) => e.name == json['persistencePolicy'],
        orElse: () => EventPersistencePolicy.session,
      ),
      replayable: json['replayable'] ?? false,
      originModule: json['originModule'] ?? '',
      sessionId: json['sessionId'] ?? '',
      parentEventId: json['parentEventId'],
      causationId: json['causationId'],
      correlationId: json['correlationId'],
      timestamp: json['timestamp'] ?? DateTime.now().toIso8601String(),
      payload: Map<String, dynamic>.from(json['payload'] ?? {}),
    );
  }

  @override
  String toString() => jsonEncode(toJson());
}