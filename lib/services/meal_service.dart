import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/meal.dart';
import 'package:my_flutter_application/utils/format_date.dart';

class MealService {
  Future<List<Meal>> fetchMeals () async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchMeals();
    return results.map((result) => Meal.fromMap(result)).toList();
  }

  Future<int> createNewMeal (Meal meal) async {
    bool validMealType = validateMealType(meal.type);

    if(!validMealType) {
      throw Exception("${meal.type} is not a valid meal option");
    }

    meal.createdAt = createTimeStamp();

    int result = await DatabaseHelper().createMeal(meal);

    if(result == 0) {
      throw Exception("There was an issue submitting the meal"); 
    }

    return result;
  }

  Future<int> updateMeal(Meal meal) async {
    bool isValid = validateMealType(meal.type);

    if(!isValid) {
      throw Exception("${meal.type} is not a valid option");
    }

    int result = await DatabaseHelper().updateMeal(meal);

    if(result == 0) {
      throw Exception("There was an error updating meal ${meal.id}");
    }

    return result;
  }

  bool validateMealType(String mealType) {
    List validMealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

    bool isValid = validMealTypes.firstWhere((validMealType) => validMealType == mealType);

    return isValid;
  }

  String createTimeStamp() {
    DateTime now = DateTime.now();
    return FormatDate().trimTimeStamp(now);
  }

}