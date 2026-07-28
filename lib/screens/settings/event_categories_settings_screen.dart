import 'package:flutter/material.dart';
import '../../database/calendar_dao.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'package:provider/provider.dart';

/// Links calendar colours to people where `person_id` is set on categories.
class EventCategoriesSettingsScreen extends StatefulWidget {
  const EventCategoriesSettingsScreen({super.key});

  @override
  State<EventCategoriesSettingsScreen> createState() => _EventCategoriesSettingsScreenState();
}

class _EventCategoriesSettingsScreenState extends State<EventCategoriesSettingsScreen> {
  final _dao = CalendarDao();
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final cats = await _dao.getCategories();
    if (mounted) setState(() => _categories = cats);
  }

  @override
  Widget build(BuildContext context) {
    final hub = context.watch<FamilyHubProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Event categories')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Categories colour-code your calendar and filter views. '
            'Maximum 15 categories.',
            style: BethTypography.caption.copyWith(color: BethColours.textMuted),
          ),
          const SizedBox(height: 12),
          ..._categories.map((cat) {
            final personId = cat['person_id'] as String?;
            final linked = personId != null ? hub.personById(personId)?.displayName : null;
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
                onPressed: () => _showEditStub(context, cat['name'] as String? ?? 'Category'),
                child: const Text('Edit'),
              ),
            );
          }),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.add),
            title: const Text('Add category'),
            subtitle: Text(
              'Full editor coming soon — stub for Phase 1B',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
            onTap: () => _showEditStub(context, 'New category', isAdd: true),
          ),
        ],
      ),
    );
  }

  void _showEditStub(BuildContext context, String name, {bool isAdd = false}) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isAdd ? 'Add category' : 'Edit $name'),
        content: const Text(
          'Name, icon, colour, and calendar/filter visibility will be editable here. '
          'Persistence wiring lands with calendar category CRUD.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
        ],
      ),
    );
  }
}
