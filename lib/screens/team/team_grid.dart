import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';
import 'instance_chat.dart';

class TeamGrid extends StatefulWidget {
  const TeamGrid({super.key});

  @override
  State<TeamGrid> createState() => _TeamGridState();
}

class _TeamGridState extends State<TeamGrid> {
  Set<String> _hidden = {};
  Set<String> _seenIntro = {};
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _hidden = {...(prefs.getStringList('team_hidden_instances') ?? const [])};
      _seenIntro = {...(prefs.getStringList('team_seen_intros') ?? const [])};
      _loaded = true;
    });
  }

  String _statusLabel(Map<String, dynamic> instance) {
    final status = instance['status'] as String? ?? 'pending';
    if (status == 'active') return 'Active';
    if (status == 'monitoring') return 'Monitoring';
    if ((instance['draft_ready'] as bool?) == true) return 'Draft ready';
    return 'Setup';
  }

  Color _statusColour(String label) {
    switch (label) {
      case 'Active':
        return BethColours.instanceActive;
      case 'Monitoring':
        return BethColours.amber;
      case 'Draft ready':
        return BethColours.primary;
      default:
        return BethColours.instancePending;
    }
  }

  Future<void> _openInstance(Map<String, dynamic> instance) async {
    final id = instance['id'] as String;
    if (!_seenIntro.contains(id)) {
      final continueChat = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Meet ${instance['name']}'),
          content: Text(
            '${instance['name']} is your ${instance['domain']}.\n\n'
            '${instance['primary_functions'] ?? 'Ready when you are.'}',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Later')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Say hello')),
          ],
        ),
      );
      final prefs = await SharedPreferences.getInstance();
      _seenIntro.add(id);
      await prefs.setStringList('team_seen_intros', _seenIntro.toList());
      if (continueChat != true || !mounted) return;
    }

    if (!mounted) return;
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
  }

  @override
  Widget build(BuildContext context) {
    final visible = InstanceRegistry.instances
        .where((i) => !_hidden.contains(i['id']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Team'),
      ),
      body: !_loaded
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.95,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final instance = visible[index];
                  final label = _statusLabel(instance);
                  final colour = _statusColour(label);
                  return GestureDetector(
                    onTap: () => _openInstance(instance),
                    child: Container(
                      decoration: BoxDecoration(
                        color: BethColours.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: colour.withOpacity(0.3)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: colour.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                (instance['name'] as String)[0],
                                style: TextStyle(
                                  color: colour,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            instance['name'] as String,
                            style: BethTypography.caption?.copyWith(
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            instance['domain'] as String,
                            style: BethTypography.caption?.copyWith(fontSize: 9),
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: colour.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                color: colour,
                                fontSize: 8,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
