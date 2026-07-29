import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/calendar_provider.dart';
import '../../providers/companion_provider.dart';
import '../../providers/dashboard_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../settings/companion_settings_screen.dart';
import 'companion_avatar.dart';

class CompanionScreen extends StatefulWidget {
  const CompanionScreen({super.key});

  @override
  State<CompanionScreen> createState() => _CompanionScreenState();
}

class _CompanionScreenState extends State<CompanionScreen> {
  final _input = TextEditingController();
  final _scroll = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final companion = context.read<CompanionProvider>();
      await companion.openSession(
        dashboard: context.read<DashboardProvider>(),
        calendar: context.read<CalendarProvider>(),
      );
    });
  }

  @override
  void dispose() {
    _input.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToEnd() {
    Future.delayed(const Duration(milliseconds: 80), () {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _input.text.trim();
    if (text.isEmpty) return;
    _input.clear();
    final companion = context.read<CompanionProvider>();
    await companion.sendText(
      text,
      calendar: context.read<CalendarProvider>(),
      dashboard: context.read<DashboardProvider>(),
    );
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final companion = context.watch<CompanionProvider>();
    final dashboard = context.watch<DashboardProvider>();
    final sparkle = companion.avatarState == CompanionAvatarState.minimised;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1A22),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A2430),
        foregroundColor: Colors.white,
        title: Text(companion.instanceName, style: BethTypography.heading.copyWith(color: Colors.white)),
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Dashboard', style: TextStyle(color: Colors.white70)),
        ),
        leadingWidth: 110,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CompanionSettingsScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              controller: _scroll,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              children: [
                const SizedBox(height: 12),
                Center(
                  child: CompanionAvatar(
                    state: companion.avatarState,
                    mood: dashboard.mood,
                    name: companion.instanceName,
                  ),
                ),
                const SizedBox(height: 20),
                if (companion.greeting != null && !sparkle)
                  Text(
                    companion.greeting!,
                    textAlign: TextAlign.center,
                    style: BethTypography.body.copyWith(color: Colors.white70),
                  ),
                if (!sparkle) ...[
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    children: [
                      _MoodChip(label: '😊', onTap: () => _quick('I\'m okay today.')),
                      _MoodChip(label: '😐', onTap: () => _quick('Feeling a bit flat.')),
                      _MoodChip(label: '😔', onTap: () => _quick('Having a hard time.')),
                      _MoodChip(label: '🥱', onTap: () => _quick('I\'m exhausted.')),
                      _MoodChip(label: '?', onTap: () => _quick('Not sure how I feel.')),
                    ],
                  ),
                ],
                const SizedBox(height: 24),
                ...companion.messages.map((m) {
                  final isUser = m.role == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.78,
                      ),
                      decoration: BoxDecoration(
                        color: isUser
                            ? BethColours.primary.withOpacity(0.35)
                            : Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        m.content,
                        style: BethTypography.bodySmall.copyWith(color: Colors.white),
                      ),
                    ),
                  );
                }),
                if (companion.isSending)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '${companion.instanceName} is thinking...',
                      style: BethTypography.caption.copyWith(color: Colors.white54),
                    ),
                  ),
                if (companion.partialTranscript.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      companion.partialTranscript,
                      textAlign: TextAlign.center,
                      style: BethTypography.caption.copyWith(color: Colors.white60),
                    ),
                  ),
              ],
            ),
          ),
          _composer(companion),
        ],
      ),
    );
  }

  Future<void> _quick(String text) async {
    final companion = context.read<CompanionProvider>();
    await companion.sendText(
      text,
      calendar: context.read<CalendarProvider>(),
      dashboard: context.read<DashboardProvider>(),
    );
    _scrollToEnd();
  }

  Widget _composer(CompanionProvider companion) {
    final listening = companion.isListening;
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 8,
        top: 10,
        bottom: MediaQuery.of(context).padding.bottom + 10,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF2A2430),
        border: Border(top: BorderSide(color: Colors.white12)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () async {
              final dashboard = context.read<DashboardProvider>();
              final calendar = context.read<CalendarProvider>();
              if (listening) {
                await companion.stopListening();
              } else {
                await companion.startListening(
                  calendar: calendar,
                  dashboard: dashboard,
                );
              }
            },
            icon: Icon(
              listening ? Icons.mic : Icons.mic_none,
              color: listening ? BethColours.red : Colors.white70,
            ),
          ),
          Expanded(
            child: TextField(
              controller: _input,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Type or speak...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                filled: true,
                fillColor: Colors.black26,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          IconButton(
            onPressed: companion.isSending ? null : _send,
            icon: const Icon(Icons.send_rounded, color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

class _MoodChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _MoodChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
      backgroundColor: Colors.white10,
      side: BorderSide.none,
    );
  }
}
