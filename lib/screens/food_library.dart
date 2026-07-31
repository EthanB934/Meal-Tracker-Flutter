import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/widgets/food_modal.dart';

class FoodLibrary extends HookWidget {

  const FoodLibrary({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final foodFuture = useMemoized(() => FoodService().fetchFood());
    final foodSnapshot = useFuture(foodFuture);

    if(foodSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        )
      );
    }

    if(foodSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text("Error: ${foodSnapshot.error}"),
        ),
      );
    }

    final food = foodSnapshot.data ?? [];

    return Scaffold(
      appBar: AppBar(title: Text("Food Library"),),
      body: Column(
        children: [

          SizedBox(
            height: (MediaQuery.heightOf(context) / 4) * 3,
            width: MediaQuery.widthOf(context),
            child: food.isEmpty
            ? SizedBox(
              height: MediaQuery.heightOf(context) / 2,
              width: MediaQuery.widthOf(context) / 2,
              child: Center(
                child: Text("There are no food items"),
              ),
            )
            : ListView.builder(
              itemCount: food.length,
              itemBuilder: (context, index) {
                final foodItem = food[index];
                return ListTile(
                  leading: Text(foodItem.name),
                );
              },
            ),

          ),

          ElevatedButton(
              onPressed: () => _dialogBuilder(context),
              child: Text(" + Add New Food")
          )

        ],
      )
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return FoodModal();
        }
    );
  }
}