// شاشة إدارة المنتجات
import 'package:flutter/material.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('إدارة المنتجات',
          style: TextStyle(fontSize: 22, color: Color(0xFF193A6B))),
    );
  }
}
