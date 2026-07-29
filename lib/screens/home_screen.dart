import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/utils/floorToDecimal.dart';
import 'package:my_flutter_application/utils/greeting.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:path/path.dart';

class HomeScreen extends HookWidget {
  final User user;

  HomeScreen({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences());
    final nutrientSnapshot = useFuture(nutrientsFuture);
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);

    if(nutrientSnapshot.connectionState == ConnectionState.waiting || userPreferencesSnapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    if(nutrientSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${nutrientSnapshot.error}'),
        ),
      );
    }

    if(userPreferencesSnapshot.hasError) {
      return Scaffold(
        body: Center(
            child: Text('Error: ${userPreferencesSnapshot.error}')
        ),
      );
    }

    final nutrients = nutrientSnapshot.data ?? [];
    final userPreferences = userPreferencesSnapshot.data ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(Greeting().greet()),
      ),
        body: Column(
          children: [
            Text("Nutritional Summary"),
            SizedBox(
              height: 300,
              child: Card(
                child: ListView.builder(
                  itemCount: userPreferences.length,
                  itemBuilder: (context, index) {
                    final preference = userPreferences[index];
                    final Nutrient nutrient = nutrients.firstWhere(
                            (n) => n.id == preference.nutrientId
                    );

                    final double currentAmount = 9.75;

                    return SizedBox(
                        height: 100,
                        width: double.infinity,
                        child: ListTile(
                            title: Text(nutrient.name),
                            subtitle: Text('${FloorToDecimal().floorToDecimal(((preference.goalAmount - currentAmount)).toDouble(), 2)} remaining'),
                            trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('$currentAmount ${nutrient.unit} / ${preference.goalAmount} ${nutrient.unit}'),
                                  SizedBox(
                                    height: 10,
                                    width: 250,
                                    child: LinearProgressIndicator(
                                      value: currentAmount / preference.goalAmount,
                                    ),
                                  ),
                                ]
                            )
                        )
                    );
                  },
                ),
              ),
            ),
            Text("Today's Meals"),

            SizedBox(
              height: 300,
              child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Text("Neal #${index + 1}"),
                    );
                  }
              )
            ),


            ElevatedButton(
                onPressed: () {},
                child: Text("Create New Meal")
            )
          ],

        )
    );
  }
}