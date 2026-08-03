import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
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
    final newFood = useState<Map<String, dynamic>>({
      "name": name,
      "cost": cost
    });
    final nutrientsListLoaded = useState<bool>(false);
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final nutrientsSnapshot = useFuture(nutrientsFuture);
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences());
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);

    void updateFoodState (String name, double? value) {
        newFood.value = {...newFood.value, name: value};
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
          updateFoodState(nutrients[i].name, null);
        }

      nutrientsListLoaded.value = true;

      };


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
              onPressed: () {
                print(
                    "Food to be created: "
                        "${newFood.value}"
                );
              },
              child: Text("Save Food")
          )
        ],
      )
    );
  }
}