import 'package:flutter/material.dart';

// نموذج بيانات المستخدم
class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String accountType; // 'regular', 'premium', 'business'
  final DateTime joinDate;
  final bool isActive;
  final String? profileImage;
  final String? address;
  final int productsCount;
  final int ordersCount;
  final double rating;
  final bool isVerified;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.accountType,
    required this.joinDate,
    required this.isActive,
    this.profileImage,
    this.address,
    required this.productsCount,
    required this.ordersCount,
    required this.rating,
    required this.isVerified,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      accountType: json['accountType'] ?? 'regular',
      joinDate:
          DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      isActive: json['isActive'] ?? true,
      profileImage: json['profileImage'],
      address: json['address'],
      productsCount: json['productsCount'] ?? 0,
      ordersCount: json['ordersCount'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'accountType': accountType,
      'joinDate': joinDate.toIso8601String(),
      'isActive': isActive,
      'profileImage': profileImage,
      'address': address,
      'productsCount': productsCount,
      'ordersCount': ordersCount,
      'rating': rating,
      'isVerified': isVerified,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? accountType,
    DateTime? joinDate,
    bool? isActive,
    String? profileImage,
    String? address,
    int? productsCount,
    int? ordersCount,
    double? rating,
    bool? isVerified,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      accountType: accountType ?? this.accountType,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      profileImage: profileImage ?? this.profileImage,
      address: address ?? this.address,
      productsCount: productsCount ?? this.productsCount,
      ordersCount: ordersCount ?? this.ordersCount,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
    );
  }

  String get accountTypeDisplay {
    switch (accountType) {
      case 'regular':
        return 'عادي';
      case 'premium':
        return 'مميز';
      case 'business':
        return 'تجاري';
      default:
        return 'عادي';
    }
  }

  Color get accountTypeColor {
    switch (accountType) {
      case 'regular':
        return Colors.grey;
      case 'premium':
        return Colors.amber;
      case 'business':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
