import 'package:flutter/material.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/history/orchestration_event_record.dart';
import '../../core/timeline/timeline_builder.dart';
import '../../core/events/event_category.dart';

class FeaturesTimelineScreen extends StatefulWidget {
  const FeaturesTimelineScreen({super.key});

  @override
  State<FeaturesTimelineScreen> createState() => _FeaturesTimelineScreenState();
}

class _FeaturesTimelineScreenState extends State<FeaturesTimelineScreen> {
  List<OrchestrationEventRecord> _allEvents = [];
  List<dynamic> _filteredEntries = [];
  String? _selectedModule;
  EventCategory? _selectedCategory;

  @override
  void initState() {
    super.initState();
    loadEvents();
  }

  Future<void> loadEvents() async {
    final service = OrchestrationHistoryService();
    final events = await service.loadEvents();
    setState(() {
      _allEvents = events;
      _applyFilters();
    });
  }

  void _applyFilters() {
    var filtered = _allEvents;

    if (_selectedModule != null) {
      filtered = filtered.where((e) => e.originModule == _selectedModule).toList();
    }

    if (_selectedCategory != null) {
      filtered = filtered.where((e) => e.category == _selectedCategory).toList();
    }

    setState(() {
      _filteredEntries = TimelineBuilder.build(filtered);
    });
  }

  Set<String> get _availableModules {
    return _allEvents.map((e) => e.originModule).toSet();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timeline'),
      ),
      body: Column(
        children: [
          // Filter row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                // Module filter dropdown
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedModule,
                    decoration: const InputDecoration(
                      labelText: 'Module',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem<String>(
                        value: null,
                        child: Text('All'),
                      ),
                      ..._availableModules.map((module) => DropdownMenuItem<String>(
                            value: module,
                            child: Text(module),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedModule = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 12),
                // Category filter dropdown
                Expanded(
                  child: DropdownButtonFormField<EventCategory>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    ),
                    items: [
                      const DropdownMenuItem<EventCategory>(
                        value: null,
                        child: Text('All'),
                      ),
                      ...EventCategory.values.map((cat) => DropdownMenuItem<EventCategory>(
                            value: cat,
                            child: Text(cat.name),
                          )),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedCategory = value;
                        _applyFilters();
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          // Timeline entries
          Expanded(
            child: _filteredEntries.isEmpty
                ? const Center(child: Text('No events match the selected filters'))
                : ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final item = _filteredEntries[index];
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
          ),
        ],
      ),
    );
  }
}