import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/tasks/task_energy.dart';
import '../../core/tasks/task_priority.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../tasks/task_detail_screen.dart';

class TaskDefaultsSettingsScreen extends StatefulWidget {
  const TaskDefaultsSettingsScreen({super.key});

  @override
  State<TaskDefaultsSettingsScreen> createState() =>
      _TaskDefaultsSettingsScreenState();
}

class _TaskDefaultsSettingsScreenState extends State<TaskDefaultsSettingsScreen> {
  String _layer = 'life_admin';
  TaskPriority _priority = TaskPriority.medium;
  TaskEnergy _energy = TaskEnergy.medium;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _layer = prefs.getString('task_defaults_layer') ?? 'life_admin';
      _priority = TaskPriority.values.firstWhere(
        (p) => p.name == prefs.getString('task_defaults_priority'),
        orElse: () => TaskPriority.medium,
      );
      _energy = TaskEnergy.values.firstWhere(
        (e) => e.name == prefs.getString('task_defaults_energy'),
        orElse: () => TaskEnergy.medium,
      );
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('task_defaults_layer', _layer);
    await prefs.setString('task_defaults_priority', _priority.name);
    await prefs.setString('task_defaults_energy', _energy.name);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task defaults saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: const Text('Task defaults'),
        actions: [
          TextButton(onPressed: _loaded ? _save : null, child: const Text('Save')),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Defaults apply to new tasks. You can still change each one.',
                  style: BethTypography.caption,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _layer,
                  decoration: const InputDecoration(labelText: 'Default layer'),
                  items: taskLayers
                      .map((l) => DropdownMenuItem(value: l.$1, child: Text(l.$2)))
                      .toList(),
                  onChanged: (v) => setState(() => _layer = v ?? _layer),
                ),
                const SizedBox(height: 16),
                Text('Default priority', style: BethTypography.caption),
                Wrap(
                  spacing: 8,
                  children: TaskPriority.values.map((p) {
                    return ChoiceChip(
                      label: Text(p.name),
                      selected: _priority == p,
                      onSelected: (_) => setState(() => _priority = p),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text('Default energy', style: BethTypography.caption),
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
              ],
            ),
    );
  }
}
