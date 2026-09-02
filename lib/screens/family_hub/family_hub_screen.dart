import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/family/person_age_utils.dart';
import '../../core/family/person_relationship_utils.dart';
import '../../core/family/pet_profile.dart';
import '../../core/utils/au_date_format.dart';
import '../../providers/family_hub_provider.dart';
import '../../providers/calendar_provider.dart';
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
                    _sectionTitle('Contacts'),
                    Text(
                      'Extended family, friends, co-workers — not household members.',
                      style: BethTypography.caption,
                    ),
                    const SizedBox(height: 8),
                    if (hub.contacts.isEmpty)
                      Text('No contacts yet.', style: BethTypography.caption)
                    else
                      ...hub.contacts.map((p) => _personTile(context, p)),
                    if (hub.deceasedLovedOnes.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _sectionTitle('In memory'),
                      Text(
                        'Birthdays, passing anniversaries, and wedding anniversaries on your calendar.',
                        style: BethTypography.caption,
                      ),
                      const SizedBox(height: 8),
                      ...hub.deceasedLovedOnes.map((p) => _deceasedTile(context, p)),
                    ],
                    const SizedBox(height: 16),
                    _sectionTitle('Pets'),
                    if (hub.pets.isEmpty)
                      Text('No pets yet.', style: BethTypography.caption)
                    else
                      ...hub.pets.map((p) => _petTile(context, p)),
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

  Widget _petTile(BuildContext context, Person pet) {
    final name = personDisplayName(pet);
    final summary = petSummaryLines(pet);
    final details = petDetailRows(pet);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: CircleAvatar(
          backgroundColor: BethColours.surfaceAlt,
          child: Text(pet.colourIcon ?? '🐾', style: const TextStyle(fontSize: 18)),
        ),
        title: Text(name, style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600)),
        subtitle: summary.isEmpty
            ? Text(pet.species ?? 'Pet', style: BethTypography.caption)
            : Text(summary.take(2).join(' · '), style: BethTypography.caption),
        children: [
          if (details.isEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Text(
                'Tap Edit profile to add breed, health notes, and vet details.',
                style: BethTypography.caption,
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: details
                    .map(
                      (row) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              row.$1,
                              style: BethTypography.caption.copyWith(
                                fontWeight: FontWeight.w600,
                                color: BethColours.textMuted,
                              ),
                            ),
                            Text(row.$2, style: BethTypography.bodySmall),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => PetDetailScreen(pet: pet)),
                  ),
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Edit profile'),
                ),
                TextButton.icon(
                  onPressed: () => _confirmRemovePet(context, pet),
                  icon: Icon(Icons.delete_outline, size: 18, color: BethColours.red),
                  label: Text('Remove', style: TextStyle(color: BethColours.red)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _deceasedTile(BuildContext context, Person person) {
    final name = personDisplayName(person);
    final lines = <String>[
      relationshipLabel(person.relationshipToUser),
      if (person.dateOfBirth != null)
        'Birthday: ${formatAuDate(person.dateOfBirth!)}',
      if (person.dateOfDeath != null)
        'Memorial: ${formatAuDate(person.dateOfDeath!)}',
      if (person.anniversaryDate != null)
        'Anniversary: ${formatAuDate(person.anniversaryDate!)}',
    ];
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: BethColours.surfaceAlt,
          child: Text(person.colourIcon ?? '🕯️', style: const TextStyle(fontSize: 18)),
        ),
        title: Text(name),
        subtitle: Text(lines.join(' · '), style: BethTypography.caption),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            if (value == 'remove') _confirmRemovePerson(context, person);
          },
          itemBuilder: (_) => [
            const PopupMenuItem(value: 'remove', child: Text('Remove')),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => PersonDetailScreen(person: person)),
        ),
      ),
    );
  }

  Future<void> _confirmRemovePerson(BuildContext context, Person person) async {
    final name = personDisplayName(person);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: const Text(
          'This removes them from Family Hub and deletes their calendar dates.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Remove', style: TextStyle(color: BethColours.red)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<FamilyHubProvider>().removePerson(person.id);
    if (context.mounted) {
      await context.read<CalendarProvider>().loadEvents();
      await context.read<CalendarProvider>().loadUpcoming();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name removed')));
    }
  }

  Future<void> _confirmRemovePet(BuildContext context, Person pet) async {
    final name = personDisplayName(pet);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: const Text('This removes the pet from Family Hub and their calendar birthday.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Remove', style: TextStyle(color: BethColours.red)),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    await context.read<FamilyHubProvider>().removePerson(pet.id);
    if (context.mounted) {
      await context.read<CalendarProvider>().loadEvents();
      await context.read<CalendarProvider>().loadUpcoming();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name removed')));
    }
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
    final age = person.dateOfBirth != null
        ? ' · turning ${ageTurningOnNextBirthday(person.dateOfBirth!)} on ${formatAuDate(_nextBirthdayDate(person.dateOfBirth!))}'
        : '';
    final dobAge = person.dateOfBirth != null && !age.contains('turning')
        ? ' · ${ageDisplayLabel(person)}'
        : '';
    final where = person.residenceLocation != null && person.residenceLocation!.isNotEmpty
        ? ' · ${person.residenceLocation}'
        : (livesAwayPrimarily(person.livingArrangement)
            ? ' · ${livingArrangementLabel(person.livingArrangement)}'
            : '');
    return '$rel${person.dateOfBirth != null ? age : dobAge}$where';
  }

  DateTime _nextBirthdayDate(DateTime dob) {
    final now = DateTime.now();
    var year = now.year;
    final thisYear = DateTime(year, dob.month, dob.day);
    if (thisYear.isBefore(DateTime(now.year, now.month, now.day))) year += 1;
    return DateTime(year, dob.month, dob.day);
  }
}
