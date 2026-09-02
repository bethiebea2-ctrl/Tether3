import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../database/calendar_dao.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Full CRUD for calendar event categories (Phase 1B).
class EventCategoriesSettingsScreen extends StatefulWidget {
  const EventCategoriesSettingsScreen({super.key});

  @override
  State<EventCategoriesSettingsScreen> createState() =>
      _EventCategoriesSettingsScreenState();
}

class _EventCategoriesSettingsScreenState extends State<EventCategoriesSettingsScreen> {
  final _dao = CalendarDao();
  final _uuid = const Uuid();
  List<Map<String, dynamic>> _categories = [];

  static const _colours = [
    '#7ec8e3',
    '#66bb6a',
    '#ffa726',
    '#b8a9d4',
    '#ff9800',
    '#4db6ac',
    '#f06292',
    '#9e9e9e',
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await _dao.getCategories();
    if (mounted) setState(() => _categories = cats);
  }

  Future<void> _edit({Map<String, dynamic>? existing}) async {
    if (existing == null && _categories.length >= 15) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 15 categories.')),
      );
      return;
    }
    final name = TextEditingController(text: existing?['name'] as String? ?? '');
    final icon = TextEditingController(text: existing?['icon'] as String? ?? '•');
    var colour = existing?['colour'] as String? ?? '#9e9e9e';
    String? personId = existing?['person_id'] as String?;
    final hub = context.read<FamilyHubProvider>();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text(existing == null ? 'Add category' : 'Edit category'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
                TextField(controller: icon, decoration: const InputDecoration(labelText: 'Icon / emoji')),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: _colours.map((c) {
                    return GestureDetector(
                      onTap: () => setModal(() => colour = c),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: Color(int.parse(c.replaceFirst('#', '0xFF'))),
                        child: colour == c
                            ? const Icon(Icons.check, size: 14, color: Colors.white)
                            : null,
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: personId,
                  decoration: const InputDecoration(labelText: 'Link to person'),
                  items: [
                    const DropdownMenuItem<String?>(value: null, child: Text('None')),
                    ...hub.people.where((p) => !p.isPet).map(
                          (p) => DropdownMenuItem<String?>(
                            value: p.id,
                            child: Text(p.displayName),
                          ),
                        ),
                  ],
                  onChanged: (v) => setModal(() => personId = v),
                ),
              ],
            ),
          ),
          actions: [
            if (existing != null)
              TextButton(
                onPressed: () async {
                  await _dao.deleteCategory(existing['id'] as String);
                  if (ctx.mounted) Navigator.pop(ctx, true);
                },
                child: const Text('Delete', style: TextStyle(color: BethColours.red)),
              ),
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );

    if (ok != true) return;
    final map = {
      'id': existing?['id'] as String? ?? _uuid.v4(),
      'name': name.text.trim().isEmpty ? 'Category' : name.text.trim(),
      'colour': colour,
      'icon': icon.text.trim().isEmpty ? '•' : icon.text.trim(),
      'sort_order': existing?['sort_order'] as int? ?? (_categories.length + 1),
      'person_id': personId,
    };
    await _dao.upsertCategory(map);
    await context.read<CalendarProvider>().loadCategories();
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final hub = context.watch<FamilyHubProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Event categories')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _edit(),
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Categories colour-code your calendar and filter views. Maximum 15.',
            style: BethTypography.caption.copyWith(color: BethColours.textMuted),
          ),
          const SizedBox(height: 12),
          ..._categories.map((cat) {
            final personId = cat['person_id'] as String?;
            final linked =
                personId != null ? hub.personById(personId)?.displayName : null;
            return ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                backgroundColor: Color(
                  int.parse((cat['colour'] as String? ?? '#888888').replaceFirst('#', '0xFF')),
                ),
                child: Text(cat['icon'] as String? ?? '•'),
              ),
              title: Text(cat['name'] as String? ?? ''),
              subtitle: Text(linked ?? 'Not linked to a person'),
              trailing: TextButton(
                onPressed: () => _edit(existing: cat),
                child: const Text('Edit'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
