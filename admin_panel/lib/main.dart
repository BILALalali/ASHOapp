import 'package:flutter/material.dart';
import 'features/dashboard/dashboard_screen.dart';
import 'features/users/users_screen.dart';
import 'features/upgrade_requests/upgrade_requests_screen.dart';
import 'features/products/products_screen.dart';
import 'features/chats/chats_screen.dart';
import 'features/ads/ads_screen.dart';
import 'features/reports/reports_screen.dart';

void main() {
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Asho_admen',
      theme: ThemeData(
        primaryColor: const Color(0xFF193A6B),
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF193A6B),
          primary: const Color(0xFF193A6B),
          secondary: const Color(0xFFFFA726),
          background: const Color(0xFFF5F6FA),
          surface: Colors.white,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: const Color(0xFF193A6B),
          onSurface: const Color(0xFF193A6B),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF193A6B),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFA726),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: const Color(0xFF193A6B),
            side: const BorderSide(color: Color(0xFF193A6B)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            textStyle:
                const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF193A6B), width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF193A6B), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFFA726), width: 2),
          ),
          labelStyle: const TextStyle(color: Color(0xFF193A6B)),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        dividerColor: const Color(0xFFE0E3EB),
        textTheme: const TextTheme(
          headlineSmall:
              TextStyle(color: Color(0xFF193A6B), fontWeight: FontWeight.bold),
          titleMedium:
              TextStyle(color: Color(0xFF193A6B), fontWeight: FontWeight.w600),
          bodyMedium: TextStyle(color: Color(0xFF193A6B)),
          bodySmall: TextStyle(color: Color(0xFF193A6B)),
        ),
        fontFamily: 'Tajawal',
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _error;

  void _login() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    await Future.delayed(const Duration(seconds: 1));
    if (_emailController.text == 'admin@asho.com' &&
        _passwordController.text == 'admin123') {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AdminHome()),
      );
    } else {
      setState(() {
        _error = 'بيانات الدخول غير صحيحة';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 24),
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('تسجيل دخول الأدمن',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF193A6B))),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'البريد الإلكتروني',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (v) => v == null || v.isEmpty
                          ? 'أدخل البريد الإلكتروني'
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'كلمة المرور',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      validator: (v) =>
                          v == null || v.isEmpty ? 'أدخل كلمة المرور' : null,
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Text(_error!, style: const TextStyle(color: Colors.red)),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  _login();
                                }
                              },
                        child: _isLoading
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('دخول'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<_DrawerItem> _drawerItems = const [
    _DrawerItem('لوحة المعلومات', Icons.dashboard),
    _DrawerItem('إدارة المستخدمين', Icons.people),
    _DrawerItem('طلبات الترقية', Icons.upgrade),
    _DrawerItem('إدارة المنتجات', Icons.store),
    _DrawerItem('المحادثات والطلبات', Icons.chat),
    _DrawerItem('نظام الإعلانات', Icons.campaign),
    _DrawerItem('التقارير والإحصائيات', Icons.bar_chart),
  ];

  final List<Widget> _screens = const [
    DashboardScreen(),
    UsersScreen(),
    UpgradeRequestsScreen(),
    ProductsScreen(),
    ChatsScreen(),
    AdsScreen(),
    ReportsScreen(),
  ];

  @override
  void dispose() {
    _selectedIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _selectedIndex,
      builder: (context, selected, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text(_drawerItems[selected].title),
          ),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF193A6B),
                  ),
                  child: Text('القائمة',
                      style: TextStyle(color: Colors.white, fontSize: 20)),
                ),
                ...List.generate(_drawerItems.length, (i) {
                  return ListTile(
                    leading: Icon(_drawerItems[i].icon,
                        color: selected == i ? Color(0xFFFFA726) : null),
                    title: Text(_drawerItems[i].title),
                    selected: selected == i,
                    onTap: () {
                      _selectedIndex.value = i;
                      Navigator.pop(context);
                    },
                  );
                }),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text('تسجيل الخروج'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                ),
              ],
            ),
          ),
          body: _screens[selected],
        );
      },
    );
  }
}

class _DrawerItem {
  final String title;
  final IconData icon;
  const _DrawerItem(this.title, this.icon);
}
