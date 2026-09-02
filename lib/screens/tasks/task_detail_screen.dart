import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/tasks/task_item.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_energy.dart';
import '../../core/tasks/task_repository.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'tasks_screen.dart';

const taskLayers = [
  ('bare_minimum', 'Bare minimums'),
  ('personal_care', 'Personal care'),
  ('house', 'House'),
  ('care', 'Care'),
  ('life_admin', 'Life admin'),
  ('recovery', 'Recovery'),
];

class TaskDetailScreen extends StatefulWidget {
  final TaskItem? task;
  const TaskDetailScreen({super.key, this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  late final TextEditingController _title;
  late final TextEditingController _notes;
  late TaskPriority _priority;
  late TaskEnergy _energy;
  late String _layer;
  DateTime? _deadline;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final t = widget.task;
    _title = TextEditingController(text: t?.title ?? '');
    _notes = TextEditingController(text: t?.notes ?? '');
    _priority = t?.priority ?? TaskPriority.medium;
    _energy = t?.energy ?? TaskEnergy.medium;
    _layer = t?.layer ?? 'life_admin';
    _deadline = t?.deadline;
    _loadDefaultsIfNeeded();
  }

  Future<void> _loadDefaultsIfNeeded() async {
    if (widget.task != null) return;
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _layer = prefs.getString('task_defaults_layer') ?? _layer;
      final p = prefs.getString('task_defaults_priority');
      if (p != null) {
        _priority = TaskPriority.values.firstWhere(
          (e) => e.name == p,
          orElse: () => _priority,
        );
      }
      final e = prefs.getString('task_defaults_energy');
      if (e != null) {
        _energy = TaskEnergy.values.firstWhere(
          (v) => v.name == e,
          orElse: () => _energy,
        );
      }
    });
  }

  @override
  void dispose() {
    _title.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    if (title.isEmpty || _saving) return;
    setState(() => _saving = true);
    final repo = TaskRepository();
    TaskItem result;
    if (widget.task == null) {
      result = await repo.addTask(
        title: title,
        priority: _priority,
        energy: _energy,
        layer: _layer,
        deadline: _deadline,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      );
    } else {
      result = widget.task!.copyWith(
        title: title,
        priority: _priority,
        energy: _energy,
        layer: _layer,
        deadline: _deadline,
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        clearDeadline: _deadline == null,
      );
      await repo.updateTask(result);
    }
    if (!mounted) return;
    Navigator.pop(context, result);
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 1)),
      lastDate: now.add(const Duration(days: 365 * 2)),
      initialDate: _deadline ?? now,
    );
    if (date == null || !mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_deadline ?? now),
    );
    setState(() {
      _deadline = DateTime(
        date.year,
        date.month,
        date.day,
        time?.hour ?? 9,
        time?.minute ?? 0,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.task != null;
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: Text(isEdit ? 'Task' : 'Add task'),
        actions: [
          if (isEdit)
            IconButton(
              tooltip: 'Delegate',
              onPressed: () => openTaskDelegation(context, widget.task!),
              icon: const Icon(Icons.smart_toy_outlined),
            ),
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: 'Title',
              hintText: 'What needs doing?',
            ),
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          Text('Priority', style: BethTypography.caption),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: [
              ChoiceChip(
                label: const Text('Urgent'),
                selected: _priority == TaskPriority.high,
                onSelected: (_) => setState(() => _priority = TaskPriority.high),
              ),
              ChoiceChip(
                label: const Text('Not urgent'),
                selected: _priority == TaskPriority.medium,
                onSelected: (_) => setState(() => _priority = TaskPriority.medium),
              ),
              ChoiceChip(
                label: const Text('Later'),
                selected: _priority == TaskPriority.low,
                onSelected: (_) => setState(() => _priority = TaskPriority.low),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Energy', style: BethTypography.caption),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            children: TaskEnergy.values.map((e) {
              return ChoiceChip(
                label: Text(e.name),
                selected: _energy == e,
                onSelected: (_) => setState(() => _energy = e),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _layer,
            decoration: const InputDecoration(labelText: 'Layer'),
            items: taskLayers
                .map((l) => DropdownMenuItem(value: l.$1, child: Text(l.$2)))
                .toList(),
            onChanged: (v) => setState(() => _layer = v ?? _layer),
          ),
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Deadline'),
            subtitle: Text(
              _deadline == null
                  ? 'Optional — this can wait'
                  : _deadline!.toLocal().toString().split('.').first,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_deadline != null)
                  IconButton(
                    onPressed: () => setState(() => _deadline = null),
                    icon: const Icon(Icons.clear),
                  ),
                IconButton(
                  onPressed: _pickDeadline,
                  icon: const Icon(Icons.event),
                ),
              ],
            ),
          ),
          TextField(
            controller: _notes,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Anything helpful — no judgement.',
            ),
          ),
          if (isEdit) ...[
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () async {
                await TaskRepository().deleteTask(widget.task!.id);
                if (!mounted) return;
                Navigator.pop(context, widget.task);
              },
              icon: const Icon(Icons.delete_outline, color: BethColours.red),
              label: const Text('Remove from list'),
            ),
          ],
        ],
      ),
    );
  }
}
