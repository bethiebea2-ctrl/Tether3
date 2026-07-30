import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../database/database_helper.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

const dreamCategoryOptions = <(String, String)>[
  ('goal', 'Goal'),
  ('bucket_list', 'Bucket list'),
  ('dream', 'Dream'),
  ('manifestation', 'Manifestation'),
];

String dreamCategoryLabel(String? key) {
  for (final o in dreamCategoryOptions) {
    if (o.$1 == key) return o.$2;
  }
  return 'Dream';
}

class WinLogProvider extends ChangeNotifier {
  final _uuid = const Uuid();
  List<Map<String, dynamic>> wins = [];
  List<Map<String, dynamic>> dreams = [];

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> load() async {
    final db = await _db;
    wins = await db.query('win_logs', orderBy: 'created_at DESC', limit: 50);
    dreams = await db.query(
      'dream_board_items',
      orderBy: 'sort_order ASC, created_at DESC',
    );
    notifyListeners();
  }

  Future<void> addWin(String content) async {
    final db = await _db;
    await db.insert('win_logs', {
      'id': _uuid.v4(),
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });
    await load();
  }

  Future<void> addDream(
    String title, {
    String? notes,
    String category = 'dream',
  }) async {
    final db = await _db;
    await db.insert('dream_board_items', {
      'id': _uuid.v4(),
      'title': title,
      'notes': notes,
      'category': category,
      'sort_order': dreams.length,
      'created_at': DateTime.now().toIso8601String(),
    });
    await load();
  }
}

class WinLogScreen extends StatefulWidget {
  const WinLogScreen({super.key});

  @override
  State<WinLogScreen> createState() => _WinLogScreenState();
}

class _WinLogScreenState extends State<WinLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<WinLogProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final wins = context.watch<WinLogProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Win log')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final c = TextEditingController();
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Log a win'),
              content: TextField(
                controller: c,
                decoration: const InputDecoration(
                  hintText: 'What went okay today?',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Save'),
                ),
              ],
            ),
          );
          if (ok == true && context.mounted && c.text.trim().isNotEmpty) {
            await wins.addWin(c.text.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: wins.wins
            .map(
              (w) => ListTile(
                leading: const Icon(Icons.emoji_events_outlined),
                title: Text(w['content'] as String? ?? ''),
                subtitle: Text(
                  () {
                    final raw = w['created_at'] as String?;
                    final dt = raw == null ? null : DateTime.tryParse(raw);
                    return dt == null
                        ? (raw ?? '')
                        : DateFormat('dd/MM/yyyy · h:mm a').format(dt);
                  }(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class DreamBoardScreen extends StatefulWidget {
  const DreamBoardScreen({super.key});

  @override
  State<DreamBoardScreen> createState() => _DreamBoardScreenState();
}

class _DreamBoardScreenState extends State<DreamBoardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<WinLogProvider>().load());
  }

  Future<void> _addDream(WinLogProvider wins) async {
    final title = TextEditingController();
    final notes = TextEditingController();
    var category = 'dream';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add to dream board'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: category,
                decoration: const InputDecoration(labelText: 'Category'),
                items: dreamCategoryOptions
                    .map(
                      (o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)),
                    )
                    .toList(),
                onChanged: (v) => setModal(() => category = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notes,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok == true && context.mounted && title.text.trim().isNotEmpty) {
      await wins.addDream(
        title.text.trim(),
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
        category: category,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final wins = context.watch<WinLogProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Dream board')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addDream(wins),
        child: const Icon(Icons.add),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: wins.dreams
            .map(
              (d) => Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: BethColours.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dreamCategoryLabel(d['category'] as String?),
                      style: BethTypography.caption.copyWith(
                        color: BethColours.primary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Expanded(
                      child: Text(
                        d['title'] as String? ?? '',
                        style: BethTypography.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
