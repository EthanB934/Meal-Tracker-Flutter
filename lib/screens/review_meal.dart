import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/meal_service.dart';
import 'package:my_flutter_application/services/projection.dart';
import 'package:my_flutter_application/widgets/food_list_tile.dart';
import 'package:my_flutter_application/widgets/nutritional_summary_card.dart';

class ReviewMeal extends HookWidget {
  final Map<String, dynamic> mealMetaData;
  final Map<int, int> foodIdsAndQuantities;
  final Function(int) addFood;
  final Function(int) removeFood;

  const ReviewMeal({
    super.key,
    required this.mealMetaData,
    required this.foodIdsAndQuantities,
    required this.addFood,
    required this.removeFood,
  });

  @override
  Widget build(BuildContext context) {
    final foodFuture = useMemoized(() => FoodService().fetchFood());
    final foodSnapshot = useFuture(foodFuture);
    final reviewFoodIdsAndQuantities = useState<Map<int, int>>(foodIdsAndQuantities);
    final nutrientsGoalAmountTotals = useState<Map<String, double>?>(null);

    initializeNutrientGoalAmounts() async {
      nutrientsGoalAmountTotals.value = await Projection().preferredNutrientsGoalAmounts(foodIdsAndQuantities);
    }

    useEffect(() {
      if(nutrientsGoalAmountTotals.value == null) {
        initializeNutrientGoalAmounts();
      }
    },
        [nutrientsGoalAmountTotals.value]
    );

    if(foodSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if(foodSnapshot.hasError) {
      return Scaffold(
          body: SizedBox(
            child: Center(
              child: Text("Error: ${foodSnapshot.error}"),
            ),
          )
      );
    }

    Future<void>updateProjection() async {
      Map<String, double> updatedProjections = await Projection().preferredNutrientsGoalAmounts(reviewFoodIdsAndQuantities.value);
      nutrientsGoalAmountTotals.value = updatedProjections;
    }

    void addFoodInReview (int foodId) {
      final currentQuantity = reviewFoodIdsAndQuantities.value[foodId] ?? 0;
      reviewFoodIdsAndQuantities.value = {...reviewFoodIdsAndQuantities.value, foodId: currentQuantity + 1};
      addFood(foodId);
      updateProjection();
    }

    void removeFoodInReview (int foodId) {
      if(reviewFoodIdsAndQuantities.value.containsKey(foodId)) {
        final currentQuantity = reviewFoodIdsAndQuantities.value[foodId] ?? 0;
        reviewFoodIdsAndQuantities.value = {...reviewFoodIdsAndQuantities.value, foodId: currentQuantity - 1};
        removeFood(foodId);
        updateProjection();

      }

      if(reviewFoodIdsAndQuantities.value[foodId] == 0) {
        reviewFoodIdsAndQuantities.value = {...reviewFoodIdsAndQuantities.value}..remove(foodId);
      }
    }

    final foods = foodSnapshot.data ?? [];

    String renderFoodNames() {
      final mealFoods = foods.where((food) => reviewFoodIdsAndQuantities.value.containsKey(food.id)).toList();
      String foodNames = "";

      for(int i = 0; i < mealFoods.length; i++) {
        final foodIds = reviewFoodIdsAndQuantities.value.keys.toList();
        final currentFoodId = foodIds.where((foodId) => foodId == mealFoods[i].id).first;

        if(i == mealFoods.length - 1) {
          foodNames += "${reviewFoodIdsAndQuantities.value[currentFoodId]} ${mealFoods[i].name}";
          return foodNames;
        }

        foodNames += "${reviewFoodIdsAndQuantities.value[currentFoodId]} ${mealFoods[i].name}, ";
      }

      return foodNames;
    }

    return Scaffold(
      appBar: AppBar(title: Text("Review Meal"),),
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.heightOf(context) / 10,
              width: double.infinity,
              child: NutritionalSummaryCard(inReview: true, nutrientsTotalContributions: nutrientsGoalAmountTotals.value,),
          ),

          Text("Food included in meal: ${renderFoodNames()}"),

          Expanded(
            flex: 1,
            child: FoodListTile(foodIdsAndQuantities: reviewFoodIdsAndQuantities.value, addFood: addFoodInReview, removeFood: removeFoodInReview,),
          ),


          ElevatedButton(
              onPressed: () async {
                int result = await MealService().createMealFoodRelationship(mealMetaData, reviewFoodIdsAndQuantities.value);
                if(result != 0) {
                  if(context.mounted) {
                    Navigator.push<void>(
                        context,
                      MaterialPageRoute<void>(builder: (BuildContext context) => HomeScreen())
                    );
                  }
                }
              },
              child: Text("Save Food")
          ),
        ],
      )
    );
  }
}