
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/widgets/nutrient_tile.dart';
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
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: nutrients.length,
              itemBuilder: (context, index) {
                final nutrient = nutrients[index];
                final userNutrientPreference = userPreferences.firstWhereOrNull((pref) => pref.nutrientId == nutrient.id);
                return NutrientTile(
                  nutrient: nutrient,
                  preference: userNutrientPreference
                );
            }
          )
        ),
      );
    }
  }