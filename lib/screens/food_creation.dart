import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/screens/food_library.dart';
import 'package:my_flutter_application/services/food_service.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';
import 'package:my_flutter_application/utils/format_nutrient_name.dart';
import 'package:my_flutter_application/widgets/nutrient_text_form_field.dart';

class CreateFood extends HookWidget{
  final String name;
  final double? cost;

  const CreateFood({
    super.key,
    required this.name,
    this.cost,
  });


  @override
  Widget build(BuildContext context) {
    final user = ProfileService().cachedUser;

    final newFood = useState<Map<String, dynamic>>({
      "name": name,
      "cost": cost,
      "userId": user.id,
    });

    final nutrientsListLoaded = useState<bool>(false);
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final nutrientsSnapshot = useFuture(nutrientsFuture);
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences());
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);

    void updateFoodState (String name, double? value) {
      final databaseName = FormatNutrientName().formatNutrientName(name);
      print(databaseName);
        newFood.value = {...newFood.value, databaseName: value};
    }

    if(nutrientsSnapshot.connectionState == ConnectionState.waiting || nutrientsSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(),)
      );
    }

    if(nutrientsSnapshot.hasError) {
      return Scaffold(
        body: Center(child: Text("Error: ${nutrientsSnapshot.error}")),
      );
    }

    if(userPreferencesSnapshot.hasError) {
      return Scaffold(
        body: Center(child: Text("Error: ${userPreferencesSnapshot.error}")),
      );
    }

    final nutrients = nutrientsSnapshot.data ?? [];

    useEffect(() {
      if(!nutrientsListLoaded.value && nutrients.isNotEmpty) {
        final List<Nutrient> nutrients = nutrientsSnapshot.data!;
        for(int i = 0; i < nutrients.length; i++) {
          updateFoodState(nutrients[i].name, 0.0);
        }

      nutrientsListLoaded.value = true;

      }

      return null;
    }, [nutrientsSnapshot.hasData]);

    final userPreferences = userPreferencesSnapshot.data ?? [];
    final trackedNutrients = nutrients.where((nutrient) => userPreferences.any((preference) => preference.nutrientId == nutrient.id)).toList();
    final untrackedNutrients = nutrients.where((nutrient) => userPreferences.every((preference) => preference.nutrientId != nutrient.id)).toList();

    return Scaffold(
      appBar: AppBar(title: Text("Add Nutrients"),),
      body: Column(
        children: [

          Text("YOUR PRIORITIES"),
          SizedBox(
            height: (MediaQuery.heightOf(context) / 4) * 0.5,
            width: MediaQuery.widthOf(context) / 2,
            child: ListView.builder(
              itemCount: trackedNutrients.length,
              itemBuilder: (context, index) {
                final trackedNutrient = trackedNutrients[index];

                return Column(
                    children: [
                      NutrientTextFormField(nutrientName: trackedNutrient.name, updateFoodState: updateFoodState,),
                    ],
                );
              },
            ),
          ),

          ExpansionTile(
            title: Text("ADDITIONAL NUTRIENTS"),
            children: [
              SizedBox(
                height:MediaQuery.heightOf(context) / 2,
                child: ListView.builder(
                    itemCount: untrackedNutrients.length,
                    itemBuilder: (context, index) {
                      final untrackedNutrient = untrackedNutrients[index];

                      return Column(
                        children: [
                          NutrientTextFormField(nutrientName: untrackedNutrient.name, updateFoodState: updateFoodState,),
                        ],
                      );
                    }
                ),
              )
            ],
          ),

          ElevatedButton(
              onPressed: () async {
                final result = await FoodService().createFood(newFood.value);

                if(result == 0) {
                  throw Exception("There was an error submitting ${newFood.value['name']} into the database");
                }

                if(context.mounted) {
                  return Navigator.push<void>(
                    context,
                    MaterialPageRoute<void>(builder: (BuildContext context) => const FoodLibrary())
                  );
                }
              },
              child: Text("Save Food")
          )
        ],
      )
    );
  }
}