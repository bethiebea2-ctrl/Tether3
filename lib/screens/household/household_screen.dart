import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../models/household.dart';
import '../../providers/auth_provider.dart';
import '../../providers/household_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class HouseholdScreen extends StatelessWidget {
  const HouseholdScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final household = context.watch<HouseholdProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Household')),
      body: !household.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : household.household == null
              ? _NoHouseholdBody(userId: auth.user!.id)
              : _HouseholdBody(household: household.household!, members: household.members),
    );
  }
}

class _NoHouseholdBody extends StatefulWidget {
  const _NoHouseholdBody({required this.userId});
  final String userId;

  @override
  State<_NoHouseholdBody> createState() => _NoHouseholdBodyState();
}

class _NoHouseholdBodyState extends State<_NoHouseholdBody> {
  final _name = TextEditingController(text: 'My household');
  final _code = TextEditingController();
  bool _create = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _code.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final provider = context.read<HouseholdProvider>();
    final err = _create
        ? await provider.createHousehold(userId: widget.userId, name: _name.text)
        : await provider.joinHousehold(userId: widget.userId, inviteCode: _code.text);
    if (!mounted) return;
    setState(() {
      _busy = false;
      _error = err;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Create or join a household', style: BethTypography.subheading),
        SegmentedButton<bool>(
          segments: const [
            ButtonSegment(value: true, label: Text('Create')),
            ButtonSegment(value: false, label: Text('Join')),
          ],
          selected: {_create},
          onSelectionChanged: (s) => setState(() => _create = s.first),
        ),
        const SizedBox(height: 16),
        if (_create)
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Household name', border: OutlineInputBorder()),
          )
        else
          TextField(
            controller: _code,
            decoration: const InputDecoration(labelText: 'Invite code', border: OutlineInputBorder()),
            textCapitalization: TextCapitalization.characters,
          ),
        if (_error != null) ...[
          const SizedBox(height: 8),
          Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
        ],
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: Text(_create ? 'Create household' : 'Join household'),
        ),
      ],
    );
  }
}

class _HouseholdBody extends StatelessWidget {
  const _HouseholdBody({required this.household, required this.members});
  final Household household;
  final List<HouseholdMember> members;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ListTile(
          leading: const Icon(Icons.home_outlined),
          title: Text(household.name, style: BethTypography.subheading),
          subtitle: const Text('Your connected household'),
        ),
        const Divider(),
        ListTile(
          title: const Text('Invite code'),
          subtitle: Text(household.inviteCode, style: BethTypography.body?.copyWith(letterSpacing: 2)),
          trailing: IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: household.inviteCode));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Invite code copied')),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Share this code so a partner or carer can join on their device (local MVP — cloud sync later).',
            style: BethTypography.caption?.copyWith(color: BethColours.textMuted),
          ),
        ),
        const SizedBox(height: 16),
        Text('Members', style: BethTypography.subheading),
        ...members.map(
          (m) => ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(m.userId == household.ownerUserId ? 'You (owner)' : 'Member'),
            subtitle: Text(householdRoleLabel(m.role)),
          ),
        ),
      ],
    );
  }
}
