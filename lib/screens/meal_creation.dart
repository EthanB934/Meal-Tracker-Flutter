import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/food.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';

class MealCreationForm extends HookWidget {
  final String mealType;

  const MealCreationForm({
    super.key,
    required this.mealType,
  });

  @override
  Widget build(BuildContext context) {
    final type = mealType;
    final user = ProfileService().cachedUser;
    final foodFuture = useMemoized(() => FoodService().fetchFood());
    final foodSnapshot = useFuture(foodFuture);
    final foodAndQuantity = useState<Map<int, int>>({});

    final mealFoods = useState<Map<String, dynamic>>({
      "userId": user.id,
      "type": type,
    });

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

      void addFood (int foodId) {
        final currentQuantity = foodAndQuantity.value[foodId] ?? 0;
        foodAndQuantity.value = {...foodAndQuantity.value, foodId: currentQuantity + 1};

      }

      void removeFood (int foodId) {
        if(foodAndQuantity.value.containsKey(foodId)) {
          final currentQuantity = foodAndQuantity.value[foodId] ?? 0;
          foodAndQuantity.value = {...foodAndQuantity.value, foodId: currentQuantity - 1};
        }

        if(foodAndQuantity.value[foodId] == 0) {
          foodAndQuantity.value = {...foodAndQuantity.value}..remove(foodId);
        }
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
                      title: Text("${foodItem.name} 0", textAlign: TextAlign.center,),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                              onPressed: () {
                                addFood(foodItem.id);
                              }
                          ),
                          FloatingActionButton.small(
                              onPressed: () {
                                removeFood(foodItem.id);
                              }
                          ),
                        ],
                      )
                    );
                }
            )
          ),

        ],
      )
    );
  }
}