import 'package:flutter/material.dart';
import 'package:my_flutter_application/screens/home_screen.dart';
import 'package:my_flutter_application/screens/onboarding_screen.dart';
import 'package:my_flutter_application/data/database_helper.dart';
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
  bool userExists = await ProfileService().existingUser();
  // Required for onboarding testing
  if(userExists) {
    await ProfileService().deleteExistingUser();
    userExists = false;
  }
  // Remove above section when onboarding flow is complete.

  runApp(MyApp(userExists: userExists));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    this.userExists = false
  });

  final bool userExists;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      home: userExists ? HomeScreen() : OnboardingScreen(),
    );
  }
}
