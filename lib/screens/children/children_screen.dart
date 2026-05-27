import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class ChildrenScreen extends StatefulWidget {
  const ChildrenScreen({super.key});

  @override
  State<ChildrenScreen> createState() => _ChildrenScreenState();
}

class _ChildrenScreenState extends State<ChildrenScreen> {
  final Map<String, Map<String, dynamic>> _medications = {
    'Paracetamol': {
      'dose': '2.5ml',
      'lastGiven': null,
      'intervalHours': 4,
      'status': 'available',
    },
    'Ibuprofen': {
      'dose': '2.5ml',
      'lastGiven': null,
      'intervalHours': 6,
      'status': 'available',
    },
    'Antihistamine': {
      'dose': '2ml',
      'lastGiven': DateTime.now().subtract(const Duration(hours: 2)),
      'intervalHours': 8,
      'status': 'waiting',
    },
  };

  final List<Map<String, String>> _activityLog = [];

  Color _getMedColour(String status) {
    switch (status) {
      case 'available':
        return BethColours.green;
      case 'within_1_hour':
        return BethColours.amber;
      case 'waiting':
        return BethColours.red;
      default:
        return BethColours.textMuted;
    }
  }

  String _getMedLabel(String status) {
    switch (status) {
      case 'available':
        return 'Available';
      case 'within_1_hour':
        return 'Soon';
      case 'waiting':
        return 'Wait';
      default:
        return status;
    }
  }

  void _logActivity(String type, String detail) {
    final now = DateTime.now();
    final time = '${now.hour}:${now.minute.toString().padLeft(2, '0')}${now.hour >= 12 ? 'pm' : 'am'}';
    setState(() {
      _activityLog.insert(0, {
        'type': type,
        'detail': detail,
        'time': time,
        'icon': _iconForType(type),
      });
      if (_activityLog.length > 15) _activityLog.removeLast();
    });
  }

  String _iconForType(String type) {
    switch (type) {
      case 'feed': return '🍼';
      case 'medication': return '💊';
      case 'nap': return '😴';
      case 'nappy': return '🧷';
      default: return '📌';
    }
  }

  void _logMedication(String name, Map<String, dynamic> med) {
    final now = DateTime.now();
    setState(() {
      med['lastGiven'] = now;
      med['status'] = 'waiting';
    });
    _logActivity('medication', '$name — ${med['dose']} given');
  }

  void _showQuickLog(String type, String title, String icon) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                  color: BethColours.textMuted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 8),
              Text('Log $title for Evander?', style: BethTypography.subheading),
            ]),
            const SizedBox(height: 12),
            Text(
              '🕐 ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}${DateTime.now().hour >= 12 ? 'pm' : 'am'}',
              style: BethTypography.bodySmall,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted)),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    _logActivity(type, '$title logged');
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: BethColours.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text('Log $title'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('Evander', style: BethTypography.heading),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: BethColours.evander.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text('5 months', style: BethTypography.caption),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Medication card
            Text('Medications', style: BethTypography.subheading),
            const SizedBox(height: 8),
            ..._medications.entries.map((entry) {
              final name = entry.key;
              final med = entry.value;
              final colour = _getMedColour(med['status']);
              final label = _getMedLabel(med['status']);
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: BethColours.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border(left: BorderSide(color: colour, width: 3)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                          Text(med['dose'], style: BethTypography.caption),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colour.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(label, style: TextStyle(color: colour, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _logMedication(name, med),
                      icon: const Icon(Icons.check_circle_outline, color: BethColours.green, size: 28),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),

            // Quick log buttons
            Text('Quick Log', style: BethTypography.subheading),
            const SizedBox(height: 8),
            Row(
              children: [
                _quickButton('Feed', '🍼', 'feed'),
                const SizedBox(width: 8),
                _quickButton('Nap', '😴', 'nap'),
                const SizedBox(width: 8),
                _quickButton('Nappy', '🧷', 'nappy'),
              ],
            ),
            const SizedBox(height: 24),

            // Activity feed
            Text('Recent Activity', style: BethTypography.subheading),
            const SizedBox(height: 8),
            if (_activityLog.isEmpty)
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: BethColours.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: Text('No activity yet today', style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted)),
                ),
              )
            else
              ..._activityLog.take(5).map((entry) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: BethColours.surface,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Text(entry['icon']!, style: const TextStyle(fontSize: 18)),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(entry['detail']!, style: BethTypography.bodySmall),
                        ),
                        Text(entry['time']!, style: BethTypography.caption),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _quickButton(String label, String icon, String type) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _showQuickLog(type, label, icon),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: BethColours.surface,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4, offset: const Offset(0, 2))],
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(label, style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}