import 'package:flutter/material.dart';
import '../../models/product.dart';

class MyProductDetailsScreen extends StatelessWidget {
  final Product product;
  const MyProductDetailsScreen({Key? key, required this.product})
      : super(key: key);

  void _confirmDelete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تأكيد الحذف'),
        content: const Text('هل أنت متأكد من حذف هذا المنتج؟ لا يمكن التراجع.'),
        actions: [
          TextButton(
              child: const Text('إلغاء'),
              onPressed: () => Navigator.pop(ctx, false)),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('حذف'),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      Navigator.pop(context, true); // أبلغ الشاشة الأم بالحذف
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSold = product.status == ProductStatus.sold;
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل المنتج'),
        backgroundColor: const Color(0xFF19345E),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete, color: Colors.white),
            label:
                const Text('حذف المنتج', style: TextStyle(color: Colors.white)),
            onPressed: () => _confirmDelete(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // صورة المنتج مع حواف علوية فقط
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: Image.network(
                product.imageUrl,
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 220,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, size: 60, color: Colors.grey),
                ),
              ),
            ),
            // بطاقة معلومات المنتج
            Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج وزر الحالة في نفس السطر
                    Row(
                      children: [
                        Expanded(
                          child: Text(product.name,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSold ? Colors.grey : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(isSold ? 'مباع' : 'متاح',
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text('السعر: ${product.price} ${product.currency}',
                        style: const TextStyle(fontSize: 16)),
                    const SizedBox(height: 4),
                    Text('الفئة: ${product.category}',
                        style: const TextStyle(fontSize: 15)),
                    const SizedBox(height: 8),
                    // الوصف داخل البطاقة
                    Text('الوصف:',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                            fontSize: 14)),
                    const SizedBox(height: 2),
                    Text(product.description,
                        style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),
            // معلومات إضافية
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Card(
                color: const Color(0xFFF7F8FA),
                elevation: 0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('معرف المنتج: ${product.id}'),
                      Text('البائع: ${product.sellerName}'),
                      Text('تاريخ الإضافة: 2024-01-15'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 80), // مساحة لزر الحذف السفلي
          ],
        ),
      ),
    );
  }
}
