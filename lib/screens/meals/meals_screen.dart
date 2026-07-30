import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../providers/family_hub_provider.dart';
import '../../providers/meals_provider.dart';
import '../../theme/colours.dart';
import '../../theme/typography.dart';

class MealsScreen extends StatefulWidget {
  const MealsScreen({super.key});

  @override
  State<MealsScreen> createState() => _MealsScreenState();
}

class _MealsScreenState extends State<MealsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 5, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MealsProvider>().load();
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();
    final allergyNote = _allergySubtitle(context);

    return Scaffold(
      backgroundColor: BethColours.background,
      appBar: AppBar(
        backgroundColor: BethColours.surface,
        title: const Text('Meals', style: BethTypography.heading),
        bottom: TabBar(
          controller: _tabs,
          isScrollable: true,
          labelColor: BethColours.primary,
          unselectedLabelColor: BethColours.textMuted,
          tabs: const [
            Tab(text: 'Plan'),
            Tab(text: 'Meals'),
            Tab(text: 'Shopping'),
            Tab(text: 'Pantry'),
            Tab(text: 'BLW'),
          ],
        ),
      ),
      body: !meals.isLoaded
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                if (allergyNote != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    color: BethColours.amber.withOpacity(0.12),
                    child: Text(allergyNote, style: BethTypography.caption),
                  ),
                Expanded(
                  child: TabBarView(
                    controller: _tabs,
                    children: const [
                      _PlanTab(),
                      _MealsTab(),
                      _ShoppingTab(),
                      _PantryTab(),
                      _BlwTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  String? _allergySubtitle(BuildContext context) {
    try {
      final hub = context.watch<FamilyHubProvider>();
      final notes = hub.people
          .where((p) => !p.isPet && p.notes != null && p.notes!.trim().isNotEmpty)
          .where((p) {
            final n = p.notes!.toLowerCase();
            return n.contains('allerg') ||
                n.contains('intoleran') ||
                n.contains('dietary') ||
                n.contains('gluten') ||
                n.contains('dairy');
          })
          .map((p) => '${p.displayName}: ${p.notes}')
          .take(2)
          .toList();
      if (notes.isEmpty) return null;
      return 'Household notes · ${notes.join(' · ')}';
    } catch (_) {
      return null;
    }
  }
}

class _PlanTab extends StatelessWidget {
  const _PlanTab();

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Week of ${DateFormat('d MMM').format(monday)}',
          style: BethTypography.subheading,
        ),
        const SizedBox(height: 8),
        ...days.map((day) {
          final slots = meals.planDays.where(
            (p) =>
                p.date.year == day.year &&
                p.date.month == day.month &&
                p.date.day == day.day,
          );
          final dinner = slots.where((s) => s.mealSlot == 'dinner').toList();
          final label = dinner.isEmpty
              ? 'No dinner set'
              : (meals.mealById(dinner.first.mealId)?.title ??
                  dinner.first.note ??
                  'Planned');
          return ListTile(
            tileColor: BethColours.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            title: Text(
              DateFormat('EEE d').format(day),
              style: BethTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: BethColours.textPrimary,
              ),
            ),
            subtitle: Text(label),
            trailing: const Icon(Icons.edit_outlined, size: 18),
            onTap: () => _assign(context, day),
          );
        }),
        const SizedBox(height: 16),
        Text('Cook with what you have', style: BethTypography.caption),
        const SizedBox(height: 8),
        ...() {
          final suggestions = meals.cookWithWhatYouHave();
          if (suggestions.isEmpty) {
            return [
              Text(
                'Add pantry items and meal ingredients to see suggestions.',
                style: BethTypography.bodySmall,
              ),
            ];
          }
          return suggestions
              .take(5)
              .map(
                (m) => ListTile(
                  dense: true,
                  title: Text(m.title),
                  subtitle: Text(m.ingredients.join(', ')),
                ),
              )
              .toList();
        }(),
      ],
    );
  }

  Future<void> _assign(BuildContext context, DateTime day) async {
    final meals = context.read<MealsProvider>();
    String? mealId = meals.meals.isNotEmpty ? meals.meals.first.id : null;
    final note = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: Text('Dinner · ${DateFormat('EEE d').format(day)}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (meals.meals.isEmpty)
                const Text('Add a meal first, or type a label below.')
              else
                DropdownButtonFormField<String>(
                  value: mealId,
                  items: meals.meals
                      .map(
                        (m) => DropdownMenuItem(
                          value: m.id,
                          child: Text(m.title),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => setModal(() => mealId = v),
                  decoration: const InputDecoration(labelText: 'Meal'),
                ),
              TextField(
                controller: note,
                decoration: const InputDecoration(
                  labelText: 'Or custom label / note',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || !context.mounted) return;
    await meals.assignMealToDay(
      date: day,
      mealSlot: 'dinner',
      mealId: mealId,
      note: note.text.trim().isEmpty ? null : note.text.trim(),
    );
  }
}

class _MealsTab extends StatelessWidget {
  const _MealsTab();

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: meals.meals.isEmpty
          ? Center(
              child: Text('No meals yet.', style: BethTypography.bodySmall),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: meals.meals.length,
              itemBuilder: (context, i) {
                final m = meals.meals[i];
                return ListTile(
                  tileColor: BethColours.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(m.title),
                  subtitle: Text(
                    [
                      if (m.ingredients.isNotEmpty)
                        m.ingredients.join(', '),
                      if (m.childVariation != null)
                        'Child: ${m.childVariation}',
                    ].join('\n'),
                  ),
                  isThreeLine: m.childVariation != null,
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () =>
                        context.read<MealsProvider>().deleteMeal(m.id),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final title = TextEditingController();
    final base = TextEditingController();
    final child = TextEditingController();
    final ingredients = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add meal'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: title,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: base,
                decoration: const InputDecoration(labelText: 'Base notes'),
                maxLines: 2,
              ),
              TextField(
                controller: child,
                decoration: const InputDecoration(
                  labelText: 'Child variation notes',
                ),
                maxLines: 2,
              ),
              TextField(
                controller: ingredients,
                decoration: const InputDecoration(
                  labelText: 'Ingredients (comma-separated)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true || title.text.trim().isEmpty || !context.mounted) return;
    await context.read<MealsProvider>().addMeal(
          title: title.text.trim(),
          baseRecipe: base.text.trim().isEmpty ? null : base.text.trim(),
          childVariation: child.text.trim().isEmpty ? null : child.text.trim(),
          ingredients: ingredients.text
              .split(',')
              .map((s) => s.trim())
              .where((s) => s.isNotEmpty)
              .toList(),
        );
  }
}

class _ShoppingTab extends StatelessWidget {
  const _ShoppingTab();

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: meals.shopping.isEmpty
          ? Center(
              child: Text('List is empty.', style: BethTypography.bodySmall),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: meals.shopping.length,
              itemBuilder: (context, i) {
                final item = meals.shopping[i];
                return CheckboxListTile(
                  value: item.checked,
                  onChanged: (_) => context
                      .read<MealsProvider>()
                      .toggleShoppingChecked(item.id),
                  title: Text(
                    item.name,
                    style: TextStyle(
                      decoration:
                          item.checked ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  subtitle: item.quantity != null ? Text(item.quantity!) : null,
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context
                        .read<MealsProvider>()
                        .deleteShoppingItem(item.id),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final name = TextEditingController();
    final qty = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Item'),
              autofocus: true,
            ),
            TextField(
              controller: qty,
              decoration: const InputDecoration(labelText: 'Quantity'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Add'),
          ),
        ],
      ),
    );
    if (ok != true || name.text.trim().isEmpty || !context.mounted) return;
    await context.read<MealsProvider>().addShoppingItem(
          name: name.text.trim(),
          quantity: qty.text.trim().isEmpty ? null : qty.text.trim(),
        );
  }
}

class _PantryTab extends StatelessWidget {
  const _PantryTab();

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: meals.pantry.isEmpty
          ? Center(
              child: Text('Pantry is empty.', style: BethTypography.bodySmall),
            )
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              itemCount: meals.pantry.length,
              itemBuilder: (context, i) {
                final item = meals.pantry[i];
                return ListTile(
                  tileColor: item.isExpiringSoon
                      ? BethColours.amber.withOpacity(0.12)
                      : BethColours.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  title: Text(item.name),
                  subtitle: Text(
                    [
                      if (item.quantity != null) item.quantity!,
                      item.location,
                      if (item.expiresAt != null)
                        'Exp ${DateFormat('d MMM').format(item.expiresAt!)}',
                    ].join(' · '),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => context
                        .read<MealsProvider>()
                        .deletePantryItem(item.id),
                  ),
                );
              },
            ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final name = TextEditingController();
    final qty = TextEditingController();
    DateTime? expiry;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModal) => AlertDialog(
          title: const Text('Add pantry item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: name,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: qty,
                decoration: const InputDecoration(labelText: 'Quantity'),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  expiry == null
                      ? 'Expiry (optional)'
                      : DateFormat('d MMM yyyy').format(expiry!),
                ),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: ctx,
                    initialDate: DateTime.now().add(const Duration(days: 7)),
                    firstDate: DateTime.now().subtract(const Duration(days: 1)),
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (picked != null) setModal(() => expiry = picked);
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, true),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
    if (ok != true || name.text.trim().isEmpty || !context.mounted) return;
    await context.read<MealsProvider>().addPantryItem(
          name: name.text.trim(),
          quantity: qty.text.trim().isEmpty ? null : qty.text.trim(),
          expiresAt: expiry,
        );
  }
}

class _BlwTab extends StatelessWidget {
  const _BlwTab();

  @override
  Widget build(BuildContext context) {
    final meals = context.watch<MealsProvider>();

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: BethColours.primary,
        onPressed: () => _add(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        children: [
          Text(
            'Baby-led weaning exposures — log foods tried and any reaction notes. '
            'Not medical advice; follow your health professional for allergens.',
            style: BethTypography.caption,
          ),
          const SizedBox(height: 12),
          if (meals.blwExposures.isEmpty)
            Text('No exposures logged.', style: BethTypography.bodySmall)
          else
            ...meals.blwExposures.map((e) {
              return ListTile(
                tileColor: BethColours.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                title: Text(e.foodName),
                subtitle: Text(
                  [
                    DateFormat('d MMM').format(e.firstTriedAt),
                    if (e.reaction != null) e.reaction!,
                    if (e.notes != null) e.notes!,
                  ].join(' · '),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => context
                      .read<MealsProvider>()
                      .deleteBlwExposure(e.id),
                ),
              );
            }),
        ],
      ),
    );
  }

  Future<void> _add(BuildContext context) async {
    final food = TextEditingController();
    final reaction = TextEditingController();
    final notes = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log BLW exposure'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: food,
              decoration: const InputDecoration(labelText: 'Food'),
            ),
            TextField(
              controller: reaction,
              decoration: const InputDecoration(labelText: 'Reaction'),
            ),
            TextField(
              controller: notes,
              decoration: const InputDecoration(labelText: 'Notes'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (ok != true || food.text.trim().isEmpty || !context.mounted) return;
    await context.read<MealsProvider>().addBlwExposure(
          foodName: food.text.trim(),
          reaction:
              reaction.text.trim().isEmpty ? null : reaction.text.trim(),
          notes: notes.text.trim().isEmpty ? null : notes.text.trim(),
        );
  }
}
