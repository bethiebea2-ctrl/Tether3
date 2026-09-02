import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _source = prefs.getString('affirmations_source') ?? 'built_in';
      _frequency = prefs.getString('affirmations_frequency') ?? 'daily';
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('affirmations_source', _source);
    await prefs.setString('affirmations_frequency', _frequency);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Affirmation preferences saved.')),
    );
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
              ],
            ),
    );
  }
}
