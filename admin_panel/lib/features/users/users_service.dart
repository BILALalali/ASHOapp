import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user_model.dart';

// خدمة إدارة المستخدمين
class UsersService {
  static const String baseUrl =
      'http://localhost:3000/api'; // تغيير حسب API الخاص بك

  // جلب جميع المستخدمين
  static Future<List<User>> getAllUsers() async {
    try {
      // محاكاة API - يمكن استبدالها بـ API حقيقي
      await Future.delayed(const Duration(seconds: 1));

      // بيانات تجريبية
      final mockUsers = [
        {
          'id': '1',
          'name': 'أحمد محمد',
          'email': 'ahmed@example.com',
          'phone': '+966501234567',
          'accountType': 'regular',
          'joinDate': '2024-01-15T10:30:00Z',
          'isActive': true,
          'profileImage': null,
          'address': 'الرياض، المملكة العربية السعودية',
          'productsCount': 5,
          'ordersCount': 12,
          'rating': 4.2,
          'isVerified': true,
        },
        {
          'id': '2',
          'name': 'فاطمة علي',
          'email': 'fatima@example.com',
          'phone': '+966507654321',
          'accountType': 'premium',
          'joinDate': '2024-02-20T14:15:00Z',
          'isActive': true,
          'profileImage': null,
          'address': 'جدة، المملكة العربية السعودية',
          'productsCount': 15,
          'ordersCount': 28,
          'rating': 4.8,
          'isVerified': true,
        },
        {
          'id': '3',
          'name': 'محمد عبدالله',
          'email': 'mohammed@example.com',
          'phone': '+966509876543',
          'accountType': 'business',
          'joinDate': '2024-03-10T09:45:00Z',
          'isActive': true,
          'profileImage': null,
          'address': 'الدمام، المملكة العربية السعودية',
          'productsCount': 45,
          'ordersCount': 67,
          'rating': 4.5,
          'isVerified': true,
        },
        {
          'id': '4',
          'name': 'سارة أحمد',
          'email': 'sara@example.com',
          'phone': '+966501112223',
          'accountType': 'regular',
          'joinDate': '2024-04-05T16:20:00Z',
          'isActive': false,
          'profileImage': null,
          'address': 'مكة المكرمة، المملكة العربية السعودية',
          'productsCount': 2,
          'ordersCount': 8,
          'rating': 3.9,
          'isVerified': false,
        },
        {
          'id': '5',
          'name': 'علي حسن',
          'email': 'ali@example.com',
          'phone': '+966504445556',
          'accountType': 'premium',
          'joinDate': '2024-05-12T11:30:00Z',
          'isActive': true,
          'profileImage': null,
          'address': 'المدينة المنورة، المملكة العربية السعودية',
          'productsCount': 22,
          'ordersCount': 35,
          'rating': 4.7,
          'isVerified': true,
        },
      ];

      return mockUsers.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل في جلب المستخدمين: $e');
    }
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
        accountType: data['accountType'],
        isActive: data['isActive'],
        address: data['address'],
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
