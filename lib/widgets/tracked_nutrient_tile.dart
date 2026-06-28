import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user_nutrient_preference.dart';
import 'package:my_flutter_application/models/nutrient.dart';
import 'package:my_flutter_application/services/profile_service.dart';

class TrackedNutrientTile extends HookWidget{
  final Nutrient nutrient;
  final UserNutrientPreference preference;

  const TrackedNutrientTile({super.key, required this.nutrient, required this.preference});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final trackingState = useState(preference.trackingState);
    final goalAmountController = useTextEditingController();
    final userSnapshot = useFuture(useMemoized(() => ProfileService().user));

    if(userSnapshot.connectionState == ConnectionState.waiting) {
      return Scaffold(
        body: CircularProgressIndicator()
      );
    }

    if(userSnapshot.hasError) {
      return Scaffold(
        body: Center(
          child: Text('Error: ${userSnapshot.error}'),
        ),
      );
    }

    if(userSnapshot.data == null) {
      return const SizedBox.shrink();
    }

    final user = userSnapshot.data!;

    return Scaffold(
      body: Column(
        children: [
          ListTile(
            leading: CircleAvatar(backgroundColor: preference.trackingState == "maximizing" ? Colors.green : Colors.red,),
            title: Text(nutrient.name),
            subtitle: Text(preference.trackingState),
            trailing: Text("${preference.goalAmount} ${nutrient.unit}"),
          )
        ],
      )
    );
  }
}