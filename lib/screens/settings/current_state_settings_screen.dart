import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/support_preset.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../providers/support_preset_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

const _emotional = <CurrentState>[
  CurrentState(id: 'overwhelmed', displayName: "I'm overwhelmed", description: 'Hide non-urgent items; one next step', defaultDurationMinutes: 120),
  CurrentState(id: 'panicking', displayName: "I'm panicking", description: 'Surface grounding tools', defaultDurationMinutes: 60),
  CurrentState(id: 'dissociating', displayName: "I'm dissociating", description: 'Simplify screens', defaultDurationMinutes: 120),
  CurrentState(id: 'triggered', displayName: "I'm triggered", description: 'Pause suggestions', defaultDurationMinutes: 60),
  CurrentState(id: 'shutdown', displayName: "I'm in shutdown/meltdown", description: 'Bare minimum only', defaultDurationMinutes: 180),
  CurrentState(id: 'intrusive_thoughts', displayName: "I'm having intrusive thoughts", description: 'Gentle, non-engaging prompts'),
  CurrentState(id: 'need_human', displayName: 'I need human support', description: 'Surface trusted contacts'),
];

const _physical = <CurrentState>[
  CurrentState(id: 'in_pain', displayName: "I'm in pain", description: 'Pain-day mode'),
  CurrentState(id: 'exhausted', displayName: "I'm exhausted", description: 'Reduce demands'),
  CurrentState(id: 'sleep_deprived', displayName: "I'm sleep deprived", description: 'Softer expectations'),
  CurrentState(id: 'sick', displayName: "I'm sick", description: 'Recovery focus'),
  CurrentState(id: 'migraine', displayName: 'Migraine mode', description: 'Low stim + rest'),
  CurrentState(id: 'flare', displayName: 'Flare day', description: 'Chronic flare support'),
  CurrentState(id: 'post_seizure', displayName: 'Post-seizure recovery', description: 'Quiet recovery'),
];

const _life = <CurrentState>[
  CurrentState(id: 'grief_day', displayName: 'Grief day', description: 'Gentle language, fewer asks'),
  CurrentState(id: 'relapse_risk', displayName: 'Relapse risk', description: 'Supportive check-ins'),
  CurrentState(id: 'low_energy', displayName: 'Low energy', description: 'Bare minimums emphasised'),
];

class CurrentStateSettingsScreen extends StatelessWidget {
  const CurrentStateSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();
    final support = context.watch<SupportPresetProvider>();
    final allStates = [..._emotional, ..._physical, ..._life];
    CurrentState? active;
    for (final s in allStates) {
      if (s.id == prefs.currentStateId) {
        active = s;
        break;
      }
    }
    final shortcuts = support.activePresets
        .expand((p) => p.currentStateShortcuts)
        .toSet()
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Current state')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Activate a temporary state. The app will adjust until you turn it off or the timer expires.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          ListTile(
            title: Text(
              active == null ? 'Current state: None' : 'Current state: ${active.displayName}',
              style: BethTypography.subheading,
            ),
            subtitle: active == null
                ? null
                : TextButton(
                    onPressed: () => prefs.setCurrentState(null),
                    child: const Text('Turn off'),
                  ),
          ),
          if (shortcuts.isNotEmpty) ...[
            _header('Quick access (from presets)'),
            ...shortcuts.map((id) {
              CurrentState? state;
              for (final s in allStates) {
                if (s.id == id) {
                  state = s;
                  break;
                }
              }
              if (state == null) return const SizedBox.shrink();
              return _stateTile(context, prefs, state);
            }),
          ],
          _header('Emotional states'),
          ..._emotional.map((s) => _stateTile(context, prefs, s)),
          _header('Physical states'),
          ..._physical.map((s) => _stateTile(context, prefs, s)),
          _header('Life states'),
          ..._life.map((s) => _stateTile(context, prefs, s)),
          const Divider(),
          _header('Timer (optional)'),
          RadioListTile<String>(
            title: const Text('Until I turn it off'),
            value: 'until_off',
            groupValue: prefs.currentStateTimer,
            onChanged: (v) => prefs.setCurrentStateTimer(v!),
          ),
          RadioListTile<String>(
            title: const Text('2 hours'),
            value: '2h',
            groupValue: prefs.currentStateTimer,
            onChanged: (v) => prefs.setCurrentStateTimer(v!),
          ),
          RadioListTile<String>(
            title: const Text('4 hours'),
            value: '4h',
            groupValue: prefs.currentStateTimer,
            onChanged: (v) => prefs.setCurrentStateTimer(v!),
          ),
          RadioListTile<String>(
            title: const Text('Rest of day'),
            value: 'rest_of_day',
            groupValue: prefs.currentStateTimer,
            onChanged: (v) => prefs.setCurrentStateTimer(v!),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _header(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: BethTypography.caption.copyWith(color: BethColours.textMuted)),
    );
  }

  Widget _stateTile(BuildContext context, SettingsPrefsProvider prefs, CurrentState state) {
    final selected = prefs.currentStateId == state.id;
    return ListTile(
      title: Text(state.displayName),
      subtitle: Text(state.description, style: BethTypography.caption),
      trailing: selected ? const Icon(Icons.check_circle, color: BethColours.green) : null,
      onTap: () => prefs.setCurrentState(selected ? null : state.id),
    );
  }
}
