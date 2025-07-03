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
      routes: {
        '/chat': (_) => const ChatScreen(),
      },
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
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 18, left: 16, right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 18,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.person, 'حسابي', 0, _currentIndex == 0),
                    _buildNavItem(Icons.chat, 'آشو شات', 1, _currentIndex == 1),
                    const SizedBox(width: 72), // مكان زر الرئيسية
                    _buildNavItem(
                        Icons.add_box, 'إضافة منتج', 3, _currentIndex == 3),
                    _buildNavItem(
                        Icons.store, 'منتجاتي', 4, _currentIndex == 4),
                  ],
                ),
              ),
            ),
            // زر الرئيسية الدائري المرتفع والعائم بدون إطار برتقالي
            Positioned(
              top: -28,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      color: const Color(0xFF19345E),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.13),
                          blurRadius: 16,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.home_rounded,
                        color: Colors.white, size: 32),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index, bool isActive) {
    final activeColor = const Color(0xFF19345E);
    final inactiveColor = Colors.blueGrey.shade600;
    return GestureDetector(
      onTap: () {
        if (index == 2) return;
        setState(() => _currentIndex = index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: isActive ? activeColor : inactiveColor, size: 26),
          const SizedBox(height: 2),
          Text(label,
              style: TextStyle(
                  color: isActive ? activeColor : inactiveColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
