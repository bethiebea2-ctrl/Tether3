import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/typography.dart';
import '../family_hub/add_person_flow.dart';
import '../family_hub/person_detail_screen.dart';
import '../family_hub/pet_detail_screen.dart';

class FamilyHubSettingsScreen extends StatelessWidget {
  const FamilyHubSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final hub = context.watch<FamilyHubProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Family Hub settings')),
      body: !hub.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_add_outlined),
                  title: const Text('Add person or pet'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddPersonFlow()),
                  ),
                ),
                const Divider(),
                ...hub.people.map((p) {
                  return ListTile(
                    title: Text(p.displayName),
                    subtitle: Text(p.relationshipToUser),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _confirmDelete(context, p.id, p.displayName),
                    ),
                    onTap: () {
                      if (p.isPet) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PetDetailScreen(pet: p)));
                      } else if (['baby', 'toddler', 'child', 'teen'].contains(p.ageStage)) {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => PersonDetailScreen(person: p)));
                      }
                    },
                  );
                }),
              ],
            ),
    );
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
    if (export == null) return;
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
    await hub.removePerson(id, exportFirst: false);
  }
}
