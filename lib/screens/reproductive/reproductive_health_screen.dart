import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/reproductive_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class ReproductiveHealthScreen extends StatefulWidget {
  const ReproductiveHealthScreen({super.key});

  @override
  State<ReproductiveHealthScreen> createState() =>
      _ReproductiveHealthScreenState();
}

class _ReproductiveHealthScreenState extends State<ReproductiveHealthScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  static const _symptoms = [
    'Cramps',
    'Headache',
    'Bloating',
    'Fatigue',
    'Mood change',
    'Breast tenderness',
  ];

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 7, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ReproductiveProvider>().load();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repro = context.watch<ReproductiveProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Reproductive Health', style: BethTypography.heading),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: BethColours.primary,
          unselectedLabelColor: BethColours.textMuted,
          tabs: const [
            Tab(text: 'Cycle'),
            Tab(text: 'Contraception'),
            Tab(text: 'Pregnancy'),
            Tab(text: 'Postpartum'),
            Tab(text: 'Breast health'),
            Tab(text: "Men's health"),
            Tab(text: 'Emergency'),
          ],
        ),
      ),
      body: !repro.loaded
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                _cycleTab(repro),
                _contraceptionTab(repro),
                _pregnancyTab(repro),
                _postpartumTab(repro),
                _breastHealthTab(),
                _mensTab(repro),
                _emergencyTab(),
              ],
            ),
    );
  }

  Widget _cycleTab(ReproductiveProvider repro) {
    final next = repro.mayBeNextPeriod;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Predictions use “may be” phrasing only — bodies are not clocks.',
          style: BethTypography.caption.copyWith(color: BethColours.textMuted),
        ),
        if (repro.latestCycle != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: BethColours.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Day ${repro.latestCycle!.cycleDay} · ${repro.latestCycle!.currentPhase}',
                  style: BethTypography.subheading,
                ),
                if (next != null)
                  Text(
                    'Next period may start around ${_fmt(next)} '
                    '(~${repro.averageCycleLength}-day average).',
                    style: BethTypography.bodySmall,
                  ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: () => _logPeriod(repro),
          icon: const Icon(Icons.add),
          label: const Text('Log period start / end'),
        ),
        const SizedBox(height: 16),
        Text('History', style: BethTypography.caption),
        ...repro.cycles.map(
          (c) => ListTile(
            tileColor: BethColours.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text('Started ${_fmt(c.periodStartDate)}'),
            subtitle: Text([
              if (c.periodEndDate != null) 'Ended ${_fmt(c.periodEndDate!)}',
              if (c.flowIntensity != null) 'Flow: ${c.flowIntensity}',
              if (c.symptoms.isNotEmpty) c.symptoms.join(', '),
            ].join(' · ')),
          ),
        ),
      ],
    );
  }

  Future<void> _logPeriod(ReproductiveProvider repro) async {
    var start = DateTime.now();
    DateTime? end;
    var flow = 'medium';
    final selected = <String>{};
    final notes = TextEditingController();

    final ok = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Log period', style: BethTypography.subheading),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Start'),
                  subtitle: Text(_fmt(start)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: start,
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 1)),
                    );
                    if (d != null) setModal(() => start = d);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('End (optional)'),
                  subtitle: Text(end == null ? 'Not set' : _fmt(end!)),
                  trailing: const Icon(Icons.calendar_today_outlined),
                  onTap: () async {
                    final d = await showDatePicker(
                      context: ctx,
                      initialDate: end ?? start,
                      firstDate: start,
                      lastDate: DateTime.now().add(const Duration(days: 14)),
                    );
                    if (d != null) setModal(() => end = d);
                  },
                ),
                Wrap(
                  spacing: 8,
                  children: ['light', 'medium', 'heavy'].map((f) {
                    return ChoiceChip(
                      label: Text(f),
                      selected: flow == f,
                      onSelected: (_) => setModal(() => flow = f),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  children: _symptoms.map((s) {
                    return FilterChip(
                      label: Text(s),
                      selected: selected.contains(s),
                      onSelected: (v) => setModal(() {
                        if (v) {
                          selected.add(s);
                        } else {
                          selected.remove(s);
                        }
                      }),
                    );
                  }).toList(),
                ),
                TextField(
                  controller: notes,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (ok != true || !mounted) return;
    await repro.logPeriodStart(
      start: start,
      end: end,
      flow: flow,
      symptoms: selected.toList(),
      notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
    );
  }

  Widget _contraceptionTab(ReproductiveProvider repro) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        DropdownButtonFormField<String>(
          value: repro.contraceptionMethod,
          decoration: const InputDecoration(
            labelText: 'Method',
            filled: true,
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'pill', child: Text('Pill')),
            DropdownMenuItem(value: 'iud', child: Text('IUD')),
            DropdownMenuItem(value: 'implant', child: Text('Implant')),
            DropdownMenuItem(value: 'injection', child: Text('Injection')),
            DropdownMenuItem(value: 'condom', child: Text('Condom')),
            DropdownMenuItem(value: 'other', child: Text('Other / barrier')),
          ],
          onChanged: (v) => repro.setContraception(v, repro.contraceptionNotes),
        ),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            labelText: 'Notes / reminder',
            filled: true,
            border: OutlineInputBorder(),
          ),
          controller: TextEditingController(text: repro.contraceptionNotes ?? ''),
          onSubmitted: (v) =>
              repro.setContraception(repro.contraceptionMethod, v),
        ),
        const SizedBox(height: 12),
        Text(
          'Personal reminder only — not medical advice. Talk to your GP or clinic.',
          style: BethTypography.caption,
        ),
      ],
    );
  }

  Widget _pregnancyTab(ReproductiveProvider repro) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (repro.gestationWeeks != null)
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: BethColours.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'About ${repro.gestationWeeks} weeks'
              '${repro.pregnancyDueDate != null ? ' · due ${_fmt(repro.pregnancyDueDate!)}' : ''}',
              style: BethTypography.subheading,
            ),
          ),
        ListTile(
          tileColor: BethColours.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            repro.pregnancyStart == null
                ? 'Set gestation start / LMP'
                : 'Start: ${_fmt(repro.pregnancyStart!)}',
          ),
          trailing: const Icon(Icons.calendar_today),
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 300)),
              lastDate: DateTime.now(),
              initialDate: repro.pregnancyStart ?? DateTime.now(),
            );
            if (d != null) await repro.setPregnancyStart(d);
          },
        ),
        const SizedBox(height: 8),
        ListTile(
          tileColor: BethColours.surface,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          title: Text(
            repro.pregnancyDueDate == null
                ? 'Set due date'
                : 'Due: ${_fmt(repro.pregnancyDueDate!)}',
          ),
          trailing: const Icon(Icons.edit_calendar_outlined),
          onTap: () async {
            final d = await showDatePicker(
              context: context,
              firstDate: DateTime.now().subtract(const Duration(days: 30)),
              lastDate: DateTime.now().add(const Duration(days: 300)),
              initialDate: repro.pregnancyDueDate ??
                  DateTime.now().add(const Duration(days: 280)),
            );
            if (d != null) await repro.setPregnancyDueDate(d);
          },
        ),
        TextButton(
          onPressed: () async {
            await repro.setPregnancyStart(null);
            await repro.setPregnancyDueDate(null);
          },
          child: const Text('Clear pregnancy tracking'),
        ),
      ],
    );
  }

  Widget _postpartumTab(ReproductiveProvider repro) {
    final notes = TextEditingController(text: repro.postpartumNotes ?? '');
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        TextField(
          controller: notes,
          maxLines: 5,
          decoration: const InputDecoration(
            labelText: 'Recovery notes',
            hintText: 'Bleeding, pain, appointments — as you want to track them',
            filled: true,
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 8),
        FilledButton(
          onPressed: () => repro.setPostpartumNotes(
            notes.text,
            sixWeek: repro.sixWeekCheckDue ??
                DateTime.now().add(const Duration(days: 42)),
          ),
          child: const Text('Save'),
        ),
        if (repro.sixWeekCheckDue != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text('6-week check reminder: ${_fmt(repro.sixWeekCheckDue!)}'),
          ),
        const SizedBox(height: 16),
        Text(
          'If you feel unsafe or disconnected from reality, seek urgent help '
          '(Lifeline 13 11 14 or 000).',
          style: BethTypography.caption.copyWith(color: BethColours.red),
        ),
      ],
    );
  }

  Widget _breastHealthTab() {
    const resources = [
      (
        'Mastitis / blocked ducts',
        'Pain, heat, red patch, flu-like feeling while feeding. Rest, feed/express, see GP or midwife promptly. Not for self-diagnosis.',
      ),
      (
        'Thrush (nipple / baby mouth)',
        'Shooting pain after feeds, shiny/itchy nipples, white patches in baby’s mouth — GP / lactation consultant.',
      ),
      (
        'Engorgement & supply changes',
        'Comfort measures and when to get hands-on help from a midwife or IBCLC.',
      ),
      (
        'When to seek care urgently',
        'High fever, spreading redness, cracked skin with infection signs, or if you feel seriously unwell — call GP / Healthdirect / 000.',
      ),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Education and symptom awareness only — not diagnosis or treatment.',
          style: BethTypography.caption.copyWith(color: BethColours.textMuted),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: BethColours.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            'Feed and pump logging lives under Family Hub → your baby’s profile '
            '(Feed quick action), not here.',
            style: BethTypography.bodySmall,
          ),
        ),
        const SizedBox(height: 12),
        ...resources.map(
          (r) => Card(
            child: ListTile(
              title: Text(r.$1),
              subtitle: Text(r.$2),
              isThreeLine: true,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'AU resources: Healthdirect, Australian Breastfeeding Association, '
          'your midwife / child health nurse.',
          style: BethTypography.caption,
        ),
      ],
    );
  }

  Widget _mensTab(ReproductiveProvider repro) {
    const items = [
      ('prostate_reminder', 'Prostate health reminder'),
      ('testicular_check', 'Testicular self-check education'),
      ('sti_test', 'STI testing reminder'),
      ('sexual_health_appt', 'Sexual health appointment prep'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Checklist — education and reminders only. Talk to your GP.',
          style: BethTypography.caption.copyWith(color: BethColours.textMuted),
        ),
        ...items.map(
          (e) => CheckboxListTile(
            title: Text(e.$2),
            value: repro.mensChecklistDone.contains(e.$1),
            onChanged: (_) => repro.toggleMensItem(e.$1),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Resources: Healthy Male (healthymale.org.au), sexual health clinic.',
          style: BethTypography.caption,
        ),
      ],
    );
  }

  Widget _emergencyTab() {
    const links = [
      ('Emergency', '000'),
      ('Lifeline', '13 11 14'),
      ('Pregnancy, Birth & Baby', '1800 882 436'),
      ('Healthdirect', 'https://www.healthdirect.gov.au'),
      ('1800RESPECT', '1800 737 732'),
      ('PANDA (perinatal mental health)', '1300 726 306'),
    ];
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Accredited / government Australian contacts. Not a substitute for clinical care.',
          style: BethTypography.bodySmall,
        ),
        const SizedBox(height: 12),
        ...links.map(
          (e) => ListTile(
            tileColor: BethColours.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              e.$1,
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            subtitle: Text(e.$2),
          ),
        ),
      ],
    );
  }

  String _fmt(DateTime d) => DateFormat('d MMM yyyy').format(d);
}
