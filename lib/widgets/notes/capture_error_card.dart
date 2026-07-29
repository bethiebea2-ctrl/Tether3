import 'package:flutter/material.dart';
import '../../theme/typography.dart';

enum CaptureErrorKind {
  emptyVoice,
  emptyText,
  network,
  pipelineRejected,
  timeout,
}

class CaptureErrorCard extends StatelessWidget {
  final CaptureErrorKind kind;
  final VoidCallback? onDismiss;

  const CaptureErrorCard({
    super.key,
    required this.kind,
    this.onDismiss,
  });

  bool get _isRed => kind == CaptureErrorKind.network;

  String get _message {
    switch (kind) {
      case CaptureErrorKind.emptyVoice:
        return 'No speech detected. Try again or type below.';
      case CaptureErrorKind.emptyText:
        return 'Type something or use the microphone.';
      case CaptureErrorKind.network:
        return "Couldn't reach the server. Check your connection.";
      case CaptureErrorKind.pipelineRejected:
        return "Couldn't process that. Try rewording?";
      case CaptureErrorKind.timeout:
        return 'Taking longer than expected. Still trying...';
    }
  }

  @override
  Widget build(BuildContext context) {
    final bg = _isRed ? const Color(0xFF4A2020) : const Color(0xFF4A3A20);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _message,
              style: BethTypography.bodySmall?.copyWith(color: Colors.white),
            ),
          ),
          if (onDismiss != null)
            IconButton(
              onPressed: onDismiss,
              icon: const Icon(Icons.close, color: Colors.white70, size: 18),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}
