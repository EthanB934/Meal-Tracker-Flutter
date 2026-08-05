import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/projection.dart';
import 'package:my_flutter_application/widgets/nutritional_summary_card.dart';

class ReviewMeal extends HookWidget {
  final Map<String, dynamic> mealFood;
  final Map<int, int> foodIdsAndQuantity;

  const ReviewMeal({
    super.key,
    required this.mealFood,
    required this.foodIdsAndQuantity,
  });

  @override
  Widget build(BuildContext context) {
    final nutrientsGoalAmountTotalsFuture = useMemoized(() => Projection().preferredNutrientsGoalAmounts(foodIdsAndQuantity));
    final nutrientGoalAmountTotalsSnapshot = useFuture(nutrientsGoalAmountTotalsFuture);

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

    return Scaffold(
      appBar: AppBar(title: Text("Review Meal"),),
      body: NutritionalSummaryCard(inReview: true, nutrientsTotalContributions: nutrientGoalAmountTotals,)
    );
  }
}