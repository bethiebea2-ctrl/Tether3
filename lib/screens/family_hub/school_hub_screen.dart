import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../database/database_helper.dart';
import '../../models/person.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

const schoolDays = <(String, String)>[
  ('mon', 'Monday'),
  ('tue', 'Tuesday'),
  ('wed', 'Wednesday'),
  ('thu', 'Thursday'),
  ('fri', 'Friday'),
];

/// School hub for children and teens — timetable, contacts, and notes.
class SchoolHubScreen extends StatefulWidget {
  final Person person;
  const SchoolHubScreen({super.key, required this.person});

  @override
  State<SchoolHubScreen> createState() => _SchoolHubScreenState();
}

class _SchoolHubScreenState extends State<SchoolHubScreen>
    with SingleTickerProviderStateMixin {
  final _uuid = const Uuid();
  late TabController _tabs;
  List<Map<String, dynamic>> _timetable = [];
  List<Map<String, dynamic>> _contacts = [];
  List<Map<String, dynamic>> _notes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> _load() async {
    final db = await _db;
    final pid = widget.person.id;
    _timetable = await db.query(
      'school_timetable_entries',
      where: 'person_id = ?',
      whereArgs: [pid],
      orderBy: 'day_of_week ASC, time_label ASC',
    );
    _contacts = await db.query(
      'school_contacts',
      where: 'person_id = ?',
      whereArgs: [pid],
      orderBy: 'name ASC',
    );
    _notes = await db.query(
      'school_notes',
      where: 'person_id = ?',
      whereArgs: [pid],
      orderBy: 'created_at DESC',
    );
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addTimetableEntry() async {
    var day = 'mon';
    final subject = TextEditingController();
    final period = TextEditingController();
    final time = TextEditingController();
    final room = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add timetable entry'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: day,
                  decoration: const InputDecoration(labelText: 'Day'),
                  items: schoolDays
                      .map((d) => DropdownMenuItem(value: d.$1, child: Text(d.$2)))
                      .toList(),
                  onChanged: (v) => setModal(() => day = v!),
                ),
                TextField(
                  controller: subject,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                TextField(
                  controller: period,
                  decoration: const InputDecoration(labelText: 'Period (optional)'),
                ),
                TextField(
                  controller: time,
                  decoration: const InputDecoration(labelText: 'Time (e.g. 9:00)'),
                ),
                TextField(
                  controller: room,
                  decoration: const InputDecoration(labelText: 'Room (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );
    if (ok != true || subject.text.trim().isEmpty) return;
    final db = await _db;
    await db.insert('school_timetable_entries', {
      'id': _uuid.v4(),
      'person_id': widget.person.id,
      'day_of_week': day,
      'period_label': period.text.trim().isEmpty ? null : period.text.trim(),
      'subject': subject.text.trim(),
      'time_label': time.text.trim().isEmpty ? null : time.text.trim(),
      'room': room.text.trim().isEmpty ? null : room.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });
    await _load();
  }

  Future<void> _addContact() async {
    final name = TextEditingController();
    final role = TextEditingController();
    final phone = TextEditingController();
    final email = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add school contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(controller: role, decoration: const InputDecoration(labelText: 'Role (e.g. Teacher)')),
            TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone')),
            TextField(controller: email, decoration: const InputDecoration(labelText: 'Email')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true || name.text.trim().isEmpty) return;
    final db = await _db;
    await db.insert('school_contacts', {
      'id': _uuid.v4(),
      'person_id': widget.person.id,
      'name': name.text.trim(),
      'role': role.text.trim().isEmpty ? null : role.text.trim(),
      'phone': phone.text.trim().isEmpty ? null : phone.text.trim(),
      'email': email.text.trim().isEmpty ? null : email.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });
    await _load();
  }

  Future<void> _addNote() async {
    final content = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('School note'),
        content: TextField(
          controller: content,
          maxLines: 4,
          decoration: const InputDecoration(hintText: 'Permission slip, excursion, homework…'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok != true || content.text.trim().isEmpty) return;
    final db = await _db;
    await db.insert('school_notes', {
      'id': _uuid.v4(),
      'person_id': widget.person.id,
      'content': content.text.trim(),
      'created_at': DateTime.now().toIso8601String(),
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.person.displayName} · School'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Timetable'),
            Tab(text: 'Contacts'),
            Tab(text: 'Notes'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _timetableTab(),
                _contactsTab(),
                _notesTab(),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_tabs.index == 0) _addTimetableEntry();
          if (_tabs.index == 1) _addContact();
          if (_tabs.index == 2) _addNote();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _timetableTab() {
    if (_timetable.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'No timetable yet. Tap + to add subjects by day.',
            style: BethTypography.body.copyWith(color: BethColours.textMuted),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    final byDay = <String, List<Map<String, dynamic>>>{};
    for (final row in _timetable) {
      final day = row['day_of_week'] as String? ?? 'mon';
      byDay.putIfAbsent(day, () => []).add(row);
    }
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        for (final day in schoolDays) ...[
          if ((byDay[day.$1] ?? []).isNotEmpty) ...[
            Text(day.$2, style: BethTypography.subheading),
            const SizedBox(height: 8),
            ...byDay[day.$1]!.map(
              (e) => Card(
                child: ListTile(
                  title: Text(e['subject'] as String? ?? ''),
                  subtitle: Text(
                    [
                      if ((e['time_label'] as String?)?.isNotEmpty == true) e['time_label'],
                      if ((e['period_label'] as String?)?.isNotEmpty == true)
                        'Period ${e['period_label']}',
                      if ((e['room'] as String?)?.isNotEmpty == true) 'Room ${e['room']}',
                    ].whereType<String>().join(' · '),
                    style: BethTypography.caption,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ],
    );
  }

  Widget _contactsTab() {
    if (_contacts.isEmpty) {
      return Center(
        child: Text(
          'Add teachers, office staff, or tutors.',
          style: BethTypography.body.copyWith(color: BethColours.textMuted),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _contacts.length,
      itemBuilder: (_, i) {
        final c = _contacts[i];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(c['name'] as String? ?? ''),
            subtitle: Text(
              [
                c['role'],
                c['phone'],
                c['email'],
              ].whereType<String>().where((s) => s.isNotEmpty).join(' · '),
              style: BethTypography.caption,
            ),
          ),
        );
      },
    );
  }

  Widget _notesTab() {
    if (_notes.isEmpty) {
      return Center(
        child: Text(
          'Log permission slips, homework, or school updates.',
          style: BethTypography.body.copyWith(color: BethColours.textMuted),
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _notes.length,
      itemBuilder: (_, i) {
        final n = _notes[i];
        final raw = n['created_at'] as String?;
        final dt = raw == null ? null : DateTime.tryParse(raw);
        return Card(
          child: ListTile(
            title: Text(n['content'] as String? ?? ''),
            subtitle: Text(
              dt == null ? '' : DateFormat('dd/MM/yyyy · h:mm a').format(dt),
              style: BethTypography.caption,
            ),
          ),
        );
      },
    );
  }
}
