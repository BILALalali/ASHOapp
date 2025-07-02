import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/account/account_screen.dart';
import 'features/my_products/my_products_screen.dart';
import 'features/add_product/add_product_screen.dart';

void main() {
  runApp(const UserApp());
}

class UserApp extends StatelessWidget {
  const UserApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'آشو ماركت',
      theme: appTheme,
      home: const MainNavigation(),
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomeScreen(),
    ChatScreen(),
    AddProductScreen(),
    MyProductsScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'آشو شات'),
          BottomNavigationBarItem(
              icon: Icon(Icons.add_box), label: 'إضافة منتج'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'منتجاتي'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
        ],
      ),
    );
  }
}
