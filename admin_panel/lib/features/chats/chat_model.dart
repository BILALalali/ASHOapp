// نموذج بيانات المحادثة
enum ChatStatus { pending, confirmed, cancelled }

class Chat {
  final String id;
  final String productImage;
  final String productName;
  final String buyerName;
  final String buyerId;
  final String sellerName;
  final String sellerId;
  final int unreadCount;
  final DateTime lastMessageTime;
  final String lastMessage;
  final String lastMessageSender;
  ChatStatus status;
  final bool isBuyerBlocked;
  final bool isSellerBlocked;

  Chat({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.buyerName,
    required this.buyerId,
    required this.sellerName,
    required this.sellerId,
    required this.unreadCount,
    required this.lastMessageTime,
    required this.lastMessage,
    required this.lastMessageSender,
    required this.status,
    this.isBuyerBlocked = false,
    this.isSellerBlocked = false,
  });

  factory Chat.fromJson(Map<String, dynamic> json) {
    return Chat(
      id: json['id'] ?? '',
      productImage: json['productImage'] ?? '',
      productName: json['productName'] ?? '',
      buyerName: json['buyerName'] ?? '',
      buyerId: json['buyerId'] ?? '',
      sellerName: json['sellerName'] ?? '',
      sellerId: json['sellerId'] ?? '',
      unreadCount: json['unreadCount'] ?? 0,
      lastMessageTime: DateTime.parse(
          json['lastMessageTime'] ?? DateTime.now().toIso8601String()),
      lastMessage: json['lastMessage'] ?? '',
      lastMessageSender: json['lastMessageSender'] ?? '',
      status: ChatStatus.values.firstWhere(
        (e) => e.toString() == 'ChatStatus.${json['status']}',
        orElse: () => ChatStatus.pending,
      ),
      isBuyerBlocked: json['isBuyerBlocked'] ?? false,
      isSellerBlocked: json['isSellerBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productImage': productImage,
      'productName': productName,
      'buyerName': buyerName,
      'buyerId': buyerId,
      'sellerName': sellerName,
      'sellerId': sellerId,
      'unreadCount': unreadCount,
      'lastMessageTime': lastMessageTime.toIso8601String(),
      'lastMessage': lastMessage,
      'lastMessageSender': lastMessageSender,
      'status': status.toString().split('.').last,
      'isBuyerBlocked': isBuyerBlocked,
      'isSellerBlocked': isSellerBlocked,
    };
  }

  Chat copyWith({
    String? id,
    String? productImage,
    String? productName,
    String? buyerName,
    String? buyerId,
    String? sellerName,
    String? sellerId,
    int? unreadCount,
    DateTime? lastMessageTime,
    String? lastMessage,
    String? lastMessageSender,
    ChatStatus? status,
    bool? isBuyerBlocked,
    bool? isSellerBlocked,
  }) {
    return Chat(
      id: id ?? this.id,
      productImage: productImage ?? this.productImage,
      productName: productName ?? this.productName,
      buyerName: buyerName ?? this.buyerName,
      buyerId: buyerId ?? this.buyerId,
      sellerName: sellerName ?? this.sellerName,
      sellerId: sellerId ?? this.sellerId,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      lastMessage: lastMessage ?? this.lastMessage,
      lastMessageSender: lastMessageSender ?? this.lastMessageSender,
      status: status ?? this.status,
      isBuyerBlocked: isBuyerBlocked ?? this.isBuyerBlocked,
      isSellerBlocked: isSellerBlocked ?? this.isSellerBlocked,
    );
  }
}
