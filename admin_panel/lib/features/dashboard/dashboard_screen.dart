// شاشة لوحة المعلومات الرئيسية
import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('لوحة المعلومات',
          style: TextStyle(fontSize: 22, color: Color(0xFF193A6B))),
    );
  }
}
