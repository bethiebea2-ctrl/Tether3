import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/family/person_age_utils.dart';
import '../../models/person.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/typography.dart';

enum AddPersonKind { child, partner, other, pet }

class AddPersonFlow extends StatefulWidget {
  const AddPersonFlow({super.key});

  @override
  State<AddPersonFlow> createState() => _AddPersonFlowState();
}

class _AddPersonFlowState extends State<AddPersonFlow> {
  AddPersonKind? _kind;
  bool _saving = false;
  final _legalName = TextEditingController();
  final _preferredName = TextEditingController();
  final _notes = TextEditingController();
  DateTime? _dob;
  String _pronouns = 'they/them';
  String _gender = 'prefer_not_to_say';
  String _relationship = 'partner';
  String _species = 'cat';
  bool _meds = true;
  bool _calendar = true;
  bool _tasks = true;
  bool _school = false;

  @override
  void dispose() {
    _legalName.dispose();
    _preferredName.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_kind == null ? 'Add a person' : 'Details'),
      ),
      body: _kind == null ? _pickKind() : _detailForm(),
    );
  }

  Widget _pickKind() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Who are you adding?', style: BethTypography.subheading),
        const SizedBox(height: 16),
        _kindTile('Child', AddPersonKind.child, Icons.child_care),
        _kindTile('Partner', AddPersonKind.partner, Icons.favorite_outline),
        _kindTile('Other household member', AddPersonKind.other, Icons.person_outline),
        _kindTile('Pet', AddPersonKind.pet, Icons.pets),
      ],
    );
  }

  Widget _kindTile(String label, AddPersonKind kind, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => setState(() {
          _kind = kind;
          if (kind == AddPersonKind.child) _relationship = 'child';
          if (kind == AddPersonKind.partner) _relationship = 'partner';
          if (kind == AddPersonKind.pet) _relationship = 'pet';
        }),
      ),
    );
  }

  Widget _detailForm() {
    final isPet = _kind == AddPersonKind.pet;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (!isPet) ...[
          TextField(
            controller: _legalName,
            decoration: const InputDecoration(labelText: 'Full name'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _preferredName,
            decoration: const InputDecoration(labelText: 'Preferred name / nickname'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _gender,
            decoration: const InputDecoration(labelText: 'Gender identity'),
            items: const [
              DropdownMenuItem(value: 'woman', child: Text('Woman')),
              DropdownMenuItem(value: 'man', child: Text('Man')),
              DropdownMenuItem(value: 'non_binary', child: Text('Non-binary')),
              DropdownMenuItem(value: 'genderfluid', child: Text('Genderfluid')),
              DropdownMenuItem(value: 'custom', child: Text('Custom / self-describe')),
              DropdownMenuItem(value: 'prefer_not_to_say', child: Text('Prefer not to say')),
            ],
            onChanged: (v) => setState(() => _gender = v!),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _pronouns,
            decoration: const InputDecoration(labelText: 'Pronouns'),
            items: const [
              DropdownMenuItem(value: 'she/her', child: Text('she/her')),
              DropdownMenuItem(value: 'he/him', child: Text('he/him')),
              DropdownMenuItem(value: 'they/them', child: Text('they/them')),
              DropdownMenuItem(value: 'she/they', child: Text('she/they')),
              DropdownMenuItem(value: 'he/they', child: Text('he/they')),
              DropdownMenuItem(value: 'custom', child: Text('Custom')),
            ],
            onChanged: (v) => setState(() => _pronouns = v!),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date of birth'),
            subtitle: Text(_dob == null ? 'Not set' : _dob!.toLocal().toString().split(' ').first),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dob ?? DateTime(2020),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dob = picked);
            },
          ),
          if (_dob != null)
            Text(
              'Age group: ${ageStageFromDateOfBirth(_dob!)}',
              style: BethTypography.caption,
            ),
        ] else ...[
          TextField(
            controller: _preferredName,
            decoration: const InputDecoration(labelText: 'Pet name'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _species,
            decoration: const InputDecoration(labelText: 'Species'),
            items: const [
              DropdownMenuItem(value: 'cat', child: Text('Cat')),
              DropdownMenuItem(value: 'dog', child: Text('Dog')),
              DropdownMenuItem(value: 'bird', child: Text('Bird')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _species = v!),
          ),
        ],
        if (_kind == AddPersonKind.other) ...[
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _relationship,
            decoration: const InputDecoration(labelText: 'Relationship'),
            items: const [
              DropdownMenuItem(value: 'parent', child: Text('Parent')),
              DropdownMenuItem(value: 'sibling', child: Text('Sibling')),
              DropdownMenuItem(value: 'grandchild', child: Text('Grandchild')),
              DropdownMenuItem(value: 'friend', child: Text('Friend')),
              DropdownMenuItem(value: 'carer', child: Text('Carer')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _relationship = v!),
          ),
        ],
        if (_kind == AddPersonKind.child) ...[
          const SizedBox(height: 16),
          Text('Features', style: BethTypography.subheading),
          SwitchListTile(
            title: const Text('Medication tracker'),
            value: _meds,
            onChanged: (v) => setState(() => _meds = v),
          ),
          SwitchListTile(
            title: const Text('Calendar integration'),
            value: _calendar,
            onChanged: (v) => setState(() => _calendar = v),
          ),
          SwitchListTile(
            title: const Text('Task list'),
            value: _tasks,
            onChanged: (v) => setState(() => _tasks = v),
          ),
          SwitchListTile(
            title: const Text('School hub (when school-aged)'),
            value: _school,
            onChanged: (v) => setState(() => _school = v),
          ),
        ],
        const SizedBox(height: 12),
        TextField(
          controller: _notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
          maxLines: 2,
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _saving ? null : _save,
          child: _saving
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Save'),
        ),
      ],
    );
  }

  Future<void> _save() async {
    final hub = context.read<FamilyHubProvider>();
    final now = DateTime.now();
    final legal = _legalName.text.trim();
    final preferred = _preferredName.text.trim();
    final display = preferred.isNotEmpty ? preferred : legal;

    if (_kind == AddPersonKind.pet) {
      if (preferred.isEmpty) {
        _showMessage('Enter a name for your pet.');
        return;
      }
    } else if (display.isEmpty) {
      _showMessage('Add a full name or preferred name.');
      return;
    }

    setState(() => _saving = true);
    try {
      final person = Person(
        id: const Uuid().v4(),
        displayName: display.isNotEmpty ? display : _species,
        legalName: legal.isEmpty ? null : legal,
        preferredName: preferred.isEmpty ? null : preferred,
        pronouns: isPet ? null : _pronouns,
        genderIdentity: isPet ? null : _gender,
        relationshipToUser: isPet ? 'pet' : _relationship,
        dateOfBirth: _dob,
        ageStage: isPet
            ? 'pet'
            : (_dob != null ? ageStageFromDateOfBirth(_dob!) : 'adult'),
        profileType: isPet
            ? 'pet'
            : (_kind == AddPersonKind.child
                ? 'child'
                : (_kind == AddPersonKind.partner ? 'partner' : 'household_member')),
        colourIcon: isPet ? '🐾' : null,
        species: isPet ? _species : null,
        featureTogglesJson: _kind == AddPersonKind.child
            ? jsonEncode({
                'meds': _meds,
                'calendar': _calendar,
                'tasks': _tasks,
                'school': _school,
              })
            : '{}',
        notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
        createdAt: now,
        updatedAt: now,
      );

      await hub.savePerson(person);

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${person.displayName} added')),
        );
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Could not save: $e');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  bool get isPet => _kind == AddPersonKind.pet;
}
