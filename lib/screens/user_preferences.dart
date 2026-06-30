
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';
import 'package:my_flutter_application/widgets/tracked_nutrient_tile.dart';
import 'package:my_flutter_application/widgets/untracked_nutrient_tile.dart';

class UserPreferences extends HookWidget{
  const UserPreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final refreshPreferencesKey = useState(0);
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences(), [refreshPreferencesKey.value]);
    final nutrientSnapshot = useFuture(nutrientsFuture);
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);
    final userSnapshot = useFuture(useMemoized(() => ProfileService().user));

    if(userSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
          body: CircularProgressIndicator()
      );
    }

    if(userSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${userSnapshot.error}'),
        ),
      );
    }

    if(userSnapshot.data == null) {
      return const SizedBox.shrink();
    }
    if(nutrientSnapshot.connectionState == ConnectionState.waiting || userPreferencesSnapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator(),),
      );
    }

    if(nutrientSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${nutrientSnapshot.error}'),
        ),
      );
    }

    if(userPreferencesSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${userPreferencesSnapshot.error}')
        ),
      );
    }

      void refreshPreferences() {
        refreshPreferencesKey.value++;
      }
      final user = userSnapshot.data!;
      final nutrients = nutrientSnapshot.data ?? [];
      final userPreferences = userPreferencesSnapshot.data ?? [];
      final trackedNutrients = nutrients.where((nutrient) => userPreferences.any((preference) => preference.nutrientId == nutrient.id)).toList();
      final untrackedNutrients = nutrients.where((nutrient) => userPreferences.every((preference) => preference.nutrientId != nutrient.id)).toList();


      return Scaffold(
        appBar: AppBar(title: const Text('Nutrition Goals')),
        body: Column(
          children: [
            Text('Active Priorities'),
            trackedNutrients.isEmpty
                ? Center(child: Text('No Active Priorities'),)
                : Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: trackedNutrients.length,
                        itemBuilder: (context, index) {
                          final nutrient = trackedNutrients[index];
                          final preference = userPreferences.firstWhere((preference) => preference.nutrientId == nutrient.id);
                          return TrackedNutrientTile(nutrient: nutrient, preference: preference, onPreferenceSaved: refreshPreferences, user: user,);
                        }
                    ),
                ),
            Text('Untracked Nutrients'),
            Expanded(
              child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: untrackedNutrients.length,
                      itemBuilder: (context, index) {
                        final nutrient = untrackedNutrients[index];
                        return UntrackedNutrientTile(nutrient: nutrient, preference: null, onPreferenceSaved: refreshPreferences, user: user,);
                    }
                ),
            ),
            Visibility(
              visible: trackedNutrients.isNotEmpty ? true : false,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute<void>(builder: (BuildContext context) => HomeScreen(user: user,)),
                      );
                    },
                    child: Text("Finish Preferences Setup")
                )
            )
        ]
        )
      );
    }
  }