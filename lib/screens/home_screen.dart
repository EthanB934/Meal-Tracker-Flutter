// import 'package:flutter/material.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
// import 'package:my_flutter_application/models/user.dart';
// import 'package:my_flutter_application/models/user_nutrient_preference.dart';
// import 'package:my_flutter_application/utils/greeting.dart';
// import 'package:my_flutter_application/services/nutrient_service.dart';
//
// class HomeScreen extends HookWidget {
//   final User user;
//
//   HomeScreen({
//     super.key,
//     required this.user
//   });
//
//   final NutrientService _nutrientService = NutrientService();
//
//   @override
//   Widget build(BuildContext context) {
//
//     return FutureBuilder<List<UserNutrientPreference>>(
//         future: _nutrientService.fetchUserPreferences(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error fetching preferences: ${snapshot.error}'));
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             final preferences = snapshot.data!;
//
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text(Greeting().greet()),
//               ),
//               body: ListView.builder(
//                 itemCount: preferences.length,
//                 itemBuilder: (context, index) {
//                   final preference = preferences[index];
//                   return Card(
//                     margin: const EdgeInsets.all(8.0),
//                     child: ListTile(
//                       title: Text('${preference.goalAmount}'),
//                       subtitle: Text('User Preference ID: ${preference.id}'),
//                     ),
//                   );
//                 },
//               ),
//             );
//           } else {
//             // Handle case where no preferences are found
//             return Scaffold(
//               appBar: AppBar(
//                 title: Text(Greeting().greet()),
//               ),
//               body: const Center(
//                 child: Text('No user nutrient preferences found.'),
//               ),
//             );
//           }
//         },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
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
    return FutureBuilder<dynamic>( // Changed to dynamic as we will combine lists
      future: _nutrientService.fetchUserPreferences(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error fetching preferences: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final preferences = snapshot.data!;

          final nutrients = await _nutrientService.fetchNutrientsData();

          return Scaffold(
            appBar: AppBar(
              title: Text(Greeting().greet()),
            ),
            body: ListView.builder(
              itemCount: preferences.length,
              itemBuilder: (context, index) {
                final preference = preferences[index];
                final Nutrient? nutrient = nutrients.firstWhere(
                        (n) => n.id == preference.nutrientId, // Provide a default if not found, though it should exist
                );

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('${nutrient?.name ?? 'N/A'}'), // Display nutrient name
                    subtitle: Text('Goal Amount: ${preference.goalAmount}'), // Display goal amount
                    trailing: Text('ID: ${preference.id}'),
                  ),
                );
              },
            ),
          );
        } else {
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
