// شاشة إدارة المحادثات
import 'package:flutter/material.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('إدارة المحادثات والطلبات',
          style: TextStyle(fontSize: 22, color: Color(0xFF193A6B))),
    );
  }
}
