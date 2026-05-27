import 'package:flutter/material.dart';
import '../../core/models/resolver_result.dart';

class ResolverDebugScreen extends StatelessWidget {
  final List<String> activeStates;
  final List<String> activePresets;
  final List<String> activeToggles;
  final List<ResolverTrace> traces;
  final String finalEffect;
  final String notificationDecision;

  const ResolverDebugScreen({
    super.key,
    required this.activeStates,
    required this.activePresets,
    required this.activeToggles,
    required this.traces,
    required this.finalEffect,
    required this.notificationDecision,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resolver Debug'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection('Active States', activeStates),
          _buildSection('Active Presets', activePresets),
          _buildSection('Active Toggles', activeToggles),
          _buildTraceSection(),
          Card(
            child: ListTile(
              title: const Text('Final Effect'),
              subtitle: Text(finalEffect),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Notification Decision'),
              subtitle: Text(notificationDecision),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, List<String> items) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            if (items.isEmpty)
              const Text('None', style: TextStyle(color: Colors.grey))
            else
              ...items.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Text('• $item'),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildTraceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Resolver Trace', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 8),
            if (traces.isEmpty)
              const Text('No traces', style: TextStyle(color: Colors.grey))
            else
              ...traces.map((trace) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(trace.ruleName, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Rule ID: ${trace.ruleId}'),
                        Text('Priority: ${trace.priority}'),
                        Text('Matched: ${trace.matched}'),
                        Text('Effect: ${trace.effect}'),
                        const Divider(),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }
}