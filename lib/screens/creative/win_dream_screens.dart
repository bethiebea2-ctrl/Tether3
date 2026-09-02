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
  List<Map<String, dynamic>> celebrations = [];
  List<Map<String, dynamic>> books = [];

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> load() async {
    final db = await _db;
    wins = await db.query('win_logs', orderBy: 'created_at DESC', limit: 50);
    dreams = await db.query(
      'dream_board_items',
      orderBy: 'sort_order ASC, created_at DESC',
    );
    celebrations = await db.query(
      'celebration_logs',
      orderBy: 'created_at DESC',
      limit: 50,
    );
    books = await db.query(
      'book_tracker_items',
      orderBy: 'created_at DESC',
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

  Future<void> addCelebration(String content) async {
    final db = await _db;
    await db.insert('celebration_logs', {
      'id': _uuid.v4(),
      'content': content,
      'created_at': DateTime.now().toIso8601String(),
    });
    await load();
  }

  Future<void> addBook(String title, {String? author, String status = 'want_to_read', String? notes}) async {
    final db = await _db;
    await db.insert('book_tracker_items', {
      'id': _uuid.v4(),
      'title': title,
      'author': author,
      'status': status,
      'notes': notes,
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

const bookStatusOptions = <(String, String)>[
  ('want_to_read', 'Want to read'),
  ('reading', 'Reading'),
  ('finished', 'Finished'),
  ('dnf', 'Did not finish'),
];

String bookStatusLabel(String? key) {
  for (final o in bookStatusOptions) {
    if (o.$1 == key) return o.$2;
  }
  return 'Want to read';
}

String _formatCreativeTimestamp(String? raw) {
  final dt = raw == null ? null : DateTime.tryParse(raw);
  return dt == null ? (raw ?? '') : DateFormat('dd/MM/yyyy · h:mm a').format(dt);
}

class CelebrationLogScreen extends StatefulWidget {
  const CelebrationLogScreen({super.key});

  @override
  State<CelebrationLogScreen> createState() => _CelebrationLogScreenState();
}

class _CelebrationLogScreenState extends State<CelebrationLogScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<WinLogProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WinLogProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Celebration log')),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final c = TextEditingController();
          final ok = await showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Celebrate something'),
              content: TextField(
                controller: c,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'What are you proud of?'),
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
              ],
            ),
          );
          if (ok == true && context.mounted && c.text.trim().isNotEmpty) {
            await provider.addCelebration(c.text.trim());
          }
        },
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: provider.celebrations
            .map(
              (e) => ListTile(
                leading: const Icon(Icons.celebration_outlined),
                title: Text(e['content'] as String? ?? ''),
                subtitle: Text(_formatCreativeTimestamp(e['created_at'] as String?)),
              ),
            )
            .toList(),
      ),
    );
  }
}

class BookTrackerScreen extends StatefulWidget {
  const BookTrackerScreen({super.key});

  @override
  State<BookTrackerScreen> createState() => _BookTrackerScreenState();
}

class _BookTrackerScreenState extends State<BookTrackerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<WinLogProvider>().load());
  }

  Future<void> _addBook(WinLogProvider provider) async {
    final title = TextEditingController();
    final author = TextEditingController();
    var status = 'want_to_read';
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
              TextField(controller: author, decoration: const InputDecoration(labelText: 'Author')),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: bookStatusOptions
                    .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                    .toList(),
                onChanged: (v) => setModal(() => status = v!),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (ok == true && context.mounted && title.text.trim().isNotEmpty) {
      await provider.addBook(
        title.text.trim(),
        author: author.text.trim().isEmpty ? null : author.text.trim(),
        status: status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WinLogProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Book tracker')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addBook(provider),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        children: provider.books
            .map(
              (b) => ListTile(
                leading: const Icon(Icons.menu_book_outlined),
                title: Text(b['title'] as String? ?? ''),
                subtitle: Text(
                  [
                    if ((b['author'] as String?)?.isNotEmpty == true) b['author'],
                    bookStatusLabel(b['status'] as String?),
                  ].join(' · '),
                  style: BethTypography.caption,
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class CreativeCornerScreen extends StatelessWidget {
  const CreativeCornerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Creative corner')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Wellbeing and creative spaces — gentle tracking, no pressure.',
            style: BethTypography.caption.copyWith(color: BethColours.textMuted),
          ),
          const SizedBox(height: 16),
          _linkTile(context, icon: Icons.emoji_events_outlined, title: 'Win log', subtitle: 'Tiny wins count', screen: const WinLogScreen()),
          _linkTile(context, icon: Icons.auto_awesome_outlined, title: 'Dream board', subtitle: 'Goals, dreams, manifestations', screen: const DreamBoardScreen()),
          _linkTile(context, icon: Icons.celebration_outlined, title: 'Celebration log', subtitle: 'Moments worth marking', screen: const CelebrationLogScreen()),
          _linkTile(context, icon: Icons.menu_book_outlined, title: 'Book tracker', subtitle: 'Reading list — no streak pressure', screen: const BookTrackerScreen()),
        ],
      ),
    );
  }

  Widget _linkTile(BuildContext context, {required IconData icon, required String title, required String subtitle, required Widget screen}) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: BethColours.primary),
        title: Text(title),
        subtitle: Text(subtitle, style: BethTypography.caption),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
