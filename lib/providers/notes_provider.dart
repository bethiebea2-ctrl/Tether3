import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../database/capture_dao.dart';
import '../models/note_history_entry.dart';
import '../services/api_service.dart';
import '../widgets/notes/capture_error_card.dart';
import 'calendar_provider.dart';

class NotesCaptureContext {
  final String? personId;
  final String? personName;
  final String? ageStage;
  final String? preselectedLogType;
  final String? eventContextTitle;

  const NotesCaptureContext({
    this.personId,
    this.personName,
    this.ageStage,
    this.preselectedLogType,
    this.eventContextTitle,
  });
}

class NotesProvider extends ChangeNotifier {
  final CaptureDao _dao = CaptureDao();
  final _uuid = const Uuid();
  List<NoteHistoryEntry> _entries = [];
  bool _loaded = false;
  CaptureErrorKind? activeError;
  String? undoableEntryId;
  Timer? _undoTimer;
  NotesCaptureContext captureContext = const NotesCaptureContext();
  String? lastClarifiedSummary;
  bool clarificationCollapsed = false;

  List<NoteHistoryEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  void setCaptureContext(NotesCaptureContext ctx) {
    captureContext = ctx;
    notifyListeners();
  }

  void clearError() {
    activeError = null;
    notifyListeners();
  }

  void showError(CaptureErrorKind kind) {
    activeError = kind;
    notifyListeners();
  }

  Future<void> load() async {
    _entries = await _dao.getAllOrderedByNewest();
    _loaded = true;
    notifyListeners();
  }

  Future<NoteHistoryEntry?> submitNote(
    BuildContext context, {
    required String text,
    String inputType = 'text',
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      activeError = inputType == 'voice'
          ? CaptureErrorKind.emptyVoice
          : CaptureErrorKind.emptyText;
      notifyListeners();
      return null;
    }

    activeError = null;
    clarificationCollapsed = false;
    lastClarifiedSummary = null;

    final now = DateTime.now();
    var entry = NoteHistoryEntry(
      id: _uuid.v4(),
      rawText: trimmed,
      inputType: inputType,
      pipelineStatus: 'pending',
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insert(entry);
    _entries = [..._entries, entry];
    notifyListeners();

    final result = await ApiService.sendMessage(instanceId: 'rhen', input: trimmed);
    entry = await _applyPipelineResult(context, entry, result);
    return entry;
  }

  Future<NoteHistoryEntry?> submitQuickLog(
    BuildContext context, {
    required String label,
    required String pipelineHint,
    String? detail,
  }) async {
    final person = captureContext.personName;
    final buffer = StringBuffer(pipelineHint);
    if (person != null && person.isNotEmpty) {
      buffer.write(' for $person');
    }
    if (detail != null && detail.trim().isNotEmpty) {
      buffer.write(': ${detail.trim()}');
    }
    final entry = await submitNote(
      context,
      text: buffer.toString(),
      inputType: 'quick_log',
    );
    if (entry != null && _isAutoLoggedCategory(entry.category, label)) {
      _armUndo(entry);
    }
    return entry;
  }

  bool _isAutoLoggedCategory(String? category, String label) {
    final c = (category ?? label).toLowerCase();
    return c.contains('feed') ||
        c.contains('med') ||
        c.contains('nap') ||
        c.contains('nappy') ||
        c.contains('diaper');
  }

  void _armUndo(NoteHistoryEntry entry) {
    _undoTimer?.cancel();
    undoableEntryId = entry.id;
    notifyListeners();
    _undoTimer = Timer(const Duration(seconds: 30), () {
      undoableEntryId = null;
      notifyListeners();
    });
  }

  Future<void> undoLastAutoLog() async {
    final id = undoableEntryId;
    if (id == null) return;
    _undoTimer?.cancel();
    await _dao.delete(id);
    _entries = _entries.where((e) => e.id != id).toList();
    undoableEntryId = null;
    notifyListeners();
  }

  Future<NoteHistoryEntry> submitClarification(
    BuildContext context, {
    required NoteHistoryEntry parent,
    required String clarificationText,
    required String clarifyPrompt,
  }) async {
    final result =
        await ApiService.sendMessage(instanceId: 'rhen', input: clarificationText);
    final thread = '${parent.clarifyThreadJson ?? ''}|$clarifyPrompt::$clarificationText';
    var entry = parent.copyWith(clarifyThreadJson: thread);
    entry = await _applyPipelineResult(context, entry, result);
    if (entry.pipelineStatus != 'needs_clarification') {
      lastClarifiedSummary = clarificationText.trim();
      clarificationCollapsed = true;
      notifyListeners();
    }
    return entry;
  }

  Future<NoteHistoryEntry> _applyPipelineResult(
    BuildContext context,
    NoteHistoryEntry entry,
    Map<String, dynamic> result,
  ) async {
    final status = result['status'] as String? ?? 'error';
    final log = result['log'] as Map<String, dynamic>?;
    String? responseText;

    if (status == 'network_error') {
      activeError = CaptureErrorKind.network;
      responseText = result['response'] as String?;
    } else if (status == 'timeout') {
      activeError = CaptureErrorKind.timeout;
      responseText = result['response'] as String?;
    } else if (status == 'rejected') {
      activeError = CaptureErrorKind.pipelineRejected;
      responseText = result['response'] as String?;
    } else if (status == 'processed' || status == 'accepted') {
      activeError = null;
      responseText = result['response'] as String? ?? '';
      if (log != null && log['category'] == 'schedule') {
        final calProvider = Provider.of<CalendarProvider>(context, listen: false);
        await calProvider.addEventFromPipeline(
          title: entry.rawText,
          date: DateTime.now(),
          priority: log['priority'] as String? ?? 'normal',
        );
      }
      if (_isAutoLoggedCategory(log?['category'] as String?, entry.rawText)) {
        _armUndo(entry);
      }
    } else if (status == 'created' || status == 'complete') {
      activeError = null;
      final event = result['event'] as Map<String, dynamic>?;
      responseText = 'Event created: ${event?['title'] ?? 'event'}';
      if (event != null) {
        final calProvider = Provider.of<CalendarProvider>(context, listen: false);
        await calProvider.addEventFromPipeline(
          title: event['title'] as String? ?? entry.rawText,
          date: DateTime.tryParse(event['date'] as String? ?? '') ?? DateTime.now(),
          priority: event['priority'] as String? ?? 'normal',
        );
      }
    } else if (status == 'needs_clarification') {
      activeError = null;
      responseText = result['message'] as String? ?? 'Can you clarify?';
    } else if (status == 'error') {
      activeError = CaptureErrorKind.network;
      responseText =
          result['response'] as String? ?? result['message'] as String? ?? 'Error';
    }

    final updated = entry.copyWith(
      pipelineStatus: status == 'network_error' || status == 'timeout'
          ? 'error'
          : status,
      responseText: responseText,
      category: log?['category'] as String?,
      priority: log?['priority'] as String?,
      emotionalSignal: log?['emotional_signal'] as String?,
      updatedAt: DateTime.now(),
    );
    await _dao.update(updated);
    final index = _entries.indexWhere((e) => e.id == updated.id);
    if (index != -1) {
      _entries[index] = updated;
      notifyListeners();
    }
    return updated;
  }

  @override
  void dispose() {
    _undoTimer?.cancel();
    super.dispose();
  }
}

extension NoteHistoryCopy on NoteHistoryEntry {
  NoteHistoryEntry copyWith({
    String? pipelineStatus,
    String? responseText,
    String? category,
    String? priority,
    String? emotionalSignal,
    String? clarifyThreadJson,
    DateTime? updatedAt,
  }) {
    return NoteHistoryEntry(
      id: id,
      rawText: rawText,
      inputType: inputType,
      pipelineStatus: pipelineStatus ?? this.pipelineStatus,
      responseText: responseText ?? this.responseText,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      emotionalSignal: emotionalSignal ?? this.emotionalSignal,
      clarifyThreadJson: clarifyThreadJson ?? this.clarifyThreadJson,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
