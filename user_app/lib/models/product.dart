enum ProductStatus { available, sold }

class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String category;
  final String imageUrl;
  final String sellerName;
  final String sellerId;
  final ProductStatus status;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.imageUrl,
    required this.sellerName,
    required this.sellerId,
    required this.status,
  });
}
