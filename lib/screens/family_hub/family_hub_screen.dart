import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/family/person_age_utils.dart';
import '../../core/family/person_relationship_utils.dart';
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
  Map<String, String> _statusByPerson = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hub = context.read<FamilyHubProvider>();
      if (!hub.isLoaded) await hub.load();
      await _loadStatuses();
    });
  }

  Future<void> _loadStatuses() async {
    final prefs = await SharedPreferences.getInstance();
    final hub = context.read<FamilyHubProvider>();
    final map = <String, String>{};
    for (final p in hub.people) {
      map[p.id] = prefs.getString('household_status_${p.id}') ?? 'home';
    }
    if (mounted) setState(() => _statusByPerson = map);
  }

  Future<void> _setStatus(Person person, String status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('household_status_${person.id}', status);
    setState(() => _statusByPerson[person.id] = status);
  }

  void _openAdd() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const AddPersonFlow()));
  }

  Color _statusColour(String status) {
    switch (status) {
      case 'away':
        return BethColours.amber;
      case 'work':
        return BethColours.work;
      case 'needs_checkin':
        return BethColours.red;
      default:
        return BethColours.green;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'away':
        return 'Away';
      case 'work':
        return 'At work';
      case 'needs_checkin':
        return 'Needs check-in';
      default:
        return 'Home';
    }
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
                            await _loadStatuses();
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
                    _householdStatusCard(hub),
                    const SizedBox(height: 16),
                    if (hub.partners.isNotEmpty) ...[
                      _sectionTitle('Partners'),
                      ...hub.partners.map((p) => _personTile(context, p)),
                      const SizedBox(height: 16),
                    ],
                    _sectionTitle('At home'),
                    if (hub.localHouseholdPeople.isEmpty)
                      Text(
                        'No one listed as living here yet.',
                        style: BethTypography.bodySmall,
                      )
                    else
                      ...hub.localHouseholdPeople.map((p) => _personTile(context, p)),
                    if (hub.connectedAwayPeople.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle('Connected · away / visiting'),
                      Text(
                        'Shared custody, visits, or living elsewhere — still family.',
                        style: BethTypography.caption,
                      ),
                      const SizedBox(height: 8),
                      ...hub.connectedAwayPeople.map((p) => _personTile(context, p)),
                    ],
                    const SizedBox(height: 16),
                    _sectionTitle('Pets'),
                    if (hub.pets.isEmpty)
                      Text('No pets yet.', style: BethTypography.caption)
                    else
                      ...hub.pets.map((p) => _personTile(context, p)),
                    const SizedBox(height: 16),
                    _sectionTitle('Household'),
                    Card(
                      child: ListTile(
                        leading: Icon(Icons.checklist_outlined, color: BethColours.primary),
                        title: Text('Chores & shopping',
                            style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
                        subtitle: Text('Shared lists — coming later', style: BethTypography.caption),
                      ),
                    ),
                    if (hub.schoolAged.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle('School'),
                      ...hub.schoolAged.map(
                        (p) => Card(
                          child: ListTile(
                            leading: const Icon(Icons.school_outlined),
                            title: Text(personDisplayName(p)),
                            subtitle: Text(
                              p.residenceLocation ?? livingArrangementLabel(p.livingArrangement),
                              style: BethTypography.caption,
                            ),
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

  Widget _householdStatusCard(FamilyHubProvider hub) {
    final people = [
      ...hub.partners,
      ...hub.localHouseholdPeople,
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.home_outlined, color: BethColours.primary),
                const SizedBox(width: 8),
                Text('Household status',
                    style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 8),
            if (people.isEmpty)
              Text('Add people to see status colours.', style: BethTypography.caption)
            else
              ...people.map((p) {
                final status = _statusByPerson[p.id] ?? 'home';
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: CircleAvatar(
                    radius: 8,
                    backgroundColor: _statusColour(status),
                  ),
                  title: Text(personDisplayName(p), style: BethTypography.bodySmall),
                  subtitle: Text(_statusLabel(status), style: BethTypography.caption),
                  trailing: PopupMenuButton<String>(
                    onSelected: (v) => _setStatus(p, v),
                    itemBuilder: (_) => const [
                      PopupMenuItem(value: 'home', child: Text('Home')),
                      PopupMenuItem(value: 'work', child: Text('At work')),
                      PopupMenuItem(value: 'away', child: Text('Away')),
                      PopupMenuItem(value: 'needs_checkin', child: Text('Needs check-in')),
                    ],
                  ),
                );
              }),
            if (hub.connectedAwayPeople.isNotEmpty) ...[
              const Divider(height: 20),
              Text(
                '${hub.connectedAwayPeople.length} connected away / visiting — see section below.',
                style: BethTypography.caption,
              ),
            ],
          ],
        ),
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
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => PersonDetailScreen(person: person)),
            );
          }
        },
      ),
    );
  }

  String _relationshipLabel(Person person) {
    if (person.isPet) return person.species ?? 'Pet';
    final rel = relationshipLabel(person.relationshipToUser);
    final age = person.dateOfBirth != null ? ' · ${ageDisplayLabel(person)}' : '';
    final where = person.residenceLocation != null && person.residenceLocation!.isNotEmpty
        ? ' · ${person.residenceLocation}'
        : (livesAwayPrimarily(person.livingArrangement)
            ? ' · ${livingArrangementLabel(person.livingArrangement)}'
            : '');
    return '$rel$age$where';
  }
}
