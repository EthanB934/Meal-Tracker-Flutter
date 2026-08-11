import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/meal.dart';
import 'package:my_flutter_application/models/meal_food.dart';
import 'package:my_flutter_application/utils/format_date.dart';
import 'package:sqflite/sqflite.dart';

class MealService {
  Future<List<Meal>> fetchMeals () async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchMeals();
    return results.map((result) => Meal.fromMap(result)).toList();
  }

  Future<List<MealFood>> fetchMealFoods () async {
    List<Map<String, Object?>> results = await DatabaseHelper().fetchMealFoods();
    return results.map((result) => MealFood.fromMap(result)).toList();
  }

  Future<int> createNewMeal (Map<String, dynamic> meal) async {
    bool validMealType = validateMealType(meal["type"]);

    if(!validMealType) {
      throw Exception("${meal["type"]} is not a valid meal option");
    }

    meal["createdAt"] = createTimeStamp();

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

  Future<int> deleteMeal(int mealId) async {
    int result = await DatabaseHelper().deleteMeal(mealId);

    if(result == 0) {
      throw Exception("There was an error deleting meal $mealId. Meal $mealId may not exist");
    }

    return result;
  }

  Future<int> createMealFoodRelationship(Map<String, dynamic> mealMetaData, Map<int, int> foodIdsAndQuantities) async {
    int mealId = await createNewMeal(mealMetaData);
    final iterableFoodIdsAndQuantities = foodIdsAndQuantities.entries.toList();

    int mealFoodsSubmitted = 0;

    try {
      for (int i = 0; i < iterableFoodIdsAndQuantities.length; i++) {
        final currentFoodIdAndQuantity = iterableFoodIdsAndQuantities[i];
        int result = await DatabaseHelper().createMealFoodRelationship({
          "mealId": mealId,
          "foodId": currentFoodIdAndQuantity.key,
          "quantity": currentFoodIdAndQuantity.value
        });

        if (result != 0) {
          mealFoodsSubmitted = result;
        }

      }
    } catch(e) {
      throw Exception("There was an error submitting food ${e.toString()}");
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