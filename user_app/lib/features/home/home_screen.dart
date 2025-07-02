import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../models/product.dart';
import 'widgets/banner_carousel.dart';
import 'widgets/category_selector.dart';
import 'widgets/product_card.dart';
import '../product_details/product_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User currentUser = User(
    id: '1',
    name: 'أهلاً وسهلاً..',
    avatarUrl: 'https://i.imgur.com/BoN9kdC.png',
    email: 'user@example.com',
    phone: '+966501234567',
    isSeller: false,
  );

  final List<String> banners = [
    'https://images.unsplash.com/photo-1506744038136-46273834b3fb',
    'https://images.unsplash.com/photo-1465101046530-73398c7f28ca',
  ];

  final List<String> categories = [
    'الكل',
    'ألعاب',
    'كتب',
    'أثاث',
    'ملابس',
    'إلكترونيات'
  ];
  String selectedCategory = 'الكل';

  final List<Product> allProducts = [
    Product(
      id: '1',
      name: 'هاتف ذكي',
      description: 'هاتف ذكي جديد',
      price: 1000,
      currency: ' \$',
      category: 'إلكترونيات',
      imageUrl: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9',
      sellerName: 'البائع 1',
      sellerId: '1',
      status: ProductStatus.available,
    ),
    Product(
      id: '2',
      name: 'قميص قطني',
      description: 'قميص قطني مريح',
      price: 50,
      currency: ' \$',
      category: 'ملابس',
      imageUrl: 'https://images.unsplash.com/photo-1526178613658-3f1622045557',
      sellerName: 'البائع 2',
      sellerId: '2',
      status: ProductStatus.sold,
    ),
    Product(
      id: '3',
      name: 'طاولة مكتب',
      description: 'طاولة مكتب أنيقة',
      price: 300,
      currency: ' \$',
      category: 'أثاث',
      imageUrl: 'https://images.unsplash.com/photo-1515378791036-0648a3ef77b2',
      sellerName: 'البائع 3',
      sellerId: '3',
      status: ProductStatus.available,
    ),
    Product(
      id: '4',
      name: 'كتاب برمجة',
      description: 'كتاب برمجة حديث',
      price: 25,
      currency: '  \$',
      category: 'كتب',
      imageUrl: 'https://images.unsplash.com/photo-1512820790803-83ca734da794',
      sellerName: 'البائع 4',
      sellerId: '4',
      status: ProductStatus.available,
    ),
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredProducts = allProducts.where((product) {
      final matchesCategory =
          selectedCategory == 'الكل' || product.category == selectedCategory;
      final matchesSearch =
          searchQuery.isEmpty || product.name.contains(searchQuery);
      return matchesCategory && matchesSearch;
    }).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(currentUser.avatarUrl),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(currentUser.name,
                        style: Theme.of(context).textTheme.titleMedium),
                    const Text('آشو عما تدور؟',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Banner
            BannerCarousel(imageUrls: banners),
            const SizedBox(height: 16),
            // Categories
            CategorySelector(
              categories: categories,
              selectedCategory: selectedCategory,
              onCategorySelected: (cat) =>
                  setState(() => selectedCategory = cat),
            ),
            const SizedBox(height: 16),
            // Search
            TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'ابحث عن منتج..',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              ),
              onChanged: (val) => setState(() => searchQuery = val),
            ),
            const SizedBox(height: 16),
            // Products Grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: filteredProducts.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.8,
              ),
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailsScreen(product: product),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
