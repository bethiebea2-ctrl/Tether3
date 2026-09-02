import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/tasks/task_energy.dart';
import '../../core/tasks/task_priority.dart';
import '../../core/tasks/task_repository.dart';
import '../../database/database_helper.dart';
import '../../models/task.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class TaskPackLibraryScreen extends StatefulWidget {
  const TaskPackLibraryScreen({super.key});

  @override
  State<TaskPackLibraryScreen> createState() => _TaskPackLibraryScreenState();
}

class _TaskPackLibraryScreenState extends State<TaskPackLibraryScreen> {
  final _uuid = const Uuid();
  List<TaskPack> _packs = [];
  bool _loading = true;

  static final List<TaskPack> _seedPacks = [
    TaskPack(
      id: 'pack_adhd',
      packKey: 'adhd_support',
      displayName: 'ADHD support',
      description: 'Small, startable tasks for focus days.',
      items: const [
        TaskPackItem(id: '1', title: 'Drink water', category: 'bare_minimum', energyLevel: 'low'),
        TaskPackItem(id: '2', title: 'One 10-minute tidy', category: 'house', energyLevel: 'low'),
        TaskPackItem(id: '3', title: 'Reply to one message', category: 'life_admin', energyLevel: 'medium'),
      ],
    ),
    TaskPack(
      id: 'pack_depression',
      packKey: 'depression_support',
      displayName: 'Depression support',
      description: 'Gentle bare minimums.',
      items: const [
        TaskPackItem(id: '1', title: 'Eat something', category: 'bare_minimum', energyLevel: 'low'),
        TaskPackItem(id: '2', title: 'Step outside briefly', category: 'recovery', energyLevel: 'low'),
        TaskPackItem(id: '3', title: 'Rest without guilt', category: 'recovery', energyLevel: 'low'),
      ],
    ),
    TaskPack(
      id: 'pack_new_parent',
      packKey: 'new_parent_survival',
      displayName: 'New parent survival',
      description: 'Care + survival day pack.',
      items: const [
        TaskPackItem(id: '1', title: 'Baby fed', category: 'care', priority: 'urgent', energyLevel: 'low'),
        TaskPackItem(id: '2', title: 'Drink water', category: 'bare_minimum', energyLevel: 'low'),
        TaskPackItem(id: '3', title: 'One load of washing', category: 'house', energyLevel: 'medium'),
      ],
    ),
    TaskPack(
      id: 'pack_low_energy',
      packKey: 'low_energy_day',
      displayName: 'Low-energy day',
      description: 'Only what matters.',
      items: const [
        TaskPackItem(id: '1', title: 'Medication', category: 'bare_minimum', priority: 'urgent', energyLevel: 'low'),
        TaskPackItem(id: '2', title: 'Eat', category: 'bare_minimum', energyLevel: 'low'),
        TaskPackItem(id: '3', title: 'Rest', category: 'recovery', energyLevel: 'low'),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Database> get _db async => DatabaseHelper().database;

  Future<void> _load() async {
    final db = await _db;
    final rows = await db.query('task_packs');
    if (rows.isEmpty) {
      for (final p in _seedPacks) {
        await db.insert('task_packs', {
          'id': p.id,
          'pack_key': p.packKey,
          'display_name': p.displayName,
          'description': p.description,
          'is_system': 1,
          'items_json': jsonEncode(p.items
              .map((i) => {
                    'id': i.id,
                    'title': i.title,
                    'category': i.category,
                    'priority': i.priority,
                    'energyLevel': i.energyLevel,
                    'sortOrder': i.sortOrder,
                  })
              .toList()),
        });
      }
    }
    final loaded = await db.query('task_packs');
    setState(() {
      _packs = loaded.map(_fromRow).toList();
      _loading = false;
    });
  }

  TaskPack _fromRow(Map<String, dynamic> row) {
    final itemsJson = jsonDecode(row['items_json'] as String? ?? '[]') as List;
    return TaskPack(
      id: row['id'] as String,
      packKey: row['pack_key'] as String,
      displayName: row['display_name'] as String,
      description: row['description'] as String? ?? '',
      isSystem: (row['is_system'] as int? ?? 1) == 1,
      items: itemsJson
          .map((i) => TaskPackItem(
                id: i['id'] as String? ?? _uuid.v4(),
                title: i['title'] as String? ?? '',
                category: i['category'] as String? ?? 'life_admin',
                priority: i['priority'] as String? ?? 'for_later',
                energyLevel: i['energyLevel'] as String? ?? 'medium',
                sortOrder: i['sortOrder'] as int? ?? 0,
              ))
          .toList(),
    );
  }

  Future<void> _applyPack(TaskPack pack) async {
    final repo = TaskRepository();
    for (final item in pack.items) {
      await repo.addTask(
        title: item.title,
        layer: item.category,
        priority: item.priority == 'urgent' ? TaskPriority.high : TaskPriority.medium,
        energy: TaskEnergy.values.firstWhere(
          (e) => e.name == item.energyLevel,
          orElse: () => TaskEnergy.medium,
        ),
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Added ${pack.items.length} tasks from ${pack.displayName}.')),
    );
  }

  Future<void> _removePack(TaskPack pack) async {
    final db = await _db;
    await db.delete('task_packs', where: 'id = ?', whereArgs: [pack.id]);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Task packs')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _packs.length,
              itemBuilder: (context, index) {
                final pack = _packs[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(pack.displayName, style: BethTypography.subheading),
                        const SizedBox(height: 4),
                        Text(pack.description, style: BethTypography.caption),
                        const SizedBox(height: 8),
                        ...pack.items.map(
                          (i) => Text('· ${i.title}', style: BethTypography.bodySmall),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            FilledButton(
                              onPressed: () => _applyPack(pack),
                              child: const Text('Add to list'),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => _removePack(pack),
                              child: const Text('Remove pack'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
