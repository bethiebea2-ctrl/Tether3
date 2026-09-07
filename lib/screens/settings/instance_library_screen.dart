import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/instance_library_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class InstanceLibraryScreen extends StatelessWidget {
  const InstanceLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final library = context.watch<InstanceLibraryProvider>();
    final templates = library.availableTemplates;
    final active = library.activeInstances;

    return Scaffold(
      appBar: AppBar(title: const Text('Instance library')),
      body: !library.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  'Active: ${active.length} · Min ${InstanceLibraryProvider.minInstances} · '
                  'Max ${InstanceLibraryProvider.maxInstances}',
                  style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                ),
                const SizedBox(height: 12),
                Text('Active team', style: BethTypography.subheading),
                ...active.map((i) => _InstanceTile(instance: i, active: true, library: library)),
                const Divider(height: 32),
                Text('Templates', style: BethTypography.subheading),
                ...templates.where((i) => !library.isActive(i['id'] as String)).map(
                      (i) => _InstanceTile(instance: i, active: false, library: library),
                    ),
              ],
            ),
    );
  }
}

class _InstanceTile extends StatelessWidget {
  const _InstanceTile({
    required this.instance,
    required this.active,
    required this.library,
  });

  final Map<String, dynamic> instance;
  final bool active;
  final InstanceLibraryProvider library;

  @override
  Widget build(BuildContext context) {
    final id = instance['id'] as String;
    return ListTile(
      leading: CircleAvatar(child: Text((instance['name'] as String)[0])),
      title: Text(instance['name'] as String),
      subtitle: Text(instance['domain'] as String? ?? ''),
      trailing: active
          ? IconButton(
              icon: const Icon(Icons.remove_circle_outline),
              onPressed: () async {
                final err = await library.toggleInstance(id, false);
                if (err != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                }
              },
            )
          : IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () async {
                final err = await library.toggleInstance(id, true);
                if (err != null && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
                }
              },
            ),
    );
  }
}
