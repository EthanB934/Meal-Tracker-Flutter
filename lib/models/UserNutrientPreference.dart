class UserNutrientPreference {
  final int id;
  final String name;
  final String unit;
  final String trackingState;
  final double goalAmount;

  UserNutrientPreference({
    required this.id,
    required this.name,
    required this.unit,
    required this.trackingState,
    required this.goalAmount,
  });

  factory UserNutrientPreference.fromMap(Map<String, Object?> map) {
    return UserNutrientPreference(
      id: map['id'] as int,
      name: map['name'] as String,
      unit: map['unit'] as String,
      trackingState: map['tracking_state'] as String,
      goalAmount: map['goal_amount'] as double,
    );
  }
}