class MealFood {
  final int id;
  final int mealId;
  final int foodId;
  final int quantity;

  MealFood({
    required this.id,
    required this.mealId,
    required this.foodId,
    required this.quantity,
  });

  factory MealFood.fromMap(Map<String, Object?> map) {
    return MealFood(
        id: map['id'] as int,
        mealId: map['mealId'] as int,
        foodId: map['foodId'] as int,
        quantity: map['quantity'] as int,
    );
  }
}