import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../../core/affirmations/user_affirmations_store.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class AffirmationsSettingsScreen extends StatefulWidget {
  const AffirmationsSettingsScreen({super.key});

  @override
  State<AffirmationsSettingsScreen> createState() =>
      _AffirmationsSettingsScreenState();
}

class _AffirmationsSettingsScreenState extends State<AffirmationsSettingsScreen> {
  String _source = 'built_in';
  String _frequency = 'daily';
  List<String> _custom = [];
  bool _loaded = false;
  final _newAffirmation = TextEditingController();

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _newAffirmation.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final custom = await UserAffirmationsStore.load();
    setState(() {
      _source = prefs.getString('affirmations_source') ?? 'built_in';
      _frequency = prefs.getString('affirmations_frequency') ?? 'daily';
      _custom = custom;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('affirmations_source', _source);
    await prefs.setString('affirmations_frequency', _frequency);
    await UserAffirmationsStore.save(_custom);
    if (!mounted) return;
    await context.read<DashboardProvider>().reloadAffirmationPrefs();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affirmation preferences saved.')),
    );
  }

  Future<void> _addCustom() async {
    final text = _newAffirmation.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _custom = [..._custom, text];
      _newAffirmation.clear();
    });
    await UserAffirmationsStore.save(_custom);
    if (!mounted) return;
    await context.read<DashboardProvider>().reloadAffirmationPrefs();
  }

  Future<void> _removeCustom(int index) async {
    setState(() => _custom = [..._custom]..removeAt(index));
    await UserAffirmationsStore.save(_custom);
    if (!mounted) return;
    await context.read<DashboardProvider>().reloadAffirmationPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: const Text('Affirmations'),
        actions: [
          TextButton(onPressed: _loaded ? _save : null, child: const Text('Save')),
        ],
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Source', style: BethTypography.caption),
                RadioListTile<String>(
                  title: const Text('Built-in library'),
                  value: 'built_in',
                  groupValue: _source,
                  onChanged: (v) => setState(() => _source = v!),
                ),
                RadioListTile<String>(
                  title: const Text('Marlowe curated'),
                  value: 'marlowe',
                  groupValue: _source,
                  onChanged: (v) => setState(() => _source = v!),
                ),
                RadioListTile<String>(
                  title: const Text('My affirmations'),
                  subtitle: Text(
                    _custom.isEmpty
                        ? 'Add your own below — falls back to built-in if empty'
                        : '${_custom.length} saved',
                    style: BethTypography.caption,
                  ),
                  value: 'custom',
                  groupValue: _source,
                  onChanged: (v) => setState(() => _source = v!),
                ),
                const SizedBox(height: 12),
                Text('Frequency', style: BethTypography.caption),
                RadioListTile<String>(
                  title: const Text('Daily'),
                  value: 'daily',
                  groupValue: _frequency,
                  onChanged: (v) => setState(() => _frequency = v!),
                ),
                RadioListTile<String>(
                  title: const Text('On open'),
                  value: 'on_open',
                  groupValue: _frequency,
                  onChanged: (v) => setState(() => _frequency = v!),
                ),
                RadioListTile<String>(
                  title: const Text('Off'),
                  value: 'off',
                  groupValue: _frequency,
                  onChanged: (v) => setState(() => _frequency = v!),
                ),
                const Divider(height: 32),
                Text('My affirmations', style: BethTypography.subheading),
                const SizedBox(height: 4),
                Text(
                  'Your words rotate on the dashboard when source is set to My affirmations.',
                  style: BethTypography.caption,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _newAffirmation,
                        decoration: const InputDecoration(
                          labelText: 'Add affirmation',
                          hintText: 'Write something that lands for you',
                        ),
                        onSubmitted: (_) => _addCustom(),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Add',
                      onPressed: _addCustom,
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                if (_custom.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'No custom affirmations yet.',
                      style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
                    ),
                  )
                else
                  ...List.generate(_custom.length, (i) {
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        title: Text(_custom[i]),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => _removeCustom(i),
                        ),
                      ),
                    );
                  }),
              ],
            ),
    );
  }
}
