import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class EventCreation extends StatefulWidget {
  const EventCreation({super.key});

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  final _titleController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String? _selectedCategoryId;
  String? _selectedEmoji;

  final List<Map<String, String>> _emojiOptions = [
    {'emoji': '👶', 'label': 'Baby'},
    {'emoji': '💼', 'label': 'Work'},
    {'emoji': '🎉', 'label': 'Party'},
    {'emoji': '🏥', 'label': 'Health'},
    {'emoji': '📚', 'label': 'Study'},
    {'emoji': '✈️', 'label': 'Travel'},
    {'emoji': '🍽️', 'label': 'Dinner'},
    {'emoji': '❤️', 'label': 'Date'},
  ];

  bool get _canSave => _titleController.text.trim().isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime({bool isStart = true}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startTime = picked;
        else _endTime = picked;
      });
    }
  }

  void _save() {
    if (!_canSave) return;

    final provider = Provider.of<CalendarProvider>(context, listen: false);
    final date = _selectedDate;

    DateTime? endDateTime;
    if (!_hasEndTime && _startTime != null) {
      // Single start time, no end time = not all-day
    }
    if (_endTime != null) {
      endDateTime = DateTime(date.year, date.month, date.day, _endTime!.hour, _endTime!.minute);
    }

    final startDateTime = _startTime != null
        ? DateTime(date.year, date.month, date.day, _startTime!.hour, _startTime!.minute)
        : date;

    provider.addEvent(
      title: _titleController.text.trim(),
      date: startDateTime,
      endTime: endDateTime,
      categoryId: _selectedCategoryId,
      emoji: _selectedEmoji,
      location: _locationController.text.trim().isNotEmpty ? _locationController.text.trim() : null,
      description: _descriptionController.text.trim().isNotEmpty ? _descriptionController.text.trim() : null,
    );

    Navigator.pop(context);
  }

  bool get _hasEndTime => _endTime != null;

  @override
  Widget build(BuildContext context) {
    final categories = Provider.of<CalendarProvider>(context).categories;

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: BethColours.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('New Event', style: BethTypography.heading),
        actions: [
          TextButton(
            onPressed: _canSave ? _save : null,
            child: Text('Save', style: BethTypography.button?.copyWith(
              color: _canSave ? BethColours.primary : BethColours.textMuted,
            )),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: _inputDecoration('Event title'),
              style: BethTypography.body,
              autofocus: true,
            ),
            const SizedBox(height: 20),

            // Date
            _optionRow(
              icon: Icons.calendar_today,
              label: 'Date',
              value: _formatDate(_selectedDate),
              onTap: _pickDate,
            ),
            const SizedBox(height: 12),

            // Start time
            _optionRow(
              icon: Icons.access_time,
              label: 'Start time',
              value: _startTime != null ? _startTime!.format(context) : 'None',
              onTap: () => _pickTime(isStart: true),
            ),
            const SizedBox(height: 12),

            // End time
            _optionRow(
              icon: Icons.access_time,
              label: 'End time',
              value: _endTime != null ? _endTime!.format(context) : 'None',
              onTap: () => _pickTime(isStart: false),
            ),
            const SizedBox(height: 20),

            // Category
            Text('Category', style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final selected = _selectedCategoryId == cat['id'];
                final colour = Color(int.parse('FF${(cat['colour'] as String).replaceAll('#', '')}', radix: 16));
                return ChoiceChip(
                  label: Text(cat['name'] as String, style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  onSelected: (_) => setState(() => _selectedCategoryId = selected ? null : cat['id'] as String),
                  selectedColor: colour.withOpacity(0.2),
                  backgroundColor: BethColours.surface,
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Emoji
            Text('Emoji (optional)', style: BethTypography.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojiOptions.map((e) {
                final selected = _selectedEmoji == e['emoji'];
                return GestureDetector(
                  onTap: () => setState(() => _selectedEmoji = selected ? null : e['emoji']),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected ? BethColours.primary.withOpacity(0.2) : BethColours.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: selected ? Border.all(color: BethColours.primary) : null,
                    ),
                    child: Text(e['emoji']!, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Location
            TextField(
              controller: _locationController,
              decoration: _inputDecoration('Location (optional)'),
              style: BethTypography.bodySmall,
            ),
            const SizedBox(height: 16),

            // Description / Notes
            TextField(
              controller: _descriptionController,
              decoration: _inputDecoration('Notes (optional)'),
              style: BethTypography.bodySmall,
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionRow({required IconData icon, required String label, required String value, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: BethColours.surface,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: BethColours.textMuted),
            const SizedBox(width: 10),
            Text(label, style: BethTypography.bodySmall),
            const Spacer(),
            Text(value, style: BethTypography.bodySmall?.copyWith(color: BethColours.primary)),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
      filled: true,
      fillColor: BethColours.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year && date.month == now.month && date.day == now.day) return 'Today';
    if (date.year == now.year && date.month == now.month && date.day == now.day + 1) return 'Tomorrow';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }
}