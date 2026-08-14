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

    for(final type in mealTypes) {
       final List<Meal> typeMeals = todayMeals.where((todayMeal) => todayMeal.type == type).toList();
       typeMeals.sort((a, b) => b.id.compareTo(a.id));
       final Meal mostRecentTypeMeal = typeMeals.first;
       mostRecentMealsOfType.add(mostRecentTypeMeal);
    }

    return mostRecentMealsOfType;
  }

  Future<List<Meal>> fetchMostRecentTodayMeals() async {
    final String today = FormatDate().trimTimeStamp(DateTime.now());
    final List<Map<String, Object?>> todayMealsRecords = await DatabaseHelper().fetchTodayMeals(today);
    final List<Meal> todayMeals = todayMealsRecords.map((todayMealRecord) => Meal.fromMap(todayMealRecord)).toList();
    return mostRecentMealsOfType(todayMeals);
  }

  Future<List<MealFood>> fetchMealFoodsByMealId(int mealId) async {
    final List<Map<String, Object?>> todayMealFoodsRecords = await DatabaseHelper().fetchTodayMealFoods(mealId);
    return todayMealFoodsRecords.map((todayMealFoodsRecord) => MealFood.fromMap(todayMealFoodsRecord)).toList();
  }

  Future<List<MealFood>> fetchTodayFoods() async {
    final List<Meal> todayMeals = await fetchMostRecentTodayMeals();
    List<MealFood> todayMealsFoods = [];

    for(final Meal todayMeal in todayMeals) {
      final List<MealFood> todayMealFoods = await fetchMealFoodsByMealId(todayMeal.id);
      todayMealsFoods = [...todayMealFoods];
    }

    return todayMealsFoods;
  }
}