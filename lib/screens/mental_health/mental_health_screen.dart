import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/mental_health_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class MentalHealthScreen extends StatefulWidget {
  const MentalHealthScreen({super.key});

  @override
  State<MentalHealthScreen> createState() => _MentalHealthScreenState();
}

class _MentalHealthScreenState extends State<MentalHealthScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentalHealthProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Mental Health Toolkit', style: BethTypography.heading),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _EmergencyBanner(),
          const SizedBox(height: 12),
          _navTile(
            context,
            icon: Icons.shield_outlined,
            title: 'Crisis / Safety Plan',
            subtitle: 'Steps you wrote for hard moments',
            screen: const CrisisPlanScreen(),
          ),
          _navTile(
            context,
            icon: Icons.spa_outlined,
            title: 'Grounding 5-4-3-2-1',
            subtitle: 'Interactive sensory checklist',
            screen: const GroundingScreen(),
          ),
          _navTile(
            context,
            icon: Icons.air,
            title: 'Breathing',
            subtitle: 'Box breathing and 4-7-8',
            screen: const BreathingScreen(),
          ),
          _navTile(
            context,
            icon: Icons.edit_note_outlined,
            title: 'Worry log',
            subtitle: 'Park a worry on the page',
            screen: const WorryLogScreen(),
          ),
          _navTile(
            context,
            icon: Icons.place_outlined,
            title: 'Orientation',
            subtitle: 'Name, date, place, safe',
            screen: const OrientationCardScreen(),
          ),
          _navTile(
            context,
            icon: Icons.favorite_border,
            title: 'Panic support',
            subtitle: 'Short calm steps',
            screen: const PanicSupportScreen(),
          ),
          _navTile(
            context,
            icon: Icons.people_outline,
            title: 'Trusted contacts',
            subtitle: 'People you can reach',
            screen: const TrustedContactsScreen(),
          ),
        ],
      ),
    );
  }

  Widget _navTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget screen,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        tileColor: BethColours.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        leading: Icon(icon, color: BethColours.primary),
        title: Text(title, style: BethTypography.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: BethColours.textPrimary,
        )),
        subtitle: Text(subtitle, style: BethTypography.caption),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        ),
      ),
    );
  }
}

class _EmergencyBanner extends StatelessWidget {
  const _EmergencyBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: BethColours.red.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: BethColours.red.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency resources (Australia)',
            style: BethTypography.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              color: BethColours.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Lifeline 13 11 14 · Beyond Blue 1300 22 4636 · '
            'Suicide Call Back 1300 659 467 · Emergency 000 · '
            '13YARN 13 92 76 · Kids Helpline 1800 55 1800',
            style: BethTypography.caption.copyWith(color: BethColours.textPrimary),
          ),
        ],
      ),
    );
  }
}

// ── Crisis plan ──────────────────────────────────────────────

class CrisisPlanScreen extends StatefulWidget {
  const CrisisPlanScreen({super.key});

  @override
  State<CrisisPlanScreen> createState() => _CrisisPlanScreenState();
}

class _CrisisPlanScreenState extends State<CrisisPlanScreen> {
  late final TextEditingController _warning;
  late final TextEditingController _coping;
  late final TextEditingController _people;
  late final TextEditingController _pro;
  late final TextEditingController _safe;
  late final TextEditingController _reasons;
  bool _inited = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_inited) return;
    _inited = true;
    final plan = context.read<MentalHealthProvider>().crisisPlan;
    _warning = TextEditingController(text: plan?.warningSigns ?? '');
    _coping = TextEditingController(text: plan?.copingStrategies ?? '');
    _people = TextEditingController(text: plan?.peopleToContact ?? '');
    _pro = TextEditingController(text: plan?.professionalHelp ?? '');
    _safe = TextEditingController(text: plan?.makeEnvironmentSafe ?? '');
    _reasons = TextEditingController(text: plan?.reasonsToStay ?? '');
  }

  @override
  void dispose() {
    _warning.dispose();
    _coping.dispose();
    _people.dispose();
    _pro.dispose();
    _safe.dispose();
    _reasons.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Crisis / Safety Plan')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _EmergencyBanner(),
          const SizedBox(height: 12),
          _field('1. Warning signs', _warning),
          _field('2. Coping strategies (alone)', _coping),
          _field('3. People & social settings that help', _people),
          _field('4. Professional help', _pro),
          _field('5. Making the environment safer', _safe),
          _field('6. Reasons for living', _reasons),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: () async {
              await context.read<MentalHealthProvider>().saveCrisisPlan(
                    warningSigns: _warning.text,
                    copingStrategies: _coping.text,
                    peopleToContact: _people.text,
                    professionalHelp: _pro.text,
                    makeEnvironmentSafe: _safe.text,
                    reasonsToStay: _reasons.text,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Safety plan saved')),
                );
              }
            },
            child: const Text('Save plan'),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        maxLines: 3,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}

// ── Grounding ────────────────────────────────────────────────

class GroundingScreen extends StatefulWidget {
  const GroundingScreen({super.key});

  @override
  State<GroundingScreen> createState() => _GroundingScreenState();
}

class _GroundingScreenState extends State<GroundingScreen> {
  final _checks = List<bool>.filled(15, false);

  static const _prompts = [
    ('See', 5, '5 things you can see'),
    ('Touch', 4, '4 things you can touch'),
    ('Hear', 3, '3 things you can hear'),
    ('Smell', 2, '2 things you can smell'),
    ('Taste', 1, '1 thing you can taste'),
  ];

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[
      Text(
        'Tick each sense as you notice it. No rush.',
        style: BethTypography.bodySmall,
      ),
      const SizedBox(height: 12),
    ];
    var offset = 0;
    for (final prompt in _prompts) {
      children.add(Text(prompt.$3, style: BethTypography.subheading));
      children.add(const SizedBox(height: 4));
      for (var i = 0; i < prompt.$2; i++) {
        final idx = offset + i;
        children.add(
          CheckboxListTile(
            value: _checks[idx],
            onChanged: (v) => setState(() => _checks[idx] = v ?? false),
            title: Text('${prompt.$1} ${i + 1}', style: BethTypography.bodySmall),
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        );
      }
      offset += prompt.$2;
      children.add(const SizedBox(height: 8));
    }
    children.add(
      TextButton(
        onPressed: () => setState(() {
          for (var i = 0; i < _checks.length; i++) {
            _checks[i] = false;
          }
        }),
        child: const Text('Reset'),
      ),
    );

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Grounding 5-4-3-2-1')),
      body: ListView(padding: const EdgeInsets.all(16), children: children),
    );
  }
}

// ── Breathing ────────────────────────────────────────────────

class BreathingScreen extends StatelessWidget {
  const BreathingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Breathing')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _breathCard(
            context,
            title: 'Box breathing',
            subtitle: 'In 4 · Hold 4 · Out 4 · Hold 4',
            phases: const [
              ('Inhale', 4),
              ('Hold', 4),
              ('Exhale', 4),
              ('Hold', 4),
            ],
          ),
          const SizedBox(height: 12),
          _breathCard(
            context,
            title: '4-7-8',
            subtitle: 'In 4 · Hold 7 · Out 8',
            phases: const [
              ('Inhale', 4),
              ('Hold', 7),
              ('Exhale', 8),
            ],
          ),
        ],
      ),
    );
  }

  Widget _breathCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<(String, int)> phases,
  }) {
    return ListTile(
      tileColor: BethColours.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(title, style: BethTypography.body.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.play_arrow),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BreathingTimerScreen(title: title, phases: phases),
        ),
      ),
    );
  }
}

class BreathingTimerScreen extends StatefulWidget {
  final String title;
  final List<(String, int)> phases;

  const BreathingTimerScreen({
    super.key,
    required this.title,
    required this.phases,
  });

  @override
  State<BreathingTimerScreen> createState() => _BreathingTimerScreenState();
}

class _BreathingTimerScreenState extends State<BreathingTimerScreen> {
  int _phaseIndex = 0;
  int _secondsLeft = 0;
  bool _running = false;

  @override
  void initState() {
    super.initState();
    _secondsLeft = widget.phases.first.$2;
  }

  void _toggle() {
    if (_running) {
      setState(() => _running = false);
      return;
    }
    setState(() => _running = true);
    _tick();
  }

  Future<void> _tick() async {
    while (_running && mounted) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!_running || !mounted) return;
      setState(() {
        if (_secondsLeft <= 1) {
          _phaseIndex = (_phaseIndex + 1) % widget.phases.length;
          _secondsLeft = widget.phases[_phaseIndex].$2;
        } else {
          _secondsLeft--;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final phase = widget.phases[_phaseIndex];
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(phase.$1, style: BethTypography.displayLarge),
            const SizedBox(height: 16),
            Text(
              '$_secondsLeft',
              style: BethTypography.displayLarge.copyWith(fontSize: 64),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _toggle,
              child: Text(_running ? 'Pause' : 'Start'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Worry log ────────────────────────────────────────────────

class WorryLogScreen extends StatelessWidget {
  const WorryLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mh = context.watch<MentalHealthProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Worry log')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: mh.worryLogs.isEmpty
          ? Center(
              child: Text(
                'No worries parked yet.',
                style: BethTypography.bodySmall,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: mh.worryLogs.length,
              itemBuilder: (context, i) {
                final w = mh.worryLogs[i];
                return Dismissible(
                  key: ValueKey(w.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) =>
                      context.read<MentalHealthProvider>().deleteWorry(w.id),
                  background: Container(
                    color: BethColours.red.withOpacity(0.2),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline, color: BethColours.red),
                  ),
                  child: ListTile(
                    tileColor: BethColours.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(w.content, style: BethTypography.bodySmall),
                    subtitle: Text(
                      DateFormat('d MMM · h:mm a').format(w.createdAt),
                      style: BethTypography.caption,
                    ),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final c = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Park a worry'),
        content: TextField(
          controller: c,
          maxLines: 4,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'What is on your mind?'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true && c.text.trim().isNotEmpty && context.mounted) {
      await context.read<MentalHealthProvider>().addWorry(c.text.trim());
    }
  }
}

// ── Orientation ──────────────────────────────────────────────

class OrientationCardScreen extends StatelessWidget {
  const OrientationCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Orientation')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: BethColours.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('You are here', style: BethTypography.subheading),
              const SizedBox(height: 16),
              Text('My name is…', style: BethTypography.caption),
              Text('(Say or write your name)', style: BethTypography.body),
              const SizedBox(height: 12),
              Text('Today is', style: BethTypography.caption),
              Text(
                DateFormat('EEEE d MMMM yyyy').format(now),
                style: BethTypography.body,
              ),
              const SizedBox(height: 12),
              Text('I am in', style: BethTypography.caption),
              Text('(Name this place — room, city, home)', style: BethTypography.body),
              const SizedBox(height: 12),
              Text('Right now I am', style: BethTypography.caption),
              Text('Safe enough in this moment.', style: BethTypography.body),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Panic support ────────────────────────────────────────────

class PanicSupportScreen extends StatelessWidget {
  const PanicSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const steps = [
      'This feeling will pass. Panic peaks and then eases.',
      'Plant your feet. Feel the floor.',
      'Lengthen your exhale — slower out than in.',
      'Name 3 things you can see.',
      'If you can, sip water or hold something cool.',
      'You do not have to solve everything right now.',
    ];

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Panic support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _EmergencyBanner(),
          const SizedBox(height: 12),
          ...steps.map(
            (s) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: BethColours.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(s, style: BethTypography.body),
              ),
            ),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const GroundingScreen()),
            ),
            icon: const Icon(Icons.spa_outlined),
            label: const Text('Open grounding 5-4-3-2-1'),
          ),
        ],
      ),
    );
  }
}

// ── Trusted contacts ─────────────────────────────────────────

class TrustedContactsScreen extends StatelessWidget {
  const TrustedContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mh = context.watch<MentalHealthProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Trusted contacts')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          const _EmergencyBanner(),
          const SizedBox(height: 12),
          if (mh.contacts.isEmpty)
            Text('No contacts yet.', style: BethTypography.bodySmall)
          else
            ...mh.contacts.map((c) {
              return ListTile(
                tileColor: BethColours.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(c.name),
                subtitle: Text(
                  [if (c.phone != null) c.phone!, if (c.notes != null) c.notes!]
                      .join(' · '),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (c.phone != null && c.phone!.isNotEmpty)
                      IconButton(
                        tooltip: 'Copy phone',
                        icon: const Icon(Icons.copy_outlined),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: c.phone!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Copied ${c.phone}')),
                          );
                        },
                      ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => context
                          .read<MentalHealthProvider>()
                          .deleteContact(c.id),
                    ),
                  ],
                ),
              );
            }),
          const SizedBox(height: 8),
          Text(
            'Phone numbers are shown here so you can call or text from your phone app '
            '(e.g. sms: in your dialler). No automatic messages are sent.',
            style: BethTypography.caption,
          ),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final name = TextEditingController();
    final phone = TextEditingController();
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextField(
              controller: phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone'),
            ),
            TextField(controller: notes, decoration: const InputDecoration(labelText: 'Notes')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Save')),
        ],
      ),
    );
    if (ok == true && name.text.trim().isNotEmpty && context.mounted) {
      await context.read<MentalHealthProvider>().addContact(
            name: name.text.trim(),
            phone: phone.text.trim().isEmpty ? null : phone.text.trim(),
            notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
          );
    }
  }
}
