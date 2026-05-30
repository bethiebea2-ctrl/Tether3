import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'orchestration_event_record.dart';
import 'resolver_decision_record.dart';
import '../../core/events/event_validator.dart';
import '../../core/events/event_persistence_policy.dart';

class OrchestrationHistoryService {
  static const _eventsKey = 'orchestration_events';
  static const _decisionsKey = 'resolver_decisions';
  static const int _retentionDays = 90;

  static final OrchestrationHistoryService _instance = OrchestrationHistoryService._internal();
  factory OrchestrationHistoryService() => _instance;
  OrchestrationHistoryService._internal();

  Future<void> saveEvent(OrchestrationEventRecord record) async {
    // Validate event before persistence
    final validationResult = EventValidator.validate(
      record.eventId,
      record.eventType,
      record.category,
      record.persistencePolicy,
      record.replayable,
      record.originModule,
    );
    if (!validationResult.isValid) {
      throw Exception('Event validation failed: ${validationResult.errors.join(", ")}');
    }

    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_eventsKey) ?? [];
    existing.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_eventsKey, existing);
  }

  Future<void> saveDecision(ResolverDecisionRecord record) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = prefs.getStringList(_decisionsKey) ?? [];
    existing.add(jsonEncode(record.toJson()));
    await prefs.setStringList(_decisionsKey, existing);
  }

  Future<List<OrchestrationEventRecord>> loadEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_eventsKey) ?? [];
    return data.map((e) => OrchestrationEventRecord.fromJson(jsonDecode(e))).toList();
  }

  Future<List<ResolverDecisionRecord>> loadDecisions() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_decisionsKey) ?? [];
    return data.map((e) => ResolverDecisionRecord.fromJson(jsonDecode(e))).toList();
  }

  /// Removes events that have exceeded the retention period (90 days)
  /// or have transient/session persistence policies.
  /// Returns the number of events pruned.
  Future<int> pruneEvents() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_eventsKey) ?? [];
    if (data.isEmpty) return 0;

    final now = DateTime.now();
    final cutoff = now.subtract(Duration(days: _retentionDays));
    final originalCount = data.length;

    final kept = data.where((encoded) {
      final record = OrchestrationEventRecord.fromJson(jsonDecode(encoded));

      // Prune: transient and session events (not meant for long-term storage)
      if (record.persistencePolicy == EventPersistencePolicy.transient ||
          record.persistencePolicy == EventPersistencePolicy.session) {
        return false;
      }

      // Prune: events older than retention period
      final eventDate = DateTime.tryParse(record.timestamp);
      if (eventDate != null && eventDate.isBefore(cutoff)) {
        return false;
      }

      return true;
    }).toList();

    await prefs.setStringList(_eventsKey, kept);
    return originalCount - kept.length;
  }
}