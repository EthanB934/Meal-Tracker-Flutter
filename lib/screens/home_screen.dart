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
    final mealsFuture = useMemoized(() => MealService().fetchMeals());
    final mealsSnapshot = useFuture(mealsFuture);
    final mealFoodsFuture = useMemoized(() => MealService().fetchMealFoods());
    final mealFoodsSnapshot = useFuture(mealFoodsFuture);
    
    if(mealsSnapshot.connectionState == ConnectionState.waiting || mealFoodsSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    
    if(mealsSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text("Error: ${mealsSnapshot.error}"),
        ),
      );
    }

    if(mealFoodsSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text("Error: ${mealsSnapshot.error}"),
        ),
      );
    }

    final meals = mealsSnapshot.data ?? [];
    final mealFoods = mealFoodsSnapshot.data ?? [];

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

