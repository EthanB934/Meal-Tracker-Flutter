class Food {
  final int id;
  final String name;
  final int userId;
  final int? calcium;
  final int? calories;
  final int? cholesterol;
  final double? cost;
  final int? fiber;
  final int? iron;
  final int? potassium;
  final int? protein;
  final int? saturatedFat;
  final int? sodium;
  final int? totalCarbohydrates;
  final int? totalFat;
  final int? totalSugars;
  final int? vitaminD;

  Food({
    required this.id,
    required this.name,
    required this.userId,
    this.calcium,
    this.calories,
    this.cholesterol,
    this.cost,
    this.fiber,
    this.iron,
    this.potassium,
    this.protein,
    this.saturatedFat,
    this.sodium,
    this.totalCarbohydrates,
    this.totalFat,
    this.totalSugars,
    this.vitaminD,
});

  factory Food.fromMap(Map<String, Object?> map) {
    return Food(
      id: map['id'] as int,
      name: map['name'] as String,
      userId: map['userId'] as int,
      calcium: map['calcium'] as int,
      calories: map['calories'] as int,
      cholesterol: map['cholesterol'] as int,
      cost: map['cost'] as double,
      fiber: map['fiber'] as int,
      iron: map['iron'] as int,
      potassium: map['potassium'] as int,
      protein: map['protein'] as int,
      saturatedFat: map['saturated_fat'] as int,
      sodium: map['sodium'] as int,
      totalCarbohydrates: map['total_carbohydrates'] as int,
      totalFat: map['total_fat'] as int,
      totalSugars: map['total_sugars'] as int,
      vitaminD: map['vitamin_d'] as int
    );
  }
}