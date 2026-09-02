import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/family/person_relationship_utils.dart';
import '../../core/family/pet_profile.dart';
import '../../core/utils/au_date_format.dart';
import '../../providers/family_hub_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../family_hub/add_person_flow.dart';
import '../family_hub/person_detail_screen.dart';
import '../family_hub/pet_detail_screen.dart';

class FamilyHubSettingsScreen extends StatefulWidget {
  const FamilyHubSettingsScreen({super.key});

  @override
  State<FamilyHubSettingsScreen> createState() => _FamilyHubSettingsScreenState();
}

class _FamilyHubSettingsScreenState extends State<FamilyHubSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hub = context.read<FamilyHubProvider>();
      if (!hub.isLoaded) {
        await hub.load();
      } else {
        await hub.refreshFromDatabase();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final hub = context.watch<FamilyHubProvider>();
    final prefs = context.watch<SettingsPrefsProvider>();

    if (!hub.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Family Hub settings')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final people = hub.people.where((p) => !p.isPet && !p.isDeceased).toList();
    final deceased = hub.deceasedLovedOnes;
    final pets = hub.people.where((p) => p.isPet).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Family Hub settings')),
      body: ListView(
        children: [
          _header('People'),
          ...people.map((p) {
            return ListTile(
              title: Text(p.displayName),
              subtitle: Text(
                [
                  relationshipLabel(p.relationshipToUser),
                  if (p.dateOfBirth != null) formatAuDate(p.dateOfBirth!),
                ].join(' · '),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PersonDetailScreen(person: p),
                        ),
                      );
                    },
                    child: const Text('Edit'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context, p.id, p.displayName),
                  ),
                ],
              ),
            );
          }),
          ListTile(
            leading: const Icon(Icons.person_add_outlined),
            title: const Text('Add person'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPersonFlow()),
            ),
          ),
          if (deceased.isNotEmpty) ...[
            const Divider(),
            _header('In memory'),
            ...deceased.map((p) {
              return ListTile(
                title: Text(p.displayName),
                subtitle: Text(
                  [
                    relationshipLabel(p.relationshipToUser),
                    if (p.dateOfBirth != null) 'Birthday ${formatAuDate(p.dateOfBirth!)}',
                    if (p.dateOfDeath != null) 'Memorial ${formatAuDate(p.dateOfDeath!)}',
                  ].join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _confirmDelete(context, p.id, p.displayName),
                ),
              );
            }),
          ],
          const Divider(),
          _header('Pets'),
          ...pets.map((p) {
            final summary = petSummaryLines(p);
            return ListTile(
              title: Text(p.displayName),
              subtitle: Text(
                summary.isEmpty ? (p.species ?? 'Pet') : summary.take(3).join(' · '),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PetDetailScreen(pet: p)),
                    ),
                    child: const Text('Edit'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => _confirmDelete(context, p.id, p.displayName),
                  ),
                ],
              ),
            );
          }),
          ListTile(
            leading: const Icon(Icons.pets_outlined),
            title: const Text('Add pet'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddPersonFlow()),
            ),
          ),
          const Divider(),
          _header('Default features for new children'),
          ...const [
            ('medication', 'Medication tracker'),
            ('calendar', 'Calendar integration'),
            ('tasks', 'Task list'),
            ('school', 'School hub (if school-aged)'),
          ].map(
            (e) => SwitchListTile(
              title: Text(e.$2),
              value: prefs.childDefaultFeatures.contains(e.$1),
              onChanged: (_) => prefs.toggleChildDefault(e.$1),
            ),
          ),
          _header('Default features for new pets'),
          ...const [
            ('care', 'Care tasks'),
            ('medication', 'Medication tracker'),
            ('vet', 'Vet records'),
            ('supplies', 'Supplies tracking'),
          ].map(
            (e) => SwitchListTile(
              title: Text(e.$2),
              value: prefs.petDefaultFeatures.contains(e.$1),
              onChanged: (_) => prefs.togglePetDefault(e.$1),
            ),
          ),
          _header('Household'),
          ListTile(
            title: const Text('Household name'),
            subtitle: Text(
              prefs.householdName.isEmpty ? 'Not set' : prefs.householdName,
            ),
            trailing: const Icon(Icons.edit_outlined),
            onTap: () => _editHouseholdName(context, prefs),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: BethTypography.caption.copyWith(color: BethColours.textMuted)),
    );
  }

  Future<void> _editHouseholdName(BuildContext context, SettingsPrefsProvider prefs) async {
    final controller = TextEditingController(text: prefs.householdName);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Household name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(hintText: 'e.g. The Clulows'),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result != null) await prefs.setHouseholdName(result);
  }

  Future<void> _confirmDelete(BuildContext context, String id, String name) async {
    final export = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: const Text('Export their profile data before deleting?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Delete only')),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Export & delete')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
        ],
      ),
    );
    if (export == null || !context.mounted) return;
    final hub = context.read<FamilyHubProvider>();
    if (export) {
      final json = await hub.exportPersonData(id);
      await Clipboard.setData(ClipboardData(text: json));
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile JSON copied to clipboard')),
        );
      }
    }
    if (!context.mounted) return;
    await hub.removePerson(id, exportFirst: false);
    if (context.mounted) {
      await context.read<CalendarProvider>().loadEvents();
      await context.read<CalendarProvider>().loadUpcoming();
    }
  }
}
