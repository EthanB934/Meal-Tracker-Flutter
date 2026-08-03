import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class NutrientTextFormField extends HookWidget{
  final String nutrientName;
  final Function(String, double?) updateFoodState;

  const NutrientTextFormField({
    super.key,
    required this.nutrientName,
    required this.updateFoodState,
  });

  @override
  Widget build(BuildContext context) {
    final nutrientTextFormFieldController = useTextEditingController();

    void captureString(String value) {

       print(value);
       updateFoodState(nutrientName, double.tryParse(nutrientTextFormFieldController.text));
    }

    return TextFormField(
        controller: nutrientTextFormFieldController,
        decoration: InputDecoration(labelText: nutrientName),
        onChanged: (currentValue) => captureString(currentValue)
    );
  }
}