import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../providers/calendar_provider.dart';
import '../../services/api_service.dart';
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
  Map<String, dynamic>? _lastResult;
  String? _clarifyMessage;
  final List<String> _clarifyHistory = [];
  late stt.SpeechToText _speech;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    _focusNode.unfocus();

    setState(() {
      _isLoading = true;
      _lastResult = null;
      _clarifyMessage = null;
    });

    final result = await ApiService.sendMessage(instanceId: 'rhen', input: text);

    // If schedule, also add to calendar via provider
    if (result['status'] == 'processed') {
      final log = result['log'] as Map<String, dynamic>?;
      if (log != null && log['category'] == 'schedule') {
        final calProvider = Provider.of<CalendarProvider>(context, listen: false);
        await calProvider.addEventFromPipeline(
          title: text,
          date: DateTime.now(),
          priority: log['priority'] as String? ?? 'normal',
        );
      }
    }

    // Check for clarification request
    if (result['status'] == 'needs_clarification') {
      setState(() {
        _clarifyMessage = result['message'] as String? ?? 'Can you clarify?';
      });
    }

    setState(() {
      _isLoading = false;
      _lastResult = result;
    });

    _controller.clear();
    _scrollToBottom();
  }

  void sendClarification() async {
    final text = _clarifyController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final result = await ApiService.sendMessage(instanceId: 'rhen', input: text);

    // If event created, add to calendar
    if (result['status'] == 'created' || result['status'] == 'complete') {
      final event = result['event'] as Map<String, dynamic>?;
      if (event != null) {
        final calProvider = Provider.of<CalendarProvider>(context, listen: false);
        await calProvider.addEventFromPipeline(
          title: event['title'] as String? ?? text,
          date: DateTime.tryParse(event['date'] as String? ?? '') ?? DateTime.now(),
          priority: event['priority'] as String? ?? 'normal',
        );
      }
    }

    setState(() {
      _isLoading = false;
      _clarifyHistory.add(_clarifyMessage!);
      _clarifyMessage = null;
      _lastResult = result;
    });

    _clarifyController.clear();
    _scrollToBottom();
  }

  void _startListening() async {
    bool available = await _speech.initialize(
      onStatus: (status) {},
      onError: (error) {
        setState(() => _isListening = false);
      },
    );

    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (result) {
          setState(() {
            _controller.text = result.recognizedWords;
          });
          if (result.finalResult) {
            setState(() => _isListening = false);
            if (_controller.text.trim().isNotEmpty) {
              sendMessage();
            }
          }
        },
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 2),
      );
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Speech recognition not available on this device.'),
            backgroundColor: BethColours.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
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
    String instanceName = 'Assistant';
    String errorMessage = '';
    bool isError = false;
    String responseText = '';

    if (_lastResult != null) {
      final status = _lastResult!['status'] as String? ?? '';

      if (status == 'rejected') {
        isError = true;
        final reason = _lastResult!['reason'] as String? ?? '';
        if (reason.contains('Missing') || reason.contains('empty')) {
          errorMessage = 'Type something or use the microphone';
        } else {
          errorMessage = 'Couldn\'t process that';
        }
      } else if (status == 'error') {
        isError = true;
        final message = _lastResult!['message'] as String? ?? '';
        if (message.contains('Connection') || message.contains('SocketException')) {
          errorMessage = 'Couldn\'t reach the server';
        } else {
          errorMessage = 'Something went wrong. Try again.';
        }
      } else if (status == 'created' || status == 'complete') {
        final event = _lastResult!['event'] as Map<String, dynamic>?;
        responseText = 'Event created: ${event?['title'] ?? 'event'}';
        instanceName = 'Rhen';
      } else if (status == 'processed' || status == 'accepted') {
        responseText = _lastResult!['response'] as String? ?? '';
        instanceName = (_lastResult!['instance'] ?? 'rhen').toString();
        if (instanceName.isNotEmpty) {
          instanceName = instanceName[0].toUpperCase() + instanceName.substring(1);
        }
      }
    }

    final log = _lastResult?['log'] as Map<String, dynamic>?;
    final category = log?['category'] as String? ?? 'unknown';
    final priority = log?['priority'] as String? ?? 'unknown';
    final emotional = log?['emotional_signal'] as String? ?? 'unknown';

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        title: const Text('Notes', style: BethTypography.heading),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: _lastResult == null && _clarifyMessage == null && _controller.text.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _isListening ? _stopListening : _startListening,
                          child: Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: _isListening
                                  ? BethColours.red.withOpacity(0.15)
                                  : BethColours.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                              border: _isListening
                                  ? Border.all(color: BethColours.red, width: 2)
                                  : null,
                            ),
                            child: Icon(
                              _isListening ? Icons.mic : Icons.mic_none,
                              size: 36,
                              color: _isListening ? BethColours.red : BethColours.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _isListening ? 'Listening...' : 'Tap mic or type below',
                          style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tasks, events, notes — all processed automatically',
                          style: BethTypography.caption,
                        ),
                      ],
                    ),
                  )
                : SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _sectionHeader('You said'),
                        const SizedBox(height: 4),
                        Text(
                          _controller.text.isNotEmpty ? _controller.text : '(sent)',
                          style: BethTypography.bodySmall,
                        ),
                        const SizedBox(height: 16),

                        if (isError) ...[
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4a2020),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    errorMessage,
                                    style: BethTypography.bodySmall?.copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (!isError && _lastResult != null && responseText.isNotEmpty) ...[
                          _sectionHeader('$instanceName says'),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: BethColours.surface,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 4,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Text(responseText, style: BethTypography.bodySmall),
                          ),
                          const SizedBox(height: 16),
                        ],

                        if (!isError && log != null && _clarifyMessage == null) ...[
                          _sectionHeader('Classification'),
                          const SizedBox(height: 8),
                          _pipelineBadge('Category', category, BethColours.primary),
                          const SizedBox(height: 6),
                          _pipelineBadge('Priority', priority, priority == 'high' ? BethColours.red : BethColours.green),
                          const SizedBox(height: 6),
                          _pipelineBadge('Emotional signal', emotional, BethColours.amber),
                          const SizedBox(height: 16),
                        ],

                        if (_clarifyHistory.isNotEmpty) ...[
                          ..._clarifyHistory.map((msg) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BethColours.surfaceAlt,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: BethColours.green.withOpacity(0.3)),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.check_circle, color: BethColours.green, size: 18),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'Clarified: "$msg"',
                                        style: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                        ],

                        if (_clarifyMessage != null) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color(0xFF4a3a20),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: BethColours.amber.withOpacity(0.3)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.warning_amber_rounded, color: BethColours.amber, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      'Needs more details',
                                      style: BethTypography.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: BethColours.amber,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  _clarifyMessage!,
                                  style: BethTypography.bodySmall?.copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _clarifyController,
                                        decoration: InputDecoration(
                                          hintText: 'Type your answer...',
                                          hintStyle: BethTypography.bodySmall?.copyWith(
                                            color: Colors.white54,
                                          ),
                                          filled: true,
                                          fillColor: Colors.white.withOpacity(0.1),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 10,
                                          ),
                                        ),
                                        style: BethTypography.bodySmall?.copyWith(color: Colors.white),
                                        onSubmitted: (_) => sendClarification(),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: _isLoading ? null : sendClarification,
                                      icon: Icon(
                                        Icons.send_rounded,
                                        color: _isLoading ? Colors.white38 : BethColours.amber,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),

          if (_isLoading)
            Container(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2, color: BethColours.primary),
                  ),
                  const SizedBox(width: 8),
                  Text('Processing...', style: BethTypography.caption),
                ],
              ),
            ),

          Container(
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
                GestureDetector(
                  onTap: _isListening ? _stopListening : _startListening,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _isListening
                          ? BethColours.red.withOpacity(0.15)
                          : BethColours.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isListening ? Icons.mic : Icons.mic_outlined,
                      color: _isListening ? BethColours.red : BethColours.primary,
                      size: 22,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: InputDecoration(
                      hintText: _isListening ? 'Listening...' : 'Type anything — task, note, event...',
                      hintStyle: BethTypography.bodySmall?.copyWith(color: BethColours.textMuted),
                      filled: true,
                      fillColor: BethColours.surfaceAlt,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    style: BethTypography.bodySmall,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => sendMessage(),
                  ),
                ),
                const SizedBox(width: 4),
                IconButton(
                  onPressed: _isLoading ? null : sendMessage,
                  icon: Icon(
                    Icons.send_rounded,
                    color: _isLoading ? BethColours.textMuted : BethColours.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: BethTypography.caption?.copyWith(
        fontWeight: FontWeight.w700,
        color: BethColours.textMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _pipelineBadge(String label, String value, Color colour) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: colour, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label: ', style: BethTypography.caption?.copyWith(fontWeight: FontWeight.w600)),
        Text(value, style: BethTypography.caption?.copyWith(color: colour)),
      ],
    );
  }
}