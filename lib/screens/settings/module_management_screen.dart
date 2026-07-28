import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../models/module_definition.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class ModuleManagementScreen extends StatelessWidget {
  const ModuleManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();
    final modules = registry.manageableModules;

    return Scaffold(
      appBar: AppBar(title: const Text('Module management')),
      body: ListView.builder(
        itemCount: modules.length,
        itemBuilder: (context, index) {
          final module = modules[index];
          final isActive = module.status == ModuleStatus.active;
          final locked = module.id == 'dashboard' || module.id == 'capture_notes';

          return SwitchListTile(
            title: Text(module.title),
            subtitle: Text(
              module.description,
              style: BethTypography.caption,
            ),
            secondary: Text('Phase ${module.phase}', style: BethTypography.caption),
            value: isActive,
            onChanged: locked
                ? null
                : (on) {
                    if (on) {
                      final err = registry.activateModule(module.id);
                      if (err != null && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(err)),
                        );
                      }
                    } else {
                      registry.deactivateModule(module.id);
                    }
                  },
          );
        },
      ),
    );
  }
}
