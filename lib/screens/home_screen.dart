import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/food_library.dart';
import 'package:my_flutter_application/services/meal_service.dart';
import 'package:my_flutter_application/utils/greeting.dart';
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
          height: (MediaQuery.heightOf(context) / 4) * 3,
          width: double.infinity,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Expanded(
                flex: 1,
                child: Text("Nutritional Summary",),
              ),

              Expanded(
                flex: 1,
                child: NutritionalSummaryCard(inReview: false,),
              ),


              Expanded(
                flex: 1,
                  child: Text("Today's Meals"),
              ),

              Text("Breakfast"),

              SizedBox(
                  height: 300,
                  child: ListView.builder(
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Text(""),
                        );
                      }
                  )
              ),

              Expanded(
                flex: 1,
                child: ElevatedButton(
                      onPressed: () => _dialogBuilder(context),
                      child: Text("Create New Meal")
                  )
              ),

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

/*
  Problem: I want to display a list of meals to the user. The list will include only one of each type of meal. the most recent.
  The display meals, should only be for the current day. If no meal of a type does not exist on the current day, the user still
  has the opportunity to add it before the day ends. If no meal is provided by the end of day, then I am not responsible to remind
  the user. If a user has more than one type of meal on the current day, display the most recent. Users can have more than one of
  the same type of meal per day. Even though the most recent meals of type are displayed, the running total contributions from all
  meals will be calculated in the nutritional summary card.

  Strategy:

  1. Fetch a list of meals by the current day.
  2. For each type of meal
    a. Order meal by id descending from greater to lesser
    b. return the first row. (The most recent meal of type on the current day).
    c. if query fails, a meal for that type does not exist. Render a fallback
  3. For each recent meal of a type
    a. Find all meal food relationships
        ^
        |---- Done
    b. For each meal food relationship
      a. Get the food by foodId from meal food relationship
      b. track cost with counter
      c. track food name with quantity
    c. return cost, and quantity: food name
  4. In a list view builder, create list tiles for each meal of type
     a. The type of meal
     b. The cost of the meal
     c. The contents of the meal (possibly truncated)
     d.If no meal of type, replace cost and contents with text
*/