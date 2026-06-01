import 'package:my_flutter_application/data/database_helper.dart';

class ProfileService {
  Future<int> createUserProfile(String name, DateTime dateOfBirth) async {
    String validName = validateName(name);
    String validDate = formatDate(dateOfBirth);

    return await DatabaseHelper().createUser(validName, validDate);
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
}