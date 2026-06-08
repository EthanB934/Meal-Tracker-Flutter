import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/data/database_helper.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';

class NutrientTile extends HookWidget{
  final Nutrient nutrient;
  final UserNutrientPreference? preference;

  const NutrientTile({super.key, required this.nutrient, this.preference});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final trackingState = useState("untracked");
    final goalAmountController = useTextEditingController();
    return ExpansionTile(
        title: Text(nutrient.name),
        subtitle: Text(nutrient.unit),
        children: [
          Form(
        key: formKey,
        child: Column(
          children: [
            DropdownMenu(
              onSelected: (option) {
                if(option != trackingState) {
                  trackingState.value = option;
                }
              },
                dropdownMenuEntries: <DropdownMenuEntry>[
                  DropdownMenuEntry(value: "maximizing", label: "Maximize"),
                  DropdownMenuEntry(value: "limiting", label: "Limit"),
                  DropdownMenuEntry(value: "untracked", label: "Untrack")
            ]),
            TextFormField(
              controller: goalAmountController,
              decoration: const InputDecoration(labelText: "Goal"),
              validator: (value) {
                if(value == null || value.isEmpty) {
                  return "Please enter a goal amount";
                }

                double? goalValue = double.tryParse(value);

                if(goalValue is! double) {
                 return "Please enter a valid number";
                }

                return null;
              },
            ),
            ElevatedButton(
                onPressed: () async {
                  try {
                    final isFormValid = formKey.currentState!.validate();
                    final selectedTrackingState = trackingState as String;
                    final goalValue = goalAmountController as double;
                    final UserNutrientPreference newUserNutrientPreference;

                    if(isFormValid) {
                      newUserNutrientPreference = UserNutrientPreference(
                          userId: 1,
                          nutrientId: nutrient.id,
                          trackingState: selectedTrackingState,
                          goalAmount: goalValue
                      );

                      await DatabaseHelper().createUserNutrientPreference(newUserNutrientPreference);
                    }
                  }
                  catch(e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(e.toString()))
                    );
                  }
                },
                child: const Text("Save")
            ),
            ElevatedButton(
                onPressed: () {
                  ExpansibleController().collapse();
                },
                child: const Text("Close")
            ),
          ],
            ),
          )
        ],
    );
  }
}