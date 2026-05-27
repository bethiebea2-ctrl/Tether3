import 'package:flutter/material.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

// ============================================
// FEED CAPTURE MODAL
// ============================================
class FeedCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const FeedCaptureModal({super.key, required this.onLogged});

  @override
  State<FeedCaptureModal> createState() => _FeedCaptureModalState();
}

class _FeedCaptureModalState extends State<FeedCaptureModal> {
  final _amountController = TextEditingController();
  DateTime _timestamp = DateTime.now();

  void _log() {
    final amount = _amountController.text;
    final summary = amount.isNotEmpty
        ? 'Feed — ${_formatTime(_timestamp)} (${amount}oz)'
        : 'Feed — ${_formatTime(_timestamp)}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Log feed for Evander?',
      icon: '🍼',
      label: 'Feed',
      children: [
        _timestampRow(),
        const SizedBox(height: 12),
        _optionalField(
          controller: _amountController,
          hint: 'Amount in oz/ml (optional)',
        ),
      ],
      onConfirm: _log,
    );
  }
}

// ============================================
// MEDICATION CAPTURE MODAL
// ============================================
class MedicationCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const MedicationCaptureModal({super.key, required this.onLogged});

  @override
  State<MedicationCaptureModal> createState() => _MedicationCaptureModalState();
}

class _MedicationCaptureModalState extends State<MedicationCaptureModal> {
  String? _selectedMed;
  DateTime _timestamp = DateTime.now();

  final _medications = [
    'Paracetamol (2.5ml)',
    'Ibuprofen (2.5ml)',
    'Antihistamine (2ml)',
  ];

  void _log() {
    if (_selectedMed == null) return;
    final summary = '$_selectedMed — ${_formatTime(_timestamp)}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Log medication for Evander',
      icon: '💊',
      label: 'Medication',
      children: [
        Text('Which medication?', style: BethTypography.bodySmall),
        const SizedBox(height: 8),
        ..._medications.map((med) => RadioListTile<String>(
              title: Text(med, style: BethTypography.bodySmall),
              value: med,
              groupValue: _selectedMed,
              onChanged: (v) => setState(() => _selectedMed = v),
              activeColor: BethColours.primary,
              contentPadding: EdgeInsets.zero,
              dense: true,
            )),
        _timestampRow(),
      ],
      onConfirm: _selectedMed != null ? _log : null,
    );
  }
}

// ============================================
// NAP CAPTURE MODAL
// ============================================
class NapCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const NapCaptureModal({super.key, required this.onLogged});

  @override
  State<NapCaptureModal> createState() => _NapCaptureModalState();
}

class _NapCaptureModalState extends State<NapCaptureModal> {
  DateTime _timestamp = DateTime.now();

  void _log() {
    final summary = 'Nap — ${_formatTime(_timestamp)}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Log nap for Evander?',
      icon: '😴',
      label: 'Nap',
      children: [_timestampRow()],
      onConfirm: _log,
    );
  }
}

// ============================================
// NAPPY CAPTURE MODAL
// ============================================
class NappyCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const NappyCaptureModal({super.key, required this.onLogged});

  @override
  State<NappyCaptureModal> createState() => _NappyCaptureModalState();
}

class _NappyCaptureModalState extends State<NappyCaptureModal> {
  String? _type;
  DateTime _timestamp = DateTime.now();

  void _log() {
    final typeStr = _type ?? '';
    final summary = typeStr.isNotEmpty
        ? 'Nappy ($typeStr) — ${_formatTime(_timestamp)}'
        : 'Nappy — ${_formatTime(_timestamp)}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Log nappy for Evander?',
      icon: '🧷',
      label: 'Nappy',
      children: [
        _timestampRow(),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _type,
          decoration: _inputDecoration('Type (optional)'),
          items: ['Wet', 'Dirty', 'Both']
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: (v) => setState(() => _type = v),
          style: BethTypography.bodySmall,
        ),
      ],
      onConfirm: _log,
    );
  }
}

// ============================================
// TASK CAPTURE MODAL
// ============================================
class TaskCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const TaskCaptureModal({super.key, required this.onLogged});

  @override
  State<TaskCaptureModal> createState() => _TaskCaptureModalState();
}

class _TaskCaptureModalState extends State<TaskCaptureModal> {
  final _titleController = TextEditingController();
  DateTime? _deadline;
  String _priority = 'Not urgent';

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  void _log() {
    if (!_canSave) return;
    final summary = 'Task: ${_titleController.text.trim()}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Add a task',
      icon: '✅',
      label: 'Task',
      children: [
        TextField(
          controller: _titleController,
          decoration: _inputDecoration('Title'),
          style: BethTypography.bodySmall,
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _deadline == null ? null : 'custom',
          decoration: _inputDecoration('Deadline (optional)'),
          items: ['Today', 'Tomorrow', 'This week', 'Custom date']
              .map((d) => DropdownMenuItem(
                    value: d,
                    child: Text(d, style: BethTypography.bodySmall),
                  ))
              .toList(),
          onChanged: (v) {
            if (v == 'Today') setState(() => _deadline = DateTime.now());
            if (v == 'Tomorrow') setState(() => _deadline = DateTime.now().add(const Duration(days: 1)));
          },
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text('Priority:', style: BethTypography.bodySmall),
            const SizedBox(width: 12),
            ChoiceChip(
              label: const Text('Urgent'),
              selected: _priority == 'Urgent',
              onSelected: (_) => setState(() => _priority = 'Urgent'),
              selectedColor: BethColours.red.withOpacity(0.2),
            ),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Not urgent'),
              selected: _priority == 'Not urgent',
              onSelected: (_) => setState(() => _priority = 'Not urgent'),
              selectedColor: BethColours.green.withOpacity(0.2),
            ),
          ],
        ),
      ],
      onConfirm: _canSave ? _log : null,
    );
  }
}

// ============================================
// NOTE CAPTURE MODAL
// ============================================
class NoteCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const NoteCaptureModal({super.key, required this.onLogged});

  @override
  State<NoteCaptureModal> createState() => _NoteCaptureModalState();
}

class _NoteCaptureModalState extends State<NoteCaptureModal> {
  final _noteController = TextEditingController();
  DateTime _timestamp = DateTime.now();

  bool get _canSave => _noteController.text.trim().isNotEmpty;

  void _log() {
    if (!_canSave) return;
    final preview = _noteController.text.trim();
    final summary = preview.length > 50 ? '${preview.substring(0, 50)}...' : preview;
    widget.onLogged('Note: $summary');
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Write a note',
      icon: '📝',
      label: 'Note',
      children: [
        TextField(
          controller: _noteController,
          decoration: _inputDecoration('Free text'),
          maxLines: 5,
          style: BethTypography.bodySmall,
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
        _timestampRow(),
      ],
      onConfirm: _canSave ? _log : null,
    );
  }
}

// ============================================
// EVENT CAPTURE MODAL
// ============================================
class EventCaptureModal extends StatefulWidget {
  final Function(String) onLogged;
  const EventCaptureModal({super.key, required this.onLogged});

  @override
  State<EventCaptureModal> createState() => _EventCaptureModalState();
}

class _EventCaptureModalState extends State<EventCaptureModal> {
  final _titleController = TextEditingController();
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  String? _category;

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  void _log() {
    if (!_canSave) return;
    final summary = 'Event: ${_titleController.text.trim()}';
    widget.onLogged(summary);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _modalContainer(
      title: 'Add an event',
      icon: '📅',
      label: 'Event',
      children: [
        TextField(
          controller: _titleController,
          decoration: _inputDecoration('Title'),
          style: BethTypography.bodySmall,
          autofocus: false,
          onChanged: (_) => setState(() {}),
        ),
        _timestampRow(),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _category,
          decoration: _inputDecoration('Category (optional)'),
          items: ['Evander', 'Beth', 'Work', 'Family', 'Ant']
              .map((c) => DropdownMenuItem(value: c, child: Text(c, style: BethTypography.bodySmall)))
              .toList(),
          onChanged: (v) => setState(() => _category = v),
        ),
      ],
      onConfirm: _canSave ? _log : null,
    );
  }
}

// ============================================
// SHARED HELPERS
// ============================================

Widget _modalContainer({
  required String title,
  required String icon,
  required String label,
  required List<Widget> children,
  required VoidCallback? onConfirm,
}) {
  return Builder(
    builder: (context) {
      return Container(
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
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: BethColours.textMuted.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(title, style: BethTypography.subheading),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(icon, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(label, style: BethTypography.body?.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 20),
            ...children,
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
                  onPressed: onConfirm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: onConfirm != null ? BethColours.primary : BethColours.textMuted,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Text('Log $label', style: BethTypography.button?.copyWith(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _timestampRow() {
  return Row(
    children: [
      const Icon(Icons.access_time, size: 16, color: BethColours.textMuted),
      const SizedBox(width: 8),
      Text(
        _formatTime(DateTime.now()),
        style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
      ),
    ],
  );
}

InputDecoration _inputDecoration(String hint) {
  return InputDecoration(
    hintText: hint,
    hintStyle: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
    filled: true,
    fillColor: BethColours.surfaceAlt,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide.none,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
  );
}

Widget _optionalField({required TextEditingController controller, required String hint}) {
  return TextField(
    controller: controller,
    decoration: _inputDecoration(hint),
    style: BethTypography.bodySmall,
  );
}

String _formatTime(DateTime dt) {
  final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
  final amPm = dt.hour >= 12 ? 'pm' : 'am';
  return '$hour:${dt.minute.toString().padLeft(2, '0')} $amPm';
}