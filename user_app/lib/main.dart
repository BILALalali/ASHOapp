import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/account/account_screen.dart';
import 'features/my_products/my_products_screen.dart';
import 'features/add_product/add_product_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 2; // HomeScreen is at index 2

  final List<Widget> _screens = const [
    AccountScreen(), // 0
    ChatScreen(), // 1
    HomeScreen(), // 2 (center)
    AddProductScreen(), // 3
    MyProductsScreen(), // 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _currentIndex,
            onTap: (index) {
              // Prevent tapping the placeholder (center)
              if (index == 2) return;
              setState(() => _currentIndex = index);
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.person), label: 'حسابي'),
              BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'آشو شات'),
              BottomNavigationBarItem(
                  icon: SizedBox.shrink(), label: ''), // Center placeholder
              BottomNavigationBarItem(
                  icon: Icon(Icons.add_box), label: 'إضافة منتج'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.store), label: 'منتجاتي'),
            ],
          ),
          // Center Home Button
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: Container(
                height: 72,
                width: 72,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.home_rounded, color: Colors.white, size: 38),
                    SizedBox(height: 2),
                    Text('الرئيسية',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
