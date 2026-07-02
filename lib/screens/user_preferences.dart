
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';
import 'package:my_flutter_application/widgets/tracked_nutrient_tile.dart';
import 'package:my_flutter_application/widgets/untracked_nutrient_tile.dart';

class UserPreferences extends HookWidget{
  const UserPreferences({super.key});

  /*
    The User Preferences screen. This screen is displayed at two points in the
    Meal Tracker App:
      1. When a first time user creates their user profile.
      2. WHen an existing user wishes to update their preferences.
    The user preferences screen contains two lists:
      1. A list of nutrients that are not tracked by the user.
      2. A list of nutrients that are tracked by the user.
     Each list has a form with behavior that depends on the user's tracking status
     of that nutrient. If a relationship exists, the user may update or delete that
     tracked nutrient from that list. If one does not, then the user may create a
     tracking relationship with that nutrient.
     All create, read, update, and delete operations are performed in real time when
     the user submits either form to the database.

     With first time users, the user may not navigate past the user preferences screen
     until at least one relationship is created (some of the later UI elements are
     dependent upon the user's relationships). If the user closes the app after creating
     their profile, but does not create any preference relationship: upon return, they
     will be redirected to the user preferences screen until at least one relationship
     exists.
  */

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