import 'package:flutter/material.dart';
import 'package:my_flutter_application/Screens/onboarding_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meal Tracker',
      home: OnboardingScreen(),
    );
  }
}
/*
  Problem: I need to develop a form field. This form field is required whenever
  a new user downloads the app, and it is there first time setting the app up.
  There is no real use for this form field, other than to learn how to develop
  for Flutter/Dart. The form field will only be displayed once at initial
  startup. If the user already has completed this form, it will not show up
  again. Instead, it will be saved in the user profile tab. There the user may
  update the information if they so need to, but it is really unnecessary. It
  may possibly be used later for communication between the user and their
  dietitian.

  Strategy:

  Task 1. First, I have to research how form fields work, I have included the
  Flutter Forms package, so it might be worthwhile to read up on that.
  Task 2. I will probably need to define a 'form' class that can be used not only
  for this problem, but as a reusable component elsewhere in the development of
  the app.
  Task 3. Form fields are comprised of a few elements:
    (a) Header title
    (b) Labels
    (c) Input fields
    (d) Buttons
  I will need to research these components, how they work together and what support
  is already included for them in the main flutter package.
  Task 4. I will need to figure out how much responsibility a button actually holds,
  do I need to develop an event listener for when the button is clicked, or is there
  support for that as well?
  Task 5. When the button is clicked, I need to make sure there is actual information
  in the input fields, these fields will certainly be required.
  Task 6. If the input fields are filled out, I will need to check the type of data
  that they have within them. Generally, the input field will return string types,
  so how will I account for numbers in the 'Name' field? Secondarily, I will have to
  enforce some date time format, and coerce the data entered into the 'date of birth'
  field to conform to that requirement.
  Task 7. If the 'Name' and 'Date of Birth' fields are filled out, contain the correct
  type of data, then the submission event can finally occur. I will need to research
  what that looks like. I intend to use a Flutter supported, lightweight, personal
  database (i.e. sqflite) to handle permanent storage of information, but how does
  the information actual transfer from transient state to a SQL query to be submitted
  into the database?
  Task 8. Once I figure out how data is transferred from the form, perform that operation
  Task 9. Ensure that the information from the form data was saved permanently to the
  sqflite database.
  Task 10. Once the form data is surely saved in the sqflite database, the user needs
  to be notified that it was successfully saved. If it was not successfully saved, then
  at this point, it is a server issue and that should be thrown instead.
  Task 11. When the user receives the notification that the form data was saved
  successfully in the sqflite database, they will then be routed to the next step of
  the user onboarding process, where they will define their preferences.
 */