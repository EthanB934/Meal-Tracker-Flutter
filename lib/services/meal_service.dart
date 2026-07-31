import 'package:my_flutter_application/data/database_helper.dart';

class MealService {
  Future<List<Map<String, Object?>>> fetchMeals () async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchMeals();
    return results;
  }
}