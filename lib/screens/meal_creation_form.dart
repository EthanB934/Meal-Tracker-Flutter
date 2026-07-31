import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/services/food_service.dart';

class MealCreationForm extends HookWidget {
  final String mealType;
  final User user;

  const MealCreationForm({
    super.key,
    required this.mealType,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final meal = mealType;
    final foodFuture = useMemoized(() => FoodService().fetchFood());
    final foodSnapshot = useFuture(foodFuture);

    if(foodSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator())
      );
    }

    if(foodSnapshot.hasError) {
      return Scaffold(
        body: Center(child: Text("Error: ${foodSnapshot.error}"),),
      );
    }

    final food = foodSnapshot.data ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Add Foods"),),
      body: Column(
        children: [

          SizedBox(
            height: (MediaQuery.heightOf(context) / 4) * 3,
            width: MediaQuery.widthOf(context),
            child: food.isEmpty
            ? SizedBox(
              height: MediaQuery.heightOf(context) / 2,
              width: MediaQuery.widthOf(context) / 2,
              child: Center(child: Text("No food items found"),),
              )
            : ListView.builder(
              itemCount: food.length,
              itemBuilder: (context, index) {
                  final foodItem = food[index];
                  return ListTile(
                    leading: Text(foodItem.name),
                  );
                }
            )
          ),



        ],
      )
    );
  }
}