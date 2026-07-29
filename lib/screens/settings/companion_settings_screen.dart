import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/companion_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';

class CompanionSettingsScreen extends StatefulWidget {
  const CompanionSettingsScreen({super.key});

  @override
  State<CompanionSettingsScreen> createState() => _CompanionSettingsScreenState();
}

class _CompanionSettingsScreenState extends State<CompanionSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CompanionProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final companion = context.watch<CompanionProvider>();
    final activeInstances = InstanceRegistry.instances
        .where((i) => i['status'] == 'active')
        .toList();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Companion settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Companion instance', style: BethTypography.caption),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: activeInstances.any((i) => i['id'] == companion.instanceId)
                ? companion.instanceId
                : 'viva',
            decoration: const InputDecoration(
              filled: true,
              border: OutlineInputBorder(),
            ),
            items: activeInstances
                .map(
                  (i) => DropdownMenuItem(
                    value: i['id'] as String,
                    child: Text('${i['name']} · ${i['domain']}'),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) companion.setInstanceId(v);
            },
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Speak replies (TTS)'),
            subtitle: const Text('Companion speaks responses aloud'),
            value: companion.ttsEnabled,
            onChanged: companion.setTtsEnabled,
          ),
          const Divider(height: 32),
          Text('Coming in Phase 2A', style: BethTypography.caption),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Ambient presence'),
            subtitle: const Text('Small corner companion when not chatting'),
            value: false,
            onChanged: null,
          ),
          SwitchListTile(
            title: const Text('Wake word (“Hey Tether”)'),
            subtitle: const Text('Voice activation from anywhere'),
            value: false,
            onChanged: null,
          ),
          SwitchListTile(
            title: const Text('Interactive life system'),
            subtitle: const Text('Atmospheric reading / reflecting moments'),
            value: false,
            onChanged: null,
          ),
          const SizedBox(height: 16),
          Text(
            '1C companion knows today\'s calendar and tasks. Health, budget, and family tools arrive in Phase 2A.',
            style: BethTypography.caption.copyWith(color: BethColours.textMuted),
          ),
        ],
      ),
    );
  }
}
