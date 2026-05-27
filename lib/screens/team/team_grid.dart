import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';
import 'instance_chat.dart';

class TeamGrid extends StatelessWidget {
  const TeamGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Team'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined),
            onPressed: () {
              // TODO: Team feed
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 0.75,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: InstanceRegistry.instances.length,
          itemBuilder: (context, index) {
            final instance = InstanceRegistry.instances[index];
            return _InstanceCard(instance: instance);
          },
        ),
      ),
    );
  }
}

class _InstanceCard extends StatelessWidget {
  final Map<String, dynamic> instance;
  const _InstanceCard({required this.instance});

  @override
  Widget build(BuildContext context) {
    final isActive = instance['status'] == 'active';
    final colour = isActive ? BethColours.instanceActive : BethColours.instancePending;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InstanceChat(
              instanceId: instance['id'],
              instanceName: instance['name'],
              domain: instance['domain'],
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colour.withOpacity(0.3)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: colour.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  instance['name'][0],
                  style: TextStyle(
                    color: colour,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              instance['name'],
              style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              instance['domain'],
              style: BethTypography.caption?.copyWith(fontSize: 10),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colour.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                isActive ? 'Active' : 'Setup',
                style: TextStyle(
                  color: colour,
                  fontSize: 9,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}