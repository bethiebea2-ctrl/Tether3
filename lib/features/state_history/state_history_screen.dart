import 'package:flutter/material.dart';
import '../../core/state/state_history_service.dart';
import '../../core/state/models/state_record.dart';

class StateHistoryScreen extends StatefulWidget {
  const StateHistoryScreen({super.key});

  @override
  State<StateHistoryScreen> createState() => _StateHistoryScreenState();
}

class _StateHistoryScreenState extends State<StateHistoryScreen> {
  List<StateRecord> _states = [];

  @override
  void initState() {
    super.initState();
    loadStates();
  }

  Future<void> loadStates() async {
    final service = StateHistoryService();
    final states = await service.loadStates();
    setState(() {
      _states = states;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('State History'),
      ),
      body: _states.isEmpty
          ? const Center(child: Text('No state changes recorded yet'))
          : ListView.builder(
              itemCount: _states.length,
              itemBuilder: (context, index) {
                final state = _states[index];
                return ListTile(
                  leading: Icon(
                    _iconForStatus(state.status),
                    color: _colourForStatus(state.status),
                  ),
                  title: Text(state.stateName),
                  subtitle: Text('${state.status} — ${state.timestamp}'),
                );
              },
            ),
    );
  }

  IconData _iconForStatus(String status) {
    switch (status) {
      case 'activated':
        return Icons.play_circle;
      case 'updated':
        return Icons.refresh;
      case 'cleared':
        return Icons.stop_circle;
      default:
        return Icons.circle;
    }
  }

  Color _colourForStatus(String status) {
    switch (status) {
      case 'activated':
        return Colors.green;
      case 'updated':
        return Colors.amber;
      case 'cleared':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}