import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/profile_service.dart';
import 'package:my_flutter_application/widgets/UserPreferencesForm.dart';

class TrackedNutrientTile extends HookWidget{
  final Nutrient nutrient;
  final User user;
  final UserNutrientPreference preference;
  final VoidCallback onPreferenceSaved;

  const TrackedNutrientTile({
    super.key,
    required this.nutrient,
    required this.onPreferenceSaved,
    required this.preference,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(backgroundColor: preference.trackingState == "maximizing" ? Colors.green : Colors.red,),
      title: Text(nutrient.name),
      subtitle: Text(preference.trackingState),
      trailing: Text("${preference.goalAmount} ${nutrient.unit}"),
      children: [
        UserPreferencesForm(
          nutrient: nutrient,
          onPreferenceSaved: onPreferenceSaved,
          user: user,
          preference: preference,
        )
      ],
    );
  }
}