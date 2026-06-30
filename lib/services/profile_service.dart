import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/user.dart';

class ProfileService {
  static User? _userProfile;

  Future<User?> fetchUserProfile() async {
    List<Map<String, Object?>> user = await DatabaseHelper().getUser();

    if(user.isEmpty){
      throw Exception("User not found");
    }

    return _userProfile = user.map((map) => User.fromMap(map)).first;
  }

  Future<int> createUserProfile(String name, DateTime dateOfBirth) async {
    String validName = validateName(name);
    String validDate = formatDate(dateOfBirth);

    return await DatabaseHelper().createUser(validName, validDate);
  }

  Future<User?> get user async {
    return _userProfile ??= await fetchUserProfile();
  }

  String validateName(String name) {
    name = name.trim();
    if(name.isEmpty) {
      throw Exception('Name cannot be empty');
    }
    if (name.length > 100) {
      throw Exception('Name is too long!');
    }

    return name;
  }

  String formatDate(DateTime date) {
    String year = date.year.toString();
    String month = date.month.toString().padLeft(2, '0');
    String day = date.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  Future<bool> existingUser() async {
    return await DatabaseHelper().userExists();
  }

  Future<int> deleteExistingUser() async {
    return await DatabaseHelper().deleteUser();
  }
}