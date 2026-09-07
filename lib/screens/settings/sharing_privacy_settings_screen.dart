import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../database/share_permissions_dao.dart';
import '../../models/household.dart';
import '../../providers/auth_provider.dart';
import '../../providers/household_provider.dart';
import '../../services/activity_ledger_service.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class SharingPrivacySettingsScreen extends StatefulWidget {
  const SharingPrivacySettingsScreen({super.key});

  @override
  State<SharingPrivacySettingsScreen> createState() => _SharingPrivacySettingsScreenState();
}

class _SharingPrivacySettingsScreenState extends State<SharingPrivacySettingsScreen> {
  final SharePermissionsDao _dao = SharePermissionsDao();
  List<SharePermission> _permissions = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final householdId = context.read<HouseholdProvider>().household?.id;
    if (householdId == null) {
      setState(() => _loading = false);
      return;
    }
    final rows = await _dao.forHousehold(householdId);
    if (!mounted) return;
    setState(() {
      _permissions = rows;
      _loading = false;
    });
  }

  Future<void> _setMaster(String role, bool enabled) async {
    final householdId = context.read<HouseholdProvider>().household?.id;
    if (householdId == null) return;
    await _dao.setRoleMaster(householdId: householdId, viewerRole: role, enabled: enabled);
    await _load();
    final auth = context.read<AuthProvider>();
    await ActivityLedgerService.instance.log(
      action: enabled ? 'Enabled sharing for ${householdRoleLabel(role)}' : 'Disabled sharing for ${householdRoleLabel(role)}',
      userId: auth.user?.id,
      householdId: householdId,
      dataUsed: 'D1–D3',
      sharedWith: householdRoleLabel(role),
    );
  }

  Future<void> _setToggle(SharePermission p, bool enabled) async {
    if (p.sensitivity == 'D4') return;
    await _dao.setEnabled(
      householdId: p.householdId,
      viewerRole: p.viewerRole,
      sensitivity: p.sensitivity,
      enabled: enabled,
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final household = context.watch<HouseholdProvider>().household;

    return Scaffold(
      appBar: AppBar(title: const Text('Sharing & privacy')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : household == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      'Create a household first to configure sharing.',
                      style: BethTypography.body,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Private by default. Master toggles apply to D1–D3 for each role. '
                      'D4 (crisis plans, panic logs) is never shared.',
                      style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
                    ),
                    const SizedBox(height: 16),
                    ...shareViewerRoles.map((role) {
                      final master = _dao.roleMasterEnabled(_permissions, role);
                      final roleRows = _permissions.where((p) => p.viewerRole == role);
                      return ExpansionTile(
                        title: Text(householdRoleLabel(role)),
                        subtitle: Text(master ? 'Sharing on (D1–D3)' : 'Private'),
                        trailing: Switch(
                          value: master,
                          onChanged: (v) => _setMaster(role, v),
                        ),
                        children: roleRows.map((p) {
                          final isD4 = p.sensitivity == 'D4';
                          return SwitchListTile(
                            title: Text('${p.sensitivity} data'),
                            subtitle: Text(_sensitivityHint(p.sensitivity)),
                            value: p.enabled,
                            onChanged: isD4 ? null : (v) => _setToggle(p, v),
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
    );
  }

  String _sensitivityHint(String level) {
    return switch (level) {
      'D1' => 'Routine — calendar, tasks, meals',
      'D2' => 'Personal — health notes, budget summaries',
      'D3' => 'Sensitive — reproductive, MH patterns',
      'D4' => 'Never shared — crisis, panic, hidden notes',
      _ => level,
    };
  }
}
