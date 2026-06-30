import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/widgets/UserPreferencesForm.dart';


class UntrackedNutrientTile extends HookWidget {
  final Nutrient nutrient;
  final User user;
  final UserNutrientPreference? preference;
  final VoidCallback onPreferenceSaved;

  const UntrackedNutrientTile({
    super.key,
    required this.nutrient,
    required this.onPreferenceSaved,
    required this.user,
    this.preference,
  });

  @override
  Widget build(BuildContext context) {

    return ExpansionTile(
      title: Text(nutrient.name),
      subtitle: Text(nutrient.unit),
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