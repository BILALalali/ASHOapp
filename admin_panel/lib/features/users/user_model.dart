import 'package:flutter/material.dart';

// نموذج بيانات المستخدم
class User {
  final String id;
  final String name;
  final String avatarUrl;
  final String email;
  final String phone;
  final bool isSeller;
  final DateTime joinDate;
  final bool isVerified;
  final bool hasUpgradeRequest;

  User({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.email,
    required this.phone,
    required this.isSeller,
    required this.joinDate,
    required this.isVerified,
    required this.hasUpgradeRequest,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      avatarUrl: json['avatarUrl'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isSeller: json['isSeller'] ?? false,
      joinDate:
          DateTime.parse(json['joinDate'] ?? DateTime.now().toIso8601String()),
      isVerified: json['isVerified'] ?? false,
      hasUpgradeRequest: json['hasUpgradeRequest'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatarUrl': avatarUrl,
      'email': email,
      'phone': phone,
      'isSeller': isSeller,
      'joinDate': joinDate.toIso8601String(),
      'isVerified': isVerified,
      'hasUpgradeRequest': hasUpgradeRequest,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    String? email,
    String? phone,
    bool? isSeller,
    DateTime? joinDate,
    bool? isVerified,
    bool? hasUpgradeRequest,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isSeller: isSeller ?? this.isSeller,
      joinDate: joinDate ?? this.joinDate,
      isVerified: isVerified ?? this.isVerified,
      hasUpgradeRequest: hasUpgradeRequest ?? this.hasUpgradeRequest,
    );
  }

  String get accountTypeDisplay => isSeller ? 'بائع' : 'مشتري';
  Color get accountTypeColor => isSeller ? Colors.blue : Colors.grey;
}
