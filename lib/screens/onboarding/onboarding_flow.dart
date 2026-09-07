import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/household_provider.dart';
import '../../providers/instance_library_provider.dart';
import '../../providers/module_registry_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';
import '../../utils/constants.dart';

enum OnboardingTier { fullCustom, defaultLearning, instanceGrowth }

class OnboardingFlow extends StatefulWidget {
  const OnboardingFlow({super.key});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
  int _step = 0;
  OnboardingTier _tier = OnboardingTier.defaultLearning;
  final Set<String> _selectedModules = {};
  final Set<String> _selectedInstances = {...InstanceLibraryProvider.defaultLearningIds};
  final _householdName = TextEditingController(text: 'My household');
  final _inviteCode = TextEditingController();
  bool _createHousehold = true;
  bool _busy = false;
  String? _error;

  @override
  void dispose() {
    _householdName.dispose();
    _inviteCode.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    final auth = context.read<AuthProvider>();
    final household = context.read<HouseholdProvider>();
    final library = context.read<InstanceLibraryProvider>();
    final modules = context.read<ModuleRegistryProvider>();
    final userId = auth.user!.id;

    if (_createHousehold) {
      final err = await household.createHousehold(
        userId: userId,
        name: _householdName.text,
      );
      if (err != null) {
        setState(() {
          _busy = false;
          _error = err;
        });
        return;
      }
    } else {
      final err = await household.joinHousehold(
        userId: userId,
        inviteCode: _inviteCode.text,
      );
      if (err != null) {
        setState(() {
          _busy = false;
          _error = err;
        });
        return;
      }
    }

    if (_tier == OnboardingTier.fullCustom) {
      await library.applyFullCustom(_selectedInstances);
      for (final m in modules.manageableModules) {
        if (_selectedModules.contains(m.id)) {
          modules.activateModule(m.id);
        } else {
          modules.deactivateModule(m.id);
        }
      }
    } else if (_tier == OnboardingTier.defaultLearning) {
      await library.applyDefaultLearning();
    } else {
      await library.applyDefaultLearning();
    }

    final tierKey = switch (_tier) {
      OnboardingTier.fullCustom => 'full_custom',
      OnboardingTier.defaultLearning => 'default_learning',
      OnboardingTier.instanceGrowth => 'instance_growth',
    };
    await auth.completeOnboarding(tierKey);
    if (!mounted) return;
    setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final modules = context.watch<ModuleRegistryProvider>();
    final instances = InstanceRegistry.instances;

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        title: Text('Set up Tether (${_step + 1}/4)'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (_step == 0) ...[
            Text('How would you like to start?', style: BethTypography.subheading),
            const SizedBox(height: 12),
            _tierTile(
              tier: OnboardingTier.defaultLearning,
              title: 'Default learning',
              subtitle: 'Pre-named team (Viva, Val, Ellory, Tim, Rae). Edit anytime.',
            ),
            _tierTile(
              tier: OnboardingTier.fullCustom,
              title: 'Full custom',
              subtitle: 'Pick your modules and instances manually.',
            ),
            _tierTile(
              tier: OnboardingTier.instanceGrowth,
              title: 'Instance growth',
              subtitle: 'Start with defaults; Tether suggests changes over time.',
            ),
          ],
          if (_step == 1 && _tier == OnboardingTier.fullCustom) ...[
            Text('Choose modules', style: BethTypography.subheading),
            const SizedBox(height: 8),
            ...modules.manageableModules.map((m) {
              final active = _selectedModules.contains(m.id);
              return CheckboxListTile(
                value: active,
                onChanged: (v) => setState(() {
                  if (v == true) {
                    _selectedModules.add(m.id);
                  } else {
                    _selectedModules.remove(m.id);
                  }
                }),
                title: Text(m.title),
                subtitle: Text(m.description ?? ''),
              );
            }),
            const SizedBox(height: 16),
            Text('Choose instances (min ${InstanceLibraryProvider.minInstances})',
                style: BethTypography.subheading),
            ...instances.map((i) {
              final id = i['id'] as String;
              return CheckboxListTile(
                value: _selectedInstances.contains(id),
                onChanged: (v) => setState(() {
                  if (v == true) {
                    if (_selectedInstances.length < InstanceLibraryProvider.maxInstances) {
                      _selectedInstances.add(id);
                    }
                  } else if (_selectedInstances.length > InstanceLibraryProvider.minInstances) {
                    _selectedInstances.remove(id);
                  }
                }),
                title: Text(i['name'] as String),
                subtitle: Text(i['domain'] as String? ?? ''),
              );
            }),
          ],
          if (_step == 1 && _tier != OnboardingTier.fullCustom) ...[
            Text('Your starting team', style: BethTypography.subheading),
            const SizedBox(height: 8),
            Text(
              _tier == OnboardingTier.instanceGrowth
                  ? 'We will start with the default team and suggest adjustments as you use Tether.'
                  : 'These instances will be active on your Team grid. You can change them in Settings.',
              style: BethTypography.bodySmall,
            ),
            const SizedBox(height: 12),
            ...InstanceLibraryProvider.defaultLearningIds.map((id) {
              final i = InstanceRegistry.getById(id);
              if (i == null) return const SizedBox.shrink();
              return ListTile(
                leading: CircleAvatar(child: Text((i['name'] as String)[0])),
                title: Text(i['name'] as String),
                subtitle: Text(i['domain'] as String? ?? ''),
              );
            }),
          ],
          if (_step == 2) ...[
            Text('Your household', style: BethTypography.subheading),
            const SizedBox(height: 8),
            SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: true, label: Text('Create')),
                ButtonSegment(value: false, label: Text('Join')),
              ],
              selected: {_createHousehold},
              onSelectionChanged: (s) => setState(() => _createHousehold = s.first),
            ),
            const SizedBox(height: 16),
            if (_createHousehold)
              TextField(
                controller: _householdName,
                decoration: const InputDecoration(
                  labelText: 'Household name',
                  border: OutlineInputBorder(),
                ),
              )
            else
              TextField(
                controller: _inviteCode,
                decoration: const InputDecoration(
                  labelText: 'Invite code',
                  border: OutlineInputBorder(),
                  hintText: '6-character code',
                ),
                textCapitalization: TextCapitalization.characters,
              ),
          ],
          if (_step == 3) ...[
            Text('Ready to go', style: BethTypography.subheading),
            const SizedBox(height: 8),
            Text(
              'Your account, household, and starting team will be saved on this device. '
              'Cloud sync arrives in a later phase.',
              style: BethTypography.bodySmall,
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ],
          const SizedBox(height: 24),
          Row(
            children: [
              if (_step > 0)
                OutlinedButton(
                  onPressed: _busy ? null : () => setState(() => _step -= 1),
                  child: const Text('Back'),
                ),
              const Spacer(),
              FilledButton(
                onPressed: _busy
                    ? null
                    : () {
                        if (_step < 3) {
                          if (_step == 0 && _tier == OnboardingTier.fullCustom) {
                            final modules = context.read<ModuleRegistryProvider>();
                            _selectedModules
                              ..clear()
                              ..addAll(
                                modules.manageableModules
                                    .where((m) => modules.isModuleActive(m.id))
                                    .map((m) => m.id),
                              );
                          }
                          if (_step == 1 &&
                              _tier == OnboardingTier.fullCustom &&
                              (_selectedModules.isEmpty ||
                                  _selectedInstances.length <
                                      InstanceLibraryProvider.minInstances)) {
                            setState(() => _error =
                                'Pick at least one module and ${InstanceLibraryProvider.minInstances} instances.');
                            return;
                          }
                          setState(() {
                            _step += 1;
                            _error = null;
                          });
                        } else {
                          _finish();
                        }
                      },
                child: _busy
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(_step < 3 ? 'Continue' : 'Finish setup'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tierTile({
    required OnboardingTier tier,
    required String title,
    required String subtitle,
  }) {
    final selected = _tier == tier;
    return Card(
      color: selected ? BethColours.primary.withOpacity(0.08) : BethColours.surface,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle, style: BethTypography.caption),
        trailing: selected ? const Icon(Icons.check_circle, color: BethColours.primary) : null,
        onTap: () => setState(() => _tier = tier),
      ),
    );
  }
}
