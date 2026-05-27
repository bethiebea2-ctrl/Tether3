import 'package:flutter/material.dart';
import '../theme/typography.dart';
import '../theme/colours.dart';

class ChildrenSummaryCard extends StatelessWidget {
  const ChildrenSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Children', style: BethTypography.subheading),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _childStatus('Evander', BethColours.green),
              _childStatus('Theo', BethColours.green),
              _childStatus('Bella', BethColours.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _childStatus(String name, Color colour) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: colour.withOpacity(0.15), shape: BoxShape.circle),
          child: Center(child: Text(name[0], style: TextStyle(color: colour, fontSize: 20, fontWeight: FontWeight.w600))),
        ),
        const SizedBox(height: 4),
        Text(name, style: BethTypography.bodySmall),
      ],
    );
  }
}