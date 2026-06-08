class UserNutrientPreference {
  final int? id;
  final int userId;
  final int nutrientId;
  final String trackingState;
  final double goalAmount;

  UserNutrientPreference({
    this.id,
    required this.userId,
    required this.nutrientId,
    required this.trackingState,
    required this.goalAmount,
  });

  factory UserNutrientPreference.fromMap(Map<String, Object?> map) {
    return UserNutrientPreference(
      id: map['id'] as int,
      userId: map['user_id'] as int,
      nutrientId: map['nutrient_id'] as int,
      trackingState: map['tracking_state'] as String,
      goalAmount: map['goal_amount'] as double,
    );
  }
}