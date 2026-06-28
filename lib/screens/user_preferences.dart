
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/widgets/tracked_nutrient_tile.dart';
import 'package:my_flutter_application/widgets/untracked_nutrient_tile.dart';
import 'package:collection/collection.dart';

class UserPreferences extends HookWidget{
  const UserPreferences({super.key});

  @override
  Widget build(BuildContext build) {
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final userPreferencesFuture = useMemoized(() => NutrientService().fetchUserPreferences());
    final nutrientSnapshot = useFuture(nutrientsFuture);
    final userPreferencesSnapshot = useFuture(userPreferencesFuture);

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

      final nutrients = nutrientSnapshot.data ?? [];
      final userPreferences = userPreferencesSnapshot.data ?? [];


      return Scaffold(
        appBar: AppBar(title: const Text('Nutrition Goals')),
        body: Column(
          children: [
            Text('Active Priorities'),
            Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: nutrients.length,
                        itemBuilder: (context, index) {
                          if(userPreferences.isEmpty) {
                            return Scaffold(
                              body: const Text("No Priorities"),
                            );
                          }
                          final nutrient = nutrients[index];
                          final userNutrientPreference = userPreferences.firstWhere((pref) => pref.nutrientId == nutrient.id);
                          return TrackedNutrientTile(nutrient: nutrient, preference: userNutrientPreference);
                        }
                    ),
                ),
            Text('Untracked Nutrients'),
            Expanded(
              child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: nutrients.length,
                      itemBuilder: (context, index) {
                        final nutrient = nutrients[index];
                        final userNutrientPreference = userPreferences.firstWhereOrNull((pref) => pref.nutrientId == nutrient.id);
                        return UntrackedNutrientTile(nutrient: nutrient, preference: userNutrientPreference);
                    }
                ),
            ),
        ]
        )
      );
    }
  }