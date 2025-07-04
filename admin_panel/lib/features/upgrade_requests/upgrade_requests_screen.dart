// شاشة مراجعة طلبات الترقية
import 'package:flutter/material.dart';

class UpgradeRequestsScreen extends StatelessWidget {
  const UpgradeRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('طلبات الترقية',
          style: TextStyle(fontSize: 22, color: Color(0xFF193A6B))),
    );
  }
}
