/// Meals module models — aligned with Phase 1D SQLite tables.
class Meal {
  final String id;
  final String title;
  final String? baseRecipe;
  final String? childVariation;
  final String? babyVariation;
  final List<String> ingredients;
  final String? notes;
  final DateTime createdAt;

  const Meal({
    required this.id,
    required this.title,
    this.baseRecipe,
    this.childVariation,
    this.babyVariation,
    this.ingredients = const [],
    this.notes,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'base_recipe': baseRecipe,
        'child_variation': childVariation,
        'baby_variation': babyVariation,
        'ingredients': ingredients.join(','),
        'notes': notes,
        'created_at': createdAt.toIso8601String(),
      };

  factory Meal.fromMap(Map<String, dynamic> map) => Meal(
        id: map['id'] as String,
        title: map['title'] as String,
        baseRecipe: map['base_recipe'] as String?,
        childVariation: map['child_variation'] as String?,
        babyVariation: map['baby_variation'] as String?,
        ingredients: (map['ingredients'] as String? ?? '')
            .split(',')
            .map((s) => s.trim())
            .where((s) => s.isNotEmpty)
            .toList(),
        notes: map['notes'] as String?,
        createdAt: DateTime.parse(map['created_at'] as String),
      );
}

class MealPlanDay {
  final String id;
  final DateTime date;
  final String mealSlot;
  final String? mealId;
  final String? note;

  const MealPlanDay({
    required this.id,
    required this.date,
    this.mealSlot = 'dinner',
    this.mealId,
    this.note,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'date': DateTime(date.year, date.month, date.day).toIso8601String(),
        'meal_slot': mealSlot,
        'meal_id': mealId,
        'note': note,
      };

  factory MealPlanDay.fromMap(Map<String, dynamic> map) => MealPlanDay(
        id: map['id'] as String,
        date: DateTime.parse(map['date'] as String),
        mealSlot: map['meal_slot'] as String? ?? 'dinner',
        mealId: map['meal_id'] as String?,
        note: map['note'] as String?,
      );
}

class PantryItem {
  final String id;
  final String name;
  final String? quantity;
  final DateTime? expiresAt;
  final String location;
  final DateTime createdAt;

  const PantryItem({
    required this.id,
    required this.name,
    this.quantity,
    this.expiresAt,
    this.location = 'pantry',
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'expires_at': expiresAt?.toIso8601String(),
        'location': location,
        'created_at': createdAt.toIso8601String(),
      };

  factory PantryItem.fromMap(Map<String, dynamic> map) => PantryItem(
        id: map['id'] as String,
        name: map['name'] as String,
        quantity: map['quantity'] as String?,
        expiresAt: map['expires_at'] != null
            ? DateTime.tryParse(map['expires_at'] as String)
            : null,
        location: map['location'] as String? ?? 'pantry',
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  bool get isExpiringSoon {
    if (expiresAt == null) return false;
    return expiresAt!.difference(DateTime.now()).inDays <= 3;
  }
}

class ShoppingListItem {
  final String id;
  final String name;
  final String? quantity;
  final bool checked;
  final DateTime createdAt;

  const ShoppingListItem({
    required this.id,
    required this.name,
    this.quantity,
    this.checked = false,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'checked': checked ? 1 : 0,
        'created_at': createdAt.toIso8601String(),
      };

  factory ShoppingListItem.fromMap(Map<String, dynamic> map) =>
      ShoppingListItem(
        id: map['id'] as String,
        name: map['name'] as String,
        quantity: map['quantity'] as String?,
        checked: map['checked'] == 1,
        createdAt: DateTime.parse(map['created_at'] as String),
      );

  ShoppingListItem copyWith({bool? checked}) => ShoppingListItem(
        id: id,
        name: name,
        quantity: quantity,
        checked: checked ?? this.checked,
        createdAt: createdAt,
      );
}

class BlwExposure {
  final String id;
  final String foodName;
  final DateTime firstTriedAt;
  final String? reaction;
  final String? textureNotes;
  final String? notes;

  const BlwExposure({
    required this.id,
    required this.foodName,
    required this.firstTriedAt,
    this.reaction,
    this.textureNotes,
    this.notes,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'food_name': foodName,
        'first_tried_at': firstTriedAt.toIso8601String(),
        'reaction': reaction,
        'texture_notes': textureNotes,
        'notes': notes,
      };

  factory BlwExposure.fromMap(Map<String, dynamic> map) => BlwExposure(
        id: map['id'] as String,
        foodName: map['food_name'] as String,
        firstTriedAt: DateTime.parse(map['first_tried_at'] as String),
        reaction: map['reaction'] as String?,
        textureNotes: map['texture_notes'] as String?,
        notes: map['notes'] as String?,
      );
}
