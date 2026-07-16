import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/utils/greeting.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';

class HomeScreen extends HookWidget {
  final User user;

  HomeScreen({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
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
    final trackedNutrients = nutrients.where((nutrient) => userPreferences.any((preference) => preference.nutrientId == nutrient.id)).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(Greeting().greet()),
      ),
      body: ListView.builder(
        itemCount: userPreferences.length,
        itemBuilder: (context, index) {
          final preference = userPreferences[index];
          final Nutrient? nutrient = nutrients.firstWhere(
                (n) => n.id == preference.nutrientId
          );
          return Card(
            margin: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Text('${nutrient?.name ?? 'N/A'}'), // Display nutrient name
              trailing: Text('${preference.goalAmount} ${nutrient?.unit}'), // Display goal amount,
            ),
          );
        },
      ),
    );
  }
}