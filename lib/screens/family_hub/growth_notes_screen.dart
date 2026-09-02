import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:uuid/uuid.dart';
import '../../core/utils/au_date_format.dart';
import '../../database/database_helper.dart';
import '../../models/person.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Growth notes for babies and children — weight, height, head circumference.
class GrowthNotesScreen extends StatefulWidget {
  final Person person;
  const GrowthNotesScreen({super.key, required this.person});

  @override
  State<GrowthNotesScreen> createState() => _GrowthNotesScreenState();
}

class _GrowthNotesScreenState extends State<GrowthNotesScreen> {
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<Database> get _db => DatabaseHelper().database;

  Future<void> _load() async {
    final db = await _db;
    _entries = await db.query(
      'growth_notes',
      where: 'person_id = ? OR child_id = ?',
      whereArgs: [widget.person.id, widget.person.id],
      orderBy: 'date DESC',
    );
    if (mounted) setState(() => _loading = false);
  }

  Future<void> _addEntry() async {
    var date = DateTime.now();
    final weight = TextEditingController();
    final height = TextEditingController();
    final head = TextEditingController();
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add growth note'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Date'),
                  subtitle: Text(formatAuDate(date)),
                  trailing: const Icon(Icons.calendar_today),
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: date,
                      firstDate: DateTime(2010),
                      lastDate: DateTime.now(),
                      helpText: 'Measurement date (DD/MM/YYYY)',
                    );
                    if (picked != null) setModal(() => date = picked);
                  },
                ),
                TextField(
                  controller: weight,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: height,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
                TextField(
                  controller: head,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Head circumference (cm)'),
                ),
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
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
    if (ok != true) return;
    final db = await _db;
    final now = DateTime.now().toIso8601String();
    await db.insert('growth_notes', {
      'id': _uuid.v4(),
      'child_id': widget.person.id,
      'person_id': widget.person.id,
      'date': date.toIso8601String().split('T').first,
      'weight_kg': double.tryParse(weight.text.trim()),
      'height_cm': double.tryParse(height.text.trim()),
      'head_circumference_cm': double.tryParse(head.text.trim()),
      'notes': notes.text.trim().isEmpty ? null : notes.text.trim(),
      'created_at': now,
    });
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.person.displayName} · Growth')),
      floatingActionButton: FloatingActionButton(
        onPressed: _addEntry,
        child: const Icon(Icons.add),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Track weight, height, and head circumference over time. '
                      'Percentile charts arrive in a later phase.',
                      style: BethTypography.body.copyWith(color: BethColours.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _entries.length,
                  itemBuilder: (_, i) {
                    final e = _entries[i];
                    final parts = <String>[];
                    final w = e['weight_kg'];
                    final h = e['height_cm'];
                    final hc = e['head_circumference_cm'];
                    if (w != null) parts.add('${w} kg');
                    if (h != null) parts.add('${h} cm');
                    if (hc != null) parts.add('head ${hc} cm');
                    final dateStr = e['date'] as String? ?? '';
                    final parsed = DateTime.tryParse(dateStr);
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.show_chart),
                        title: Text(
                          parsed == null ? dateStr : formatAuDate(parsed),
                          style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          [
                            if (parts.isNotEmpty) parts.join(' · '),
                            if ((e['notes'] as String?)?.isNotEmpty == true) e['notes'],
                          ].join('\n'),
                          style: BethTypography.caption,
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
