import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class FoodModal extends HookWidget {

  const FoodModal({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final foodNameController = TextEditingController();
    final costController = TextEditingController();
    final caloriesController = TextEditingController();

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

                  TextFormField(
                    controller: caloriesController,
                    decoration: const InputDecoration(labelText: "Calories"),
                  ),

                  ElevatedButton(
                      onPressed: () {},
                      child: Text("Continue ->")
                  )
                ],
              ),
            )
          )
        ],
      ),
      )
    );
  }
}