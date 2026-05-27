import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class InstanceChat extends StatefulWidget {
  final String instanceId;
  final String instanceName;
  final String domain;

  const InstanceChat({
    super.key,
    required this.instanceId,
    required this.instanceName,
    required this.domain,
  });

  @override
  State<InstanceChat> createState() => _InstanceChatState();
}

class _InstanceChatState extends State<InstanceChat> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await ApiService.getConversation(widget.instanceId);
    setState(() {
      _messages.addAll(history);
      _isLoadingHistory = false;
    });
    _scrollToBottom();
  }

  void _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'content': text});
      _isLoading = true;
    });
    _messageController.clear();
    _scrollToBottom();

    final result = await ApiService.sendMessage(
      instanceId: widget.instanceId,
      input: text,
    );

        setState(() {
      _isLoading = false;
      if (result['status'] == 'processed' || result['status'] == 'accepted') {
        _messages.add({
          'role': 'assistant',
          'content': result['response'] ?? '(no response)',
        });
      } else if (result['status'] == 'complete') {
        _messages.add({
          'role': 'assistant',
          'content': result['message'] ?? '(no response)',
        });
      } else if (result['status'] == 'error' || result['status'] == 'rejected') {
        _messages.add({
          'role': 'assistant',
          'content': '⚠️ ${result['response'] ?? result['message'] ?? 'Something went wrong.'}',
        });
      } else {
        _messages.add({
          'role': 'assistant',
          'content': result['response'] ?? '(no response)',
        });
      }
    });

    _scrollToBottom();
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
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: BethColours.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.instanceName, style: BethTypography.body?.copyWith(fontWeight: FontWeight.w600)),
            Text(widget.domain, style: BethTypography.caption),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _isLoadingHistory
                ? const Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color: BethColours.primary.withOpacity(0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.instanceName[0],
                                  style: TextStyle(
                                    color: BethColours.primary,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Say hello to ${widget.instanceName}',
                              style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.domain,
                              style: BethTypography.caption,
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: _messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (_isLoading && index == _messages.length) {
                            return Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                margin: const EdgeInsets.only(top: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: BethColours.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: BethColours.primary,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Text('Thinking...', style: BethTypography.caption),
                                  ],
                                ),
                              ),
                            );
                          }

                          final msg = _messages[index];
                          final isUser = msg['role'] == 'user';

                          return Align(
                            alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(14),
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width * 0.75,
                              ),
                              decoration: BoxDecoration(
                                color: isUser ? BethColours.primary : BethColours.surface,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: isUser
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 4,
                                          offset: const Offset(0, 1),
                                        ),
                                      ],
                              ),
                              child: Text(
                                msg['content']!,
                                style: BethTypography.bodySmall?.copyWith(
                                  color: isUser ? Colors.white : BethColours.textPrimary,
                                ),
                              ),
                            ),
                          );
                        },
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
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      hintText: 'Message ${widget.instanceName}...',
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
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : _sendMessage,
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
}