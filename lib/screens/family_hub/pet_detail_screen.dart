import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/family/person_age_utils.dart';
import '../../models/person.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class PetDetailScreen extends StatefulWidget {
  final Person pet;
  const PetDetailScreen({super.key, required this.pet});

  @override
  State<PetDetailScreen> createState() => _PetDetailScreenState();
}

class _PetDetailScreenState extends State<PetDetailScreen> {
  late final TextEditingController _species;
  late final TextEditingController _breed;
  late final TextEditingController _notes;
  late final TextEditingController _vet;

  @override
  void initState() {
    super.initState();
    _species = TextEditingController(text: widget.pet.species ?? '');
    _breed = TextEditingController(text: widget.pet.breed ?? '');
    _notes = TextEditingController(text: widget.pet.notes ?? '');
    _vet = TextEditingController();
    _loadVet();
  }

  Future<void> _loadVet() async {
    final prefs = await SharedPreferences.getInstance();
    _vet.text = prefs.getString('pet_vet_${widget.pet.id}') ?? '';
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _species.dispose();
    _breed.dispose();
    _notes.dispose();
    _vet.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = widget.pet.copyWith(
      species: _species.text.trim().isEmpty ? null : _species.text.trim(),
      breed: _breed.text.trim().isEmpty ? null : _breed.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
      updatedAt: DateTime.now(),
    );
    await context.read<FamilyHubProvider>().savePerson(updated);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pet_vet_${widget.pet.id}', _vet.text.trim());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pet profile saved.')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personDisplayName(widget.pet)),
        actions: [
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
            subtitle: const Text('Basic pet care profile'),
          ),
          const Divider(),
          TextField(
            controller: _species,
            decoration: const InputDecoration(labelText: 'Species'),
          ),
          TextField(
            controller: _breed,
            decoration: const InputDecoration(labelText: 'Breed'),
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
              labelText: 'Care notes',
              hintText: 'Food, walks, quirks — whatever helps.',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Vaccination schedules deepen in a later phase. Notes stay on device.',
            style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
          ),
        ],
      ),
    );
  }
}
