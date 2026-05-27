import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/capture_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import 'capture_modals.dart';

class CaptureScreen extends StatefulWidget {
  const CaptureScreen({super.key});

  @override
  State<CaptureScreen> createState() => _CaptureScreenState();
}

class _CaptureScreenState extends State<CaptureScreen> {
  bool _isListening = false;

  void _logAndClose(BuildContext context, String type, String summary) {
    Provider.of<CaptureProvider>(context, listen: false).addRecentItem(
      type: type,
      summary: summary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BethColours.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Capture', style: BethTypography.heading),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: BethColours.textMuted),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'What do you want to log?',
                    style: BethTypography.body?.copyWith(
                      color: BethColours.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return _buildCaptureButton(context, index);
                    },
                  ),
                  const SizedBox(height: 24),

                  const Divider(color: BethColours.textMuted),
                  const SizedBox(height: 16),

                  _buildVoiceInput(),
                  const SizedBox(height: 24),

                  _buildRecentItems(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCaptureButton(BuildContext context, int index) {
    final buttons = [
      {'icon': '🍼', 'label': 'Feed', 'type': 'feed'},
      {'icon': '💊', 'label': 'Meds', 'type': 'medication'},
      {'icon': '😴', 'label': 'Nap', 'type': 'nap'},
      {'icon': '🧷', 'label': 'Nappy', 'type': 'nappy'},
      {'icon': '✅', 'label': 'Task', 'type': 'task'},
      {'icon': '📝', 'label': 'Note', 'type': 'note'},
      {'icon': '📅', 'label': 'Event', 'type': 'event'},
    ];

    final button = buttons[index];
    return GestureDetector(
      onTap: () => _showCaptureModal(context, button['type']!, button['label']!),
      child: Container(
        decoration: BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(button['icon']!, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              button['label']!,
              style: BethTypography.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: BethColours.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceInput() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Voice input will be available when phone is connected.'),
            backgroundColor: BethColours.primary,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: BethColours.primary.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              size: 32,
              color: _isListening ? BethColours.primary : BethColours.textMuted,
            ),
            const SizedBox(height: 12),
            Text(
              'Tap mic to speak freely',
              style: BethTypography.bodySmall?.copyWith(
                color: BethColours.textMuted,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '"Evander had a feed, and I need to book..."',
              style: BethTypography.caption?.copyWith(
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentItems(BuildContext context) {
    final recentItems = Provider.of<CaptureProvider>(context).recentItems;

    if (recentItems.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent',
          style: BethTypography.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: BethColours.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        ...recentItems.map((item) => _buildRecentItem(context, item)),
      ],
    );
  }

  Widget _buildRecentItem(BuildContext context, Map<String, dynamic> item) {
    final now = DateTime.now();
    final timestamp = '${now.hour}:${now.minute.toString().padLeft(2, '0')}${now.hour >= 12 ? 'pm' : 'am'}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      margin: const EdgeInsets.only(bottom: 4),
      decoration: BoxDecoration(
        color: BethColours.surface,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(item['icon'] ?? '', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '${item['label']} — $timestamp',
              style: BethTypography.bodySmall,
            ),
          ),
          GestureDetector(
            onTap: () {
              Provider.of<CaptureProvider>(context, listen: false)
                  .undoItem(item['id']);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${item['label']} undone.'),
                  backgroundColor: BethColours.textMuted,
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Text(
              '↩ Undo',
              style: BethTypography.caption?.copyWith(
                color: BethColours.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCaptureModal(BuildContext context, String type, String label) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        switch (type) {
          case 'feed':
            return FeedCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'feed', summary),
            );
          case 'medication':
            return MedicationCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'medication', summary),
            );
          case 'nap':
            return NapCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'nap', summary),
            );
          case 'nappy':
            return NappyCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'nappy', summary),
            );
          case 'task':
            return TaskCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'task', summary),
            );
          case 'note':
            return NoteCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'note', summary),
            );
          case 'event':
            return EventCaptureModal(
              onLogged: (summary) => _logAndClose(context, 'event', summary),
            );
          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}