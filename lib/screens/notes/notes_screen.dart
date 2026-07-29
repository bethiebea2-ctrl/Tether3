import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/note_history_entry.dart';
import '../../providers/notes_provider.dart';
import '../../providers/settings_prefs_provider.dart';
import '../../services/speech_output_service.dart';
import '../../services/voice_input_service.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../widgets/notes/capture_error_card.dart';
import '../../widgets/notes/clarification_card.dart';
import '../../widgets/notes/quick_log_grid.dart';
import '../../widgets/notes/recent_captures_list.dart';

enum NotesCaptureMode { voice, text }

class NotesScreen extends StatefulWidget {
  final String? personId;
  final String? personName;
  final String? ageStage;
  final String? preselectedLogType;
  final String? eventContextTitle;

  const NotesScreen({
    super.key,
    this.personId,
    this.personName,
    this.ageStage,
    this.preselectedLogType,
    this.eventContextTitle,
  });

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _clarifyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  final VoiceInputService _voice = VoiceInputService();
  final SpeechOutputService _tts = SpeechOutputService();
  bool _isLoading = false;
  bool _isListening = false;
  bool _continuousListen = false;
  NotesCaptureMode _mode = NotesCaptureMode.text;
  NoteHistoryEntry? _pendingClarifyEntry;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notes = context.read<NotesProvider>();
      notes.load();
      notes.setCaptureContext(NotesCaptureContext(
        personId: widget.personId,
        personName: widget.personName,
        ageStage: widget.ageStage,
        preselectedLogType: widget.preselectedLogType,
        eventContextTitle: widget.eventContextTitle,
      ));
      if (widget.eventContextTitle != null && widget.eventContextTitle!.isNotEmpty) {
        _controller.text = 'Event: ${widget.eventContextTitle}';
      }
      if (widget.preselectedLogType != null) {
        _mode = NotesCaptureMode.text;
        _openQuickLogById(widget.preselectedLogType!);
      }
    });
  }

  Future<void> sendMessage({String inputType = 'text'}) async {
    final text = _controller.text.trim();
    if (_isLoading) return;
    if (text.isEmpty) {
      context.read<NotesProvider>().showError(
            inputType == 'voice'
                ? CaptureErrorKind.emptyVoice
                : CaptureErrorKind.emptyText,
          );
      return;
    }

    _focusNode.unfocus();
    setState(() => _isLoading = true);

    final entry = await context.read<NotesProvider>().submitNote(
          context,
          text: text,
          inputType: inputType,
        );

    _controller.clear();
    setState(() {
      _isLoading = false;
      if (entry?.pipelineStatus == 'needs_clarification') {
        _pendingClarifyEntry = entry;
      } else if (entry != null) {
        _pendingClarifyEntry = null;
      }
    });
    _maybeShowUndoSnack(entry);
    await _maybeSpeakConfirmation(entry);
    _scrollToBottom();
    if (_continuousListen && _mode == NotesCaptureMode.voice && mounted) {
      await _startListening(continuous: true);
    }
  }

  Future<void> _maybeSpeakConfirmation(NoteHistoryEntry? entry) async {
    if (entry == null) return;
    final prefs = context.read<SettingsPrefsProvider>();
    final ttsOn = prefs.accessibilityToggleIds.contains('tts_default');
    if (!ttsOn) return;
    final msg = entry.responseText ?? 'Captured.';
    await _tts.speak(msg, enabled: true);
  }

  Future<void> sendClarification() async {
    final text = _clarifyController.text.trim();
    final parent = _pendingClarifyEntry;
    if (text.isEmpty || parent == null || _isLoading) return;

    setState(() => _isLoading = true);
    final entry = await context.read<NotesProvider>().submitClarification(
          context,
          parent: parent,
          clarificationText: text,
          clarifyPrompt: parent.responseText ?? '',
        );

    _clarifyController.clear();
    setState(() {
      _isLoading = false;
      _pendingClarifyEntry =
          entry.pipelineStatus == 'needs_clarification' ? entry : null;
    });
    _scrollToBottom();
  }

  void _maybeShowUndoSnack(NoteHistoryEntry? entry) {
    if (entry == null) return;
    final notes = context.read<NotesProvider>();
    if (notes.undoableEntryId != entry.id) return;

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Logged. Undo available for 30 seconds.'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => notes.undoLastAutoLog(),
        ),
        duration: const Duration(seconds: 30),
      ),
    );
  }

  Future<void> _startListening({bool continuous = false}) async {
    final ok = await _voice.startListening(
      continuous: continuous,
      onResult: (words, isFinal) {
        setState(() => _controller.text = words);
        if (isFinal) {
          setState(() => _isListening = false);
          if (words.trim().isEmpty) {
            context.read<NotesProvider>().showError(CaptureErrorKind.emptyVoice);
          } else {
            sendMessage(inputType: 'voice');
          }
        }
      },
      onError: (_) {
        setState(() => _isListening = false);
        context.read<NotesProvider>().showError(CaptureErrorKind.emptyVoice);
      },
    );

    if (!ok) {
      context.read<NotesProvider>().showError(CaptureErrorKind.emptyVoice);
      return;
    }
    setState(() {
      _mode = NotesCaptureMode.voice;
      _isListening = true;
      _continuousListen = continuous;
    });
  }

  Future<void> _stopListening() async {
    await _voice.stop();
    setState(() {
      _isListening = false;
      _continuousListen = false;
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _openQuickLogById(String id) async {
    final notes = context.read<NotesProvider>();
    final actions = quickLogActionsForContext(ageStage: notes.captureContext.ageStage);
    final match = actions.where((a) => a.id == id);
    if (match.isEmpty) return;
    await _onQuickLog(match.first);
  }

  Future<void> _onQuickLog(QuickLogAction action) async {
    final detail = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: BethColours.surface,
      builder: (ctx) => _QuickLogConfirmSheet(
        action: action,
        personName: context.read<NotesProvider>().captureContext.personName,
      ),
    );
    if (detail == null || !mounted) return;
    setState(() => _isLoading = true);
    final entry = await context.read<NotesProvider>().submitQuickLog(
          context,
          label: action.label,
          pipelineHint: action.pipelineHint,
          detail: detail.isEmpty ? null : detail,
        );
    setState(() {
      _isLoading = false;
      if (entry?.pipelineStatus == 'needs_clarification') {
        _pendingClarifyEntry = entry;
      }
    });
    _maybeShowUndoSnack(entry);
  }

  @override
  void dispose() {
    _controller.dispose();
    _clarifyController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NotesProvider>();
    final prefs = context.watch<SettingsPrefsProvider>();
    final overwhelmed = prefs.currentStateId == 'overwhelmed';
    final actions = quickLogActionsForContext(
      ageStage: notes.captureContext.ageStage ?? widget.ageStage,
      overwhelmed: overwhelmed,
    );

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: Text(
          notes.captureContext.personName != null
              ? 'Notes · ${notes.captureContext.personName}'
              : 'Notes',
          style: BethTypography.heading,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: SegmentedButton<NotesCaptureMode>(
              segments: const [
                ButtonSegment(value: NotesCaptureMode.voice, label: Text('Voice'), icon: Icon(Icons.mic, size: 16)),
                ButtonSegment(value: NotesCaptureMode.text, label: Text('Text'), icon: Icon(Icons.keyboard, size: 16)),
              ],
              selected: {_mode},
              onSelectionChanged: (s) => setState(() => _mode = s.first),
              style: const ButtonStyle(
                visualDensity: VisualDensity.compact,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: !notes.isLoaded
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    controller: _scrollController,
                    children: [
                      if (_mode == NotesCaptureMode.voice) _voiceModeBody() else _textModeBody(actions),
                      if (_isLoading)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            'Rhen is sorting this...',
                            textAlign: TextAlign.center,
                            style: BethTypography.caption,
                          ),
                        ),
                      RecentCapturesList(
                        entries: notes.entries,
                        undoableEntryId: notes.undoableEntryId,
                        onUndo: (_) => notes.undoLastAutoLog(),
                        onTapIncomplete: (e) {
                          setState(() => _pendingClarifyEntry = e);
                        },
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
          ),
          if (notes.clarificationCollapsed && notes.lastClarifiedSummary != null)
            ClarificationCard(
              originalText: '',
              question: '',
              controller: _clarifyController,
              onSubmit: () {},
              collapsed: true,
              clarifiedSummary: notes.lastClarifiedSummary,
            ),
          if (_pendingClarifyEntry != null)
            ClarificationCard(
              originalText: _pendingClarifyEntry!.rawText,
              question: _pendingClarifyEntry!.responseText ?? 'Can you clarify?',
              controller: _clarifyController,
              onSubmit: sendClarification,
              isLoading: _isLoading,
            ),
          if (notes.activeError != null)
            CaptureErrorCard(
              kind: notes.activeError!,
              onDismiss: notes.clearError,
            ),
          if (_mode == NotesCaptureMode.text) _textComposer(),
        ],
      ),
    );
  }

  Widget _voiceModeBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              if (_isListening) {
                _stopListening();
              } else {
                _startListening(continuous: _continuousListen);
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isListening
                    ? BethColours.red.withOpacity(0.15)
                    : BethColours.primary.withOpacity(0.12),
                border: Border.all(
                  color: _isListening ? BethColours.red : BethColours.primary,
                  width: 2,
                ),
              ),
              child: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                size: 40,
                color: _isListening ? BethColours.red : BethColours.primary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _isListening
                ? (_continuousListen ? 'Continuous listening...' : 'Listening...')
                : 'Tap and speak freely.\nI\'ll sort it out.',
            textAlign: TextAlign.center,
            style: BethTypography.body.copyWith(color: BethColours.textSecondary),
          ),
          const SizedBox(height: 12),
          FilterChip(
            label: Text(_continuousListen ? 'Continuous on' : 'Continuous listen'),
            selected: _continuousListen,
            onSelected: (v) {
              setState(() => _continuousListen = v);
              if (!v && _isListening) _stopListening();
            },
          ),
          if (_controller.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Text(_controller.text, textAlign: TextAlign.center),
            ),
        ],
      ),
    );
  }

  Widget _textModeBody(List<QuickLogAction> actions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Type a note or use quick log...',
            style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
          ),
        ),
        QuickLogGrid(actions: actions, onSelected: _onQuickLog),
        const Divider(height: 24),
      ],
    );
  }

  Widget _textComposer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: BethColours.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              minLines: 1,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type anything — task, note, event...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          TextButton(
            onPressed: _isLoading ? null : () => sendMessage(),
            child: const Text('Save Note'),
          ),
        ],
      ),
    );
  }
}

class _QuickLogConfirmSheet extends StatefulWidget {
  final QuickLogAction action;
  final String? personName;

  const _QuickLogConfirmSheet({required this.action, this.personName});

  @override
  State<_QuickLogConfirmSheet> createState() => _QuickLogConfirmSheetState();
}

class _QuickLogConfirmSheetState extends State<_QuickLogConfirmSheet> {
  final _detail = TextEditingController();

  @override
  void dispose() {
    _detail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = TimeOfDay.now().format(context);
    final who = widget.personName != null ? ' for ${widget.personName}' : '';
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Log ${widget.action.label.toLowerCase()}$who?',
            style: BethTypography.subheading,
          ),
          const SizedBox(height: 8),
          Text('${widget.action.emoji} ${widget.action.label} · $now (auto)',
              style: BethTypography.bodySmall),
          const SizedBox(height: 12),
          TextField(
            controller: _detail,
            decoration: InputDecoration(
              hintText: widget.action.id == 'feed'
                  ? 'Amount (optional)'
                  : widget.action.id == 'task' || widget.action.id == 'event'
                      ? 'Title'
                      : 'Optional detail',
              filled: true,
              fillColor: BethColours.surfaceAlt,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const Spacer(),
              FilledButton(
                onPressed: () => Navigator.pop(context, _detail.text),
                child: Text('Log ${widget.action.label}'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
