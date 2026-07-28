import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../models/module_definition.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class ModuleManagementScreen extends StatelessWidget {
  const ModuleManagementScreen({super.key});

  static const int maxBottomNav = 8;

  @override
  Widget build(BuildContext context) {
    final registry = context.watch<ModuleRegistryProvider>();
    final modules = registry.manageableModules;
    final activeCount = registry.activeModules.length;
    final registeredCount = modules.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Module management')),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              'Active modules appear in your bottom nav and dashboard.\n'
              'Active: $activeCount · Registered: $registeredCount',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
          ...modules.map((module) {
            final isActive = module.status == ModuleStatus.active;
            final locked = module.id == 'dashboard' || module.id == 'capture_notes';

            return SwitchListTile(
              title: Text(module.title),
              subtitle: Text(
                locked
                    ? '${module.description} (required)'
                    : module.description,
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
          }),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Modules marked (required) cannot be disabled.\n\n'
              'Maximum $maxBottomNav active modules for bottom nav. '
              'Additional active modules appear in More (⋯). '
              'Inactive modules stay hidden but their data is preserved.',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ),
        ],
      ),
    );
  }
}
