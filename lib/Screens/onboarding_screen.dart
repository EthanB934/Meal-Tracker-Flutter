import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/*
  The Onboarding Screen feature is the first thing new users will encounter
  once they open the app. It's purpose is to initiate the user's profile and
  their preferences which will determine the UI.

  Written here is a form where the first-time users will give there name and
  date of birth. There is strict typing enforced for the name as text. Notice
  that the main form of UI is known as widgets. There are stateless and stateful
  widgets provided by the main flutter package used here. A controller for the
  form field is incorporated here from the Flutter Hooks package to assist in
  retrieving the current value of the transient state in the form field inputs.
 */
class OnboardingScreen extends HookWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final nameController = useTextEditingController();
    final selectedDate = useState<DateTime?>(null);

    return Scaffold(
      appBar: AppBar(title: const Text('Welcome'),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if(value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if(value.trim().contains(RegExp(r'[0-9]'))) {
                    return 'Name cannot contain numbers';
                  }
                  return null;
                },
             ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime(2000, 1, 1),
                      firstDate: DateTime(1900, 1, 1),
                      lastDate: DateTime.now()
                  );
                  if(picked != null) {
                    selectedDate.value = picked;
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: Colors.grey)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        selectedDate.value != null
                            ? '${selectedDate.value!.month}/${selectedDate.value!.day}/${selectedDate.value!.year}'
                            : 'Date of Birth',
                        style: TextStyle(
                          color: selectedDate.value != null ? Colors.black : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                      const Icon(Icons.calendar_today, color: Colors.grey),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                  onPressed: () {
                    final isFormValid = formKey.currentState!.validate();
                    final isDateSelected = selectedDate.value != null;

                    if(!isDateSelected) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select your date of birth')),
                      );
                    }

                    if(isFormValid && isDateSelected) {
                      print('Name: ${nameController.text}');
                      print('Date of Birth: ${selectedDate.value}');
                    }

                  },
                  child: const Text('Continue'),
              )
            ]
          ),
        ),
      )
    );
  }
}