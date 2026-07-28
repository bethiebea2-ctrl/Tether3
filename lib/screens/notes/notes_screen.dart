import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../models/note_history_entry.dart';
import '../../providers/notes_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _clarifyController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _isListening = false;
  NoteHistoryEntry? _pendingClarifyEntry;
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotesProvider>().load();
    });
  }

  Future<void> sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isLoading) return;

    _focusNode.unfocus();
    setState(() => _isLoading = true);

    final entry = await context.read<NotesProvider>().submitNote(
          context,
          text: text,
          inputType: _isListening ? 'voice' : 'text',
        );

    _controller.clear();
    setState(() {
      _isLoading = false;
      if (entry.pipelineStatus == 'needs_clarification') {
        _pendingClarifyEntry = entry;
      } else {
        _pendingClarifyEntry = null;
      }
    });
    _scrollToBottom();
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

  void _startListening() async {
    final available = await _speech.initialize(
      onError: (_) => setState(() => _isListening = false),
    );
    if (!available) return;

    setState(() => _isListening = true);
    _speech.listen(
      onResult: (result) {
        setState(() => _controller.text = result.recognizedWords);
        if (result.finalResult) {
          setState(() => _isListening = false);
          if (_controller.text.trim().isNotEmpty) sendMessage();
        }
      },
      listenFor: const Duration(seconds: 30),
      pauseFor: const Duration(seconds: 2),
    );
  }

  void _stopListening() {
    _speech.stop();
    setState(() => _isListening = false);
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

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: const Text('Notes', style: BethTypography.heading),
      ),
      body: Column(
        children: [
          Expanded(
            child: !notes.isLoaded
                ? const Center(child: CircularProgressIndicator())
                : notes.entries.isEmpty
                    ? Center(
                        child: Text(
                          'Your note history will appear here.\nType or speak below.',
                          textAlign: TextAlign.center,
                          style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: notes.entries.length,
                        itemBuilder: (context, index) {
                          final entry = notes.entries[index];
                          return _NoteBubble(entry: entry);
                        },
                      ),
          ),
          if (_pendingClarifyEntry != null) _clarifyBar(),
          if (_isLoading)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Text('Processing...', style: BethTypography.caption),
            ),
          _composer(),
        ],
      ),
    );
  }

  Widget _clarifyBar() {
    return Container(
      padding: const EdgeInsets.all(12),
      color: BethColours.amber.withOpacity(0.15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _pendingClarifyEntry?.responseText ?? 'Needs more details',
            style: BethTypography.bodySmall,
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _clarifyController,
                  decoration: const InputDecoration(hintText: 'Your answer...'),
                  onSubmitted: (_) => sendClarification(),
                ),
              ),
              IconButton(onPressed: sendClarification, icon: const Icon(Icons.send)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _composer() {
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
          IconButton(
            onPressed: _isListening ? _stopListening : _startListening,
            icon: Icon(_isListening ? Icons.mic : Icons.mic_outlined),
            color: _isListening ? BethColours.red : BethColours.primary,
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              decoration: const InputDecoration(
                hintText: 'Type anything — task, note, event...',
                border: InputBorder.none,
              ),
              onSubmitted: (_) => sendMessage(),
            ),
          ),
          IconButton(
            onPressed: _isLoading ? null : sendMessage,
            icon: const Icon(Icons.send_rounded),
            color: BethColours.primary,
          ),
        ],
      ),
    );
  }
}

class _NoteBubble extends StatelessWidget {
  final NoteHistoryEntry entry;
  const _NoteBubble({required this.entry});

  @override
  Widget build(BuildContext context) {
    final status = entry.pipelineStatus ?? 'pending';
    final isError = status == 'error' || status == 'rejected';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: BethColours.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(entry.rawText, style: BethTypography.bodySmall),
            ),
          ),
          const SizedBox(height: 6),
          if (entry.responseText != null && entry.responseText!.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isError ? BethColours.red.withOpacity(0.1) : BethColours.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(entry.responseText!, style: BethTypography.bodySmall),
            ),
          if (entry.category != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${entry.category} · ${entry.priority ?? 'normal'}',
                style: BethTypography.caption,
              ),
            ),
        ],
      ),
    );
  }
}
