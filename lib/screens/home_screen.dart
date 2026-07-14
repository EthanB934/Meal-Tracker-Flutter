import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:my_flutter_application/models/user.dart';
import 'package:my_flutter_application/utils/greeting.dart';

class HomeScreen extends HookWidget {
  final User user;
  const HomeScreen({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Greeting().greet()),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Hello World',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}