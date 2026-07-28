import 'package:uuid/uuid.dart';
import 'task_item.dart';
import 'task_status.dart';
import 'task_priority.dart';
import 'task_energy.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  final _uuid = const Uuid();
  final List<TaskItem> _tasks = [];

  List<TaskItem> getTasks() => List.unmodifiable(_tasks);

  List<TaskItem> getPendingTasks() =>
      _tasks.where((t) => t.status == TaskStatus.pending).toList();

  TaskItem addTask({
    required String title,
    TaskPriority priority = TaskPriority.medium,
    TaskEnergy energy = TaskEnergy.medium,
    String? sourceCaptureId,
    String? layer,
  }) {
    final task = TaskItem(
      id: _uuid.v4(),
      title: title,
      status: TaskStatus.pending,
      priority: priority,
      energy: energy,
      createdAt: DateTime.now(),
      sourceCaptureId: sourceCaptureId,
      layer: layer,
    );

    _tasks.add(task);
    return task;
  }

  TaskItem? completeTask(String id) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;

    _tasks[index] = _tasks[index].copyWith(status: TaskStatus.completed);
    return _tasks[index];
  }

  TaskItem? snoozeTask(String id, DateTime until) {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;

    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.snoozed,
      snoozedUntil: until,
    );
    return _tasks[index];
  }
}