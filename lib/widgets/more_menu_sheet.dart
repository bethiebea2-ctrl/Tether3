import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/module_registry_provider.dart';
import '../theme/colours.dart';
import '../theme/typography.dart';
import '../screens/settings/settings_screen.dart';

class MoreMenuSheet extends StatelessWidget {
  const MoreMenuSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final inactive = context.watch<ModuleRegistryProvider>().inactiveModules;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.85;

    return Container(
      constraints: BoxConstraints(maxHeight: maxHeight),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: BethColours.textMuted.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('More', style: BethTypography.subheading),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.pop(context);
                    openSettings(context);
                  },
                ),
                if (inactive.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text('Inactive modules', style: BethTypography.caption),
                  ...inactive.map(
                    (m) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(m.title),
                      subtitle: Text(m.description, style: BethTypography.caption),
                      trailing: TextButton(
                        onPressed: () {
                          final err = context.read<ModuleRegistryProvider>().activateModule(m.id);
                          if (err != null) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                          } else {
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Turn on'),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
