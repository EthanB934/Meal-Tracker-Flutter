class Nutrient {
  final int? id;
  final String? name;
  final String? unit;

  Nutrient({this.id, required this.name, required this.unit});

  factory Nutrient.fromMap(Map<String, Object?> map) {
    return Nutrient(
      id: map['id'] as int?,
      name: map['name'] as String,
      unit: map['unit'] as String,
    );
  }
}

