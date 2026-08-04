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
  final nutrientGoalAmountTotals = useState<Map<String, double>>(Projection().preferredNutrientsGoalAmounts(foodIdsAndQuantity.values.toList()));

  

    return Scaffold(
      appBar: AppBar(title: Text("Review Meal"),),
      body: NutritionalSummaryCard(inReview: true,)
    );
  }
}