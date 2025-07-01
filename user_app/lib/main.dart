import 'package:flutter/material.dart';

void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      home: Scaffold(
        appBar: AppBar(title: const Text('User App')),
        body: const Center(child: Text('Welcome to User App!')),
      ),
    );
  }
}
