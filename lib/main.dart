import 'package:flutter/material.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/screens/onboarding_screen.dart';
import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/screens/user_preferences.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';

/*
  Meal Tracker entrypoint file. Before app starts, there is a guarantee that the
  widgets layer and flutter engine are bound for a pre-app user exist verification.
  Depending on the resolution on the resolution of that verification, the app will
  route the user through the onboarding process, the user does not yet exist, or
  to the Home Screen of the app, the user exists.
*/
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().initDatabase();

  final bool userExists = await ProfileService().existingUser();
  bool userHasPreferences = false;
  User? user;

  if(userExists){
     user = await ProfileService().user;
     userHasPreferences = await NutrientService().userHasPreferences(user!.id);
  }


  runApp(MyApp(
    userExists: userExists,
    userHasPreferences: userHasPreferences,
    user: user,
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.userExists,
    required this.userHasPreferences,
    this.user,
  });

  final bool userExists;
  final bool userHasPreferences;
  final User? user;

  @override
  Widget build(BuildContext context) {
    if(userExists && userHasPreferences) {
      return MaterialApp(
        title: 'Meal Tracker',
        home: HomeScreen(user: user!,)
      );
    }

    return userExists && !userHasPreferences
        ? MaterialApp(
          title: 'Meal Tracker',
          home: UserPreferences()
        )
        : MaterialApp(
          title: 'Meal Tracker',
          home: OnboardingScreen()
        );
  }
}
