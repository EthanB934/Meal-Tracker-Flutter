import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/review_meal.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';
import 'package:my_flutter_application/widgets/food_list_tile.dart';

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

    final mealMetaData = useState<Map<String, dynamic>>({
      "userId": user.id,
      "type": type,
    });

    final foodIdsAndQuantities = useState<Map<int, int>>({});

    void addFood (int foodId) {
      final currentQuantity = foodIdsAndQuantities.value[foodId] ?? 0;
      foodIdsAndQuantities.value = {...foodIdsAndQuantities.value, foodId: currentQuantity + 1};

    }

    void removeFood (int foodId) {
      if(foodIdsAndQuantities.value.containsKey(foodId)) {
        final currentQuantity = foodIdsAndQuantities.value[foodId] ?? 0;
        foodIdsAndQuantities.value = {...foodIdsAndQuantities.value, foodId: currentQuantity - 1};
      }

      if(foodIdsAndQuantities.value[foodId] == 0) {
        foodIdsAndQuantities.value = {...foodIdsAndQuantities.value}..remove(foodId);
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Foods"),),
      body: SizedBox(
        height: MediaQuery.heightOf(context),
        width: MediaQuery.widthOf(context),
        child: Column(
          children: [
            FoodListTile(foodIdsAndQuantities: foodIdsAndQuantities.value, addFood: addFood, removeFood: removeFood,),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => ReviewMeal(
                      mealMetaData: mealMetaData.value,
                      foodIdsAndQuantities: foodIdsAndQuantities.value,
                      addFood: addFood,
                      removeFood: removeFood,
                    )
                  )
                );
              },
              child: Text("Review Meal ->"),
            ),
          ],
        ),
      ),
    );
  }
}