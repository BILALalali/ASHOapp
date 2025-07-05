// شريط إشعار أعلى الشاشة
import 'package:flutter/material.dart';

class NotificationBanner extends StatelessWidget {
  final String message;
  final Color? color;
  const NotificationBanner({super.key, required this.message, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: color ?? Colors.orange,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: Text(
        message,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
