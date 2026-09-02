import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/family_hub_provider.dart';
import '../providers/module_registry_provider.dart';
import '../services/family_hub_urgency_service.dart';
import '../screens/family_hub/family_hub_screen.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';

class FamilyHubSummaryCard extends StatefulWidget {
  const FamilyHubSummaryCard({super.key});

  @override
  State<FamilyHubSummaryCard> createState() => _FamilyHubSummaryCardState();
}

class _FamilyHubSummaryCardState extends State<FamilyHubSummaryCard> {
  final _urgency = FamilyHubUrgencyService();
  List<PersonUrgentLine>? _lines;
  bool _expanded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final hub = context.read<FamilyHubProvider>();
      if (hub.isLoaded) await hub.refreshFromDatabase();
      _refreshUrgency();
    });
  }

  Future<void> _refreshUrgency() async {
    final hub = context.read<FamilyHubProvider>();
    if (!hub.isLoaded) return;
    final lines = await _urgency.urgentLinesForPeople(
      hub.children.isNotEmpty ? hub.children : hub.people,
    );
    if (mounted) setState(() => _lines = lines);
  }

  @override
  Widget build(BuildContext context) {
    if (!context.watch<ModuleRegistryProvider>().isModuleActive('family_hub')) {
      return const SizedBox.shrink();
    }

    final hub = context.watch<FamilyHubProvider>();
    if (!hub.isLoaded) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: BethColours.primary.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            const Icon(Icons.family_restroom, color: BethColours.primary, size: 20),
            const SizedBox(width: 8),
            Text('Loading family…', style: BethTypography.bodySmall),
          ],
        ),
      );
    }

    final lines = _lines ?? [];
    final visible = _expanded ? lines : lines.take(3).toList();

    return Material(
      color: BethColours.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FamilyHubScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: BethColours.primary.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.family_restroom, color: BethColours.primary, size: 20),
                  const SizedBox(width: 8),
                  Text('Family', style: BethTypography.subheading),
                  const Spacer(),
                  const Icon(Icons.chevron_right, color: BethColours.textMuted),
                ],
              ),
              const SizedBox(height: 8),
              if (lines.isNotEmpty) ...[
                ...visible.map(
                  (l) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(l.line, style: BethTypography.bodySmall),
                  ),
                ),
                if (lines.length > 3)
                  TextButton(
                    onPressed: () => setState(() => _expanded = !_expanded),
                    child: Text(_expanded ? 'Show less' : '+${lines.length - 3} more'),
                  ),
              ] else if (hub.people.isEmpty)
                Text(
                  'Add your family. Get started in Family Hub.',
                  style: BethTypography.bodySmall,
                )
              else
                Text(
                  hub.people.take(4).map((p) => p.displayName).join(', '),
                  style: BethTypography.bodySmall,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
