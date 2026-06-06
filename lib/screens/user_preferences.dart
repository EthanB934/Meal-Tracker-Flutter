
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';

class UserPreferences extends HookWidget{
  const UserPreferences({super.key});

  @override
  Widget build(BuildContext build) {
    final nutrientsFuture = useMemoized(() => NutrientService().fetchNutrientsData());
    final snapshot = useFuture(nutrientsFuture);

      if(snapshot.connectionState == ConnectionState.waiting) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator(),),
        );
      }

      if(snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text('Error: ${snapshot.error}'),
          ),
        );
      }

      final nutrients = snapshot.data ?? [];

      return Scaffold(
        appBar: AppBar(title: const Text('Nutrition Goals')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
              itemCount: nutrients.length,
              itemBuilder: (context, index) {
                final nutrient = nutrients[index];
                return ListTile(
                  title: Text(nutrient.name ?? ""),
                  subtitle: Text(nutrient.unit ?? ""),
                );
            }
          )
        ),
      );
    }
  }