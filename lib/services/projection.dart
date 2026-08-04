import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';

class Projection {
  late List<UserNutrientPreference> preferences;
  late List<Food> foods;
  late List<Nutrient> nutrients;
  late List<Nutrient> trackedNutrients;

  void setPreferences () async {
    preferences = await NutrientService().fetchUserPreferences();
  }

  void setFood () async {
    foods = await FoodService().fetchFood();
  }

  void setNutrients () async {
    nutrients = await NutrientService().fetchNutrientsData();
  }

  void setTrackedNutrients () async {
    setPreferences();
    setNutrients();
    trackedNutrients = nutrients.where((nutrient) => preferences.any((preference) => preference.nutrientId == nutrient.id)).toList();
  }

  Map<String, double> preferredNutrientsGoalAmounts(List<int> foodIds) {
    final Map<String, double>projectedAmounts = {};
    setFood();
    setTrackedNutrients();

    final List<Food> mealFoods = foods.where((food) => foodIds.contains(food.id)).toList();

    for(final food in mealFoods) {
      for(final nutrient in trackedNutrients) {
        final double foodValue = food[nutrient.name] ?? 0.0;
        final double previousValue = projectedAmounts[nutrient.name] ?? 0.0;
        projectedAmounts[nutrient.name] = previousValue + foodValue;
      }
    }

    return projectedAmounts;
  }
}