import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/family/person_age_utils.dart';
import '../../core/family/pet_profile.dart';
import '../../core/utils/au_date_format.dart';
import '../../models/person.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'birthday_sync_dialog.dart';

class PetDetailScreen extends StatefulWidget {
  final Person pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late final TextEditingController _nickname;
  late final TextEditingController _legalName;
  late final TextEditingController _species;
  late final TextEditingController _breed;
  late final TextEditingController _notes;
  late final TextEditingController _vet;
  late final TextEditingController _conditions;
  late final TextEditingController _medications;
  late final TextEditingController _injuries;
  DateTime? _dob;
  String _spayedNeutered = 'unknown';

  @override
  void initState() {
    super.initState();
    _nickname = TextEditingController(text: widget.pet.preferredName ?? widget.pet.displayName);
    _legalName = TextEditingController(text: widget.pet.legalName ?? '');
    _species = TextEditingController(text: widget.pet.species ?? '');
    _breed = TextEditingController(text: widget.pet.breed ?? '');
    _notes = TextEditingController(text: widget.pet.notes ?? '');
    _dob = widget.pet.dateOfBirth;
    final profile = widget.pet.petProfile;
    _vet = TextEditingController(text: profile.vetContact ?? '');
    _conditions = TextEditingController(text: profile.conditions ?? '');
    _medications = TextEditingController(text: profile.medications ?? '');
    _injuries = TextEditingController(text: profile.injuries ?? '');
    _spayedNeutered = profile.spayedNeutered;
    _migrateLegacyVet();
  }

  Future<void> _migrateLegacyVet() async {
    if (_vet.text.isNotEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    final legacy = prefs.getString('pet_vet_${widget.pet.id}');
    if (legacy != null && legacy.isNotEmpty && mounted) {
      setState(() => _vet.text = legacy);
    }
  }

  @override
  void dispose() {
    _nickname.dispose();
    _legalName.dispose();
    _species.dispose();
    _breed.dispose();
    _notes.dispose();
    _vet.dispose();
    _conditions.dispose();
    _medications.dispose();
    _injuries.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final nickname = _nickname.text.trim();
    if (nickname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add a nickname or name for your pet.')),
      );
      return;
    }
    final profile = PetProfile(
      vetContact: _vet.text.trim().isEmpty ? null : _vet.text.trim(),
      conditions: _conditions.text.trim().isEmpty ? null : _conditions.text.trim(),
      medications: _medications.text.trim().isEmpty ? null : _medications.text.trim(),
      injuries: _injuries.text.trim().isEmpty ? null : _injuries.text.trim(),
      spayedNeutered: _spayedNeutered,
    ).toJson();

    var updated = widget.pet.copyWith(
      displayName: nickname,
      preferredName: nickname,
      legalName: _legalName.text.trim().isEmpty ? null : _legalName.text.trim(),
      species: _species.text.trim().isEmpty ? null : _species.text.trim(),
      breed: _breed.text.trim().isEmpty ? null : _breed.text.trim(),
      dateOfBirth: _dob,
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      petProfileJson: profile,
      updatedAt: DateTime.now(),
    );

    final saved = await savePersonResolvingBirthday(context, updated);
    if (saved == null || !mounted) return;

    if (mounted) {
      await context.read<CalendarProvider>().loadEvents();
      await context.read<CalendarProvider>().loadUpcoming();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pet profile saved.')),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _confirmDelete() async {
    final name = personDisplayName(widget.pet);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Remove $name?'),
        content: const Text(
          'This removes the pet from Family Hub and their calendar birthday.',
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
    if (ok != true || !mounted) return;
    await context.read<FamilyHubProvider>().removePerson(widget.pet.id);
    if (!mounted) return;
    await context.read<CalendarProvider>().loadEvents();
    await context.read<CalendarProvider>().loadUpcoming();
    if (!mounted) return;
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$name removed')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personDisplayName(widget.pet)),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: BethColours.red),
            tooltip: 'Remove pet',
            onPressed: _confirmDelete,
          ),
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Text('🐾', style: TextStyle(fontSize: 28)),
            title: Text(personDisplayName(widget.pet)),
            subtitle: const Text('Pet profile & health notes'),
          ),
          const Divider(),
          Text('Identity', style: BethTypography.subheading),
          const SizedBox(height: 8),
          TextField(
            controller: _nickname,
            decoration: const InputDecoration(labelText: 'Nickname / what you call them'),
          ),
          TextField(
            controller: _legalName,
            decoration: const InputDecoration(labelText: 'Full / registered name (optional)'),
          ),
          TextField(
            controller: _species,
            decoration: const InputDecoration(labelText: 'Species'),
          ),
          TextField(
            controller: _breed,
            decoration: const InputDecoration(labelText: 'Breed'),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date of birth / gotcha day'),
            subtitle: Text(_dob == null ? 'Not set' : formatAuDate(_dob!)),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dob ?? DateTime(2020),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dob = picked);
            },
          ),
          const SizedBox(height: 16),
          Text('Health & care', style: BethTypography.subheading),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: petSpayNeuterOptions.any((o) => o.$1 == _spayedNeutered)
                ? _spayedNeutered
                : 'unknown',
            decoration: const InputDecoration(labelText: 'Spayed / neutered'),
            items: petSpayNeuterOptions
                .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                .toList(),
            onChanged: (v) => setState(() => _spayedNeutered = v!),
          ),
          TextField(
            controller: _conditions,
            decoration: const InputDecoration(
              labelText: 'Conditions',
              hintText: 'e.g. diabetes, anxiety, arthritis',
            ),
          ),
          TextField(
            controller: _medications,
            decoration: const InputDecoration(
              labelText: 'Medications',
              hintText: 'Name, dose, schedule',
            ),
            maxLines: 2,
          ),
          TextField(
            controller: _injuries,
            decoration: const InputDecoration(
              labelText: 'Injuries / recovery notes',
            ),
            maxLines: 2,
          ),
          TextField(
            controller: _vet,
            decoration: const InputDecoration(
              labelText: 'Vet contact',
              hintText: 'Clinic name / phone',
            ),
          ),
          TextField(
            controller: _notes,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'General care notes',
              hintText: 'Food, walks, quirks — whatever helps.',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Health notes stay on device. Vaccination schedules deepen in a later phase.',
            style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
          ),
        ],
      ),
    );
  }
}
