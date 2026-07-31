import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/screens/create_food.dart';

class FoodModal extends HookWidget {

  const FoodModal({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final foodNameController = TextEditingController();
    final costController = TextEditingController();

    return Scaffold(
      body: SizedBox(
        height: MediaQuery.heightOf(context),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: MediaQuery.heightOf(context) / 2,
            width: MediaQuery.widthOf(context) / 2,
            child: Form(
              key: formKey,
              child: Column(
                children: [

                  TextFormField(
                    controller: foodNameController,
                    decoration: const InputDecoration(labelText: "Food Name"),
                  ),

                  TextFormField(
                    controller: costController,
                    decoration: const InputDecoration(labelText: "Cost"),
                  ),
                ],
              ),
            )
          ),

          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(builder: (BuildContext context) => CreateFood(
                    name: foodNameController.text,
                    cost: double.parse(costController.text),
                  ))
                );
              },
              child: Text("Continue ->")
          )
        ],
      ),
      )
    );
  }
}