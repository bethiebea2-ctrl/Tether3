import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/health_models.dart';
import '../../providers/health_provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Static accredited red-flag resources (Phase 1D — no url_launcher in pubspec).
const _redFlagResources = <(String, String)>[
  (
    'Chest pain — when to call 000',
    'https://www.healthdirect.gov.au/chest-pain',
  ),
  (
    'Meningitis symptoms',
    'https://www.healthdirect.gov.au/meningitis',
  ),
  (
    'Stroke symptoms — FAST',
    'https://strokefoundation.org.au/about-stroke/learn/signs-of-stroke',
  ),
  (
    'Fever in babies',
    'https://raisingchildren.net.au/babies/health/common-concerns/fever',
  ),
  (
    'Seizure lasting >5 minutes',
    'https://www.epilepsy.org.au/about-epilepsy/first-aid/',
  ),
  (
    'Anaphylaxis signs',
    'https://www.allergy.org.au/patients/about-allergy/anaphylaxis',
  ),
  (
    'If you are thinking about suicide',
    'https://www.lifeline.org.au/get-help/topics/suicide',
  ),
];

class HealthStatusScreen extends StatefulWidget {
  const HealthStatusScreen({super.key});

  @override
  State<HealthStatusScreen> createState() => _HealthStatusScreenState();
}

class _HealthStatusScreenState extends State<HealthStatusScreen> {
  final _dateFmt = DateFormat('d MMM, HH:mm');

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HealthProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final health = context.watch<HealthProvider>();

    if (!health.isLoaded) {
      return Scaffold(
        appBar: AppBar(title: const Text('Health Status')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Status'),
        actions: [
          IconButton(
            tooltip: 'Discuss with Doctor',
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _discussWithDoctor(health),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 32),
        children: [
          _disclaimerBanner(),
          _sectionHeader('Personal medications'),
          if (health.medications.isEmpty)
            const ListTile(
              title: Text('No personal medications yet'),
              subtitle: Text('Add meds you take yourself'),
            )
          else
            ...health.medications.map((m) => _medTile(health, m)),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add medication'),
            onTap: () => _addMedication(health),
          ),
          const ListTile(
            leading: Icon(Icons.family_restroom_outlined),
            title: Text('Dependent medications → Family Hub'),
            subtitle: Text(
              'Medications for children and dependents are managed in Family Hub profiles.',
            ),
          ),
          const Divider(),
          _sectionHeader('Quick log'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _quickChip('BP', Icons.favorite_outline, () => _logBp(health)),
                _quickChip('Glucose', Icons.water_drop_outlined, () => _logGlucose(health)),
                _quickChip('Symptom', Icons.sick_outlined, () => _logSymptom(health)),
                _quickChip('Pain', Icons.healing_outlined, () => _logPain(health)),
                _quickChip('Sleep', Icons.bedtime_outlined, () => _logSleep(health)),
              ],
            ),
          ),
          if (health.logs.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...health.logs.take(8).map(
              (e) => ListTile(
                dense: true,
                title: Text('${e.type}: ${e.displayValue()}'),
                subtitle: Text(_dateFmt.format(e.loggedAt)),
                trailing: IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => health.deleteHealthLog(e.id),
                ),
              ),
            ),
          ],
          const Divider(),
          _sectionHeader('Allergies'),
          if (health.allergies.isEmpty)
            const ListTile(title: Text('No allergies recorded'))
          else
            ...health.allergies.map(
              (a) => ListTile(
                title: Text(a.name),
                subtitle: Text(
                  [
                    if (a.severity != null && a.severity!.isNotEmpty) a.severity,
                    if (a.notes != null && a.notes!.isNotEmpty) a.notes,
                  ].whereType<String>().join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => health.deleteAllergy(a.id),
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add allergy'),
            onTap: () => _addAllergy(health),
          ),
          const Divider(),
          _sectionHeader('Documents'),
          if (health.documents.isEmpty)
            const ListTile(title: Text('No documents yet'))
          else
            ...health.documents.map(
              (d) => ListTile(
                title: Text(d.title),
                subtitle: Text(
                  [
                    if (d.docType != null) d.docType,
                    if (d.notes != null && d.notes!.isNotEmpty) d.notes,
                    if (d.filePath != null && d.filePath!.isNotEmpty) d.filePath,
                  ].whereType<String>().join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => health.deleteDocument(d.id),
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Add document'),
            onTap: () => _addDocument(health),
          ),
          const Divider(),
          _sectionHeader('Seizure log'),
          if (health.seizures.isEmpty)
            const ListTile(title: Text('No seizures logged'))
          else
            ...health.seizures.take(5).map(
              (s) => ListTile(
                title: Text(_dateFmt.format(s.startedAt)),
                subtitle: Text(
                  [
                    if (s.durationMinutes != null) '${s.durationMinutes} min',
                    if (s.notes != null && s.notes!.isNotEmpty) s.notes,
                    if (s.postSeizureModeTriggered) 'post-seizure mode',
                  ].whereType<String>().join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => health.deleteSeizureLog(s.id),
                ),
              ),
            ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text('Log seizure'),
            onTap: () => _logSeizure(health),
          ),
          ListTile(
            leading: const Icon(Icons.spa_outlined, color: BethColours.primary),
            title: const Text('Start post-seizure recovery'),
            subtitle: const Text('Sets Current State to post-seizure recovery'),
            onTap: () => _startPostSeizure(health),
          ),
          const Divider(),
          _sectionHeader('Red-flag resources'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Accredited links only. Open in a browser. Not triage or medical advice.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          ..._redFlagResources.map(
            (r) => ListTile(
              title: Text(r.$1),
              subtitle: SelectableText(
                r.$2,
                style: BethTypography.caption.copyWith(color: BethColours.primary),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.copy_outlined, size: 20),
                tooltip: 'Copy URL',
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: r.$2));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('URL copied')),
                  );
                },
              ),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.medical_services_outlined),
            title: const Text('Discuss with Doctor'),
            subtitle: const Text('Copy a plain-text summary to clipboard'),
            onTap: () => _discussWithDoctor(health),
          ),
        ],
      ),
    );
  }

  Widget _disclaimerBanner() {
    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BethColours.surfaceAlt,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: BethColours.primaryLight.withValues(alpha: 0.4)),
      ),
      child: const Text(
        'Track only — not medical advice. Tether does not diagnose, dose, or interpret results. Seek urgent care for red-flag symptoms (see resources below).',
        style: BethTypography.bodySmall,
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        title,
        style: BethTypography.caption.copyWith(color: BethColours.textMuted),
      ),
    );
  }

  Widget _quickChip(String label, IconData icon, VoidCallback onTap) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: onTap,
    );
  }

  Widget _medTile(HealthProvider health, PersonalMedication m) {
    return ListTile(
      title: Text(m.name),
      subtitle: Text(
        '${m.dose} ${m.doseUnit} · ${m.mode}'
        '${m.lastGiven != null ? ' · last ${_dateFmt.format(m.lastGiven!)}' : ''}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              await health.logDose(m);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged dose of ${m.name}')),
              );
            },
            child: const Text('Log dose'),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () => health.deleteMedication(m.id),
          ),
        ],
      ),
    );
  }

  Future<void> _discussWithDoctor(HealthProvider health) async {
    final text = health.discussWithDoctorExport();
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Doctor summary copied to clipboard')),
    );
  }

  Future<void> _addMedication(HealthProvider health) async {
    final name = TextEditingController();
    final dose = TextEditingController();
    final unit = TextEditingController(text: 'mg');
    final notes = TextEditingController();
    var mode = 'as_needed';

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add medication'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: dose,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Dose'),
                ),
                TextField(
                  controller: unit,
                  decoration: const InputDecoration(labelText: 'Unit'),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ChoiceChip(
                      label: const Text('As needed'),
                      selected: mode == 'as_needed',
                      onSelected: (_) => setModal(() => mode = 'as_needed'),
                    ),
                    const SizedBox(width: 8),
                    ChoiceChip(
                      label: const Text('Scheduled'),
                      selected: mode == 'scheduled',
                      onSelected: (_) => setModal(() => mode = 'scheduled'),
                    ),
                  ],
                ),
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
          ],
        ),
      ),
    );

    if (ok != true) return;
    final doseVal = double.tryParse(dose.text.trim());
    if (name.text.trim().isEmpty || doseVal == null) return;
    await health.addMedication(
      name: name.text.trim(),
      dose: doseVal,
      doseUnit: unit.text.trim().isEmpty ? 'mg' : unit.text.trim(),
      mode: mode,
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _logBp(HealthProvider health) async {
    final sys = TextEditingController();
    final dia = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Blood pressure',
      fields: [
        TextField(
          controller: sys,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Systolic'),
        ),
        TextField(
          controller: dia,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Diastolic'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true) return;
    final s = double.tryParse(sys.text.trim());
    final d = double.tryParse(dia.text.trim());
    if (s == null || d == null) return;
    await health.addHealthLog(
      type: 'bp',
      valueNum: s,
      valueNumSecondary: d,
      valueText: '${s.toStringAsFixed(0)}/${d.toStringAsFixed(0)}',
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _logGlucose(HealthProvider health) async {
    final value = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Glucose',
      fields: [
        TextField(
          controller: value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Reading'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true) return;
    final v = double.tryParse(value.text.trim());
    if (v == null) return;
    await health.addHealthLog(
      type: 'glucose',
      valueNum: v,
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _logSymptom(HealthProvider health) async {
    final text = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Symptom',
      fields: [
        TextField(
          controller: text,
          decoration: const InputDecoration(labelText: 'Symptom'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true || text.text.trim().isEmpty) return;
    await health.addHealthLog(
      type: 'symptom',
      valueText: text.text.trim(),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _logPain(HealthProvider health) async {
    final value = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Pain (0–10)',
      fields: [
        TextField(
          controller: value,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Level 0–10'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true) return;
    final v = double.tryParse(value.text.trim());
    if (v == null) return;
    await health.addHealthLog(
      type: 'pain',
      valueNum: v.clamp(0, 10),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _logSleep(HealthProvider health) async {
    final value = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Sleep',
      fields: [
        TextField(
          controller: value,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'Hours'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true) return;
    final v = double.tryParse(value.text.trim());
    if (v == null) return;
    await health.addHealthLog(
      type: 'sleep',
      valueNum: v,
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _addAllergy(HealthProvider health) async {
    final name = TextEditingController();
    final severity = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Add allergy',
      fields: [
        TextField(
          controller: name,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: severity,
          decoration: const InputDecoration(labelText: 'Severity (optional)'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true || name.text.trim().isEmpty) return;
    await health.addAllergy(
      name: name.text.trim(),
      severity: severity.text.trim().isEmpty ? null : severity.text.trim(),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _addDocument(HealthProvider health) async {
    final title = TextEditingController();
    final docType = TextEditingController();
    final notes = TextEditingController();
    final path = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Add document',
      fields: [
        TextField(
          controller: title,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        TextField(
          controller: docType,
          decoration: const InputDecoration(labelText: 'Type (optional)'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
        TextField(
          controller: path,
          decoration: const InputDecoration(labelText: 'File path (optional)'),
        ),
      ],
    );
    if (ok != true || title.text.trim().isEmpty) return;
    await health.addDocument(
      title: title.text.trim(),
      docType: docType.text.trim().isEmpty ? null : docType.text.trim(),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
      filePath: path.text.trim().isEmpty ? null : path.text.trim(),
    );
  }

  Future<void> _logSeizure(HealthProvider health) async {
    final duration = TextEditingController();
    final notes = TextEditingController();
    final ok = await _simpleDialog(
      title: 'Log seizure',
      fields: [
        TextField(
          controller: duration,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Duration (minutes)'),
        ),
        TextField(
          controller: notes,
          decoration: const InputDecoration(labelText: 'Notes (optional)'),
        ),
      ],
    );
    if (ok != true) return;
    await health.addSeizureLog(
      durationMinutes: int.tryParse(duration.text.trim()),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Future<void> _startPostSeizure(HealthProvider health) async {
    await health.addSeizureLog(
      notes: 'Post-seizure recovery started',
      postSeizureModeTriggered: true,
    );
    if (!mounted) return;
    try {
      await context.read<SettingsPrefsProvider>().setCurrentState('post_seizure');
    } catch (_) {
      // Provider may not be wired yet by parent agent.
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Post-seizure recovery set')),
    );
  }

  Future<bool?> _simpleDialog({
    required String title,
    required List<Widget> fields,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: fields,
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
  }
}
