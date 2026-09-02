import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/colour_mood.dart';
import '../providers/dashboard_provider.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';

class ColourCard extends StatelessWidget {
  const ColourCard({super.key});

  @override
  Widget build(BuildContext context) {
    final mood = context.watch<DashboardProvider>().mood;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _openSelector(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: BethColours.primary.withOpacity(0.15)),
              ),
              child: Row(
                children: [
                  Text(mood.emoji, style: const TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${mood.label} · ${mood.meaning}',
                      style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: BethColours.textMuted),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Visible to: Household',
          style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
        ),
      ],
    );
  }

  Future<void> _openSelector(BuildContext context) async {
    final selected = await showModalBottomSheet<ColourMood>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _ColourSelectorSheet(),
    );
    if (selected != null && context.mounted) {
      await context.read<DashboardProvider>().setMood(selected);
    }
  }
}

class _ColourSelectorSheet extends StatelessWidget {
  const _ColourSelectorSheet();

  @override
  Widget build(BuildContext context) {
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          constraints: BoxConstraints(maxHeight: maxHeight),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          decoration: BoxDecoration(
            color: BethColours.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Select mood', style: BethTypography.subheading),
              const SizedBox(height: 4),
              Text('How are you right now?', style: BethTypography.caption),
              const SizedBox(height: 16),
              Flexible(
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: 2.1,
                  children: ColourMood.values
                      .map(
                        (m) => InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () => Navigator.pop(context, m),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: BethColours.surfaceAlt,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${m.emoji} ${m.label}',
                                  style: BethTypography.bodySmall.copyWith(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  m.meaning,
                                  style: BethTypography.caption,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ],
          ),
        ),
      ),
    );
  }
}

