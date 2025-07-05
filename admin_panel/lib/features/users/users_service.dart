import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';
import 'dart:math';

// خدمة إدارة المستخدمين
class UsersService {
  static const String baseUrl =
      'http://localhost:3000/api'; // تغيير حسب API الخاص بك

  // جلب جميع المستخدمين
  static Future<List<User>> getAllUsers() async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      User(
        id: '1',
        name: 'أحمد محمد',
        avatarUrl: '',
        email: 'ahmed@example.com',
        phone: '+963991234567',
        isSeller: false,
        joinDate: now.subtract(const Duration(days: 120)),
        isVerified: true,
        hasUpgradeRequest: true,
      ),
      User(
        id: '2',
        name: 'فاطمة علي',
        avatarUrl: '',
        email: 'fatima@example.com',
        phone: '+963994567890',
        isSeller: true,
        joinDate: now.subtract(const Duration(days: 90)),
        isVerified: true,
        hasUpgradeRequest: false,
      ),
      User(
        id: '3',
        name: 'محمد عبدالله',
        avatarUrl: '',
        email: 'mohammed@example.com',
        phone: '+963995678901',
        isSeller: false,
        joinDate: now.subtract(const Duration(days: 60)),
        isVerified: false,
        hasUpgradeRequest: false,
      ),
      User(
        id: '4',
        name: 'سارة أحمد',
        avatarUrl: '',
        email: 'sara@example.com',
        phone: '+963996789012',
        isSeller: false,
        joinDate: now.subtract(const Duration(days: 30)),
        isVerified: false,
        hasUpgradeRequest: true,
      ),
      User(
        id: '5',
        name: 'علي حسن',
        avatarUrl: '',
        email: 'ali@example.com',
        phone: '+963997890123',
        isSeller: true,
        joinDate: now.subtract(const Duration(days: 10)),
        isVerified: true,
        hasUpgradeRequest: false,
      ),
    ];
  }

  // جلب مستخدم واحد
  static Future<User> getUserById(String id) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // محاكاة البحث عن المستخدم
      final users = await getAllUsers();
      final user = users.firstWhere((user) => user.id == id);
      return user;
    } catch (e) {
      throw Exception('فشل في جلب المستخدم: $e');
    }
  }

  // تحديث مستخدم
  static Future<User> updateUser(String id, Map<String, dynamic> data) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // محاكاة التحديث
      final users = await getAllUsers();
      final userIndex = users.indexWhere((user) => user.id == id);

      if (userIndex == -1) {
        throw Exception('المستخدم غير موجود');
      }

      final updatedUser = users[userIndex].copyWith(
        name: data['name'],
        email: data['email'],
        phone: data['phone'],
        isSeller: data['isSeller'],
        joinDate: data['joinDate'],
        isVerified: data['isVerified'],
      );

      return updatedUser;
    } catch (e) {
      throw Exception('فشل في تحديث المستخدم: $e');
    }
  }

  // حذف مستخدم
  static Future<bool> deleteUser(String id) async {
    try {
      await Future.delayed(const Duration(seconds: 1));

      // محاكاة الحذف
      return true;
    } catch (e) {
      throw Exception('فشل في حذف المستخدم: $e');
    }
  }

  // تفعيل/إلغاء تفعيل مستخدم
  static Future<bool> toggleUserStatus(String id, bool isActive) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      // محاكاة تغيير الحالة
      return true;
    } catch (e) {
      throw Exception('فشل في تغيير حالة المستخدم: $e');
    }
  }

  // البحث في المستخدمين
  static Future<List<User>> searchUsers(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300));

      final allUsers = await getAllUsers();
      return allUsers
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.email.toLowerCase().contains(query.toLowerCase()) ||
              user.phone.contains(query))
          .toList();
    } catch (e) {
      throw Exception('فشل في البحث: $e');
    }
  }
}
