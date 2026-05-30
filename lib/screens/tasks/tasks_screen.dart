import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../core/tasks/task_item.dart';
import '../../core/tasks/task_status.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_energy.dart';
import '../../core/tasks/task_repository.dart';
import '../../core/events/event_bus.dart';
import '../../core/events/event_category.dart';
import '../../core/events/event_persistence_policy.dart';
import '../../core/tasks/events/task_created_event.dart';
import '../../core/tasks/events/task_completed_event.dart';
import '../../core/tasks/events/task_snoozed_event.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../core/history/orchestration_history_service.dart';
import '../../core/history/orchestration_event_record.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TaskRepository _repository = TaskRepository();
  final TextEditingController _titleController = TextEditingController();
  final _uuid = const Uuid();
  String _filter = 'pending'; // pending, completed, snoozed

  void _addTask() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final task = _repository.addTask(title: title);
    final createdEvent = TaskCreatedEvent(task: task);
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
        payload: {'taskId': task.id, 'title': task.title},
      ),
    );
    _titleController.clear();
    setState(() {});
  }

  void _completeTask(String id) {
    _repository.completeTask(id);
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

  void _snoozeTask(String id) {
    final until = DateTime.now().add(const Duration(hours: 4));
    _repository.snoozeTask(id, until);
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
        return 'Medium';
      case TaskEnergy.high:
        return 'High energy';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
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
      ),
      body: Column(
        children: [
          // Add task input
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: BethColours.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: 'Add a task...',
                      hintStyle: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
                      filled: true,
                      fillColor: BethColours.surfaceAlt,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    style: BethTypography.bodySmall,
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTask,
                  icon: const Icon(Icons.add_circle, color: BethColours.primary, size: 32),
                ),
              ],
            ),
          ),

          // Filter chips
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

          // Task list
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      _filter == 'pending' ? 'No tasks yet' : 'No ${_filter} tasks',
                      style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: BethColours.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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
                            _energyLabel(task.energy),
                            style: BethTypography.caption,
                          ),
                          trailing: task.status == TaskStatus.pending
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.snooze, color: BethColours.amber, size: 20),
                                      onPressed: () => _snoozeTask(task.id),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.check_circle_outline, color: BethColours.green, size: 20),
                                      onPressed: () => _completeTask(task.id),
                                    ),
                                  ],
                                )
                              : null,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

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