import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'orchestration_event_record.dart';
import 'resolver_decision_record.dart';

class OrchestrationHistoryService {
  static const _eventsKey = 'orchestration_events';
  static const _decisionsKey = 'resolver_decisions';

  static final OrchestrationHistoryService _instance = OrchestrationHistoryService._internal();
  factory OrchestrationHistoryService() => _instance;
  OrchestrationHistoryService._internal();

  Future<void> saveEvent(OrchestrationEventRecord record) async {
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
}