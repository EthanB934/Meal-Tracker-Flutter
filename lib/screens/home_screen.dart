import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/food_library.dart';
import 'package:my_flutter_application/services/meal_food_service.dart';
import 'package:my_flutter_application/utils/greeting.dart';
import 'package:my_flutter_application/widgets/daily_meals_snapshots.dart';
import 'package:my_flutter_application/widgets/meal_modal.dart';
import 'package:my_flutter_application/widgets/nutritional_summary_card.dart';

class HomeScreen extends HookWidget {
  HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
          title: Text(Greeting().greet()),
          actions: [
            FloatingActionButton(
              onPressed: () {
                Navigator.push(
                context,
                MaterialPageRoute<void>(builder: (BuildContext context) => FoodLibrary())
                );
              },
          )
        ],
      ),
        body:SizedBox(
          height: (MediaQuery.heightOf(context) / 4) * 2.25,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text("Nutritional Summary",),

              Expanded(
                flex: 1,
                child: NutritionalSummaryCard(inReview: false,),
              ),


              Text("Today's Meals"),

              DailyMealsSnapshots(),

              ElevatedButton(
                  onPressed: () => _dialogBuilder(context),
                  child: Text("Create New Meal")
              )
            ],

          ),
        )

    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return MealModal();
      }
    );
  }
}