import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/family/person_age_utils.dart';
import '../../core/family/person_relationship_utils.dart';
import '../../core/utils/au_date_format.dart';
import '../../database/family_care_dao.dart';
import '../../models/person.dart';
import '../../providers/family_hub_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../notes/notes_screen.dart';
import 'birthday_sync_dialog.dart';
import 'growth_notes_screen.dart';
import 'school_hub_screen.dart';

class PersonDetailScreen extends StatefulWidget {
  final Person person;
  const PersonDetailScreen({super.key, required this.person});

  @override
  State<PersonDetailScreen> createState() => _PersonDetailScreenState();
}

class _PersonDetailScreenState extends State<PersonDetailScreen> {
  final FamilyCareDao _dao = FamilyCareDao();
  late Person _person;
  List<Map<String, dynamic>> _meds = [];
  List<Map<String, dynamic>> _activity = [];
  List<int> _feedChart = [];
  bool _loading = true;
  Map<String, bool> _teenPrivacy = {
    'hide_mood_from_parents': false,
    'hide_journal': false,
    'limit_partner_visibility': false,
  };

  @override
  void initState() {
    super.initState();
    _person = widget.person;
    _load();
  }

  Future<void> _load() async {
    if (_person.ageStage == 'baby') {
      await _dao.seedDefaultMedsIfEmpty(_person.id);
    }
    final meds = await _dao.getMedications(_person.id);
    final activity = await _dao.getRecentActivity(_person.id);
    final chart = await _dao.feedsPerDayLast7Days(_person.id);
    if (mounted) {
      setState(() {
        _meds = meds;
        _activity = activity;
        _feedChart = chart;
        _loading = false;
      });
    }
  }

  bool get _isSelf =>
      _person.relationshipToUser == 'self' || _person.profileType == 'user';

  Future<void> _editProfile() async {
    final legal = TextEditingController(text: _person.legalName ?? _person.displayName);
    final preferred = TextEditingController(text: _person.preferredName ?? '');
    final pronouns = TextEditingController(text: _person.pronouns ?? '');
    final typedDob = TextEditingController(
      text: _person.dateOfBirth == null ? '' : formatAuDate(_person.dateOfBirth!),
    );
    var gender = _person.genderIdentity ?? 'prefer_not';
    DateTime? dob = _person.dateOfBirth;
    final genderChoices = const [
      ('woman', 'Woman'),
      ('man', 'Man'),
      ('non_binary', 'Non-binary'),
      ('prefer_not', 'Prefer not to say'),
      ('custom', 'Custom / self-describe'),
    ];

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _isSelf ? 'Edit your profile' : 'Edit profile',
                      style: BethTypography.subheading,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: legal,
                      decoration: const InputDecoration(labelText: 'Full name'),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: preferred,
                      decoration: const InputDecoration(
                        labelText: 'Preferred name / nickname',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: pronouns,
                      decoration: const InputDecoration(labelText: 'Pronouns'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: genderChoices.any((g) => g.$1 == gender) ? gender : 'prefer_not',
                      decoration: const InputDecoration(labelText: 'Gender identity'),
                      items: genderChoices
                          .map((g) => DropdownMenuItem(value: g.$1, child: Text(g.$2)))
                          .toList(),
                      onChanged: (v) => setModal(() => gender = v!),
                    ),
                    const SizedBox(height: 12),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Date of birth'),
                      subtitle: Text(
                        dob == null ? 'Not set (DD/MM/YYYY)' : formatAuDate(dob!),
                      ),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: ctx,
                          initialDate: dob ?? DateTime(1990),
                          firstDate: DateTime(1920),
                          lastDate: DateTime.now(),
                          helpText: 'Date of birth (DD/MM/YYYY)',
                          fieldHintText: 'DD/MM/YYYY',
                          fieldLabelText: 'DD/MM/YYYY',
                        );
                        if (picked != null) {
                          setModal(() {
                            dob = picked;
                            typedDob.text = formatAuDate(picked);
                          });
                        }
                      },
                    ),
                    TextField(
                      controller: typedDob,
                      decoration: const InputDecoration(
                        labelText: 'Or type DD/MM/YYYY',
                        hintText: '31/12/1990',
                      ),
                      keyboardType: TextInputType.datetime,
                      onChanged: (v) {
                        final parsed = parseAuDate(v);
                        if (parsed != null) setModal(() => dob = parsed);
                      },
                    ),
                    if (dob != null)
                      TextButton(
                        onPressed: () => setModal(() {
                          dob = null;
                          typedDob.clear();
                        }),
                        child: const Text('Clear date of birth'),
                      ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Save'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (ok != true || !mounted) return;
    final typed = parseAuDate(typedDob.text);
    if (typedDob.text.trim().isNotEmpty && typed == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Use DD/MM/YYYY for date of birth')),
      );
      return;
    }
    final resolvedDob = typed ?? dob;
    final display = preferred.text.trim().isNotEmpty
        ? preferred.text.trim()
        : legal.text.trim();
    if (display.isEmpty) return;

    var updated = _person.copyWith(
      displayName: display,
      legalName: legal.text.trim().isEmpty ? null : legal.text.trim(),
      preferredName:
          preferred.text.trim().isEmpty ? null : preferred.text.trim(),
      pronouns: pronouns.text.trim().isEmpty ? null : pronouns.text.trim(),
      genderIdentity: gender,
      dateOfBirth: resolvedDob,
      clearDateOfBirth: resolvedDob == null,
      ageStage: _isSelf
          ? 'adult'
          : (resolvedDob != null
              ? ageStageFromDateOfBirth(resolvedDob)
              : _person.ageStage),
      updatedAt: DateTime.now(),
    );
    final saved = await savePersonResolvingBirthday(context, updated);
    if (!mounted) return;
    if (saved != null) setState(() => _person = saved);
  }

  Future<void> _editConnection() async {
    if (_isSelf) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your profile is always “Me”.')),
      );
      return;
    }
    var relationship = _person.relationshipToUser;
    var arrangement = _person.livingArrangement;
    var listKind = _person.isContact ? listKindContact : listKindFamily;
    final residence = TextEditingController(text: _person.residenceLocation ?? '');

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Family connection', style: BethTypography.subheading),
                  const SizedBox(height: 8),
                  Text(
                    'Stepfamilies, shared custody, and overseas households are welcome here.',
                    style: BethTypography.caption,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: relationshipOptions.any((o) => o.$1 == relationship)
                        ? relationship
                        : 'other',
                    decoration: const InputDecoration(
                      labelText: 'Relationship / relation to you',
                    ),
                    items: birthdayRelationOptions
                        .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                        .toList(),
                    onChanged: (v) => setModal(() {
                      relationship = v!;
                      listKind = defaultListKindFor(relationship);
                    }),
                  ),
                  const SizedBox(height: 12),
                  Text('List placement', style: BethTypography.caption),
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
                    selected: {listKind},
                    onSelectionChanged: (s) => setModal(() => listKind = s.first),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    value: arrangement,
                    decoration: const InputDecoration(labelText: 'Living arrangement'),
                    items: livingArrangementOptions
                        .map((o) => DropdownMenuItem(value: o.$1, child: Text(o.$2)))
                        .toList(),
                    onChanged: (v) => setModal(() => arrangement = v!),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: residence,
                    decoration: const InputDecoration(
                      labelText: 'Usual residence / notes',
                      hintText: 'e.g. UK with mum · visits in school holidays',
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () => Navigator.pop(ctx, true),
                    child: const Text('Save'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (ok != true || !mounted) return;
    final updated = _person.copyWith(
      relationshipToUser: relationship,
      livingArrangement: arrangement,
      livesWithMe:
          arrangement == 'lives_with_me' || arrangement == 'shared_custody',
      listKind: listKind,
      residenceLocation: residence.text.trim().isEmpty ? null : residence.text.trim(),
      clearResidenceLocation: residence.text.trim().isEmpty,
      updatedAt: DateTime.now(),
    );
    await context.read<FamilyHubProvider>().savePerson(updated);
    if (!mounted) return;
    setState(() => _person = updated);
  }

  Future<void> _confirmDelete() async {
    final name = personDisplayName(_person);
    final export = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(_isSelf ? 'Remove your self profile?' : 'Remove $name?'),
        content: Text(
          _isSelf
              ? 'You can add yourself again later from Add person → Me. Export first?'
              : 'Export their profile data before deleting?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Delete only'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Export & delete'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
    if (export == null || !mounted) return;
    final hub = context.read<FamilyHubProvider>();
    if (export) {
      final json = await hub.exportPersonData(_person.id);
      await Clipboard.setData(ClipboardData(text: json));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile JSON copied to clipboard')),
        );
      }
    }
    if (!mounted) return;
    await hub.removePerson(_person.id, exportFirst: false);
    if (!mounted) return;
    Navigator.pop(context);
  }

  List<({String label, String icon, String type})> get _quickButtons {
    switch (widget.person.ageStage) {
      case 'baby':
        return [
          (label: 'Feed', icon: '🍼', type: 'feed'),
          (label: 'Nap', icon: '😴', type: 'nap'),
          (label: 'Nappy', icon: '🧷', type: 'nappy'),
          (label: 'Bath', icon: '🛁', type: 'bath'),
          (label: 'Tummy', icon: '👶', type: 'tummy'),
          (label: 'Other', icon: '📌', type: 'other'),
        ];
      case 'toddler':
        return [
          (label: 'Meal', icon: '🍽', type: 'meal'),
          (label: 'Nap', icon: '😴', type: 'nap'),
          (label: 'Nappy', icon: '🧷', type: 'nappy'),
          (label: 'Play', icon: '🧸', type: 'play'),
        ];
      case 'child':
        return [
          (label: 'School', icon: '🏫', type: 'school'),
          (label: 'Homework', icon: '📚', type: 'homework'),
          (label: 'Activity', icon: '⚽', type: 'activity'),
        ];
      case 'teen':
        return [
          (label: 'Mood', icon: '💭', type: 'mood'),
          (label: 'Study', icon: '📖', type: 'study'),
          (label: 'Out', icon: '🚪', type: 'out'),
        ];
      default:
        return [(label: 'Note', icon: '📌', type: 'other')];
    }
  }

  Color _medColour(Map<String, dynamic> med) {
    final last = med['last_given'] as String?;
    final hours = med['minimum_interval_hours'] as int? ?? 4;
    if (last == null) return BethColours.green;
    final lastDt = DateTime.tryParse(last);
    if (lastDt == null) return BethColours.green;
    final next = lastDt.add(Duration(hours: hours));
    final now = DateTime.now();
    if (now.isAfter(next)) return BethColours.green;
    if (next.difference(now).inMinutes <= 60) return BethColours.amber;
    return BethColours.red;
  }

  String _medLabel(Map<String, dynamic> med) {
    final c = _medColour(med);
    if (c == BethColours.green) return 'Available';
    if (c == BethColours.amber) return 'Soon';
    return 'Wait';
  }

  @override
  Widget build(BuildContext context) {
    final person = _person;
    final name = personDisplayName(person);

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        actions: [
          if (person.dateOfBirth != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(ageDisplayLabel(person), style: BethTypography.caption),
              ),
            ),
          IconButton(
            tooltip: 'Edit profile',
            icon: const Icon(Icons.edit_outlined),
            onPressed: _editProfile,
          ),
          IconButton(
            tooltip: 'Delete',
            icon: const Icon(Icons.delete_outline),
            onPressed: _confirmDelete,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: ListTile(
                      leading: Icon(
                        _isSelf ? Icons.person : Icons.badge_outlined,
                        color: BethColours.primary,
                      ),
                      title: Text(name),
                      subtitle: Text(() {
                        final bits = <String>[
                          if (person.dateOfBirth != null)
                            'DOB ${formatAuDate(person.dateOfBirth!)}',
                          if (person.genderIdentity != null &&
                              person.genderIdentity!.isNotEmpty)
                            person.genderIdentity!.replaceAll('_', ' '),
                          if (person.pronouns != null && person.pronouns!.isNotEmpty)
                            person.pronouns!,
                        ];
                        return bits.isEmpty
                            ? 'Tap to edit name, birthday, gender'
                            : bits.join(' · ');
                      }()),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: _editProfile,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        livesAwayPrimarily(person.livingArrangement)
                            ? Icons.flight_takeoff
                            : Icons.home_outlined,
                        color: BethColours.primary,
                      ),
                      title: Text(relationshipLabel(person.relationshipToUser)),
                      subtitle: Text(
                        [
                          if (person.isContact) 'Contacts',
                          livingArrangementLabel(person.livingArrangement),
                          if (person.residenceLocation != null &&
                              person.residenceLocation!.isNotEmpty)
                            person.residenceLocation!,
                        ].join(' · '),
                      ),
                      trailing: _isSelf
                          ? null
                          : const Icon(Icons.edit_outlined),
                      onTap: _isSelf ? null : _editConnection,
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.edit_note_outlined),
                      title: const Text('Quick log in Notes'),
                      subtitle: Text('Capture for ${personDisplayName(person)}'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NotesScreen(
                            personId: person.id,
                            personName: personDisplayName(person),
                            ageStage: person.ageStage,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (person.ageStage == 'child' || person.ageStage == 'teen')
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.school_outlined),
                        title: const Text('School hub'),
                        subtitle: const Text('Timetable, contacts, and school notes'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SchoolHubScreen(person: person),
                          ),
                        ),
                      ),
                    ),
                  if (person.ageStage == 'baby' ||
                      person.ageStage == 'child' ||
                      person.ageStage == 'toddler')
                    Card(
                      child: ListTile(
                        leading: const Icon(Icons.show_chart_outlined),
                        title: const Text('Growth notes'),
                        subtitle: const Text('Weight, height, and head circumference'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => GrowthNotesScreen(person: person),
                          ),
                        ),
                      ),
                    ),
                  if (person.isTeen) ...[
                    Text('Privacy (on device)', style: BethTypography.subheading),
                    SwitchListTile(
                      title: const Text('Hide mood check-ins from parents'),
                      value: _teenPrivacy['hide_mood_from_parents']!,
                      onChanged: (v) => setState(() => _teenPrivacy['hide_mood_from_parents'] = v),
                    ),
                    SwitchListTile(
                      title: const Text('Keep journal private'),
                      value: _teenPrivacy['hide_journal']!,
                      onChanged: (v) => setState(() => _teenPrivacy['hide_journal'] = v),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_meds.isNotEmpty) ...[
                    Text('Medications', style: BethTypography.subheading),
                    const SizedBox(height: 8),
                    ..._meds.map((med) {
                      final colour = _medColour(med);
                      return Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: BethColours.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border(left: BorderSide(color: colour, width: 3)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    med['name'] as String? ?? 'Med',
                                    style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    '${med['dose']} ${med['dose_unit'] ?? ''}',
                                    style: BethTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            Text(_medLabel(med), style: TextStyle(color: colour, fontSize: 11)),
                            IconButton(
                              onPressed: () async {
                                await _dao.logMedicationGiven(med['id'] as String);
                                await _load();
                              },
                              icon: const Icon(Icons.check_circle_outline, color: BethColours.green),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 16),
                  ],
                  if (person.ageStage == 'baby') ...[
                    Text('7-day feeds', style: BethTypography.subheading),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: BarChart(
                        BarChartData(
                          maxY: (_feedChart.isEmpty ? 1 : _feedChart.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (v, _) {
                                  const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                                  final i = v.toInt();
                                  if (i < 0 || i >= 7) return const SizedBox.shrink();
                                  return Text(days[i], style: const TextStyle(fontSize: 10));
                                },
                              ),
                            ),
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          ),
                          gridData: const FlGridData(show: false),
                          borderData: FlBorderData(show: false),
                          barGroups: List.generate(
                            7,
                            (i) => BarChartGroupData(
                              x: i,
                              barRods: [
                                BarChartRodData(
                                  toY: (i < _feedChart.length ? _feedChart[i] : 0).toDouble(),
                                  color: BethColours.primary,
                                  width: 12,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  Text('Quick log', style: BethTypography.subheading),
                  if (person.ageStage == 'baby' || person.ageStage == 'toddler')
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Text(
                        'Feed logs breast, bottle, and solids for this child (including breastfeeding).',
                        style: BethTypography.caption,
                      ),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _quickButtons
                        .map((b) => _quickChip(b.label, b.icon, b.type))
                        .toList(),
                  ),
                  const SizedBox(height: 24),
                  Text('Recent activity', style: BethTypography.subheading),
                  const SizedBox(height: 8),
                  if (_activity.isEmpty)
                    Text('Nothing logged yet.', style: BethTypography.caption)
                  else
                    ..._activity.take(10).map((e) {
                      final at = DateTime.tryParse(e['logged_at'] as String? ?? '');
                      final time = at != null
                          ? '${at.hour}:${at.minute.toString().padLeft(2, '0')}'
                          : '';
                      return ListTile(
                        dense: true,
                        leading: Text(_iconFor(e['log_type'] as String? ?? '')),
                        title: Text(e['detail'] as String? ?? ''),
                        trailing: Text(time, style: BethTypography.caption),
                      );
                    }),
                ],
              ),
            ),
    );
  }

  String _iconFor(String type) {
    switch (type) {
      case 'feed':
        return '🍼';
      case 'nap':
        return '😴';
      case 'nappy':
        return '🧷';
      case 'medication':
        return '💊';
      default:
        return '📌';
    }
  }

  Widget _quickChip(String label, String icon, String type) {
    return ActionChip(
      avatar: Text(icon),
      label: Text(label),
      onPressed: () async {
        if (type == 'other' || label.toLowerCase() == 'note') {
          await _addNoteLog();
          return;
        }
        await _dao.logActivity(
          personId: widget.person.id,
          logType: type,
          detail: '$label logged for ${personDisplayName(widget.person)}',
        );
        await _load();
      },
    );
  }

  Future<void> _addNoteLog() async {
    final controller = TextEditingController();
    String? error;
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModal) {
            return AlertDialog(
              title: const Text('Add note'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: controller,
                    autofocus: true,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Note for ${personDisplayName(_person)}',
                      errorText: error,
                    ),
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (_) {
                      if (error != null) setModal(() => error = null);
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) {
                      setModal(() => error = 'Enter a note before saving');
                      return;
                    }
                    Navigator.pop(ctx, true);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
    final text = controller.text.trim();
    controller.dispose();
    if (saved != true || text.isEmpty || !mounted) return;

    await _dao.logActivity(
      personId: _person.id,
      logType: 'other',
      detail: text,
    );
    await _load();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note saved')),
    );
  }
}
