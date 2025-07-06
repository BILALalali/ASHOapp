// خدمة جلب الإحصائيات والتقارير
class StatsService {
  static Future<Map<String, dynamic>> getUsersStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'count': 120,
      'pendingRequests': 0,
      'lastUpdates': [
        {'name': 'أحمد', 'action': 'تسجيل جديد'},
        {'name': 'سارة', 'action': 'تحديث بيانات'},
        {'name': 'محمد', 'action': 'طلب ترقية'},
      ],
    };
  }

  static Future<Map<String, dynamic>> getUpgradeStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'pending': 0,
      'upgraded': 42,
    };
  }

  static Future<Map<String, dynamic>> getProductsStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'today': 3,
      'week': 12,
      'lastProducts': [
        {'name': 'هاتف ذكي'},
        {'name': 'كتاب برمجة'},
        {'name': 'طاولة مكتب'},
      ],
      'count': 87,
    };
  }

  static Future<Map<String, dynamic>> getChatsStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'negotiation': 5,
      'sold': 7,
      'cancelled': 2,
      'reports': 1,
    };
  }

  static Future<Map<String, dynamic>> getAdsStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return {
      'count': 4,
      'lastAd': 'عرض خاص على الإلكترونيات',
      'expiringTomorrow': 1,
    };
  }
}
