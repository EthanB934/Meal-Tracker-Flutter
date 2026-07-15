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
  }