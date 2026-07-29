import 'package:uuid/uuid.dart';
import '../../database/task_dao.dart';
import 'task_item.dart';
import 'task_status.dart';
import 'task_priority.dart';
import 'task_energy.dart';

class TaskRepository {
  static final TaskRepository _instance = TaskRepository._internal();
  factory TaskRepository() => _instance;
  TaskRepository._internal();

  final _uuid = const Uuid();
  final TaskDao _dao = TaskDao();
  final List<TaskItem> _tasks = [];
  bool _loaded = false;
  bool get isLoaded => _loaded;

  List<TaskItem> getTasks() => List.unmodifiable(_tasks);

  List<TaskItem> getPendingTasks() =>
      _tasks.where((t) => t.status == TaskStatus.pending).toList();

  List<TaskItem> getUrgentTasks() => _tasks
      .where((t) =>
          t.status == TaskStatus.pending &&
          (t.priority == TaskPriority.high || t.isOverdue))
      .toList();

  List<TaskItem> getSnoozedTasks() =>
      _tasks.where((t) => t.status == TaskStatus.snoozed).toList();

  Future<void> load() async {
    final rows = await _dao.getAll();
    _tasks
      ..clear()
      ..addAll(rows);
    if (_tasks.isEmpty) {
      for (final title in ['Eat', 'Drink water', 'Take medication', 'Rest']) {
        await addTask(
          title: title,
          layer: 'bare_minimum',
          priority: TaskPriority.medium,
          energy: TaskEnergy.low,
        );
      }
    } else {
      await escalateOverdue();
    }
    _loaded = true;
  }

  Future<void> escalateOverdue() async {
    var changed = false;
    for (var i = 0; i < _tasks.length; i++) {
      final t = _tasks[i];
      if (t.isOverdue && t.priority != TaskPriority.high) {
        final updated = t.copyWith(priority: TaskPriority.high);
        _tasks[i] = updated;
        await _dao.upsert(updated);
        changed = true;
      }
      // Unsnooze when time passed
      if (t.status == TaskStatus.snoozed &&
          t.snoozedUntil != null &&
          t.snoozedUntil!.isBefore(DateTime.now())) {
        final updated = t.copyWith(
          status: TaskStatus.pending,
          clearSnooze: true,
        );
        _tasks[i] = updated;
        await _dao.upsert(updated);
        changed = true;
      }
    }
    if (changed) {
      // callers refresh via notify on screen
    }
  }

  Future<TaskItem> addTask({
    required String title,
    TaskPriority priority = TaskPriority.medium,
    TaskEnergy energy = TaskEnergy.medium,
    String? sourceCaptureId,
    String? layer,
    DateTime? deadline,
    String? notes,
    String? assignedInstanceId,
  }) async {
    final now = DateTime.now();
    final task = TaskItem(
      id: _uuid.v4(),
      title: title,
      status: TaskStatus.pending,
      priority: priority,
      energy: energy,
      createdAt: now,
      updatedAt: now,
      sourceCaptureId: sourceCaptureId,
      layer: layer ?? 'life_admin',
      deadline: deadline,
      notes: notes,
      assignedInstanceId: assignedInstanceId,
    );
    _tasks.insert(0, task);
    await _dao.upsert(task);
    return task;
  }

  Future<TaskItem?> updateTask(TaskItem task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index == -1) return null;
    final updated = task.copyWith(updatedAt: DateTime.now());
    _tasks[index] = updated;
    await _dao.upsert(updated);
    return updated;
  }

  Future<TaskItem?> completeTask(String id) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;
    _tasks[index] = _tasks[index].copyWith(status: TaskStatus.completed);
    await _dao.upsert(_tasks[index]);
    return _tasks[index];
  }

  Future<TaskItem?> snoozeTask(String id, DateTime until) async {
    final index = _tasks.indexWhere((t) => t.id == id);
    if (index == -1) return null;
    _tasks[index] = _tasks[index].copyWith(
      status: TaskStatus.snoozed,
      snoozedUntil: until,
    );
    await _dao.upsert(_tasks[index]);
    return _tasks[index];
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((t) => t.id == id);
    await _dao.delete(id);
  }
}
