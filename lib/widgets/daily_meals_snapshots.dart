import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/meal_food_service.dart';

class DailyMealsSnapshots extends HookWidget {

  const DailyMealsSnapshots({super.key});

  @override
  Widget build(BuildContext context)  {
    final mealInfoFuture = useMemoized(() => Projection().fetchTodayFoodInfo());
    final mealInfoSnapshot = useFuture(mealInfoFuture);

    if(mealInfoSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if(mealInfoSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text("Error: ${mealInfoSnapshot.error}"),
        ),
      );
    }

    final mealInfo = mealInfoSnapshot.data as Map<String, Object>;

    final breakFastInfo = mealInfo["breakfast"] as Map<String, Object>;
    final lunchInfo = mealInfo["lunch"] as Map<String, Object>;
    final dinnerInfo = mealInfo["dinner"] as Map<String, Object>;
    final snacksInfo = mealInfo["snacks"] as Map<String, Object>;

    bool hasDetails (String details) {
      if(details.isNotEmpty) {
        return true;
      }
      return false;
    }
    return SizedBox(
        height: 250,
        child: ListView(
            children: [
              SizedBox(
                  height: 150,
                  child: hasDetails(breakFastInfo["details"] as String)
                      ? ListTile(
                      title: Text("Breakfast"),
                      subtitle: Column(
                        children: [
                          Text(breakFastInfo["details"] as String),
                        ],
                      )
                  )
                      : ListTile(
                      title: Text("Breakfast"),
                      subtitle: Column(
                        children: [
                          Text("There were no breakfast meals found from today"),
                        ],
                      )
                  )
              ),
              SizedBox(
                  height: 150,
                  child: hasDetails(lunchInfo["details"] as String)
                      ? ListTile(
                      title: Text("Lunch"),
                      subtitle: Column(
                        children: [
                          Text(lunchInfo["details"] as String),
                        ],
                      )
                  )
                      : ListTile(
                      title: Text("Lunch"),
                      subtitle: Column(
                        children: [
                          Text("There were no lunch meals found from today"),
                        ],
                      )
                  )
              ),
              SizedBox(
                  height: 150,
                  child: hasDetails(dinnerInfo["details"] as String)
                      ? ListTile(
                      title: Text("Dinner"),
                      subtitle: Column(
                        children: [
                          Text(dinnerInfo["details"] as String),
                        ],
                      )
                  )
                      : ListTile(
                      title: Text("Dinner"),
                      subtitle: Column(
                        children: [
                          Text("There were no dinner meals found from today"),
                        ],
                      )
                  )
              ),
              SizedBox(
                  height: 150,
                  child: hasDetails(snacksInfo["details"] as String)
                      ? ListTile(
                      title: Text("Snacks"),
                      subtitle: Column(
                        children: [
                          Text(snacksInfo["details"] as String),
                        ],
                      )
                  )
                      : ListTile(
                      title: Text("Snacks"),
                      subtitle: Column(
                        children: [
                          Text("There were no snack meals found from today"),
                        ],
                      )
                  )
              )
            ]
        )
    );
  }
}