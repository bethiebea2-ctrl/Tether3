import 'package:flutter/material.dart';
import '../../core/tasks/task_item.dart';
import '../../core/tasks/task_status.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_energy.dart';
import '../../core/tasks/task_repository.dart';
import '../../core/events/event_bus.dart';
import '../../core/tasks/events/task_created_event.dart';
import '../../core/tasks/events/task_completed_event.dart';
import '../../core/tasks/events/task_snoozed_event.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/history/orchestration_event_record.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';
import '../team/instance_chat.dart';
import 'task_detail_screen.dart';
import 'task_pack_library_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskRepository _repository = TaskRepository();
  String _filter = 'pending';
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _repository.load();
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _refresh() async {
    await _repository.escalateOverdue();
    setState(() {});
  }

  Future<void> _openCreate({TaskItem? existing}) async {
    final result = await Navigator.push<TaskItem>(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(task: existing),
      ),
    );
    if (result == null) return;
    if (existing == null) {
      final createdEvent = TaskCreatedEvent(task: result);
      EventBus().emit(createdEvent);
      OrchestrationHistoryService().saveEvent(
        OrchestrationEventRecord(
          eventId: createdEvent.eventId,
          eventType: createdEvent.eventType,
          category: createdEvent.category,
          persistencePolicy: createdEvent.persistencePolicy,
          replayable: createdEvent.replayable,
          originModule: createdEvent.originModule,
          sessionId: 'session_1',
          timestamp: createdEvent.timestamp.toIso8601String(),
          payload: {'taskId': result.id, 'title': result.title},
        ),
      );
    }
    setState(() {});
  }

  Future<void> _completeTask(String id) async {
    await _repository.completeTask(id);
    final completedEvent = TaskCompletedEvent(taskId: id);
    EventBus().emit(completedEvent);
    OrchestrationHistoryService().saveEvent(
      OrchestrationEventRecord(
        eventId: completedEvent.eventId,
        eventType: completedEvent.eventType,
        category: completedEvent.category,
        persistencePolicy: completedEvent.persistencePolicy,
        replayable: completedEvent.replayable,
        originModule: completedEvent.originModule,
        sessionId: 'session_1',
        timestamp: completedEvent.timestamp.toIso8601String(),
        payload: {'taskId': id},
      ),
    );
    setState(() {});
  }

  Future<void> _showSnoozePresets(String id) async {
    final until = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (ctx) {
        final now = DateTime.now();
        DateTime tonight = DateTime(now.year, now.month, now.day, 20);
        if (tonight.isBefore(now)) tonight = tonight.add(const Duration(days: 1));
        final tomorrow = DateTime(now.year, now.month, now.day + 1, 9);
        var weekend = now.add(Duration(days: (DateTime.saturday - now.weekday + 7) % 7));
        if (weekend.weekday != DateTime.saturday) {
          weekend = now.add(Duration(days: (6 - now.weekday + 7) % 7));
        }
        weekend = DateTime(weekend.year, weekend.month, weekend.day, 10);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Tonight'),
                subtitle: const Text('Still on the list later this evening.'),
                onTap: () => Navigator.pop(ctx, tonight),
              ),
              ListTile(
                title: const Text('Tomorrow'),
                subtitle: const Text('This can wait until morning.'),
                onTap: () => Navigator.pop(ctx, tomorrow),
              ),
              ListTile(
                title: const Text('Weekend'),
                subtitle: const Text('Park it for Saturday morning.'),
                onTap: () => Navigator.pop(ctx, weekend),
              ),
              ListTile(
                title: const Text('Custom…'),
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    firstDate: now,
                    lastDate: now.add(const Duration(days: 365)),
                    initialDate: now.add(const Duration(days: 1)),
                  );
                  if (date == null || !ctx.mounted) return;
                  final time = await showTimePicker(
                    context: ctx,
                    initialTime: const TimeOfDay(hour: 9, minute: 0),
                  );
                  if (time == null || !ctx.mounted) return;
                  Navigator.pop(
                    ctx,
                    DateTime(date.year, date.month, date.day, time.hour, time.minute),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
    if (until == null) return;
    await _repository.snoozeTask(id, until);
    final snoozedEvent = TaskSnoozedEvent(taskId: id, snoozedUntil: until);
    EventBus().emit(snoozedEvent);
    OrchestrationHistoryService().saveEvent(
      OrchestrationEventRecord(
        eventId: snoozedEvent.eventId,
        eventType: snoozedEvent.eventType,
        category: snoozedEvent.category,
        persistencePolicy: snoozedEvent.persistencePolicy,
        replayable: snoozedEvent.replayable,
        originModule: snoozedEvent.originModule,
        sessionId: 'session_1',
        timestamp: snoozedEvent.timestamp.toIso8601String(),
        payload: {'taskId': id, 'snoozedUntil': until.toIso8601String()},
      ),
    );
    setState(() {});
  }

  List<TaskItem> _filteredTasks() {
    final all = _repository.getTasks();
    switch (_filter) {
      case 'pending':
        return all.where((t) => t.status == TaskStatus.pending).toList();
      case 'completed':
        return all.where((t) => t.status == TaskStatus.completed).toList();
      case 'snoozed':
        return all.where((t) => t.status == TaskStatus.snoozed).toList();
      default:
        return all;
    }
  }

  Color _priorityColour(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.high:
        return BethColours.red;
      case TaskPriority.medium:
        return BethColours.amber;
      case TaskPriority.low:
        return BethColours.green;
    }
  }

  String _energyLabel(TaskEnergy energy) {
    switch (energy) {
      case TaskEnergy.low:
        return 'Low energy';
      case TaskEnergy.medium:
        return 'Medium energy';
      case TaskEnergy.high:
        return 'High energy';
    }
  }

  @override
  Widget build(BuildContext context) {
    final tasks = _filteredTasks();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('Tasks', style: BethTypography.heading),
        actions: [
          IconButton(
            tooltip: 'Task packs',
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TaskPackLibraryScreen()),
              );
              setState(() {});
            },
            icon: const Icon(Icons.inventory_2_outlined),
          ),
          IconButton(
            onPressed: () => _openCreate(),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                    child: Text(
                      'Still on the list — pick what fits today.',
                      style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        _filterChip('Pending', 'pending'),
                        const SizedBox(width: 8),
                        _filterChip('Completed', 'completed'),
                        const SizedBox(width: 8),
                        _filterChip('Snoozed', 'snoozed'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: tasks.isEmpty
                        ? ListView(
                            children: [
                              const SizedBox(height: 80),
                              Center(
                                child: Text(
                                  _filter == 'pending'
                                      ? 'Nothing here yet. Want the smallest version?'
                                      : 'No $_filter tasks',
                                  style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          )
                        : _filter == 'pending'
                            ? _buildPendingSections(tasks)
                            : ListView.builder(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                itemCount: tasks.length,
                                itemBuilder: (context, index) => _taskTile(tasks[index]),
                              ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openCreate(),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildPendingSections(List<TaskItem> tasks) {
    final bare = tasks.where((t) => t.layer == 'bare_minimum').toList();
    final urgent = tasks
        .where((t) =>
            t.layer != 'bare_minimum' &&
            (t.priority == TaskPriority.high || t.isOverdue))
        .toList();
    final other = tasks
        .where((t) =>
            t.layer != 'bare_minimum' &&
            t.priority != TaskPriority.high &&
            !t.isOverdue)
        .toList();

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (bare.isNotEmpty) ...[
          Text('Bare minimums', style: BethTypography.subheading),
          const SizedBox(height: 8),
          ...bare.map(_taskTile),
          const SizedBox(height: 16),
        ],
        if (urgent.isNotEmpty) ...[
          Text('Urgent', style: BethTypography.subheading),
          const SizedBox(height: 8),
          ...urgent.map(_taskTile),
          const SizedBox(height: 16),
        ],
        if (other.isNotEmpty) ...[
          Text('Not urgent', style: BethTypography.subheading),
          const SizedBox(height: 8),
          ...other.map(_taskTile),
        ],
      ],
    );
  }

  Widget _taskTile(TaskItem task) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: () => _openCreate(existing: task),
        leading: Container(
          width: 4,
          height: 36,
          decoration: BoxDecoration(
            color: _priorityColour(task.priority),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        title: Text(
          task.title,
          style: BethTypography.bodySmall?.copyWith(
            decoration: task.status == TaskStatus.completed
                ? TextDecoration.lineThrough
                : null,
            color: task.status == TaskStatus.completed
                ? BethColours.textMuted
                : BethColours.textPrimary,
          ),
        ),
        subtitle: Text(
          [
            _energyLabel(task.energy),
            if (task.isOverdue) 'Overdue — bumped to urgent',
            if (task.deadline != null && !task.isOverdue)
              'Due ${_shortDate(task.deadline!)}',
          ].where((s) => s.isNotEmpty).join(' · '),
          style: BethTypography.caption?.copyWith(
            color: task.isOverdue ? BethColours.red : BethColours.textMuted,
          ),
        ),
        trailing: task.status == TaskStatus.pending
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    tooltip: 'Snooze',
                    icon: const Icon(Icons.snooze, color: BethColours.amber, size: 20),
                    onPressed: () => _showSnoozePresets(task.id),
                  ),
                  IconButton(
                    tooltip: 'Done',
                    icon: const Icon(Icons.check_circle_outline, color: BethColours.green, size: 20),
                    onPressed: () => _completeTask(task.id),
                  ),
                ],
              )
            : null,
      ),
    );
  }

  String _shortDate(DateTime d) =>
      '${d.day}/${d.month}${d.hour != 0 || d.minute != 0 ? ' ${d.hour}:${d.minute.toString().padLeft(2, '0')}' : ''}';

  Widget _filterChip(String label, String value) {
    final selected = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? BethColours.primary : BethColours.surfaceAlt,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : BethColours.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

/// Shared helpers used by task detail for delegation.
Future<void> openTaskDelegation(BuildContext context, TaskItem task) async {
  final instances = InstanceRegistry.instances
      .where((i) => i['status'] == 'active')
      .toList();
  final chosen = await showModalBottomSheet<Map<String, dynamic>>(
    context: context,
    builder: (ctx) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Delegate to an instance', style: BethTypography.subheading),
          ),
          ...instances.map(
            (i) => ListTile(
              title: Text(i['name'] as String? ?? i['id'] as String),
              subtitle: Text(i['domain'] as String? ?? ''),
              onTap: () => Navigator.pop(ctx, i),
            ),
          ),
        ],
      ),
    ),
  );
  if (chosen == null || !context.mounted) return;
  final updated = task.copyWith(assignedInstanceId: chosen['id'] as String?);
  await TaskRepository().updateTask(updated);
  if (!context.mounted) return;
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (_) => InstanceChat(
        instanceId: chosen['id'] as String,
        instanceName: chosen['name'] as String? ?? 'Instance',
        domain: chosen['domain'] as String? ?? '',
        initialDraft:
            'Can you help with this task: "${task.title}"?${task.notes != null ? '\nNotes: ${task.notes}' : ''}',
      ),
    ),
  );
}
