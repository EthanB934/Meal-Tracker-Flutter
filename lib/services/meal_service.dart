import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/meal.dart';
import 'package:my_flutter_application/utils/format_date.dart';

class MealService {
  Future<List<Meal>> fetchMeals () async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchMeals();
    return results.map((result) => Meal.fromMap(result)).toList();
  }

  Future<int> createNewMeal (Map<String, dynamic> meal) async {
    bool validMealType = validateMealType(meal["type"]);

    if(!validMealType) {
      throw Exception("${meal["type"]} is not a valid meal option");
    }

    meal["createdAt"] = createTimeStamp();

    int result = await DatabaseHelper().createMeal({
      "userId": meal["userId"],
      "type": meal["type"],
      "createdAt": meal["createdAt"]
    });

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

  Future<int> deleteMeal(int mealId) async {
    int result = await DatabaseHelper().deleteMeal(mealId);

    if(result == 0) {
      throw Exception("There was an error deleting meal $mealId. Meal $mealId may not exist");
    }

    return result;
  }

  Future<int> createMealFoodRelationship(List<Map<String, dynamic>> mealFoodRelationships) async {
    Future<int> mealId = createNewMeal(mealFoodRelationships.first);

    int mealFoodsSubmitted = 0;
    for(final mealFoodRelationship in mealFoodRelationships) {
      int result = await DatabaseHelper().createMealFoodRelationship({
        "mealId": mealId,
        "foodId": mealFoodRelationship["foodId"],
        "quantity": mealFoodRelationship["quantity"]
      });

      if(result == 0) {
        throw Exception("There was an issue adding ${mealFoodRelationship["foodId"]} to ${mealFoodRelationship["mealId"]}");
      }

      mealFoodsSubmitted = 1;
    }

    return mealFoodsSubmitted;
  }

  bool validateMealType(String mealType) {
    List validMealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

    bool isValid = validMealTypes.contains(mealType);

    return isValid;
  }

  String createTimeStamp() {
    DateTime now = DateTime.now();
    return FormatDate().trimTimeStamp(now);
  }

}