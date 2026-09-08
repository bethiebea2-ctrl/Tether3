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

Color dreamCategoryColour(String? key) {
  switch (key) {
    case 'goal':
      return BethColours.green;
    case 'bucket_list':
      return BethColours.amber;
    case 'manifestation':
      return BethColours.social;
    case 'dream':
    default:
      return BethColours.primary;
  }
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

  Future<void> deleteWin(String id) async {
    final db = await _db;
    await db.delete('win_logs', where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> deleteDream(String id) async {
    final db = await _db;
    await db.delete('dream_board_items', where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> deleteCelebration(String id) async {
    final db = await _db;
    await db.delete('celebration_logs', where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> deleteBook(String id) async {
    final db = await _db;
    await db.delete('book_tracker_items', where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> updateWin(String id, String content) async {
    final db = await _db;
    await db.update('win_logs', {'content': content}, where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> updateDream(
    String id, {
    required String title,
    String? notes,
    required String category,
  }) async {
    final db = await _db;
    await db.update(
      'dream_board_items',
      {'title': title, 'notes': notes, 'category': category},
      where: 'id = ?',
      whereArgs: [id],
    );
    await load();
  }

  Future<void> updateCelebration(String id, String content) async {
    final db = await _db;
    await db.update('celebration_logs', {'content': content}, where: 'id = ?', whereArgs: [id]);
    await load();
  }

  Future<void> updateBook(
    String id, {
    required String title,
    String? author,
    required String status,
    String? notes,
  }) async {
    final db = await _db;
    await db.update(
      'book_tracker_items',
      {'title': title, 'author': author, 'status': status, 'notes': notes},
      where: 'id = ?',
      whereArgs: [id],
    );
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

  Future<void> _addOrEditWin(WinLogProvider provider, {Map<String, dynamic>? existing}) async {
    final c = TextEditingController(text: existing?['content'] as String? ?? '');
    final isEdit = existing != null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit win' : 'Log a win'),
        content: TextField(
          controller: c,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'What went okay today?',
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(isEdit ? 'Save' : 'Add')),
        ],
      ),
    );
    if (ok != true || !mounted || c.text.trim().isEmpty) return;
    if (isEdit) {
      await provider.updateWin(existing['id'] as String, c.text.trim());
    } else {
      await provider.addWin(c.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final wins = context.watch<WinLogProvider>();
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Win log'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.amber,
        onPressed: () => _addOrEditWin(wins),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: wins.wins.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Tiny wins count — log one when something goes okay.',
                  style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: wins.wins.length,
              itemBuilder: (context, i) {
                final w = wins.wins[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        BethColours.amber.withOpacity(0.18),
                        BethColours.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BethColours.amber.withOpacity(0.35)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    leading: CircleAvatar(
                      backgroundColor: BethColours.amber.withOpacity(0.25),
                      child: const Icon(Icons.emoji_events, color: BethColours.amber, size: 22),
                    ),
                    title: Text(
                      w['content'] as String? ?? '',
                      style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _formatCreativeTimestamp(w['created_at'] as String?),
                      style: BethTypography.caption,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'edit') {
                          await _addOrEditWin(wins, existing: w);
                        } else if (action == 'delete') {
                          final ok = await _confirmDelete(context, 'win');
                          if (ok == true) await wins.deleteWin(w['id'] as String);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
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

  Future<void> _addOrEditDream(WinLogProvider wins, {Map<String, dynamic>? existing}) async {
    final title = TextEditingController(text: existing?['title'] as String? ?? '');
    final notes = TextEditingController(text: existing?['notes'] as String? ?? '');
    var category = existing?['category'] as String? ?? 'dream';
    final isEdit = existing != null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(isEdit ? 'Edit dream' : 'Add to dream board'),
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
                    .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                    .toList(),
                onChanged: (v) => setModal(() => category = v!),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: notes,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
                maxLines: 2,
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(isEdit ? 'Save' : 'Add')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted || title.text.trim().isEmpty) return;
    if (isEdit) {
      await wins.updateDream(
        existing['id'] as String,
        title: title.text.trim(),
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
        category: category,
      );
    } else {
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
    final grouped = <String, List<Map<String, dynamic>>>{};
    for (final d in wins.dreams) {
      final cat = d['category'] as String? ?? 'dream';
      grouped.putIfAbsent(cat, () => []).add(d);
    }

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Dream board'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _addOrEditDream(wins),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: wins.dreams.isEmpty
          ? Center(
              child: Text(
                'Pin goals, bucket-list items, and dreams here.',
                style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                for (final option in dreamCategoryOptions) ...[
                  if ((grouped[option.$1] ?? []).isNotEmpty) ...[
                    _dreamSectionHeader(option.$2, dreamCategoryColour(option.$1)),
                    const SizedBox(height: 8),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 1.05,
                      children: grouped[option.$1]!.map((d) {
                        final colour = dreamCategoryColour(d['category'] as String?);
                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colour.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colour.withOpacity(0.45)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.auto_awesome, size: 16, color: colour),
                                  const Spacer(),
                                  PopupMenuButton<String>(
                                    icon: Icon(Icons.more_horiz, size: 18, color: colour),
                                    onSelected: (action) async {
                                      if (action == 'edit') {
                                        await _addOrEditDream(wins, existing: d);
                                      } else if (action == 'delete') {
                                        final ok = await _confirmDelete(context, 'item');
                                        if (ok == true) await wins.deleteDream(d['id'] as String);
                                      }
                                    },
                                    itemBuilder: (_) => const [
                                      PopupMenuItem(value: 'edit', child: Text('Edit')),
                                      PopupMenuItem(value: 'delete', child: Text('Delete')),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Expanded(
                                child: Text(
                                  d['title'] as String? ?? '',
                                  style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ),
                              if ((d['notes'] as String?)?.isNotEmpty == true)
                                Text(
                                  d['notes'] as String,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: BethTypography.caption,
                                ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                  ],
                ],
              ],
            ),
    );
  }
}

Widget _dreamSectionHeader(String title, Color colour) {
  return Row(
    children: [
      Container(width: 4, height: 20, color: colour, margin: const EdgeInsets.only(right: 10)),
      Text(title, style: BethTypography.subheading.copyWith(color: colour)),
    ],
  );
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

Future<bool?> _confirmDelete(BuildContext context, String label) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text('Delete $label?'),
      content: const Text('This cannot be undone.'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
      ],
    ),
  );
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

  Future<void> _addOrEditCelebration(WinLogProvider provider, {Map<String, dynamic>? existing}) async {
    final c = TextEditingController(text: existing?['content'] as String? ?? '');
    final isEdit = existing != null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Edit celebration' : 'Celebrate something'),
        content: TextField(
          controller: c,
          maxLines: 3,
          decoration: const InputDecoration(hintText: 'What are you proud of?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(isEdit ? 'Save' : 'Add')),
        ],
      ),
    );
    if (ok != true || !mounted || c.text.trim().isEmpty) return;
    if (isEdit) {
      await provider.updateCelebration(existing['id'] as String, c.text.trim());
    } else {
      await provider.addCelebration(c.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WinLogProvider>();
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Celebration log'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.social,
        onPressed: () => _addOrEditCelebration(provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.celebrations.isEmpty
          ? Center(
              child: Text(
                'Mark moments worth celebrating — big or small.',
                style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              itemCount: provider.celebrations.length,
              itemBuilder: (context, i) {
                final e = provider.celebrations[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        BethColours.social.withOpacity(0.16),
                        BethColours.surface,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: BethColours.social.withOpacity(0.35)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
                    leading: CircleAvatar(
                      backgroundColor: BethColours.social.withOpacity(0.2),
                      child: const Icon(Icons.celebration, color: BethColours.social),
                    ),
                    title: Text(
                      e['content'] as String? ?? '',
                      style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      _formatCreativeTimestamp(e['created_at'] as String?),
                      style: BethTypography.caption,
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) async {
                        if (action == 'edit') {
                          await _addOrEditCelebration(provider, existing: e);
                        } else if (action == 'delete') {
                          final ok = await _confirmDelete(context, 'celebration');
                          if (ok == true) await provider.deleteCelebration(e['id'] as String);
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                      ],
                    ),
                  ),
                );
              },
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

  Future<void> _addOrEditBook(WinLogProvider provider, {Map<String, dynamic>? existing}) async {
    final title = TextEditingController(text: existing?['title'] as String? ?? '');
    final author = TextEditingController(text: existing?['author'] as String? ?? '');
    final notes = TextEditingController(text: existing?['notes'] as String? ?? '');
    var status = existing?['status'] as String? ?? 'want_to_read';
    final isEdit = existing != null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(isEdit ? 'Edit book' : 'Add book'),
          content: SingleChildScrollView(
            child: Column(
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
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(isEdit ? 'Save' : 'Add')),
          ],
        ),
      ),
    );
    if (ok != true || !mounted || title.text.trim().isEmpty) return;
    if (isEdit) {
      await provider.updateBook(
        existing['id'] as String,
        title: title.text.trim(),
        author: author.text.trim().isEmpty ? null : author.text.trim(),
        status: status,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
      );
    } else {
      await provider.addBook(
        title.text.trim(),
        author: author.text.trim().isEmpty ? null : author.text.trim(),
        status: status,
        notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
      );
    }
  }

  Color _statusColour(String? status) {
    switch (status) {
      case 'reading':
        return BethColours.primary;
      case 'finished':
        return BethColours.green;
      case 'dnf':
        return BethColours.textMuted;
      case 'want_to_read':
      default:
        return BethColours.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WinLogProvider>();
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Book tracker'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _addOrEditBook(provider),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: provider.books.isEmpty
          ? Center(
              child: Text(
                'Track your reading list — no streak pressure.',
                style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
                textAlign: TextAlign.center,
              ),
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
              children: [
                for (final option in bookStatusOptions) ...[
                  ...() {
                    final section = provider.books
                        .where((b) => (b['status'] as String? ?? 'want_to_read') == option.$1)
                        .toList();
                    if (section.isEmpty) return <Widget>[];
                    final colour = _statusColour(option.$1);
                    return [
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 4,
                              height: 20,
                              color: colour,
                              margin: const EdgeInsets.only(right: 10),
                            ),
                            Text(option.$2, style: BethTypography.subheading.copyWith(color: colour)),
                            const SizedBox(width: 8),
                            Text('(${section.length})', style: BethTypography.caption),
                          ],
                        ),
                      ),
                      ...section.map((b) {
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          color: colour.withOpacity(0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: colour.withOpacity(0.3)),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.menu_book, color: colour),
                            title: Text(
                              b['title'] as String? ?? '',
                              style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text(
                              [
                                if ((b['author'] as String?)?.isNotEmpty == true) b['author'],
                                if ((b['notes'] as String?)?.isNotEmpty == true) b['notes'],
                              ].join(' · '),
                              style: BethTypography.caption,
                            ),
                            trailing: PopupMenuButton<String>(
                              onSelected: (action) async {
                                if (action == 'edit') {
                                  await _addOrEditBook(provider, existing: b);
                                } else if (action == 'delete') {
                                  final ok = await _confirmDelete(context, 'book');
                                  if (ok == true) await provider.deleteBook(b['id'] as String);
                                }
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(value: 'edit', child: Text('Edit')),
                                PopupMenuItem(value: 'delete', child: Text('Delete')),
                              ],
                            ),
                          ),
                        );
                      }),
                    ];
                  }(),
                ],
              ],
            ),
    );
  }
}

class CreativeCornerScreen extends StatefulWidget {
  const CreativeCornerScreen({super.key});

  @override
  State<CreativeCornerScreen> createState() => _CreativeCornerScreenState();
}

class _CreativeCornerScreenState extends State<CreativeCornerScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<WinLogProvider>().load());
  }

  @override
  Widget build(BuildContext context) {
    final creative = context.watch<WinLogProvider>();
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Creative corner'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Wellbeing and creative spaces — gentle tracking, no pressure.',
            style: BethTypography.caption.copyWith(color: BethColours.textMuted),
          ),
          const SizedBox(height: 16),
          _linkTile(
            context,
            icon: Icons.emoji_events_outlined,
            title: 'Win log',
            subtitle: 'Tiny wins count',
            count: creative.wins.length,
            accent: BethColours.amber,
            screen: const WinLogScreen(),
          ),
          _linkTile(
            context,
            icon: Icons.auto_awesome_outlined,
            title: 'Dream board',
            subtitle: 'Goals, dreams, manifestations',
            count: creative.dreams.length,
            accent: BethColours.primary,
            screen: const DreamBoardScreen(),
          ),
          _linkTile(
            context,
            icon: Icons.celebration_outlined,
            title: 'Celebration log',
            subtitle: 'Moments worth marking',
            count: creative.celebrations.length,
            accent: BethColours.social,
            screen: const CelebrationLogScreen(),
          ),
          _linkTile(
            context,
            icon: Icons.menu_book_outlined,
            title: 'Book tracker',
            subtitle: 'Reading list — no streak pressure',
            count: creative.books.length,
            accent: BethColours.evander,
            screen: const BookTrackerScreen(),
          ),
        ],
      ),
    );
  }

  Widget _linkTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int count,
    required Color accent,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: accent.withOpacity(0.06),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: BorderSide(color: accent.withOpacity(0.25)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: accent.withOpacity(0.18),
          child: Icon(icon, color: accent),
        ),
        title: Text(title, style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: BethTypography.caption),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (count > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('$count', style: BethTypography.caption.copyWith(color: accent)),
              ),
            const Icon(Icons.chevron_right),
          ],
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => screen)),
      ),
    );
  }
}
