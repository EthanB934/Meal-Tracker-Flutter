import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
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
    final Map<String, double>projectedAmounts = {};
    await setFood();
    await setTrackedNutrients();
    final List<Food> mealFoods = foods.where((food) => foodIds.containsKey(food.id)).toList();

    for(final food in mealFoods) {
      for(final nutrient in trackedNutrients) {
        final String foodFormattedNutrientName = FormatNutrientName().formatNutrientName(nutrient.name);
        final double foodValue = food[(foodFormattedNutrientName)] ?? 0.0;
        final double previousValue = projectedAmounts[foodFormattedNutrientName] ?? 0.0;
        projectedAmounts[foodFormattedNutrientName] = previousValue + foodValue;

      }
    }

    return projectedAmounts;
  }
}