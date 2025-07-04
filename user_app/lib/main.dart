import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'features/home/home_screen.dart';
import 'features/chat/chat_screen.dart';
import 'features/account/account_screen.dart';
import 'features/my_products/my_products_screen.dart';
import 'features/add_product/add_product_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'widgets/upgrade_dialogs.dart';

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
      home: const LoginScreen(), // شاشة البداية مؤقتاً
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/main': (_) => const MainNavigation(),
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

  // متغير حالة المستخدم (مؤقتًا)
  bool userIsSeller = false;

  final List<Widget> _screens = const [
    // سيتم إعادة بناء القائمة عند التغيير
    // AccountScreen(), // 0
    ChatScreen(), // 1
    HomeScreen(), // 2 (center)
    AddProductScreen(), // 3
    MyProductsScreen(), // 4
  ];

  void _showUpgradeDialog() async {
    final upgraded = await showDialog<bool>(
      context: context,
      builder: (context) => UpgradeToSellerDialog(
        onPlanSelected: (plan) {
          setState(() => userIsSeller = true);
        },
      ),
    );
    if (upgraded == true) {
      setState(() => userIsSeller = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      AccountScreen(isSeller: userIsSeller),
      const ChatScreen(),
      const HomeScreen(),
      const AddProductScreen(),
      const MyProductsScreen(),
    ];
    return Scaffold(
      body: screens[_currentIndex],
      extendBody: true,
      bottomNavigationBar: SizedBox(
        height: 82,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 12, left: 12, right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.97),
                borderRadius: BorderRadius.circular(26),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.10),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(
                    color: AppColors.primary.withOpacity(0.10), width: 1.2),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(Icons.person, 'حسابي', 0, _currentIndex == 0),
                    _buildNavItem(Icons.chat, 'آشو شات', 1, _currentIndex == 1),
                    const SizedBox(width: 68), // مكان زر الرئيسية
                    _buildNavItem(
                        Icons.add_box, 'إضافة منتج', 3, _currentIndex == 3),
                    _buildNavItem(
                        Icons.store, 'منتجاتي', 4, _currentIndex == 4),
                  ],
                ),
              ),
            ),
            // زر الرئيسية المربع بحواف مستديرة قليلاً
            Positioned(
              top: -10,
              left: 0,
              right: 0,
              child: Center(
                child: GestureDetector(
                  onTap: () => setState(() => _currentIndex = 2),
                  child: Container(
                    height: 58,
                    width: 58,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.10),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.13),
                          width: 1.2),
                    ),
                    child: const Icon(Icons.home_rounded,
                        color: Colors.white, size: 30),
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
    final activeColor = AppColors.primary;
    final inactiveColor = Colors.blueGrey.shade600;
    return GestureDetector(
      onTap: () {
        if (index == 2) return;
        if (!userIsSeller && (index == 3 || index == 4)) {
          _showUpgradeDialog();
          return;
        }
        setState(() => _currentIndex = index);
      },
      child: SizedBox(
        width: 54,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 2),
            Icon(icon, color: isActive ? activeColor : inactiveColor, size: 23),
            const SizedBox(height: 2),
            Text(label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: isActive ? activeColor : inactiveColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
          ],
        ),
      ),
    );
  }
}
