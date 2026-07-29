import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../models/calendar_event.dart';
import '../../providers/calendar_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class EventCreation extends StatefulWidget {
  final CalendarEvent? existing;
  final DateTime? initialDate;
  final TimeOfDay? initialTime;

  const EventCreation({
    super.key,
    this.existing,
    this.initialDate,
    this.initialTime,
  });

  @override
  State<EventCreation> createState() => _EventCreationState();
}

class _EventCreationState extends State<EventCreation> {
  late final TextEditingController _titleController;
  late final TextEditingController _locationController;
  late final TextEditingController _descriptionController;

  late DateTime _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool _allDay = false;
  String? _selectedCategoryId;
  String? _selectedEmoji;
  String _priority = 'important';
  String _repeat = 'none';
  List<CalendarEvent> _conflicts = [];
  bool _checkingConflicts = false;

  final List<String> _emojiOptions = [
    '😊', '👶', '💼', '🎉', '🏥', '📚', '✈️', '🍽️', '❤️', '🐾', '🏫',
  ];

  bool get _isEditing => widget.existing != null;
  bool get _canSave => _titleController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _titleController = TextEditingController(text: e.title);
      _locationController = TextEditingController(text: e.location ?? '');
      _descriptionController =
          TextEditingController(text: e.description ?? '');
      _selectedDate =
          DateTime(e.startTime.year, e.startTime.month, e.startTime.day);
      _allDay = e.isAllDay;
      if (!e.isAllDay) {
        _startTime = TimeOfDay.fromDateTime(e.startTime);
        if (e.endTime != null) {
          _endTime = TimeOfDay.fromDateTime(e.endTime!);
        }
      }
      _selectedCategoryId = e.categoryId;
      _selectedEmoji = e.emoji;
      _priority = e.normalisedPriority;
      _repeat = e.recurrenceRule ?? 'none';
    } else {
      _titleController = TextEditingController();
      _locationController = TextEditingController();
      _descriptionController = TextEditingController();
      final base = widget.initialDate ?? DateTime.now();
      _selectedDate = DateTime(base.year, base.month, base.day);
      if (widget.initialTime != null) {
        _startTime = widget.initialTime;
        final endMins =
            widget.initialTime!.hour * 60 + widget.initialTime!.minute + 30;
        _endTime = TimeOfDay(hour: (endMins ~/ 60) % 24, minute: endMins % 60);
      } else {
        _startTime = _roundUpTo15(TimeOfDay.now());
        final endMins = _startTime!.hour * 60 + _startTime!.minute + 30;
        _endTime = TimeOfDay(hour: (endMins ~/ 60) % 24, minute: endMins % 60);
      }
    }
    _titleController.addListener(() => setState(() {}));
    WidgetsBinding.instance.addPostFrameCallback((_) => _refreshConflicts());
  }

  TimeOfDay _roundUpTo15(TimeOfDay t) {
    final total = t.hour * 60 + t.minute;
    final rounded = ((total + 14) ~/ 15) * 15;
    return TimeOfDay(hour: (rounded ~/ 60) % 24, minute: rounded % 60);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  DateTime? get _startDateTime {
    if (_allDay || _startTime == null) {
      return DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
      );
    }
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _startTime!.hour,
      _startTime!.minute,
    );
  }

  DateTime? get _endDateTime {
    if (_allDay || _endTime == null) return null;
    return DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _endTime!.hour,
      _endTime!.minute,
    );
  }

  Future<void> _refreshConflicts() async {
    if (_allDay || _startTime == null) {
      setState(() => _conflicts = []);
      return;
    }
    setState(() => _checkingConflicts = true);
    final provider = context.read<CalendarProvider>();
    final found = await provider.checkConflicts(
      date: _selectedDate,
      startTime: _startDateTime,
      endTime: _endDateTime,
      excludeId: widget.existing?.id,
    );
    if (mounted) {
      setState(() {
        _conflicts = found;
        _checkingConflicts = false;
      });
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
      await _refreshConflicts();
    }
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isStart
          ? (_startTime ?? TimeOfDay.now())
          : (_endTime ?? _startTime ?? TimeOfDay.now()),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          if (_endTime == null) {
            final endMins = picked.hour * 60 + picked.minute + 30;
            _endTime =
                TimeOfDay(hour: (endMins ~/ 60) % 24, minute: endMins % 60);
          }
        } else {
          _endTime = picked;
        }
      });
      await _refreshConflicts();
    }
  }

  Future<void> _save() async {
    if (!_canSave) return;

    if (_isEditing && (widget.existing?.isRecurring ?? false)) {
      final choice = await showDialog<String>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Edit recurring event'),
          content: const Text(
            'Edit this event only, or all future events?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'cancel'),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'this'),
              child: const Text('This only'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, 'future'),
              child: const Text('All future'),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (choice == null || choice == 'cancel') return;
    }

    final provider = context.read<CalendarProvider>();
    final title = _titleController.text.trim();
    if (title.length > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title max 100 characters')),
      );
      return;
    }
    final notes = _descriptionController.text.trim();
    if (notes.length > 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Notes max 500 characters')),
      );
      return;
    }

    if (_conflicts.isNotEmpty) {
      final proceed = await showDialog<bool>(
        context: context,
        builder: (ctx) {
          final c = _conflicts.first;
          final range = c.endTime != null
              ? '${DateFormat('h:mm a').format(c.startTime)} — ${DateFormat('h:mm a').format(c.endTime!)}'
              : DateFormat('h:mm a').format(c.startTime);
          return AlertDialog(
            title: const Text('Conflict detected'),
            content: Text(
              'Overlaps with "${c.title}" ($range). Add anyway?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Add anyway'),
              ),
            ],
          );
        },
      );
      if (!mounted) return;
      if (proceed != true) return;
    }

    final start = _startDateTime!;
    final end = _allDay ? null : _endDateTime;
    final location = _locationController.text.trim();

    if (_isEditing) {
      final ex = widget.existing!;
      final updated = CalendarEvent(
        id: ex.id,
        householdId: ex.householdId,
        title: title,
        description: notes.isEmpty ? null : notes,
        startTime: start,
        endTime: end,
        isAllDay: _allDay,
        timezone: ex.timezone,
        categoryId: _selectedCategoryId,
        personId: ex.personId,
        location: location.isEmpty ? null : location,
        emoji: _selectedEmoji,
        priority: _priority,
        recurrenceRule: _repeat == 'none' ? null : _repeat,
        source: ex.source,
        createdByInstance: ex.createdByInstance,
        privacyScope: ex.privacyScope,
        sensitivityLevel: ex.sensitivityLevel,
        eventType: ex.eventType,
        createdAt: ex.createdAt,
        updatedAt: DateTime.now(),
      );
      await provider.updateEvent(updated);
    } else {
      await provider.addEvent(
        title: title,
        date: start,
        endTime: end,
        isAllDay: _allDay,
        categoryId: _selectedCategoryId,
        emoji: _selectedEmoji,
        location: location.isEmpty ? null : location,
        description: notes.isEmpty ? null : notes,
        priority: _priority,
        recurrenceRule: _repeat,
      );
    }

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CalendarProvider>().categories;

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: BethColours.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _isEditing ? 'Edit event' : 'New event',
          style: BethTypography.heading,
        ),
        actions: [
          TextButton(
            onPressed: _canSave ? _save : null,
            child: Text(
              'Save',
              style: BethTypography.button.copyWith(
                color: _canSave ? BethColours.primary : BethColours.textMuted,
              ),
            ),
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
              maxLength: 100,
              decoration: _inputDecoration('Title *'),
              style: BethTypography.body,
              autofocus: !_isEditing,
            ),
            const SizedBox(height: 12),
            _optionRow(
              icon: Icons.calendar_today,
              label: 'Date *',
              value: DateFormat('d MMMM yyyy').format(_selectedDate),
              onTap: _pickDate,
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text('All day', style: BethTypography.bodySmall),
              value: _allDay,
              activeColor: BethColours.primary,
              onChanged: (v) {
                setState(() => _allDay = v);
                _refreshConflicts();
              },
            ),
            if (!_allDay) ...[
              _optionRow(
                icon: Icons.access_time,
                label: 'Start time *',
                value: _startTime?.format(context) ?? 'Set time',
                onTap: () => _pickTime(isStart: true),
              ),
              const SizedBox(height: 8),
              _optionRow(
                icon: Icons.access_time,
                label: 'End time',
                value: _endTime?.format(context) ?? 'None',
                onTap: () => _pickTime(isStart: false),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              'Repeat',
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _repeat,
              decoration: _inputDecoration(''),
              items: const [
                DropdownMenuItem(value: 'none', child: Text('None')),
                DropdownMenuItem(value: 'daily', child: Text('Daily')),
                DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                DropdownMenuItem(value: 'biweekly', child: Text('Biweekly')),
                DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
              ],
              onChanged: (v) => setState(() => _repeat = v ?? 'none'),
            ),
            const SizedBox(height: 16),
            Text(
              'Category',
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((cat) {
                final selected = _selectedCategoryId == cat['id'];
                final colour = BethColours.fromHex(cat['colour'] as String);
                return ChoiceChip(
                  label: Text(
                    '${cat['icon'] ?? ''} ${cat['name']}'.trim(),
                    style: const TextStyle(fontSize: 12),
                  ),
                  selected: selected,
                  onSelected: (_) => setState(
                    () => _selectedCategoryId =
                        selected ? null : cat['id'] as String,
                  ),
                  selectedColor: colour.withOpacity(0.25),
                  backgroundColor: BethColours.surface,
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Text(
              'Emoji (optional)',
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _emojiOptions.map((emoji) {
                final selected = _selectedEmoji == emoji;
                return GestureDetector(
                  onTap: () => setState(
                    () => _selectedEmoji = selected ? null : emoji,
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: selected
                          ? BethColours.primary.withOpacity(0.2)
                          : BethColours.surface,
                      borderRadius: BorderRadius.circular(8),
                      border: selected
                          ? Border.all(color: BethColours.primary)
                          : null,
                    ),
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: _inputDecoration('Location (optional)'),
              style: BethTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: _inputDecoration('Notes (optional)'),
              style: BethTypography.bodySmall,
              maxLines: 3,
              maxLength: 500,
            ),
            const SizedBox(height: 8),
            Text(
              'Priority',
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('⚠ Urgent'),
              value: 'urgent',
              groupValue: _priority,
              onChanged: (v) => setState(() => _priority = v!),
            ),
            RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('📋 Important'),
              value: 'important',
              groupValue: _priority,
              onChanged: (v) => setState(() => _priority = v!),
            ),
            RadioListTile<String>(
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: const Text('Routine'),
              value: 'routine',
              groupValue: _priority,
              onChanged: (v) => setState(() => _priority = v!),
            ),
            const SizedBox(height: 8),
            _conflictBanner(),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: _canSave ? _save : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: BethColours.primary,
                    ),
                    child: Text(_isEditing ? 'Save changes' : 'Save event'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _conflictBanner() {
    if (_checkingConflicts) {
      return Text('Checking conflicts…', style: BethTypography.caption);
    }
    if (_allDay || _startTime == null) {
      return const SizedBox.shrink();
    }
    if (_conflicts.isEmpty) {
      return Text(
        '✅ No conflicts detected',
        style: BethTypography.caption.copyWith(color: BethColours.green),
      );
    }
    final c = _conflicts.first;
    final range = c.endTime != null
        ? '${DateFormat('h:mm a').format(c.startTime)} — ${DateFormat('h:mm a').format(c.endTime!)}'
        : DateFormat('h:mm a').format(c.startTime);
    return Text(
      '⚠ Overlaps with "${c.title}" ($range). Add anyway?',
      style: BethTypography.caption.copyWith(color: BethColours.amber),
    );
  }

  Widget _optionRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
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
            Text(
              value,
              style: BethTypography.bodySmall.copyWith(
                color: BethColours.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
      filled: true,
      fillColor: BethColours.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      counterText: '',
    );
  }
}
