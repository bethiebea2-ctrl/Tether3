import 'package:flutter/material.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/history/models/resolver_decision_record.dart';
import '../../core/tracing/trace_service.dart';

class DecisionInspectorScreen extends StatefulWidget {
  const DecisionInspectorScreen({super.key});

  @override
  State<DecisionInspectorScreen> createState() => _DecisionInspectorScreenState();
}

class _DecisionInspectorScreenState extends State<DecisionInspectorScreen> {
  List<ResolverDecisionRecord> _decisions = [];
  ResolverDecisionRecord? _selectedDecision;

  @override
  void initState() {
    super.initState();
    loadDecisions();
  }

  Future<void> loadDecisions() async {
    final history = OrchestrationHistoryService();
    final decisions = await history.loadDecisions();
    setState(() {
      _decisions = decisions.reversed.toList(); // newest first
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Decision Inspector'),
      ),
      body: _decisions.isEmpty
          ? const Center(child: Text('No decisions recorded yet'))
          : ListView.builder(
              itemCount: _decisions.length,
              itemBuilder: (context, index) {
                final decision = _decisions[index];
                final isSelected = _selectedDecision?.decisionId == decision.decisionId;

                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        _iconForEffect(decision.effect),
                        color: _colourForEffect(decision.effect),
                      ),
                      title: Text(decision.winningRuleName),
                      subtitle: Text('${decision.effect} — ${decision.timestamp}'),
                      trailing: Text(
                        '${decision.traceCount} rules',
                        style: const TextStyle(fontSize: 12),
                      ),
                      onTap: () {
                        setState(() {
                          _selectedDecision = isSelected ? null : decision;
                        });
                      },
                    ),
                    if (isSelected) _decisionDetailCard(decision),
                    const Divider(height: 1),
                  ],
                );
              },
            ),
    );
  }

  Widget _decisionDetailCard(ResolverDecisionRecord decision) {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _detailRow('Decision ID', decision.decisionId),
          _detailRow('Target', decision.target),
          _detailRow('Winning Rule', decision.winningRuleId),
          _detailRow('Rule Name', decision.winningRuleName),
          _detailRow('Effect', decision.effect),
          _detailRow('Traces Evaluated', decision.traceCount.toString()),
          _detailRow('Session', decision.sessionId ?? 'N/A'),
          _detailRow('Origin Event', decision.originEventId ?? 'N/A'),
          _detailRow('Timestamp', decision.timestamp),
        ],
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconForEffect(String effect) {
    switch (effect) {
      case 'allow':
        return Icons.check_circle;
      case 'suppress':
        return Icons.block;
      case 'digest':
        return Icons.summarize;
      default:
        return Icons.help_outline;
    }
  }

  Color _colourForEffect(String effect) {
    switch (effect) {
      case 'allow':
        return Colors.green;
      case 'suppress':
        return Colors.red;
      case 'digest':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }
}