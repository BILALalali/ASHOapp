// شاشة إدارة المستخدمين
import 'package:flutter/material.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('إدارة المستخدمين',
          style: TextStyle(fontSize: 22, color: Color(0xFF193A6B))),
    );
  }
}
