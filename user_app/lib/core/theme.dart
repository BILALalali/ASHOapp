import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF193A6B); // الأزرق الداكن
  static const Color accent = Color(0xFFFFA726); // البرتقالي
  static const Color white = Colors.white;
  static const Color lightGrey = Color(0xFFF5F6FA);
}

final ThemeData appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.white,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.accent,
    background: AppColors.white,
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: AppColors.white,
    elevation: 0,
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.white,
    selectedItemColor: AppColors.primary,
    unselectedItemColor: AppColors.primary,
    showUnselectedLabels: true,
  ),
  fontFamily: 'Tajawal', // يمكنك تغيير الخط حسب الحاجة
);
