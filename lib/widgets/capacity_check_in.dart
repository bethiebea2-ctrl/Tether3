import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';

class CapacityCheckIn extends StatelessWidget {
  const CapacityCheckIn({super.key});

  @override
  Widget build(BuildContext context) {
    final dash = context.watch<DashboardProvider>();
    final value = dash.capacity;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "⚡ How's your energy?  ${value.round()}%",
          style: BethTypography.caption?.copyWith(color: BethColours.textSecondary),
        ),
        Slider(
          value: value,
          min: 0,
          max: 100,
          divisions: 20,
          activeColor: BethColours.primary,
          onChanged: (v) => context.read<DashboardProvider>().setCapacity(v),
        ),
        Wrap(
          spacing: 8,
          children: [
            _chip(context, '25% · Low', 25),
            _chip(context, '50% · Okay', 50),
            _chip(context, '75% · Good', 75),
            _chip(context, '100% · Full', 100),
          ],
        ),
      ],
    );
  }

  Widget _chip(BuildContext context, String label, double value) {
    final selected = context.watch<DashboardProvider>().capacity.round() == value.round();
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 11)),
      selected: selected,
      onSelected: (_) => context.read<DashboardProvider>().setCapacity(value),
    );
  }
}
