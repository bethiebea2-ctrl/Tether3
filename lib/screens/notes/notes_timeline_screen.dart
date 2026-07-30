import 'package:flutter/material.dart';
import '../../models/note_history_entry.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

/// Canonical Phase 1D note folders.
const noteFolderIds = [
  'Scheduling',
  'Shopping',
  'Tasks',
  'Health',
  'Family',
  'Budget',
  'Ideas',
  'Correspondence',
  'Random',
];

String normalizeNoteFolder(String? category) {
  final c = (category ?? '').toLowerCase();
  if (c.contains('schedul') || c.contains('event') || c.contains('calendar')) {
    return 'Scheduling';
  }
  if (c.contains('shop') || c.contains('groc') || c.contains('pantry')) {
    return 'Shopping';
  }
  if (c.contains('task') || c.contains('todo')) return 'Tasks';
  if (c.contains('health') || c.contains('med') || c.contains('symptom')) {
    return 'Health';
  }
  if (c.contains('family') || c.contains('feed') || c.contains('child') || c.contains('baby')) {
    return 'Family';
  }
  if (c.contains('budget') || c.contains('money') || c.contains('expense') || c.contains('bill')) {
    return 'Budget';
  }
  if (c.contains('idea') || c.contains('dream')) return 'Ideas';
  if (c.contains('correspond') || c.contains('email') || c.contains('message') || c.contains('draft')) {
    return 'Correspondence';
  }
  if (c.isEmpty) return 'Random';
  // Map unknown categories into closest folder or Random
  for (final f in noteFolderIds) {
    if (c == f.toLowerCase()) return f;
  }
  return 'Random';
}

class NotesTimelineScreen extends StatefulWidget {
  final List<NoteHistoryEntry> entries;
  final ValueChanged<NoteHistoryEntry>? onTapIncomplete;

  const NotesTimelineScreen({
    super.key,
    required this.entries,
    this.onTapIncomplete,
  });

  @override
  State<NotesTimelineScreen> createState() => _NotesTimelineScreenState();
}

class _NotesTimelineScreenState extends State<NotesTimelineScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  String? _folderFilter;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  List<NoteHistoryEntry> get _filtered {
    var list = [...widget.entries];
    if (_folderFilter != null) {
      list = list.where((e) => normalizeNoteFolder(e.category) == _folderFilter).toList();
    }
    if (_query.trim().isNotEmpty) {
      final q = _query.toLowerCase();
      list = list.where((e) {
        return e.rawText.toLowerCase().contains(q) ||
            (e.responseText ?? '').toLowerCase().contains(q) ||
            (e.category ?? '').toLowerCase().contains(q);
      }).toList();
    }
    list.sort((a, b) {
      final aInc = a.pipelineStatus == 'needs_clarification' ? 0 : 1;
      final bInc = b.pipelineStatus == 'needs_clarification' ? 0 : 1;
      if (aInc != bInc) return aInc.compareTo(bInc);
      return b.createdAt.compareTo(a.createdAt);
    });
    return list;
  }

  Map<String, List<NoteHistoryEntry>> get _byDay {
    final map = <String, List<NoteHistoryEntry>>{};
    for (final e in _filtered) {
      final key =
          '${e.createdAt.year}-${e.createdAt.month.toString().padLeft(2, '0')}-${e.createdAt.day.toString().padLeft(2, '0')}';
      map.putIfAbsent(key, () => []).add(e);
    }
    return map;
  }

  Map<String, List<NoteHistoryEntry>> get _byFolder {
    final map = {for (final f in noteFolderIds) f: <NoteHistoryEntry>[]};
    for (final e in _filtered) {
      map.putIfAbsent(normalizeNoteFolder(e.category), () => []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Captures'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Timeline'),
            Tab(text: 'Folders'),
            Tab(text: 'Search'),
          ],
        ),
      ),
      body: Column(
        children: [
          if (_folderFilter != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: InputChip(
                  label: Text('Folder: $_folderFilter'),
                  onDeleted: () => setState(() => _folderFilter = null),
                ),
              ),
            ),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: [
                _timelineTab(),
                _foldersTab(),
                _searchTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _timelineTab() {
    final byDay = _byDay;
    if (byDay.isEmpty) {
      return Center(
        child: Text('No captures yet.', style: BethTypography.body.copyWith(color: BethColours.textMuted)),
      );
    }
    final days = byDay.keys.toList()..sort((a, b) => b.compareTo(a));
    return ListView.builder(
      itemCount: days.length,
      itemBuilder: (ctx, i) {
        final day = days[i];
        final items = byDay[day]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
              child: Text(day, style: BethTypography.caption.copyWith(color: BethColours.textMuted)),
            ),
            ...items.map(_entryTile),
          ],
        );
      },
    );
  }

  Widget _foldersTab() {
    final byFolder = _byFolder;
    return ListView(
      children: noteFolderIds.map((f) {
        final count = byFolder[f]?.length ?? 0;
        return ListTile(
          leading: const Icon(Icons.folder_outlined),
          title: Text(f),
          trailing: Text('$count', style: BethTypography.caption),
          onTap: () {
            setState(() {
              _folderFilter = f;
              _tabs.index = 0;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _searchTab() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Search all captures',
              border: OutlineInputBorder(),
            ),
            onChanged: (v) => setState(() => _query = v),
          ),
        ),
        Expanded(
          child: ListView(children: _filtered.map(_entryTile).toList()),
        ),
      ],
    );
  }

  Widget _entryTile(NoteHistoryEntry e) {
    final incomplete = e.pipelineStatus == 'needs_clarification';
    final folder = normalizeNoteFolder(e.category);
    final cleaned = e.responseText;
    return ListTile(
      leading: Icon(
        incomplete ? Icons.warning_amber : Icons.note_outlined,
        color: incomplete ? BethColours.amber : BethColours.primary,
      ),
      title: Text(e.rawText, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: Text(
        incomplete
            ? '⚠ Incomplete — tap to clarify · $folder'
            : cleaned != null && cleaned.isNotEmpty
                ? 'Cleaned: $cleaned\nMessy original kept · $folder'
                : folder,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: BethTypography.caption.copyWith(
          color: incomplete ? BethColours.amber : BethColours.textMuted,
        ),
      ),
      isThreeLine: cleaned != null && cleaned.isNotEmpty,
      onTap: incomplete && widget.onTapIncomplete != null
          ? () => widget.onTapIncomplete!(e)
          : () => _showDetail(e),
    );
  }

  void _showDetail(NoteHistoryEntry e) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Capture detail', style: BethTypography.subheading),
            const SizedBox(height: 8),
            Text('Messy original', style: BethTypography.caption),
            Text(e.rawText),
            if (e.responseText != null && e.responseText!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text('Cleaned result', style: BethTypography.caption),
              Text(e.responseText!),
            ],
            const SizedBox(height: 8),
            Text(
              'Folder: ${normalizeNoteFolder(e.category)} · ${e.createdAt}',
              style: BethTypography.caption.copyWith(color: BethColours.textMuted),
            ),
          ],
        ),
      ),
    );
  }
}
