import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/screens/meal_creation.dart';

class MealModal extends HookWidget {

  const MealModal({
    super.key,
  });


  @override
  Widget build(BuildContext context) {
  final mealTypes = ["Breakfast", "Lunch", "Dinner", "Snack"];

    return Dialog(
      child: SizedBox(
        height: 500,
        width: 300,
        child: Column(
            children: [
              SizedBox(
                  height: 250,
                  width: 150,
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 150),
                      itemCount: mealTypes.length,
                      itemBuilder: (context, index) {
                        return Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(builder: (BuildContext context) => MealCreationForm(mealType: mealTypes[index]))
                                    );
                                  },
                                  child: Text(mealTypes[index])
                              )
                            ]
                          );
                      }
                  )
              )
            ]
        ),
      ),
    );
  }
}