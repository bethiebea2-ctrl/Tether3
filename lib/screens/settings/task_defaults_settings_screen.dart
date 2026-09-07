import 'package:flutter/material.dart';
import '../../core/tasks/task_defaults_prefs.dart';
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
    final layer = await TaskDefaultsPrefs.lastSelectedLayer();
    final values = await TaskDefaultsPrefs.loadForLayer(layer);
    setState(() {
      _layer = layer;
      _priority = values.priority;
      _energy = values.energy;
      _loaded = true;
    });
  }

  Future<void> _persistCurrentLayer() async {
    await TaskDefaultsPrefs.saveForLayer(
      layer: _layer,
      priority: _priority,
      energy: _energy,
    );
  }

  Future<void> _onLayerChanged(String? next) async {
    if (next == null || next == _layer) return;
    await _persistCurrentLayer();
    final values = await TaskDefaultsPrefs.loadForLayer(next);
    setState(() {
      _layer = next;
      _priority = values.priority;
      _energy = values.energy;
    });
  }

  Future<void> _save() async {
    await _persistCurrentLayer();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Defaults saved for ${_layerLabel(_layer)}.')),
    );
  }

  String _layerLabel(String id) =>
      taskLayers.firstWhere((l) => l.$1 == id, orElse: () => (id, id)).$2;

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
                  'Set defaults per layer. Changing layer loads that layer’s saved priority and energy.',
                  style: BethTypography.caption,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _layer,
                  decoration: const InputDecoration(labelText: 'Layer'),
                  items: taskLayers
                      .map((l) => DropdownMenuItem(value: l.$1, child: Text(l.$2)))
                      .toList(),
                  onChanged: _loaded ? _onLayerChanged : null,
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
