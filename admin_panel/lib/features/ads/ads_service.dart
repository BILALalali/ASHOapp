import 'ad_model.dart';

// خدمة إدارة الإعلانات
class AdsService {
  static final List<AdModel> _ads = [];

  static Future<List<AdModel>> getAllAds() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_ads);
  }

  static Future<void> addAd(AdModel ad) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _ads.add(ad);
  }

  static Future<void> deleteAd(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _ads.removeWhere((ad) => ad.id == id);
  }
}
