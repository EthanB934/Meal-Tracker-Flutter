import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
    required user
  });

  @override
  Widget build(BuildContext build) {
    return Scaffold(body: Center(child: Text('Home')),);
  }
}