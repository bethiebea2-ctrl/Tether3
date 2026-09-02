import 'package:flutter/material.dart';
import '../../models/note_history_entry.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class RecentCapturesList extends StatelessWidget {
  final List<NoteHistoryEntry> entries;
  final String? undoableEntryId;
  final ValueChanged<NoteHistoryEntry>? onUndo;
  final ValueChanged<NoteHistoryEntry>? onTapIncomplete;

  const RecentCapturesList({
    super.key,
    required this.entries,
    this.undoableEntryId,
    this.onUndo,
    this.onTapIncomplete,
  });

  IconData _iconFor(NoteHistoryEntry e) {
    final cat = (e.category ?? '').toLowerCase();
    if (cat.contains('feed') || cat.contains('family')) return Icons.child_care;
    if (cat.contains('schedule') || cat.contains('event')) return Icons.event;
    if (cat.contains('task')) return Icons.check_circle_outline;
    if (cat.contains('budget') || cat.contains('expense')) return Icons.attach_money;
    if (cat.contains('health') || cat.contains('med')) return Icons.medication_outlined;
    if (e.pipelineStatus == 'needs_clarification') return Icons.warning_amber;
    return Icons.note_outlined;
  }

  String _statusLabel(NoteHistoryEntry e) {
    switch (e.pipelineStatus) {
      case 'needs_clarification':
        return 'Incomplete — tap to clarify';
      case 'error':
      case 'rejected':
        return 'Could not process';
      case 'processed':
      case 'accepted':
      case 'created':
      case 'complete':
        return e.category ?? 'Captured';
      default:
        return e.pipelineStatus ?? 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    final sorted = [...entries]..sort((a, b) {
      final aIncomplete = a.pipelineStatus == 'needs_clarification' ? 0 : 1;
      final bIncomplete = b.pipelineStatus == 'needs_clarification' ? 0 : 1;
      if (aIncomplete != bIncomplete) return aIncomplete.compareTo(bIncomplete);
      return b.createdAt.compareTo(a.createdAt);
    });

    if (sorted.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Recent captures will show here.',
          textAlign: TextAlign.center,
          style: BethTypography.body?.copyWith(color: BethColours.textMuted),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'RECENT CAPTURES',
            style: BethTypography.caption?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
        ),
        ...sorted.take(40).map((e) {
          final incomplete = e.pipelineStatus == 'needs_clarification';
          final canUndo = undoableEntryId == e.id && onUndo != null;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: incomplete
                  ? BethColours.amber.withOpacity(0.2)
                  : BethColours.primary.withOpacity(0.12),
              child: Icon(
                _iconFor(e),
                size: 18,
                color: incomplete ? BethColours.amber : BethColours.primary,
              ),
            ),
            title: Text(
              e.rawText,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: BethTypography.bodySmall,
            ),
            subtitle: Text(
              incomplete ? '⚠ ${_statusLabel(e)}' : _statusLabel(e),
              style: BethTypography.caption?.copyWith(
                color: incomplete ? BethColours.amber : BethColours.textMuted,
              ),
            ),
            trailing: canUndo
                ? TextButton(
                    onPressed: () => onUndo!(e),
                    child: const Text('Undo'),
                  )
                : Text(
                    _timeLabel(e.createdAt),
                    style: BethTypography.caption,
                  ),
            onTap: incomplete && onTapIncomplete != null
                ? () => onTapIncomplete!(e)
                : null,
          );
        }),
      ],
    );
  }

  String _timeLabel(DateTime dt) {
    final h = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final m = dt.minute.toString().padLeft(2, '0');
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    return '$h:$m $ampm';
  }
}
