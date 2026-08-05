import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/utils/floorToDecimal.dart';

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
    final currentAmount = useState<double>(9.75);

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

    final nutrients = nutrientSnapshot.data ?? [];
    final userPreferences = userPreferencesSnapshot.data ?? [];

    double summaryValue (Map<String, double>? foodTotalContributions, double currentValue, double goalAmount, String currentNutrient) {
      print(foodTotalContributions);
      if(inReview){
        if(nutrientsTotalContributions!.containsKey(currentNutrient)) {
          return nutrientsTotalContributions![currentNutrient]! + currentValue / goalAmount;
        }
      }

        return currentValue / goalAmount;
    }

    return SizedBox(
      height: 300,
      child: Card(
        child: ListView.builder(
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
                              value: summaryValue(nutrientsTotalContributions, currentAmount.value, preference.goalAmount, nutrient.name),
                            ),
                          ),
                        ]
                    )
                )
            );
          },
        ),
      ),
    );
  }
}