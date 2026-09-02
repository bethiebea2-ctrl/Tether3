import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../../core/family/pet_profile.dart';
import '../../core/family/person_age_utils.dart';
import '../../core/family/person_relationship_utils.dart';
import '../../core/utils/au_date_format.dart';
import '../../models/person.dart';
import '../../providers/family_hub_provider.dart';
import '../../providers/calendar_provider.dart';
import '../../services/birthday_calendar_service.dart';
import 'birthday_sync_dialog.dart';
import '../../theme/typography.dart';

enum AddPersonKind { me, child, partner, other, pet, deceased }

class AddPersonFlow extends StatefulWidget {
  final AddPersonKind? initialKind;

  const AddPersonFlow({super.key, this.initialKind});

  @override
  State<AddPersonFlow> createState() => _AddPersonFlowState();
}

class _AddPersonFlowState extends State<AddPersonFlow> {
  AddPersonKind? _kind;
  bool _saving = false;
  final _legalName = TextEditingController();
  final _preferredName = TextEditingController();
  final _notes = TextEditingController();
  final _residence = TextEditingController();
  DateTime? _dob;
  DateTime? _dateOfDeath;
  DateTime? _anniversaryDate;
  String _pronouns = 'they/them';
  String _gender = 'prefer_not_to_say';
  String _relationship = 'partner';
  String _livingArrangement = 'lives_with_me';
  String _listKind = listKindFamily;
  String _species = 'cat';
  String _petBreed = '';
  String _petSpayedNeutered = 'unknown';
  final _petVet = TextEditingController();
  final _petConditions = TextEditingController();
  final _petMedications = TextEditingController();
  final _petInjuries = TextEditingController();
  bool _meds = true;
  bool _calendar = true;
  bool _tasks = true;
  bool _school = false;

  @override
  void initState() {
    super.initState();
    _kind = widget.initialKind;
    if (_kind == AddPersonKind.deceased) {
      _relationship = 'parent';
      _livingArrangement = 'deceased';
      _listKind = listKindFamily;
    }
  }

  @override
  void dispose() {
    _legalName.dispose();
    _preferredName.dispose();
    _notes.dispose();
    _residence.dispose();
    _petVet.dispose();
    _petConditions.dispose();
    _petMedications.dispose();
    _petInjuries.dispose();
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
        const SizedBox(height: 8),
        Text(
          'Includes yourself, stepfamilies, shared custody, birthdays, and people who live elsewhere.',
          style: BethTypography.caption,
        ),
        const SizedBox(height: 16),
        _kindTile('Me (self profile)', AddPersonKind.me, Icons.person),
        _kindTile('Child / young person', AddPersonKind.child, Icons.child_care),
        _kindTile('Partner', AddPersonKind.partner, Icons.favorite_outline),
        _kindTile('Other adult / family / friend', AddPersonKind.other, Icons.person_outline),
        _kindTile('Pet', AddPersonKind.pet, Icons.pets),
        _kindTile('Deceased loved one', AddPersonKind.deceased, Icons.favorite_border),
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
          if (kind == AddPersonKind.me) {
            _relationship = 'self';
            _livingArrangement = 'lives_with_me';
            _listKind = listKindFamily;
          }
          if (kind == AddPersonKind.child) {
            _relationship = 'child';
            _livingArrangement = 'lives_with_me';
            _listKind = listKindFamily;
          }
          if (kind == AddPersonKind.partner) {
            _relationship = 'partner';
            _livingArrangement = 'lives_with_me';
            _listKind = listKindFamily;
          }
          if (kind == AddPersonKind.other) {
            _relationship = 'friend';
            _livingArrangement = 'lives_elsewhere';
            _listKind = listKindContact;
          }
          if (kind == AddPersonKind.pet) {
            _relationship = 'pet';
            _livingArrangement = 'lives_with_me';
            _listKind = listKindFamily;
          }
          if (kind == AddPersonKind.deceased) {
            _relationship = 'parent';
            _livingArrangement = 'deceased';
            _listKind = listKindFamily;
          }
        }),
      ),
    );
  }

  List<(String, String)> get _relationshipChoices {
    switch (_kind) {
      case AddPersonKind.me:
        return const [('self', 'Me')];
      case AddPersonKind.child:
        return relationshipOptions
            .where((o) => isChildRelationship(o.$1) || o.$1 == 'other')
            .toList();
      case AddPersonKind.partner:
        return const [('partner', 'Partner')];
      case AddPersonKind.other:
        return birthdayRelationOptions
            .where((o) => !isChildRelationship(o.$1) && o.$1 != 'partner')
            .toList();
      case AddPersonKind.deceased:
        return birthdayRelationOptions
            .where((o) => o.$1 != 'pet' && o.$1 != 'self' && o.$1 != 'partner')
            .toList();
      default:
        return relationshipOptions;
    }
  }

  Widget _detailForm() {
    final isPet = _kind == AddPersonKind.pet;
    final isDeceased = _kind == AddPersonKind.deceased;
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
          if (!isDeceased) ...[
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
          ],
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date of birth'),
            subtitle: Text(
              _dob == null ? 'Not set (DD/MM/YYYY)' : formatAuDate(_dob!),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dob ?? DateTime(2020),
                firstDate: DateTime(1920),
                lastDate: DateTime.now(),
                helpText: 'Date of birth (DD/MM/YYYY)',
                fieldHintText: 'DD/MM/YYYY',
                fieldLabelText: 'DD/MM/YYYY',
              );
              if (picked != null) setState(() => _dob = picked);
            },
          ),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Or type DD/MM/YYYY',
              hintText: '31/12/2020',
            ),
            keyboardType: TextInputType.datetime,
            onChanged: (v) {
              final parsed = parseAuDate(v);
              if (parsed != null) setState(() => _dob = parsed);
            },
          ),
          if (_dob != null)
            Text(
              'Age group: ${ageStageFromDateOfBirth(_dob!)} · ${formatAuDate(_dob!)}',
              style: BethTypography.caption,
            ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _relationshipChoices.any((o) => o.$1 == _relationship)
                ? _relationship
                : _relationshipChoices.first.$1,
            decoration: InputDecoration(
              labelText: _kind == AddPersonKind.me
                  ? 'Profile type'
                  : 'Relationship / relation to you',
              helperText: _kind == AddPersonKind.other
                  ? 'Friend, family, co-worker, etc.'
                  : null,
            ),
            items: _relationshipChoices
                .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                .toList(),
            onChanged: _kind == AddPersonKind.me
                ? null
                : (v) => setState(() {
                      _relationship = v!;
                      if (_kind == AddPersonKind.other) {
                        _listKind = defaultListKindFor(_relationship);
                      }
                    }),
          ),
          if (_kind != AddPersonKind.me && !isDeceased) ...[
            const SizedBox(height: 16),
            Text('Where should they appear?', style: BethTypography.subheading),
            const SizedBox(height: 4),
            Text(
              'Family Hub is household and close family. Contacts is for extended family, friends, and co-workers.',
              style: BethTypography.caption,
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                  value: listKindFamily,
                  label: Text('Family Hub'),
                  icon: Icon(Icons.home_outlined, size: 18),
                ),
                ButtonSegment(
                  value: listKindContact,
                  label: Text('Contacts'),
                  icon: Icon(Icons.contacts_outlined, size: 18),
                ),
              ],
              selected: {_listKind},
              onSelectionChanged: (s) => setState(() => _listKind = s.first),
            ),
          ],
          const SizedBox(height: 12),
          if (!isDeceased)
            DropdownButtonFormField<String>(
              value: _livingArrangement,
              decoration: const InputDecoration(labelText: 'Living arrangement'),
              items: livingArrangementOptions
                  .where((o) => o.$1 != 'deceased')
                  .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                  .toList(),
              onChanged: (v) => setState(() => _livingArrangement = v!),
            ),
          if (_livingArrangement != 'lives_with_me' && !isDeceased) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _residence,
              decoration: InputDecoration(
                labelText: _livingArrangement == 'international'
                    ? 'Where they live (e.g. UK with mum)'
                    : 'Usual residence / schedule notes',
                hintText: _livingArrangement == 'shared_custody'
                    ? 'e.g. Week A with us, Week B with dad'
                    : 'City, country, or co-parent home',
              ),
            ),
          ],
          if (isDeceased) ...[
            const SizedBox(height: 16),
            Text('Memorial dates', style: BethTypography.subheading),
            const SizedBox(height: 4),
            Text(
              'Birthdays, passing anniversaries, and wedding anniversaries appear on your calendar.',
              style: BethTypography.caption,
            ),
            const SizedBox(height: 8),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Date of passing'),
              subtitle: Text(
                _dateOfDeath == null ? 'Not set (DD/MM/YYYY)' : formatAuDate(_dateOfDeath!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _dateOfDeath ?? DateTime(2020),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                  helpText: 'Date of passing (DD/MM/YYYY)',
                );
                if (picked != null) setState(() => _dateOfDeath = picked);
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Anniversary (optional)'),
              subtitle: Text(
                _anniversaryDate == null
                    ? 'Wedding or other anniversary'
                    : formatAuDate(_anniversaryDate!),
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _anniversaryDate ?? DateTime(1980),
                  firstDate: DateTime(1920),
                  lastDate: DateTime.now(),
                  helpText: 'Anniversary date (DD/MM/YYYY)',
                );
                if (picked != null) setState(() => _anniversaryDate = picked);
              },
            ),
          ],
        ] else ...[
          TextField(
            controller: _preferredName,
            decoration: const InputDecoration(labelText: 'Nickname / what you call them'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _legalName,
            decoration: const InputDecoration(labelText: 'Full / registered name (optional)'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _species,
            decoration: const InputDecoration(labelText: 'Species'),
            items: const [
              DropdownMenuItem(value: 'cat', child: Text('Cat')),
              DropdownMenuItem(value: 'dog', child: Text('Dog')),
              DropdownMenuItem(value: 'bird', child: Text('Bird')),
              DropdownMenuItem(value: 'rabbit', child: Text('Rabbit')),
              DropdownMenuItem(value: 'other', child: Text('Other')),
            ],
            onChanged: (v) => setState(() => _species = v!),
          ),
          const SizedBox(height: 12),
          TextField(
            decoration: const InputDecoration(labelText: 'Breed (optional)'),
            onChanged: (v) => _petBreed = v,
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Date of birth / gotcha day'),
            subtitle: Text(
              _dob == null ? 'Not set (DD/MM/YYYY)' : formatAuDate(_dob!),
            ),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dob ?? DateTime(2020),
                firstDate: DateTime(1990),
                lastDate: DateTime.now(),
                helpText: 'DOB or adoption date (DD/MM/YYYY)',
              );
              if (picked != null) setState(() => _dob = picked);
            },
          ),
          const SizedBox(height: 16),
          Text('Health & care', style: BethTypography.subheading),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: petSpayNeuterOptions.any((o) => o.$1 == _petSpayedNeutered)
                ? _petSpayedNeutered
                : 'unknown',
            decoration: const InputDecoration(labelText: 'Spayed / neutered'),
            items: petSpayNeuterOptions
                .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                .toList(),
            onChanged: (v) => setState(() => _petSpayedNeutered = v!),
          ),
          TextField(
            controller: _petConditions,
            decoration: const InputDecoration(
              labelText: 'Conditions (optional)',
              hintText: 'e.g. diabetes, anxiety',
            ),
          ),
          TextField(
            controller: _petMedications,
            decoration: const InputDecoration(
              labelText: 'Medications (optional)',
              hintText: 'Name, dose, schedule',
            ),
            maxLines: 2,
          ),
          TextField(
            controller: _petInjuries,
            decoration: const InputDecoration(
              labelText: 'Injuries / recovery (optional)',
            ),
            maxLines: 2,
          ),
          TextField(
            controller: _petVet,
            decoration: const InputDecoration(
              labelText: 'Vet contact (optional)',
              hintText: 'Clinic name / phone',
            ),
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
    final legal = _legalName.text.trim();
    final preferred = _preferredName.text.trim();
    final display = preferred.isNotEmpty ? preferred : legal;

    if (_kind == AddPersonKind.pet) {
      if (preferred.isEmpty) {
        _showMessage('Enter a name for your pet.');
        return;
      }
    } else if (_kind == AddPersonKind.deceased) {
      if (display.isEmpty) {
        _showMessage('Add a name for this loved one.');
        return;
      }
    } else if (display.isEmpty) {
      _showMessage('Add a full name or preferred name.');
      return;
    }

    setState(() => _saving = true);
    try {
      final now = DateTime.now();
      final livesHere = isDeceased
          ? false
          : (_livingArrangement == 'lives_with_me' ||
              _livingArrangement == 'shared_custody');
      final petProfile = isPet
          ? PetProfile(
              vetContact: _petVet.text.trim().isEmpty ? null : _petVet.text.trim(),
              conditions:
                  _petConditions.text.trim().isEmpty ? null : _petConditions.text.trim(),
              medications: _petMedications.text.trim().isEmpty
                  ? null
                  : _petMedications.text.trim(),
              injuries:
                  _petInjuries.text.trim().isEmpty ? null : _petInjuries.text.trim(),
              spayedNeutered: _petSpayedNeutered,
            ).toJson()
          : '{}';
      final person = Person(
        id: const Uuid().v4(),
        displayName: display.isNotEmpty ? display : _species,
        legalName: legal.isEmpty ? null : legal,
        preferredName: preferred.isEmpty ? null : preferred,
        pronouns: isPet || isDeceased ? null : _pronouns,
        genderIdentity: isPet || isDeceased ? null : _gender,
        relationshipToUser: isPet ? 'pet' : _relationship,
        dateOfBirth: _dob,
        dateOfDeath: isDeceased ? _dateOfDeath : null,
        anniversaryDate: isDeceased ? _anniversaryDate : null,
        ageStage: isPet
            ? 'pet'
            : (isDeceased
                ? 'adult'
                : (_kind == AddPersonKind.me
                    ? 'adult'
                    : (_dob != null ? ageStageFromDateOfBirth(_dob!) : 'adult'))),
        profileType: isPet
            ? 'pet'
            : (isDeceased
                ? 'household_member'
                : (_kind == AddPersonKind.me
                    ? 'user'
                    : (_kind == AddPersonKind.child
                        ? 'child'
                        : (_kind == AddPersonKind.partner ? 'partner' : 'household_member')))),
        colourIcon: isPet ? '🐾' : (isDeceased ? '🕯️' : null),
        species: isPet ? _species : null,
        breed: isPet && _petBreed.trim().isNotEmpty ? _petBreed.trim() : null,
        petProfileJson: petProfile,
        livingArrangement: isDeceased ? 'deceased' : (isPet ? 'lives_with_me' : _livingArrangement),
        livesWithMe: isPet ? true : livesHere,
        listKind: (_kind == AddPersonKind.me || isPet || isDeceased)
            ? listKindFamily
            : _listKind,
        residenceLocation: _residence.text.trim().isEmpty
            ? null
            : _residence.text.trim(),
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

      final hub = context.read<FamilyHubProvider>();
      Person? saved;
      if (isDeceased) {
        saved = await hub.savePerson(person, awaitBirthday: true);
      } else {
        saved = await savePersonResolvingBirthday(context, person);
      }
      if (saved == null) return;

      await hub.refreshFromDatabase();

      if (mounted) {
        await context.read<CalendarProvider>().loadEvents();
        await context.read<CalendarProvider>().loadUpcoming();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${saved.displayName} added')),
        );
      }
    } catch (e) {
      if (mounted) {
        _showMessage(_friendlySaveError(e));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  String _friendlySaveError(Object error) {
    final msg = error.toString().toLowerCase();
    if (msg.contains('no such column') ||
        msg.contains('date_of_death') ||
        msg.contains('pet_profile_json')) {
      return 'Database needs updating — fully close and reopen the app. '
          'If it still fails, use Reset local data in Family Hub.';
    }
    return 'Could not save: $error';
  }

  bool get isPet => _kind == AddPersonKind.pet;
  bool get isDeceased => _kind == AddPersonKind.deceased;
}
