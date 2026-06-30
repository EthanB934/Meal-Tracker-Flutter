import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';

class UserPreferencesForm extends HookWidget{
  final Nutrient nutrient;
  final VoidCallback onPreferenceSaved;
  final User user;
  final UserNutrientPreference? preference;

  const UserPreferencesForm({
    super.key,
    required this.nutrient,
    required this.onPreferenceSaved,
    required this.user,
    this.preference,
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final goalAmountController = useTextEditingController(text: preference?.goalAmount != null ? '${preference?.goalAmount}' : '0.0');
    final trackingState = useState(preference?.trackingState ?? "maximizing");

    final allEntries = <DropdownMenuEntry<String>>[
      DropdownMenuEntry<String>(value: "maximizing", label: "Maximize"),
      DropdownMenuEntry<String>(value: "limiting", label: "Limit"),
    ];

    final currentSelection = allEntries.where((entry) => entry.value == trackingState.value);

    return Form(
        key: formKey,
        child: Column(
            children: [

              DropdownMenu<String>(
                onSelected: (String? option) {
                  if (option != trackingState.value) {
                    trackingState.value = option as String;
                  }
                },
                dropdownMenuEntries: allEntries,
                initialSelection: currentSelection.isEmpty ? "maximizing" : currentSelection.first.value
              ),

              TextFormField(
                controller: goalAmountController,
                decoration: const InputDecoration(labelText: "Goal"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a goal amount";
                  }

                  double? goalValue = double.tryParse(value);

                  if (goalValue is! double) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),

              preference == null
              ? ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () async {
                    try {
                      final isFormValid = formKey.currentState!.validate();
                      final selectedTrackingState = trackingState.value;
                      final goalValue = double.tryParse(
                          goalAmountController.text)!;
                      final UserNutrientPreference newUserNutrientPreference;

                      if (isFormValid) {
                        newUserNutrientPreference = UserNutrientPreference(
                            userId: user.id,
                            nutrientId: nutrient.id,
                            trackingState: selectedTrackingState,
                            goalAmount: goalValue
                        );

                        int result = await NutrientService()
                            .createNewUserNutrientPreference(
                            newUserNutrientPreference);

                        if (result > 0) {
                          onPreferenceSaved();
                        }
                      }
                    }
                    catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString()))
                      );
                    }
                  }
              )
                  : Row(
                    children: [
                      ElevatedButton(
                          child: const Text("Update Preference"),
                          onPressed: () async {
                            try {
                              final isFormValid = formKey.currentState!.validate();
                              final selectedTrackingState = trackingState.value;
                              final goalValue = double.tryParse(
                                  goalAmountController.text)!;
                              final UserNutrientPreference updatedUserNutrientPreference;

                              if (isFormValid) {
                                updatedUserNutrientPreference = UserNutrientPreference(
                                    id: preference!.id,
                                    userId: user.id,
                                    nutrientId: nutrient.id,
                                    trackingState: selectedTrackingState,
                                    goalAmount: goalValue
                                );

                                int result = await NutrientService().updateUserNutrientPreference(updatedUserNutrientPreference);

                                if (result > 0) {
                                  onPreferenceSaved();
                                }
                              }
                            }
                            catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString()))
                              );
                            }
                          }
                      ),
                      ElevatedButton(
                          child: const Text("Delete Preference"),
                          onPressed: () async {
                            final userNutrientPreferenceId = preference!.id;
                            try {
                              int result = await NutrientService().deleteUserNutrientPreference(userNutrientPreferenceId!);

                                if (result > 0) {
                                  onPreferenceSaved();
                                }
                              }
                            catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString()))
                              );
                            }
                          }
                      )
                    ]
                  )
              ]
        )
    );
  }
}