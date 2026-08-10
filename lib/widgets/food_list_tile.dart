import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/food_service.dart';

class FoodListTile extends HookWidget {
  final Map<int, int> foodIdsAndQuantities;
  final Function(int) addFood;
  final Function(int) removeFood;

  const FoodListTile({
    super.key,
    required this.foodIdsAndQuantities,
    required this.addFood,
    required this.removeFood,
  });

  @override
  Widget build(BuildContext context) {

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

  return SizedBox(
      height: (MediaQuery.heightOf(context) / 4) *3,
      width: double.infinity,
      child: food.isEmpty
          ? SizedBox(
        height: MediaQuery.heightOf(context) / 2,
        width: double.infinity,
        child: Center(child: Text("No food items found"),),
      )
          : Column (
        children: [
          SizedBox(
            height: MediaQuery.heightOf(context) / 2,
            width: double.infinity,
            child: ListView.builder(
                itemCount: food.length,
                itemBuilder: (context, index) {
                  final foodItem = food[index];
                  return ListTile(
                      title: Text(foodItem.name, style: TextStyle(fontSize: 32),),
                      isThreeLine: true,
                      subtitle: Text("${foodIdsAndQuantities[foodItem.id] ?? 0}", style: TextStyle(fontSize: 24),),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FloatingActionButton.small(
                              heroTag: "add${foodItem.id}",
                              child: Text("+"),
                              onPressed: () {
                                addFood(foodItem.id);
                              }
                          ),

                          FloatingActionButton.small(
                              heroTag: "remove${foodItem.id}",
                              child: Text("-"),
                              onPressed: () {
                                removeFood(foodItem.id);
                              }
                          ),
                        ],
                      )
                  );
                }
            ),
          ),
        ],
      )
  );
  }
}