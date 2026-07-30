import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/meals_dao.dart';
import '../models/meals_models.dart';

class MealsProvider extends ChangeNotifier {
  static const _prefsDefaultServings = 'meals_default_servings';

  final MealsDao _dao = MealsDao();
  final _uuid = const Uuid();

  List<Meal> _meals = [];
  List<MealPlanDay> _planDays = [];
  List<PantryItem> _pantry = [];
  List<ShoppingListItem> _shopping = [];
  List<BlwExposure> _blw = [];
  bool _loaded = false;
  int defaultServings = 4;

  List<Meal> get meals => List.unmodifiable(_meals);
  List<MealPlanDay> get planDays => List.unmodifiable(_planDays);
  List<PantryItem> get pantry => List.unmodifiable(_pantry);
  List<ShoppingListItem> get shopping => List.unmodifiable(_shopping);
  List<BlwExposure> get blwExposures => List.unmodifiable(_blw);
  bool get isLoaded => _loaded;

  Meal? mealById(String? id) {
    if (id == null) return null;
    try {
      return _meals.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    defaultServings = prefs.getInt(_prefsDefaultServings) ?? 4;
    _meals = await _dao.getMeals();
    _pantry = await _dao.getPantryItems();
    _shopping = await _dao.getShoppingItems();
    _blw = await _dao.getBlwExposures();
    await loadWeekPlan(DateTime.now());
    _loaded = true;
    notifyListeners();
  }

  Future<void> setDefaultServings(int n) async {
    defaultServings = n.clamp(1, 20);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefsDefaultServings, defaultServings);
    notifyListeners();
  }

  Future<void> loadWeekPlan(DateTime anyDayInWeek) async {
    final monday = anyDayInWeek.subtract(Duration(days: anyDayInWeek.weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    _planDays = await _dao.getPlanDays(monday, sunday);
    notifyListeners();
  }

  Future<void> addMeal({
    required String title,
    String? baseRecipe,
    String? childVariation,
    List<String> ingredients = const [],
    String? notes,
  }) async {
    final meal = Meal(
      id: _uuid.v4(),
      title: title,
      baseRecipe: baseRecipe,
      childVariation: childVariation,
      ingredients: ingredients,
      notes: notes,
      createdAt: DateTime.now(),
    );
    await _dao.upsertMeal(meal);
    _meals = [..._meals, meal]..sort((a, b) => a.title.compareTo(b.title));
    notifyListeners();
  }

  Future<void> deleteMeal(String id) async {
    await _dao.deleteMeal(id);
    _meals = _meals.where((m) => m.id != id).toList();
    notifyListeners();
  }

  Future<void> assignMealToDay({
    required DateTime date,
    required String mealSlot,
    String? mealId,
    String? note,
  }) async {
    final dayKey = DateTime(date.year, date.month, date.day);
    final existing = _planDays.where(
      (p) =>
          p.date.year == dayKey.year &&
          p.date.month == dayKey.month &&
          p.date.day == dayKey.day &&
          p.mealSlot == mealSlot,
    );
    final plan = MealPlanDay(
      id: existing.isEmpty ? _uuid.v4() : existing.first.id,
      date: dayKey,
      mealSlot: mealSlot,
      mealId: mealId,
      note: note,
    );
    await _dao.upsertPlanDay(plan);
    _planDays = [
      ..._planDays.where((p) => p.id != plan.id),
      plan,
    ]..sort((a, b) => a.date.compareTo(b.date));
    notifyListeners();
  }

  Future<void> addPantryItem({
    required String name,
    String? quantity,
    DateTime? expiresAt,
    String location = 'pantry',
  }) async {
    final item = PantryItem(
      id: _uuid.v4(),
      name: name,
      quantity: quantity,
      expiresAt: expiresAt,
      location: location,
      createdAt: DateTime.now(),
    );
    await _dao.upsertPantryItem(item);
    _pantry = [..._pantry, item]..sort((a, b) => a.name.compareTo(b.name));
    notifyListeners();
  }

  Future<void> deletePantryItem(String id) async {
    await _dao.deletePantryItem(id);
    _pantry = _pantry.where((p) => p.id != id).toList();
    notifyListeners();
  }

  Future<void> addShoppingItem({required String name, String? quantity}) async {
    final item = ShoppingListItem(
      id: _uuid.v4(),
      name: name,
      quantity: quantity,
      createdAt: DateTime.now(),
    );
    await _dao.upsertShoppingItem(item);
    _shopping = [..._shopping, item];
    notifyListeners();
  }

  Future<void> toggleShoppingChecked(String id) async {
    final idx = _shopping.indexWhere((s) => s.id == id);
    if (idx == -1) return;
    final updated = _shopping[idx].copyWith(checked: !_shopping[idx].checked);
    await _dao.upsertShoppingItem(updated);
    _shopping = [..._shopping]..[idx] = updated;
    notifyListeners();
  }

  Future<void> deleteShoppingItem(String id) async {
    await _dao.deleteShoppingItem(id);
    _shopping = _shopping.where((s) => s.id != id).toList();
    notifyListeners();
  }

  Future<void> addBlwExposure({
    required String foodName,
    String? reaction,
    String? notes,
  }) async {
    final exposure = BlwExposure(
      id: _uuid.v4(),
      foodName: foodName,
      firstTriedAt: DateTime.now(),
      reaction: reaction,
      notes: notes,
    );
    await _dao.insertBlwExposure(exposure);
    _blw = [exposure, ..._blw];
    notifyListeners();
  }

  Future<void> deleteBlwExposure(String id) async {
    await _dao.deleteBlwExposure(id);
    _blw = _blw.where((b) => b.id != id).toList();
    notifyListeners();
  }

  /// Loose match: meal ingredients that appear in pantry names (or vice versa).
  List<Meal> cookWithWhatYouHave() {
    if (_pantry.isEmpty) return const [];
    final pantryNames =
        _pantry.map((p) => p.name.toLowerCase().trim()).toList();
    return _meals.where((meal) {
      if (meal.ingredients.isEmpty) return false;
      var hits = 0;
      for (final ing in meal.ingredients) {
        final i = ing.toLowerCase().trim();
        if (i.isEmpty) continue;
        if (pantryNames.any((p) => p.contains(i) || i.contains(p))) {
          hits++;
        }
      }
      return hits >= 1;
    }).toList();
  }
}
