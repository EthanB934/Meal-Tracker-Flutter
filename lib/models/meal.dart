class Meal {
  final int id;
  final int userId;
  final String type;
  final DateTime createdAt;

  Meal({
    required this.id,
    required this.userId,
    required this.type,
    required this.createdAt
  });

  factory Meal.fromMap(Map<String, Object?> map) {
    return Meal(
      id: map['id'] as int,
      userId: map['userId'] as int,
      type: map['type'] as String,
      createdAt: map['createdAt'] as DateTime
    );
  }
}