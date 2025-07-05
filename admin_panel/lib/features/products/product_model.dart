// نموذج بيانات المنتج
class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String currency;
  final String category;
  final List<String> imageUrls;
  final String sellerName;
  final String sellerId;
  final String status; // 'available', 'sold'
  final DateTime createdAt;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.currency,
    required this.category,
    required this.imageUrls,
    required this.sellerName,
    required this.sellerId,
    required this.status,
    required this.createdAt,
  });

  String get mainImageUrl => imageUrls.isNotEmpty ? imageUrls.first : '';

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'SYP',
      category: json['category'] ?? '',
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      sellerName: json['sellerName'] ?? '',
      sellerId: json['sellerId'] ?? '',
      status: json['status'] ?? 'available',
      createdAt:
          DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'currency': currency,
      'category': category,
      'imageUrls': imageUrls,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? currency,
    String? category,
    List<String>? imageUrls,
    String? sellerName,
    String? sellerId,
    String? status,
    DateTime? createdAt,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      currency: currency ?? this.currency,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls,
      sellerName: sellerName ?? this.sellerName,
      sellerId: sellerId ?? this.sellerId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
