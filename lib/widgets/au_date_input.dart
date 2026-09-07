import 'package:flutter/material.dart';
import '../core/utils/au_date_format.dart';

/// Calendar + DD/MM/YYYY text field that keeps typed and picked dates in sync.
class AuDateInput extends StatefulWidget {
  const AuDateInput({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.firstDate,
    required this.lastDate,
    this.helpText,
    this.optional = false,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helpText;
  final bool optional;

  @override
  State<AuDateInput> createState() => AuDateInputState();

  /// Returns null if valid or empty (when optional). Error message otherwise.
  static String? validate(DateTime? value, String typed, {bool optional = false}) {
    final trimmed = typed.trim();
    if (trimmed.isEmpty) return optional ? null : 'Enter a date (DD/MM/YYYY)';
    if (value != null && formatAuDate(value) == trimmed) return null;
    if (parseAuDate(trimmed) != null) return null;
    return 'Use DD/MM/YYYY (e.g. 15/03/2020)';
  }
}

class AuDateInputState extends State<AuDateInput> {
  late final TextEditingController _controller;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? formatAuDate(widget.value!) : '',
    );
  }

  @override
  void didUpdateWidget(AuDateInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final next = widget.value != null ? formatAuDate(widget.value!) : '';
      if (_controller.text != next) {
        _controller.value = TextEditingValue(
          text: next,
          selection: TextSelection.collapsed(offset: next.length),
        );
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void applyTyped(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      setState(() => _error = null);
      widget.onChanged(null);
      return;
    }
    final parsed = parseAuDate(trimmed);
    if (parsed != null) {
      setState(() => _error = null);
      widget.onChanged(parsed);
      final formatted = formatAuDate(parsed);
      if (_controller.text != formatted) {
        _controller.value = TextEditingValue(
          text: formatted,
          selection: TextSelection.collapsed(offset: formatted.length),
        );
      }
    } else {
      setState(() => _error = 'Use DD/MM/YYYY (e.g. 15/03/2020)');
    }
  }

  Future<void> _pickDate() async {
    final picked = await showAuDatePicker(
      context: context,
      initialDate: widget.value ?? widget.lastDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: widget.helpText ?? '${widget.label} (DD/MM/YYYY)',
    );
    if (picked == null) return;
    final formatted = formatAuDate(picked);
    _controller.text = formatted;
    setState(() => _error = null);
    widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '15/03/2020',
        helperText: widget.optional ? 'Optional · DD/MM/YYYY' : 'DD/MM/YYYY',
        errorText: _error,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          tooltip: 'Pick date',
          onPressed: _pickDate,
        ),
      ),
      keyboardType: TextInputType.datetime,
      textInputAction: TextInputAction.done,
      onChanged: applyTyped,
      onSubmitted: applyTyped,
      onEditingComplete: () => applyTyped(_controller.text),
    );
  }
}
