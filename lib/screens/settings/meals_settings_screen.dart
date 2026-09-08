import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/meal_prefs_models.dart';
import '../../providers/family_hub_provider.dart';
import '../../providers/meals_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

const _equipmentOptions = [
  'Oven',
  'Stovetop',
  'Microwave',
  'Air fryer',
  'Slow cooker',
  'Instant pot',
  'BBQ',
  'Thermomix',
];

const _skillOptions = ['beginner', 'comfortable', 'confident'];

class MealsSettingsScreen extends StatefulWidget {
  const MealsSettingsScreen({super.key});

  @override
  State<MealsSettingsScreen> createState() => _MealsSettingsScreenState();
}

class _MealsSettingsScreenState extends State<MealsSettingsScreen> {
  final _householdNotes = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<MealsProvider>().load();
      await context.read<FamilyHubProvider>().load();
      if (mounted) {
        _householdNotes.text = context.read<MealsProvider>().householdPrefs.householdNotes;
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _householdNotes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();
    final hub = context.watch<FamilyHubProvider>();
    final household = meals.householdPrefs;
    final people = [
      ...hub.localHouseholdPeople,
      ...hub.partners,
      ...hub.connectedAwayPeople,
    ].where((p) => !p.isPet).toList();

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(title: const Text('Meals preferences')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Household cooking', style: BethTypography.subheading),
          const SizedBox(height: 8),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Default servings'),
            trailing: DropdownButton<int>(
              value: meals.defaultServings.clamp(1, 12),
              items: List.generate(
                12,
                (i) => DropdownMenuItem(value: i + 1, child: Text('${i + 1}')),
              ),
              onChanged: (v) {
                if (v != null) meals.setDefaultServings(v);
              },
            ),
          ),
          DropdownButtonFormField<String>(
            value: _skillOptions.contains(household.skillLevel)
                ? household.skillLevel
                : 'comfortable',
            decoration: const InputDecoration(labelText: 'Cooking skill level'),
            items: const [
              DropdownMenuItem(value: 'beginner', child: Text('Beginner')),
              DropdownMenuItem(value: 'comfortable', child: Text('Comfortable')),
              DropdownMenuItem(value: 'confident', child: Text('Confident')),
            ],
            onChanged: (v) {
              if (v == null) return;
              meals.saveHouseholdPrefs(household.copyWith(skillLevel: v));
            },
          ),
          const SizedBox(height: 12),
          Text('Cooking equipment', style: BethTypography.caption),
          Wrap(
            spacing: 8,
            children: _equipmentOptions.map((eq) {
              final selected = household.cookingEquipment.contains(eq);
              return FilterChip(
                label: Text(eq),
                selected: selected,
                onSelected: (on) {
                  final next = [...household.cookingEquipment];
                  if (on) {
                    next.add(eq);
                  } else {
                    next.remove(eq);
                  }
                  meals.saveHouseholdPrefs(household.copyWith(cookingEquipment: next));
                },
              );
            }).toList(),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Visual meal prompts'),
            subtitle: const Text('Prefer ingredient photos and step imagery when available'),
            value: household.visualPrompts,
            onChanged: (v) =>
                meals.saveHouseholdPrefs(household.copyWith(visualPrompts: v)),
          ),
          TextField(
            controller: _householdNotes,
            decoration: const InputDecoration(
              labelText: 'Household meal notes',
              hintText: 'Budget, time, energy, batch cooking…',
            ),
            maxLines: 2,
            onChanged: (v) =>
                meals.saveHouseholdPrefs(household.copyWith(householdNotes: v)),
          ),
          const Divider(height: 32),
          Text('Per-person preferences', style: BethTypography.subheading),
          const SizedBox(height: 4),
          Text(
            'Linked to Family Hub profiles — allergies, dislikes, and favourites.',
            style: BethTypography.caption,
          ),
          const SizedBox(height: 12),
          if (people.isEmpty)
            const ListTile(
              title: Text('Add people in Family Hub first'),
            )
          else
            ...people.map((p) => _PersonMealPrefsTile(
                  personId: p.id,
                  personName: p.displayName,
                )),
          const SizedBox(height: 24),
          Text(
            'Meals focuses on feeding your household — not dieting or body goals. '
            'Clinical allergies in Health Status can be linked separately later.',
            style: BethTypography.bodySmall.copyWith(color: BethColours.textMuted),
          ),
        ],
      ),
    );
  }
}

class _PersonMealPrefsTile extends StatefulWidget {
  const _PersonMealPrefsTile({
    required this.personId,
    required this.personName,
  });

  final String personId;
  final String personName;

  @override
  State<_PersonMealPrefsTile> createState() => _PersonMealPrefsTileState();
}

class _PersonMealPrefsTileState extends State<_PersonMealPrefsTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();
    final prefs = meals.prefsForPerson(widget.personId);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.personName),
            subtitle: Text(
              [
                prefs.dietaryPattern,
                if (prefs.allergies.isNotEmpty) 'Allergies: ${prefs.allergies.join(', ')}',
              ].join(' · '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: prefs.dietaryPattern,
                    decoration: const InputDecoration(labelText: 'Dietary pattern'),
                    items: const [
                      DropdownMenuItem(value: 'omnivore', child: Text('Omnivore')),
                      DropdownMenuItem(value: 'vegetarian', child: Text('Vegetarian')),
                      DropdownMenuItem(value: 'vegan', child: Text('Vegan')),
                      DropdownMenuItem(value: 'pescatarian', child: Text('Pescatarian')),
                      DropdownMenuItem(value: 'high_protein', child: Text('High protein')),
                      DropdownMenuItem(value: 'low_carb', child: Text('Low carb')),
                      DropdownMenuItem(value: 'high_fibre', child: Text('High fibre')),
                    ],
                    onChanged: (v) {
                      if (v == null) return;
                      meals.savePersonPrefs(prefs.copyWith(dietaryPattern: v));
                    },
                  ),
                  _tagField(
                    label: 'Allergies (comma separated)',
                    initial: prefs.allergies.join(', '),
                    onSave: (list) => meals.savePersonPrefs(prefs.copyWith(allergies: list)),
                  ),
                  _tagField(
                    label: 'Intolerances',
                    initial: prefs.intolerances.join(', '),
                    onSave: (list) => meals.savePersonPrefs(prefs.copyWith(intolerances: list)),
                  ),
                  _tagField(
                    label: 'Dislikes',
                    initial: prefs.dislikes.join(', '),
                    onSave: (list) => meals.savePersonPrefs(prefs.copyWith(dislikes: list)),
                  ),
                  _tagField(
                    label: 'Favourite foods',
                    initial: prefs.favorites.join(', '),
                    onSave: (list) => meals.savePersonPrefs(prefs.copyWith(favorites: list)),
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Medical / dietary notes',
                      hintText: 'Diabetes, post-surgery, deficiencies…',
                    ),
                    controller: TextEditingController(text: prefs.medicalNotes),
                    onSubmitted: (v) =>
                        meals.savePersonPrefs(prefs.copyWith(medicalNotes: v.trim())),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _tagField({
    required String label,
    required String initial,
    required ValueChanged<List<String>> onSave,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextField(
        decoration: InputDecoration(labelText: label),
        controller: TextEditingController(text: initial),
        onSubmitted: (v) {
          final list = v
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList();
          onSave(list);
        },
      ),
    );
  }
}
