class Food {
  final int id;
  final String name;
  final int userId;
  final double? addedSugars;
  final double? calcium;
  final double? calories;
  final double? cholesterol;
  final double cost;
  final double? dietaryFiber;
  final double? iron;
  final double? potassium;
  final double? protein;
  final double? saturatedFat;
  final double? sodium;
  final double? totalCarbohydrates;
  final double? totalFat;
  final double? totalSugars;
  final double? transFat;
  final double? vitaminA;
  final double? vitaminB6;
  final double? vitaminB12;
  final double? vitaminC;
  final double? vitaminD;
  final double? vitaminE;
  final double? vitaminK;

  Food({
    required this.id,
    required this.name,
    required this.userId,
    this.addedSugars,
    this.calcium,
    this.calories,
    this.cholesterol,
    this.cost = 0.0,
    this.dietaryFiber,
    this.iron,
    this.potassium,
    this.protein,
    this.saturatedFat,
    this.sodium,
    this.totalCarbohydrates,
    this.totalFat,
    this.totalSugars,
    this.transFat,
    this.vitaminA,
    this.vitaminB6,
    this.vitaminB12,
    this.vitaminC,
    this.vitaminD,
    this.vitaminE,
    this.vitaminK,

});

  factory Food.fromMap(Map<String, Object?> map) {
    return Food(
      id: map['id'] as int,
      name: map['name'] as String,
      userId: map['userId'] as int,
      addedSugars: map['added_sugars'] as double,
      calcium: map['calcium'] as double,
      calories: map['calories'] as double,
      cholesterol: map['cholesterol'] as double,
      cost: map['cost'] as double,
      dietaryFiber: map['dietary_fiber'] as double,
      iron: map['iron'] as double,
      potassium: map['potassium'] as double,
      protein: map['protein'] as double,
      saturatedFat: map['saturated_fat'] as double,
      sodium: map['sodium'] as double,
      totalCarbohydrates: map['total_carbohydrates'] as double,
      totalFat: map['total_fat'] as double,
      totalSugars: map['total_sugars'] as double,
      transFat: map['trans_fat'] as double,
      vitaminA: map['vitamin_a'] as double,
      vitaminB6: map['vitamin_b6'] as double,
      vitaminB12: map['vitamin_b12'] as double,
      vitaminC: map['vitamin_c'] as double,
      vitaminD: map['vitamin_d'] as double,
      vitaminE: map['vitamin_e'] as double,
      vitaminK: map['vitamin_k'] as double,
    );
  }

  dynamic operator [](String key) {
    return switch (key) {
      "added_sugars" => addedSugars,
      "calcium" => calcium,
      "calories" => calories,
      "cholesterol" => cholesterol,
      "dietary_fiber" => dietaryFiber,
      "iron" => iron,
      "potassium" => potassium,
      "protein" => protein,
      "saturated_fat" => saturatedFat,
      "sodium" => sodium,
      "total_carbohydrates" => totalCarbohydrates,
      "total_fat" => totalFat,
      "total_sugars" => totalSugars,
      "trans_fat" => transFat,
      "vitamin_a" => vitaminA,
      "vitamin_b6" => vitaminB6,
      "vitamin_b12" => vitaminB12,
      "vitamin_c" => vitaminC,
      "vitamin_d" => vitaminD,
      "vitamin_e" => vitaminE,
      "vitamin_k" => vitaminK,
       _ => null,
    };
  }
}