import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';

class TeamConfigurationSettingsScreen extends StatefulWidget {
  const TeamConfigurationSettingsScreen({super.key});

  @override
  State<TeamConfigurationSettingsScreen> createState() =>
      _TeamConfigurationSettingsScreenState();
}

class _TeamConfigurationSettingsScreenState
    extends State<TeamConfigurationSettingsScreen> {
  final Set<String> _hidden = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hidden
        ..clear()
        ..addAll(prefs.getStringList('team_hidden_instances') ?? const []);
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('team_hidden_instances', _hidden.toList());
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Team configuration saved.')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final instances = InstanceRegistry.instances;
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: const Text('Team configuration'),
        actions: [
          TextButton(onPressed: _loaded ? _save : null, child: const Text('Save')),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Phase 1B: show or hide instances on the Team grid. '
                  'Personalisation lands in Phase 2A.',
                  style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                ),
                const SizedBox(height: 12),
                ...instances.map((i) {
                  final id = i['id'] as String;
                  final hidden = _hidden.contains(id);
                  return SwitchListTile(
                    title: Text(i['name'] as String? ?? id),
                    subtitle: Text(
                      '${i['domain'] ?? ''} · ${i['status'] ?? ''}',
                      style: BethTypography.caption,
                    ),
                    value: !hidden,
                    onChanged: (v) {
                      setState(() {
                        if (v) {
                          _hidden.remove(id);
                        } else {
                          _hidden.add(id);
                        }
                      });
                    },
                  );
                }),
              ],
            ),
    );
  }
}
