import 'package:flutter/material.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/timeline/timeline_builder.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  List<dynamic> entries = [];

  @override
  void initState() {
    super.initState();
    loadTimeline();
  }

  Future<void> loadTimeline() async {
    final service = OrchestrationHistoryService();
    final events = await service.loadEvents();
    final timeline = TimelineBuilder.build(events);
    setState(() {
      entries = timeline;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
      ),
      body: entries.isEmpty
          ? const Center(child: Text('No orchestration events recorded yet'))
          : ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final item = entries[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  trailing: Text(
                    item.timestamp.toString().substring(0, 19),
                    style: const TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
    );
  }
}