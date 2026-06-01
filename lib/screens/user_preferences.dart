import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class UserPreferences extends HookWidget{
  const UserPreferences({super.key});

  @override
  Widget build(BuildContext build) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Preferences')),
    );
  }
}