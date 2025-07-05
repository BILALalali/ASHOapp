// شاشة إدارة المنتجات
import 'package:flutter/material.dart';
import 'product_model.dart';
import 'products_service.dart';
import 'edit_product_dialog.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  String _selectedSeller = 'all';
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final products = await ProductsService.getAllProducts();
      setState(() {
        _products = products;
        _filteredProducts = products;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterProducts() {
    List<Product> filtered = _products;
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((p) =>
              p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.sellerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              p.category.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
    if (_selectedSeller != 'all') {
      filtered =
          filtered.where((p) => p.sellerName == _selectedSeller).toList();
    }
    if (_selectedCategory != 'all') {
      filtered =
          filtered.where((p) => p.category == _selectedCategory).toList();
    }
    setState(() {
      _filteredProducts = filtered;
    });
  }

  List<String> get _sellers => [
        'all',
        ...{..._products.map((p) => p.sellerName)}
      ];
  List<String> get _categories => [
        'all',
        ...{..._products.map((p) => p.category)}
      ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إدارة المنتجات',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF193A6B))),
              IconButton(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh),
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'بحث عن منتج أو بائع أو فئة...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterProducts();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedSeller,
                  items: _sellers
                      .map((seller) => DropdownMenuItem(
                            value: seller,
                            child:
                                Text(seller == 'all' ? 'كل البائعين' : seller),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _selectedSeller = value!;
                    _filterProducts();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedCategory,
                  items: _categories
                      .map((cat) => DropdownMenuItem(
                            value: cat,
                            child: Text(cat == 'all' ? 'كل الفئات' : cat),
                          ))
                      .toList(),
                  onChanged: (value) {
                    _selectedCategory = value!;
                    _filterProducts();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(_error!,
                            style: const TextStyle(color: Colors.red)))
                    : _filteredProducts.isEmpty
                        ? const Center(child: Text('لا توجد منتجات'))
                        : GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _filteredProducts.length,
                            itemBuilder: (context, index) {
                              final product = _filteredProducts[index];
                              return _ProductCard(
                                product: product,
                                onDetails: () => _showProductDetails(product),
                                onEdit: () {},
                                onDelete: () {},
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  void _showProductDetails(Product product) async {
    final updatedProduct = await showDialog<Product>(
      context: context,
      builder: (context) => Dialog(
        child: _ProductDetailsDialog(
          product: product,
          onEdit: () async {
            final result = await showDialog<Product>(
              context: context,
              builder: (context) => EditProductDialog(product: product),
            );
            if (result != null) {
              setState(() {
                _products = _products
                    .map((p) => p.id == result.id ? result : p)
                    .toList();
                _filterProducts();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم حفظ التعديلات'),
                    backgroundColor: Colors.green),
              );
            }
          },
          onDelete: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('تأكيد الحذف'),
                content: const Text('هل أنت متأكد من حذف هذا المنتج؟'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('إلغاء'),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text('حذف'),
                  ),
                ],
              ),
            );
            if (confirmed == true) {
              setState(() {
                _products = _products.where((p) => p.id != product.id).toList();
                _filterProducts();
              });
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('تم حذف المنتج'),
                    backgroundColor: Colors.red),
              );
            }
          },
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDetails;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductCard(
      {required this.product,
      required this.onDetails,
      required this.onEdit,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onDetails,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(product.mainImageUrl,
                    height: 90, width: double.infinity, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Text(product.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15)),
              Text('${product.price} ${product.currency}',
                  style: const TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold)),
              Text(product.category,
                  style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const Spacer(),
              Row(
                children: [
                  Icon(
                      product.status == 'available'
                          ? Icons.check_circle
                          : Icons.remove_shopping_cart,
                      color: product.status == 'available'
                          ? Colors.green
                          : Colors.red,
                      size: 18),
                  const SizedBox(width: 4),
                  Text(product.status == 'available' ? 'متاح' : 'مباع',
                      style: TextStyle(
                          color: product.status == 'available'
                              ? Colors.green
                              : Colors.red,
                          fontSize: 12)),
                  const Spacer(),
                  IconButton(
                      icon: const Icon(Icons.info_outline),
                      tooltip: 'تفاصيل',
                      onPressed: onDetails),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductDetailsDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  const _ProductDetailsDialog(
      {required this.product, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(product.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(product.mainImageUrl,
                  height: 180, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text('الوصف:', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(product.description),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('السعر: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${product.price} ${product.currency}',
                    style: const TextStyle(color: Colors.green)),
                const Spacer(),
                Text('الحالة: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(product.status == 'available' ? 'متاح' : 'مباع',
                    style: TextStyle(
                        color: product.status == 'available'
                            ? Colors.green
                            : Colors.red)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('البائع: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(product.sellerName),
                const Spacer(),
                Text('الفئة: ',
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(product.category),
              ],
            ),
            const SizedBox(height: 8),
            Text(
                'تاريخ الإضافة: ${product.createdAt.day}/${product.createdAt.month}/${product.createdAt.year}',
                style: const TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onEdit,
                    icon: const Icon(Icons.edit),
                    label: const Text('تعديل'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete),
                    label: const Text('حذف'),
                    style:
                        OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
