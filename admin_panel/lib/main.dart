import 'package:flutter/material.dart';

void main() {
  runApp(const AdminPanelApp());
}

class AdminPanelApp extends StatelessWidget {
  const AdminPanelApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'لوحة تحكم آشو',
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
        fontFamily: 'Tajawal', // يفضل استخدام خط عربي متناسق
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('لوحة تحكم آشو')),
        body: const Center(child: Text('مرحبًا بك في لوحة تحكم آشو!')),
      ),
    );
  }
}
