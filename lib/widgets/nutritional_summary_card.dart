import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/utils/floorToDecimal.dart';
import 'package:my_flutter_application/utils/format_nutrient_name.dart';

class NutritionalSummaryCard extends HookWidget{
  final bool inReview;
  final Map<String, double>? nutrientsTotalContributions;

  const NutritionalSummaryCard({
    super.key,
    required this.inReview,
    this.nutrientsTotalContributions,
  });

  @override
  Widget build(BuildContext context) {
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences());
    final nutrientSnapshot = useFuture(nutrientsFuture);
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);
    final currentAmount = useState<double>(0.0);
    final projectedAmount = useState<double>(0.0);

    if(nutrientSnapshot.connectionState == ConnectionState.waiting || userPreferencesSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: SizedBox(
          height: MediaQuery.heightOf(context) / 2,
          width: MediaQuery.widthOf(context) /2,
          child: Center(
            child: CircularProgressIndicator(),    
          ),
        ),
      );
    }

    if(nutrientSnapshot.hasError) {
      return Scaffold(
        body: SizedBox(
          height: MediaQuery.heightOf(context) / 2,
          width: MediaQuery.widthOf(context) /2,
          child: Center(
            child: Text('Error: ${nutrientSnapshot.error}'),
          ),
        )

      );
    }

    if(userPreferencesSnapshot.hasError) {
      return Scaffold(
        body: SizedBox(
          height: MediaQuery.heightOf(context) / 2,
          width: MediaQuery.widthOf(context) /2,
          child: Center(
              child: Text('Error: ${userPreferencesSnapshot.error}')
          ),
        )
        ,
      );
    }

    double remainingGoalAmount(double goalAmount, double currentValue, double projectionValue) {
      final previousTotal = goalAmount - currentValue;
      final newTotal = previousTotal - projectionValue;
      final formattedDecimal = FloorToDecimal().floorToDecimal(newTotal, 2);

      projectedAmount.value = projectionValue + currentValue;

      return formattedDecimal.abs();
    }

    final nutrients = nutrientSnapshot.data ?? [];
    final userPreferences = userPreferencesSnapshot.data ?? [];




    return SizedBox(
      height: 300,
      child: Card(
        child: inReview
        ? ListView.builder(
          itemCount: userPreferences.length,
          itemBuilder: (context, index) {
            final preference = userPreferences[index];
            final Nutrient nutrient = nutrients.firstWhere(
                    (n) => n.id == preference.nutrientId
            );
            final formattedNutrientName = FormatNutrientName().formatNutrientName(nutrient.name);

            return SizedBox(
                height: 100,
                width: double.infinity,
                child: ListTile(
                    title: Text(nutrient.name),
                    subtitle: Text('${remainingGoalAmount(preference.goalAmount, currentAmount.value, nutrientsTotalContributions?[formattedNutrientName] ?? 0)} remaining'),
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${projectedAmount.value} ${nutrient.unit} / ${preference.goalAmount} ${nutrient.unit}'),
                          SizedBox(
                            height: 10,
                            width: 250,
                            child: LinearProgressIndicator(
                              value: projectedAmount.value / preference.goalAmount,
                            ),
                          ),
                        ]
                    )
                )
            );
          },
        )
            : ListView.builder(
          itemCount: userPreferences.length,
          itemBuilder: (context, index) {
            final preference = userPreferences[index];
            final Nutrient nutrient = nutrients.firstWhere(
                    (n) => n.id == preference.nutrientId
            );

            return SizedBox(
                height: 100,
                width: double.infinity,
                child: ListTile(
                    title: Text(nutrient.name),
                    subtitle: Text('${FloorToDecimal().floorToDecimal(((preference.goalAmount - currentAmount.value)).toDouble(), 2)} remaining'),
                    trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${currentAmount.value} ${nutrient.unit} / ${preference.goalAmount} ${nutrient.unit}'),
                          SizedBox(
                            height: 10,
                            width: 250,
                            child: LinearProgressIndicator(
                              value: currentAmount.value / preference.goalAmount,
                            ),
                          ),
                        ]
                    )
                )
            );
          },
        )
      ),
    );
  }
}