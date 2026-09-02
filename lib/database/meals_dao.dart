import 'package:sqflite/sqflite.dart';
import '../models/meals_models.dart';
import 'database_helper.dart';

class MealsDao {
  Future<Database> get _db => DatabaseHelper().database;

  // ── Meals ──────────────────────────────────────────────────

  Future<List<Meal>> getMeals() async {
    final db = await _db;
    final rows = await db.query('meals', orderBy: 'title ASC');
    return rows.map(Meal.fromMap).toList();
  }

  Future<void> upsertMeal(Meal meal) async {
    final db = await _db;
    await db.insert(
      'meals',
      meal.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteMeal(String id) async {
    final db = await _db;
    await db.delete('meals', where: 'id = ?', whereArgs: [id]);
  }

  // ── Meal plan ──────────────────────────────────────────────

  Future<List<MealPlanDay>> getPlanDays(DateTime from, DateTime to) async {
    final db = await _db;
    final rows = await db.query(
      'meal_plan_days',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        DateTime(from.year, from.month, from.day).toIso8601String(),
        DateTime(to.year, to.month, to.day).toIso8601String(),
      ],
      orderBy: 'date ASC',
    );
    return rows.map(MealPlanDay.fromMap).toList();
  }

  Future<void> upsertPlanDay(MealPlanDay day) async {
    final db = await _db;
    await db.insert(
      'meal_plan_days',
      day.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePlanDay(String id) async {
    final db = await _db;
    await db.delete('meal_plan_days', where: 'id = ?', whereArgs: [id]);
  }

  // ── Pantry ─────────────────────────────────────────────────

  Future<List<PantryItem>> getPantryItems() async {
    final db = await _db;
    final rows = await db.query('pantry_items', orderBy: 'name ASC');
    return rows.map(PantryItem.fromMap).toList();
  }

  Future<void> upsertPantryItem(PantryItem item) async {
    final db = await _db;
    await db.insert(
      'pantry_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deletePantryItem(String id) async {
    final db = await _db;
    await db.delete('pantry_items', where: 'id = ?', whereArgs: [id]);
  }

  // ── Shopping ───────────────────────────────────────────────

  Future<List<ShoppingListItem>> getShoppingItems() async {
    final db = await _db;
    final rows =
        await db.query('shopping_list_items', orderBy: 'checked ASC, name ASC');
    return rows.map(ShoppingListItem.fromMap).toList();
  }

  Future<void> upsertShoppingItem(ShoppingListItem item) async {
    final db = await _db;
    await db.insert(
      'shopping_list_items',
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteShoppingItem(String id) async {
    final db = await _db;
    await db.delete('shopping_list_items', where: 'id = ?', whereArgs: [id]);
  }

  // ── BLW ────────────────────────────────────────────────────

  Future<List<BlwExposure>> getBlwExposures() async {
    final db = await _db;
    final rows =
        await db.query('blw_exposures', orderBy: 'first_tried_at DESC');
    return rows.map(BlwExposure.fromMap).toList();
  }

  Future<void> insertBlwExposure(BlwExposure exposure) async {
    final db = await _db;
    await db.insert('blw_exposures', exposure.toMap());
  }

  Future<void> deleteBlwExposure(String id) async {
    final db = await _db;
    await db.delete('blw_exposures', where: 'id = ?', whereArgs: [id]);
  }
}
