import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/family/person_age_utils.dart';
import '../../providers/family_hub_provider.dart';
import '../../models/person.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'add_person_flow.dart';
import 'person_detail_screen.dart';
import 'pet_detail_screen.dart';
import 'school_hub_screen.dart';

class FamilyHubScreen extends StatefulWidget {
  const FamilyHubScreen({super.key});

  @override
  State<FamilyHubScreen> createState() => _FamilyHubScreenState();
}

class _FamilyHubScreenState extends State<FamilyHubScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hub = context.read<FamilyHubProvider>();
      if (!hub.isLoaded) hub.load();
    });
  }

  void _openAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPersonFlow()));
  }

  @override
  Widget build(BuildContext context) {
    final hub = context.watch<FamilyHubProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Family Hub'),
        actions: [
          IconButton(icon: const Icon(Icons.person_add_outlined), onPressed: _openAdd),
        ],
      ),
      body: !hub.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : hub.loadError != null && hub.people.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(hub.loadError!, textAlign: TextAlign.center),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () => context.read<FamilyHubProvider>().load(),
                          child: const Text('Try again'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () async {
                            await context.read<FamilyHubProvider>().resetLocalDataAndReload();
                          },
                          child: const Text('Reset local data'),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _stubCard(
                  'Household status',
                  'Everyone accounted for · placeholders for location & check-ins',
                  Icons.home_outlined,
                ),
                const SizedBox(height: 16),
                if (hub.partners.isNotEmpty) ...[
                  _sectionTitle('Partners'),
                  ...hub.partners.map((p) => _personTile(context, p)),
                  const SizedBox(height: 16),
                ],
                _sectionTitle('People'),
                if (hub.householdPeople.isEmpty)
                  Text('No people yet.', style: BethTypography.bodySmall)
                else
                  ...hub.householdPeople.map((p) => _personTile(context, p)),
                const SizedBox(height: 16),
                _sectionTitle('Pets'),
                if (hub.pets.isEmpty)
                  Text('No pets yet.', style: BethTypography.caption)
                else
                  ...hub.pets.map((p) => _personTile(context, p)),
                const SizedBox(height: 16),
                _sectionTitle('Household'),
                _stubCard('Chores & shopping', 'Shared lists — coming soon', Icons.checklist_outlined),
                if (hub.schoolAged.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  _sectionTitle('School'),
                  ...hub.schoolAged.map(
                    (p) => Card(
                      child: ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: Text(personDisplayName(p)),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => SchoolHubScreen(person: p)),
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
      floatingActionButton: FloatingActionButton(onPressed: _openAdd, child: const Icon(Icons.add)),
    );
  }

  Widget _stubCard(String title, String subtitle, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: BethColours.primary),
        title: Text(title, style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: BethTypography.caption),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: BethTypography.subheading),
    );
  }

  Widget _personTile(BuildContext context, Person person) {
    final isChild = ['baby', 'toddler', 'child', 'teen'].contains(person.ageStage);
    final name = personDisplayName(person);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(child: Text(person.colourIcon ?? name.characters.first)),
        title: Text(name),
        subtitle: Text(_relationshipLabel(person)),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (person.isPet) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PetDetailScreen(pet: person)));
          } else if (isChild) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => PersonDetailScreen(person: person)));
          }
        },
      ),
    );
  }

  String _relationshipLabel(Person person) {
    if (person.isPet) return person.species ?? 'Pet';
    final rel = person.relationshipToUser.replaceAll('_', ' ');
    final age = person.dateOfBirth != null ? ' · ${ageDisplayLabel(person)}' : '';
    return '${rel[0].toUpperCase()}${rel.substring(1)}$age';
  }
}
