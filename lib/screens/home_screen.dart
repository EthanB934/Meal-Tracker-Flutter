import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/utils/greeting.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';

class HomeScreen extends HookWidget {
  final User user;

  HomeScreen({
    super.key,
    required this.user
  });

  final NutrientService _nutrientService = NutrientService();

  @override
  Widget build(BuildContext context) {

    return FutureBuilder<List<UserNutrientPreference>>(
        future: _nutrientService.fetchUserPreferences(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching preferences: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final preferences = snapshot.data!;

            return Scaffold(
              appBar: AppBar(
                title: Text(Greeting().greet()),
              ),
              body: ListView.builder(
                itemCount: preferences.length,
                itemBuilder: (context, index) {
                  final preference = preferences[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text('${preference.goalAmount}'),
                      subtitle: Text('User Preference ID: ${preference.id}'),
                    ),
                  );
                },
              ),
            );
          } else {
            // Handle case where no preferences are found
            return Scaffold(
              appBar: AppBar(
                title: Text(Greeting().greet()),
              ),
              body: const Center(
                child: Text('No user nutrient preferences found.'),
              ),
            );
          }
        },
    );
  }
}