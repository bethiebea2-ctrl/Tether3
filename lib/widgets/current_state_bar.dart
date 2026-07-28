import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/support_preset.dart';
import '../providers/dashboard_provider.dart';
import '../providers/settings_prefs_provider.dart';
import '../screens/settings/current_state_settings_screen.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';

const _allStates = <CurrentState>[
  CurrentState(id: 'overwhelmed', displayName: "I'm overwhelmed", description: 'Hide non-urgent items; one next step', defaultDurationMinutes: 120),
  CurrentState(id: 'panicking', displayName: "I'm panicking", description: 'Surface grounding tools', defaultDurationMinutes: 60),
  CurrentState(id: 'dissociating', displayName: "I'm dissociating", description: 'Simplify screens', defaultDurationMinutes: 120),
  CurrentState(id: 'triggered', displayName: "I'm triggered", description: 'Pause suggestions', defaultDurationMinutes: 60),
  CurrentState(id: 'shutdown', displayName: "I'm in shutdown/meltdown", description: 'Bare minimum only', defaultDurationMinutes: 180),
  CurrentState(id: 'intrusive_thoughts', displayName: "I'm having intrusive thoughts", description: 'Gentle, non-engaging prompts'),
  CurrentState(id: 'need_human', displayName: 'I need human support', description: 'Surface trusted contacts'),
  CurrentState(id: 'in_pain', displayName: "I'm in pain", description: 'Pain-day mode'),
  CurrentState(id: 'exhausted', displayName: "I'm exhausted", description: 'Reduce demands'),
  CurrentState(id: 'sleep_deprived', displayName: "I'm sleep deprived", description: 'Softer expectations'),
  CurrentState(id: 'sick', displayName: "I'm sick", description: 'Recovery focus'),
  CurrentState(id: 'migraine', displayName: 'Migraine mode', description: 'Low stim + rest'),
  CurrentState(id: 'flare', displayName: 'Flare day', description: 'Chronic flare support'),
  CurrentState(id: 'post_seizure', displayName: 'Post-seizure recovery', description: 'Quiet recovery'),
  CurrentState(id: 'grief_day', displayName: 'Grief day', description: 'Gentle language, fewer asks'),
  CurrentState(id: 'relapse_risk', displayName: 'Relapse risk', description: 'Supportive check-ins'),
  CurrentState(id: 'low_energy', displayName: 'Low energy', description: 'Bare minimums emphasised'),
];

class CurrentStateBar extends StatelessWidget {
  const CurrentStateBar({super.key});

  CurrentState? _lookup(String? id) {
    if (id == null) return null;
    try {
      return _allStates.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  Color _barColour(String id) {
    const emotional = {
      'overwhelmed',
      'panicking',
      'triggered',
      'shutdown',
      'dissociating',
      'intrusive_thoughts',
      'need_human',
    };
    const physical = {
      'in_pain',
      'exhausted',
      'migraine',
      'flare',
      'sick',
      'post_seizure',
      'sleep_deprived',
    };
    if (emotional.contains(id)) return BethColours.amber;
    if (physical.contains(id)) return const Color(0xFF8D6E63);
    return BethColours.family;
  }

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<SettingsPrefsProvider>();
    final state = _lookup(prefs.currentStateId);

    if (state == null) {
      return TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CurrentStateSettingsScreen()),
        ),
        child: const Text('Activate temporary state'),
      );
    }

    final colour = _barColour(state.id);
    final timer = prefs.currentStateTimer;
    final until = timer == '2h'
        ? '2 hours'
        : timer == '4h'
            ? '4 hours'
            : timer == 'rest_of_day'
                ? 'rest of day'
                : 'until you turn it off';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colour.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: colour, width: 4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '⚠ ${state.displayName.toUpperCase()} — $until',
            style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w700, color: colour),
          ),
          const SizedBox(height: 4),
          Text(state.description, style: BethTypography.caption),
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () {
                  prefs.setCurrentState(null);
                  context.read<DashboardProvider>().setHeadsDownFromCurrentState(false);
                },
                child: const Text('Deactivate'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CurrentStateSettingsScreen()),
                ),
                child: const Text('Extend'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
