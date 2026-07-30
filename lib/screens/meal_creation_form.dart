import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';

class MealCreationForm extends HookWidget {
  final String mealType;
  final User user;

  const MealCreationForm({
    super.key,
    required this.mealType,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final meal = mealType;

    return Text("Meal: $meal");
  }
}