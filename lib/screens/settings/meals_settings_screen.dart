import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/meals_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class MealsSettingsScreen extends StatefulWidget {
  const MealsSettingsScreen({super.key});

  @override
  State<MealsSettingsScreen> createState() => _MealsSettingsScreenState();
}

class _MealsSettingsScreenState extends State<MealsSettingsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Meals preferences')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Text(
              'Defaults',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          ListTile(
            title: const Text('Default servings'),
            trailing: DropdownButton<int>(
              value: meals.defaultServings.clamp(1, 12),
              items: List.generate(
                12,
                (i) => DropdownMenuItem(
                  value: i + 1,
                  child: Text('${i + 1}'),
                ),
              ),
              onChanged: (v) {
                if (v != null) meals.setDefaultServings(v);
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Meals focuses on feeding your household — not dieting, calorie '
              'counting, or body goals. Language stays practical and kind.',
              style: BethTypography.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}
