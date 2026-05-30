import 'package:flutter/material.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/history/orchestration_event_record.dart';
import '../../core/history/models/resolver_decision_record.dart';
import '../../core/timeline/timeline_builder.dart';
import '../../core/events/event_category.dart';

enum TimelineTab { all, events, decisions }

class FeaturesTimelineScreen extends StatefulWidget {
  const FeaturesTimelineScreen({super.key});

  @override
  State<FeaturesTimelineScreen> createState() => _FeaturesTimelineScreenState();
}

class _FeaturesTimelineScreenState extends State<FeaturesTimelineScreen> {
  List<OrchestrationEventRecord> _allEvents = [];
  List<ResolverDecisionRecord> _allDecisions = [];
  List<dynamic> _filteredEntries = [];
  String? _selectedModule;
  EventCategory? _selectedCategory;
  TimelineTab _selectedTab = TimelineTab.all;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final service = OrchestrationHistoryService();
    final events = await service.loadEvents();
    final decisions = await service.loadDecisions();
    setState(() {
      _allEvents = events;
      _allDecisions = decisions;
      _applyFilters();
    });
  }

  void _applyFilters() {
    var filteredEvents = _allEvents;

    if (_selectedModule != null) {
      filteredEvents = filteredEvents.where((e) => e.originModule == _selectedModule).toList();
    }
    if (_selectedCategory != null) {
      filteredEvents = filteredEvents.where((e) => e.category == _selectedCategory).toList();
    }

    final entries = <dynamic>[];

    switch (_selectedTab) {
      case TimelineTab.all:
        entries.addAll(TimelineBuilder.build(filteredEvents));
        entries.addAll(_allDecisions);
        entries.sort((a, b) {
          final aTime = a is ResolverDecisionRecord ? a.timestamp : (a as dynamic).timestamp.toString();
          final bTime = b is ResolverDecisionRecord ? b.timestamp : (b as dynamic).timestamp.toString();
          return bTime.compareTo(aTime);
        });
        break;
      case TimelineTab.events:
        entries.addAll(TimelineBuilder.build(filteredEvents));
        break;
      case TimelineTab.decisions:
        entries.addAll(_allDecisions);
        break;
    }

    setState(() {
      _filteredEntries = entries;
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Row(
            children: [
              _tabChip('All', TimelineTab.all),
              _tabChip('Events', TimelineTab.events),
              _tabChip('Decisions', TimelineTab.decisions),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          // Module and Category filters (only for events)
          if (_selectedTab != TimelineTab.decisions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedModule,
                      decoration: const InputDecoration(
                        labelText: 'Module',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem<String>(value: null, child: Text('All')),
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
                  Expanded(
                    child: DropdownButtonFormField<EventCategory>(
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: [
                        const DropdownMenuItem<EventCategory>(value: null, child: Text('All')),
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
                ? const Center(child: Text('No entries to display'))
                : ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final item = _filteredEntries[index];
                      if (item is ResolverDecisionRecord) {
                        return _decisionTile(item);
                      }
                      return _eventTile(item);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tabChip(String label, TimelineTab tab) {
    final selected = _selectedTab == tab;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = tab;
          _applyFilters();
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).colorScheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.grey.shade700,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _eventTile(dynamic item) {
    return ListTile(
      leading: const Icon(Icons.circle, size: 10, color: Colors.blue),
      title: Text(item.title ?? ''),
      subtitle: Text(item.description ?? ''),
      trailing: Text(
        item.timestamp.toString().substring(0, 19),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }

  Widget _decisionTile(ResolverDecisionRecord record) {
    return ListTile(
      leading: const Icon(Icons.account_tree, color: Colors.orange, size: 20),
      title: Text(record.winningRuleName),
      subtitle: Text(record.effect),
      trailing: Text(
        record.timestamp.substring(0, 19),
        style: const TextStyle(fontSize: 10),
      ),
    );
  }
}