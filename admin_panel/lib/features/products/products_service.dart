import 'product_model.dart';

// خدمة إدارة المنتجات
class ProductsService {
  static Future<List<Product>> getAllProducts() async {
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();
    return [
      Product(
        id: '1',
        name: 'هاتف سامسونج',
        description: 'هاتف ذكي بحالة ممتازة، شاشة 6.5 إنش، ذاكرة 128GB.',
        price: 1200000,
        currency: 'SYP',
        category: 'إلكترونيات',
        imageUrls: [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150/0000FF',
          'https://via.placeholder.com/150/FF0000',
        ],
        sellerName: 'أحمد محمد',
        sellerId: 'u1',
        status: 'available',
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Product(
        id: '2',
        name: 'كنزة شتوية',
        description: 'كنزة صوفية دافئة، مقاس M، لون رمادي.',
        price: 80000,
        currency: 'SYP',
        category: 'ملابس',
        imageUrls: [
          'https://via.placeholder.com/150',
          'https://via.placeholder.com/150/00FF00',
        ],
        sellerName: 'فاطمة علي',
        sellerId: 'u2',
        status: 'sold',
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      Product(
        id: '3',
        name: 'لابتوب HP',
        description: 'لابتوب بحالة جيدة، معالج i5، رام 8GB، SSD 256GB.',
        price: 3500000,
        currency: 'SYP',
        category: 'إلكترونيات',
        imageUrls: [
          'https://via.placeholder.com/150',
        ],
        sellerName: 'محمد عبدالله',
        sellerId: 'u3',
        status: 'available',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }
}
