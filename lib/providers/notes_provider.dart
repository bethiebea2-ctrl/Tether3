import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../database/capture_dao.dart';
import '../models/note_history_entry.dart';
import '../services/api_service.dart';
import 'calendar_provider.dart';
import 'package:provider/provider.dart';

class NotesProvider extends ChangeNotifier {
  final CaptureDao _dao = CaptureDao();
  final _uuid = const Uuid();
  List<NoteHistoryEntry> _entries = [];
  bool _loaded = false;

  List<NoteHistoryEntry> get entries => List.unmodifiable(_entries);
  bool get isLoaded => _loaded;

  Future<void> load() async {
    _entries = await _dao.getAllOrderedByNewest();
    _loaded = true;
    notifyListeners();
  }

  Future<NoteHistoryEntry> submitNote(
    BuildContext context, {
    required String text,
    String inputType = 'text',
  }) async {
    final now = DateTime.now();
    var entry = NoteHistoryEntry(
      id: _uuid.v4(),
      rawText: text,
      inputType: inputType,
      pipelineStatus: 'pending',
      createdAt: now,
      updatedAt: now,
    );
    await _dao.insert(entry);
    _entries = [..._entries, entry];
    notifyListeners();

    final result = await ApiService.sendMessage(instanceId: 'rhen', input: text);
    entry = await _applyPipelineResult(context, entry, result);
    return entry;
  }

  Future<NoteHistoryEntry> submitClarification(
    BuildContext context, {
    required NoteHistoryEntry parent,
    required String clarificationText,
    required String clarifyPrompt,
  }) async {
    final result = await ApiService.sendMessage(instanceId: 'rhen', input: clarificationText);
    final thread = '${parent.clarifyThreadJson ?? ''}|$clarifyPrompt::$clarificationText';
    var entry = parent.copyWith(clarifyThreadJson: thread);
    entry = await _applyPipelineResult(context, entry, result);
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

    if (status == 'processed' || status == 'accepted') {
      responseText = result['response'] as String? ?? '';
      if (log != null && log['category'] == 'schedule') {
        final calProvider = Provider.of<CalendarProvider>(context, listen: false);
        await calProvider.addEventFromPipeline(
          title: entry.rawText,
          date: DateTime.now(),
          priority: log['priority'] as String? ?? 'normal',
        );
      }
    } else if (status == 'created' || status == 'complete') {
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
      responseText = result['message'] as String? ?? 'Can you clarify?';
    } else if (status == 'error') {
      responseText = result['response'] as String? ?? result['message'] as String? ?? 'Error';
    }

    final updated = entry.copyWith(
      pipelineStatus: status,
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
}

extension _NoteHistoryCopy on NoteHistoryEntry {
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
