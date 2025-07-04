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
      localizationsDelegates: const [
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
      builder: (context) => UpgradeDialog(
        onUpgrade: () async {
          final upgraded = await showDialog<bool>(
            context: context,
            builder: (context) => SellerPlansDialog(),
          );
          if (upgraded == true) {
            setState(() => userIsSeller = true);
            Navigator.pop(context, true);
          }
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

// Dialogات الترقية
class UpgradeDialog extends StatelessWidget {
  final VoidCallback onUpgrade;
  const UpgradeDialog({super.key, required this.onUpgrade});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.store, color: Color(0xFFFF9800), size: 40),
          const SizedBox(height: 12),
          Text('حساب البائع مطلوب',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF19345E))),
          const SizedBox(height: 8),
          Text(
              'هذه الميزة متاحة فقط لحسابات البائعين. يمكنك ترقية حسابك للوصول إلى هذه الميزة.',
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text('لاحقًا',
                      style: TextStyle(color: Color(0xFF19345E))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFF9800), // برتقالي
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: onUpgrade,
                  child: Text('ترقية الحساب',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SellerPlansDialog extends StatefulWidget {
  const SellerPlansDialog({super.key});
  @override
  State<SellerPlansDialog> createState() => _SellerPlansDialogState();
}

class _SellerPlansDialogState extends State<SellerPlansDialog> {
  int? selectedPlan;
  final plans = [
    {'label': 'حساب تجريبي (أسبوع مجاني)', 'price': 'مجاني'},
    {'label': 'حساب شهري', 'price': '100 رس'},
    {'label': 'حساب سنوي', 'price': '900 رس'},
    {'label': 'حساب دائم', 'price': '3500 رس'},
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('اختر نوع حساب البائع',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF19345E))),
          const SizedBox(height: 8),
          ...plans.asMap().entries.map((entry) {
            int idx = entry.key;
            var plan = entry.value;
            return RadioListTile<int>(
              value: idx,
              groupValue: selectedPlan,
              onChanged: (val) => setState(() => selectedPlan = val),
              title: Text(plan['label']!),
              subtitle: Text(plan['price']!,
                  style: TextStyle(color: Color(0xFFFF9800))),
              activeColor: Color(0xFFFF9800),
            );
          }),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child:
                      Text('إلغاء', style: TextStyle(color: Color(0xFF19345E))),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedPlan != null
                        ? Color(0xFFFF9800)
                        : Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: selectedPlan != null
                      ? () => Navigator.pop(context, true)
                      : null,
                  child: Text('ترقية الحساب',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
