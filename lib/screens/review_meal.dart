import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/meal_service.dart';
import 'package:my_flutter_application/services/projection.dart';
import 'package:my_flutter_application/widgets/nutritional_summary_card.dart';

class ReviewMeal extends HookWidget {
  final Map<String, dynamic> mealMetaData;
  final Map<int, int> foodIdsAndQuantity;

  const ReviewMeal({
    super.key,
    required this.mealMetaData,
    required this.foodIdsAndQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final nutrientsGoalAmountTotalsFuture = useMemoized(() => Projection().preferredNutrientsGoalAmounts(foodIdsAndQuantity));
    final nutrientGoalAmountTotalsSnapshot = useFuture(nutrientsGoalAmountTotalsFuture);
    final foodFuture = useMemoized(() => FoodService().fetchFood());
    final foodSnapshot = useFuture(foodFuture);

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

    if(nutrientGoalAmountTotalsSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: SizedBox(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if(nutrientGoalAmountTotalsSnapshot.hasError) {
      return Scaffold(
        body: SizedBox(
          child: Center(
            child: Text("Error: ${nutrientGoalAmountTotalsSnapshot.error}"),
          ),
        )
      );
    }

    final nutrientGoalAmountTotals = nutrientGoalAmountTotalsSnapshot.data as Map<String, double>;
    final foods = foodSnapshot.data ?? [];

    String renderFoodNames() {
      final mealFoods = foods.where((food) => foodIdsAndQuantity.containsKey(food.id)).toList();
      String foodNames = "";

      for(int i = 0; i < mealFoods.length; i++) {
        final foodIds = foodIdsAndQuantity.keys.toList();
        final currentFoodId = foodIds.where((foodId) => foodId == mealFoods[i].id).first;

        if(i == mealFoods.length - 1) {
          foodNames += "${foodIdsAndQuantity[currentFoodId]} ${mealFoods[i].name}";
          return foodNames;
        }

        foodNames += "${foodIdsAndQuantity[currentFoodId]} ${mealFoods[i].name}, ";
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
              child: NutritionalSummaryCard(inReview: true, nutrientsTotalContributions: nutrientGoalAmountTotals,),
          ),

          Text("Food included in meal: ${renderFoodNames()}"),

          ElevatedButton(
              onPressed: () async {
                int result = await MealService().createMealFoodRelationship(mealMetaData, foodIdsAndQuantity);
                if(result == 1) {
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