import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/nutrient_service.dart';
import 'package:my_flutter_application/services/profile_service.dart';

class UntrackedNutrientTile extends HookWidget{
  final Nutrient nutrient;
  final UserNutrientPreference? preference;
  final VoidCallback onPreferenceSaved;

  const UntrackedNutrientTile({super.key, required this.nutrient, this.preference, required this.onPreferenceSaved});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final trackingState = useState("maximizing");
    final goalAmountController = useTextEditingController();
    final userSnapshot = useFuture(useMemoized(() => ProfileService().user));

    if(userSnapshot.connectionState == ConnectionState.waiting) {
      return CircularProgressIndicator();
    }

    if(userSnapshot.hasError) {
      return Center(child: Text('Error: ${userSnapshot.error}'),);
    }

    if(userSnapshot.data == null) {
      return const SizedBox.shrink();
    }

    final user = userSnapshot.data!;

    return ExpansionTile(
        title: Text(nutrient.name),
        subtitle: Text(nutrient.unit),
        children: [
          Form(
        key: formKey,
        child: Column(
          children: [
            DropdownMenu<String>(
              onSelected: (String? option) {
                if(option != trackingState.value) {
                  trackingState.value = option as String;
                }
              },
                dropdownMenuEntries: <DropdownMenuEntry<String>>[
                  DropdownMenuEntry<String>(value: "maximizing", label: "Maximize"),
                  DropdownMenuEntry<String>(value: "limiting", label: "Limit"),
                  DropdownMenuEntry<String>(value: "untracked", label: "Untrack")
            ],
            initialSelection: "maximizing"
              ,),
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
                    final selectedTrackingState = trackingState.value;
                    final goalValue = double.tryParse(goalAmountController.text)!;
                    final UserNutrientPreference newUserNutrientPreference;

                    if(isFormValid) {
                      newUserNutrientPreference = UserNutrientPreference(
                          userId: user.id,
                          nutrientId: nutrient.id,
                          trackingState: selectedTrackingState,
                          goalAmount: goalValue
                      );

                      int result = await NutrientService().createNewUserNutrientPreference(newUserNutrientPreference);

                      if(result > 0) {
                        onPreferenceSaved();
                      }
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