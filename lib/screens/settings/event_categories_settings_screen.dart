import 'package:flutter/material.dart';
import '../../database/calendar_dao.dart';
import '../../providers/family_hub_provider.dart';
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
            'Person colours appear on the calendar. Link a category to someone in your household.',
            style: BethTypography.caption,
          ),
          const SizedBox(height: 12),
          ..._categories.map((cat) {
            final personId = cat['person_id'] as String?;
            final linked = personId != null ? hub.personById(personId)?.displayName : null;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(int.parse((cat['colour'] as String? ?? '#888888').replaceFirst('#', '0xFF'))),
                child: Text(cat['icon'] as String? ?? '•'),
              ),
              title: Text(cat['name'] as String? ?? ''),
              subtitle: Text(linked ?? 'Not linked to a person'),
            );
          }),
        ],
      ),
    );
  }
}
