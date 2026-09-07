import 'package:flutter/material.dart';
import '../../database/activity_ledger_dao.dart';
import '../../services/activity_ledger_service.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class UserActivityLedgerScreen extends StatefulWidget {
  const UserActivityLedgerScreen({super.key});

  @override
  State<UserActivityLedgerScreen> createState() => _UserActivityLedgerScreenState();
}

class _UserActivityLedgerScreenState extends State<UserActivityLedgerScreen> {
  List<ActivityLedgerEntry> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final entries = await ActivityLedgerService.instance.recent();
    if (!mounted) return;
    setState(() {
      _entries = entries;
      _loading = false;
    });
  }

  String _formatWhen(DateTime dt) {
    final local = dt.toLocal();
    return '${local.day}/${local.month}/${local.year} · '
        '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User activity ledger'),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _load),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Actions you take in Tether will appear here in plain English.',
                      style: BethTypography.body?.copyWith(color: BethColours.textMuted),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _entries.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final e = _entries[index];
                    return ListTile(
                      title: Text(e.action),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (e.detail != null && e.detail!.isNotEmpty) Text(e.detail!),
                          Text(
                            '${e.actorLabel} · ${_formatWhen(e.createdAt)}',
                            style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                          ),
                          if (e.sharedWith != null)
                            Text('Shared with: ${e.sharedWith}', style: BethTypography.caption),
                        ],
                      ),
                      isThreeLine: true,
                    );
                  },
                ),
    );
  }
}
