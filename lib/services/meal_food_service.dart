import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/meal.dart';
import 'package:my_flutter_application/models/meal_food.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/utils/format_date.dart';
import 'package:my_flutter_application/utils/format_nutrient_name.dart';

class Projection {
  late List<UserNutrientPreference> preferences;
  late List<Food> foods;
  late List<Nutrient> nutrients;
  late List<Nutrient> trackedNutrients;

  Future<void> setPreferences () async {
    preferences = await NutrientService().fetchUserPreferences();
  }

  Future<void> setFood () async {
    foods = await FoodService().fetchFood();
  }

  Future<void> setNutrients () async {
    nutrients = await NutrientService().fetchNutrientsData();
  }

  Future<void> setTrackedNutrients () async {
    await setPreferences();
    await setNutrients();
    trackedNutrients = nutrients.where((nutrient) => preferences.any((preference) => preference.nutrientId == nutrient.id)).toList();
  }

  Future<Map<String, double>> preferredNutrientsGoalAmounts(Map<int, int> foodIds) async {
    Map<String, double>projectedAmounts = {};
    await setFood();
    await setTrackedNutrients();
    final List<Food> mealFoods = foods.where((food) => foodIds.containsKey(food.id)).toList();
    for(final food in mealFoods) {
      final int foodQuantity = foodIds[food.id] ?? 1;
      for(final nutrient in trackedNutrients) {
        final String foodFormattedNutrientName = FormatNutrientName().formatNutrientName(nutrient.name);
        final double foodNutrientProductValue = (food[(foodFormattedNutrientName)] ?? 0.0) * foodQuantity;
        final double previousValue = projectedAmounts[foodFormattedNutrientName] ?? 0.0;
        projectedAmounts = {...projectedAmounts, foodFormattedNutrientName: previousValue + foodNutrientProductValue};

      }
    }
    return projectedAmounts;

  }

  List<Meal> mostRecentMealsOfType(List<Meal> todayMeals) {
    final List<Meal> mostRecentMealsOfType = [];
    final mealTypes = ["Breakfast", "Lunch", "Dinner", "Snacks"];

    if(todayMeals.isEmpty) {
      return [];
    }

    for(final type in mealTypes) {
       final List<Meal> typeMeals = todayMeals.where((todayMeal) => todayMeal.type == type).toList();

       if(typeMeals.isEmpty) {
         continue;
       }

       if(typeMeals.length > 1) {
         typeMeals.sort((a, b) => b.id.compareTo(a.id));
         final Meal mostRecentTypeMeal = typeMeals.first;
         mostRecentMealsOfType.add(mostRecentTypeMeal);
       }

       mostRecentMealsOfType.add(typeMeals.first);
    }

    return mostRecentMealsOfType;
  }

  Future<List<Meal>> fetchMostRecentTodayMeals() async {
    final String today = FormatDate().trimTimeStamp(DateTime.now());
    final List<Map<String, Object?>> todayMealsRecords = await DatabaseHelper().fetchTodayMeals(today);

    if(todayMealsRecords.isEmpty) {
      return [];
    }

    final List<Meal> todayMeals = todayMealsRecords.map((todayMealRecord) => Meal.fromMap(todayMealRecord)).toList();
    return mostRecentMealsOfType(todayMeals);
  }

  Future<List<MealFood>> fetchMealFoodsByMealId(int mealId) async {
    final List<Map<String, Object?>> todayMealFoodsRecords = await DatabaseHelper().fetchTodayMealFoods(mealId);
    return todayMealFoodsRecords.map((todayMealFoodsRecord) => MealFood.fromMap(todayMealFoodsRecord)).toList();
  }

  Future<List<MealFood>> fetchTodayMealsFoods() async {
    final List<Meal> todayMeals = await fetchMostRecentTodayMeals();
    List<MealFood> todayMealsFoods = [];

    for(final Meal todayMeal in todayMeals) {
      final List<MealFood> todayMealFoods = await fetchMealFoodsByMealId(todayMeal.id);
      todayMealsFoods = [...todayMealsFoods, ...todayMealFoods];
    }

    return todayMealsFoods;
  }

  Future<Food> fetchFoodById(int foodId) async {
    final Map<String, Object?> foodRecord = await DatabaseHelper().fetchFoodById(foodId);
    return Food.fromMap(foodRecord);
  }

  Future<Meal> fetchMealById(int mealId) async {
    final Map<String, Object?> mealResult = await DatabaseHelper().fetchMealById(mealId);
    return Meal.fromMap(mealResult);
  }

  Future<Map<String, Object>> fetchTodayFoodInfo () async {
    final List<Meal> mostRecentTodayMeals = await fetchMostRecentTodayMeals();
    final List<MealFood> todayMealsFoods = await fetchTodayMealsFoods();

    Map<String, Object> todayFoodInfo = {
      "breakfast": {"cost": 0.0, "details": ""},
      "lunch": {"cost": 0.0, "details": ""},
      "dinner": {"cost": 0.0, "details": ""},
      "snacks": {"cost": 0.0, "details": ""},
    };



      for(final meal in mostRecentTodayMeals) {
        List<MealFood> currentMealFoods = todayMealsFoods.where((todayMealFood) => todayMealFood.mealId == meal.id).toList();
        Map<String, Object> mealInfo = todayFoodInfo[(meal.type).toLowerCase()] as Map<String, Object>;

        for(final mealFood in currentMealFoods) {
          final Food food = await fetchFoodById(mealFood.foodId);

          double previousMealCost = mealInfo["cost"] as double ;
          double updatedCost =  previousMealCost + (food.cost * mealFood.quantity);

          String previousMealInfoDetails = mealInfo["details"] as String;
          String updatedMealInfoDetails =  "$previousMealInfoDetails ${mealFood.quantity} ${food.name}";

          mealInfo = { "cost": updatedCost, "details": updatedMealInfoDetails};
        }
        todayFoodInfo[(meal.type).toLowerCase()] = mealInfo;
      }
      return todayFoodInfo;
    }
}