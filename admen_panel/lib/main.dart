import 'package:flutter/material.dart';


void main() {
  runApp(const AdmenPanelApp());
}

class AdmenPanelApp extends StatelessWidget {
  const AdmenPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      home: Scaffold(
        appBar: AppBar(title: const Text('Admin Panel')),
        body: const Center(child: Text('Welcome to Admin Panel!')),
      ),
    );
  }
}
