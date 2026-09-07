import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/utils/au_date_format.dart';

/// Inserts slashes while typing: 15032020 → 15/03/2020
class AuDateTextInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) {
      return const TextEditingValue(text: '');
    }
    final buf = StringBuffer();
    for (var i = 0; i < digits.length && i < 8; i++) {
      if (i == 2 || i == 4) buf.write('/');
      buf.write(digits[i]);
    }
    final text = buf.toString();
    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}

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
  late final FocusNode _focusNode;
  String? _error;

  bool get hasError => _error != null;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value != null ? formatAuDate(widget.value!) : '',
    );
    _focusNode = FocusNode()..addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus) {
      commitValue();
    }
  }

  static bool _sameDay(DateTime? a, DateTime? b) {
    if (a == null && b == null) return true;
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  void didUpdateWidget(AuDateInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameDay(widget.value, oldWidget.value)) {
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
    _focusNode.dispose();
    _controller.dispose();
    super.dispose();
  }

  /// Parse the text field and notify parent. Call before save.
  DateTime? commitValue({bool notify = true}) {
    final trimmed = _controller.text.trim();
    if (trimmed.isEmpty) {
      setState(() => _error = null);
      if (notify) widget.onChanged(null);
      return null;
    }
    final parsed = parseAuDate(trimmed);
    if (parsed != null) {
      final formatted = formatAuDate(parsed);
      if (_controller.text != formatted) {
        _controller.text = formatted;
      }
      setState(() => _error = null);
      if (notify) widget.onChanged(parsed);
      return parsed;
    }
    setState(() => _error = 'Use DD/MM/YYYY (e.g. 15/03/2020)');
    return null;
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
    } else if (trimmed.length >= 10) {
      setState(() => _error = 'Use DD/MM/YYYY (e.g. 15/03/2020)');
    } else {
      setState(() => _error = null);
    }
  }

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final picked = await showAuDatePicker(
      context: context,
      initialDate: widget.value ?? widget.lastDate,
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      helpText: widget.helpText ?? '${widget.label} (DD/MM/YYYY)',
    );
    if (picked == null) return;
    _controller.text = formatAuDate(picked);
    setState(() => _error = null);
    widget.onChanged(picked);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      focusNode: _focusNode,
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: '15/03/2020',
        helperText: widget.optional
            ? 'Optional · type DD/MM/YYYY here, or tap calendar'
            : 'Type DD/MM/YYYY here, or tap calendar to pick',
        errorText: _error,
        suffixIcon: IconButton(
          icon: const Icon(Icons.calendar_today),
          tooltip: 'Pick from calendar (type DD/MM/YYYY in this field)',
          onPressed: _pickDate,
        ),
      ),
      keyboardType: TextInputType.number,
      inputFormatters: [AuDateTextInputFormatter()],
      textInputAction: TextInputAction.done,
      onChanged: applyTyped,
      onSubmitted: (_) => commitValue(),
      onEditingComplete: () => commitValue(),
    );
  }
}
