import 'package:flutter/material.dart';
import '../../models/product.dart';
import 'my_product_details_screen.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  // بيانات وهمية مؤقتة
  List<Product> products = [
    Product(
      id: '1',
      name: 'هاتف ذكي',
      description: 'هاتف ذكي حديث مع كاميرا عالية الدقة.',
      price: 1000,
      currency: ' \$',
      category: 'الكترونيات',
      imageUrl: 'https://i.imgur.com/BoN9kdC.png',
      sellerName: 'أحمد محمد',
      sellerId: '1',
      status: ProductStatus.available,
    ),
    Product(
      id: '2',
      name: 'قميص قطني',
      description: 'قميص قطني مريح وأنيق.',
      price: 50,
      currency: ' \$',
      category: 'ملابس',
      imageUrl: 'https://i.imgur.com/BoN9kdC.png',
      sellerName: 'أحمد محمد',
      sellerId: '1',
      status: ProductStatus.sold,
    ),
    // أضف المزيد حسب الحاجة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('منتجاتي'),
        centerTitle: true,
        backgroundColor: const Color(0xFF19345E),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return _ProductCard(
            product: product,
            onDetails: () async {
              final deleted = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyProductDetailsScreen(
                    product: product,
                  ),
                ),
              );
              if (deleted == true) {
                setState(() => products.removeAt(index));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم حذف المنتج بنجاح'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDetails;
  const _ProductCard({required this.product, required this.onDetails});

  @override
  Widget build(BuildContext context) {
    final isSold = product.status == ProductStatus.sold;
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                product.imageUrl,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('${product.price} ${product.currency}',
                      style: const TextStyle(fontSize: 15)),
                  Text(product.category, style: const TextStyle(fontSize: 13)),
                  const SizedBox(height: 4),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSold ? Colors.grey : Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isSold ? 'مباع' : 'متاح',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                TextButton.icon(
                  onPressed: onDetails,
                  icon: const Icon(Icons.remove_red_eye,
                      color: Color(0xFF19345E)),
                  label: const Text('التفاصيل',
                      style: TextStyle(color: Color(0xFF19345E))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
