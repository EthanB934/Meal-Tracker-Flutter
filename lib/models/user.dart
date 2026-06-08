class User {
  final int id;
  final String name;
  final String dateOfBirth;

  const User({required this.id, required this.name, required this.dateOfBirth});

  factory User.fromMap(Map<String, Object?> map) {
    return User(
      id: map["id"] as int,
      name: map["name"] as String,
      dateOfBirth: map["date_of_birth"] as String
    );
  }
}