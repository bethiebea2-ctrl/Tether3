import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/mental_health_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class MentalHealthSettingsScreen extends StatefulWidget {
  const MentalHealthSettingsScreen({super.key});

  @override
  State<MentalHealthSettingsScreen> createState() =>
      _MentalHealthSettingsScreenState();
}

class _MentalHealthSettingsScreenState extends State<MentalHealthSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MentalHealthProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final mh = context.watch<MentalHealthProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Mental health toolkit')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Privacy',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Crisis plans, worry logs, and contacts stay on this device. '
              'This toolkit is support-only — it does not diagnose or replace professional care. '
              'In an emergency call 000 or Lifeline 13 11 14.',
              style: BethTypography.bodySmall,
            ),
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: const Text('Hide from dashboard'),
            subtitle: const Text(
              'Keep toolkit entry points quieter on the home glance',
            ),
            value: mh.hideFromDashboard,
            onChanged: mh.setHideFromDashboard,
          ),
        ],
      ),
    );
  }
}
