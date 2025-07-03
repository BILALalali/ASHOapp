enum ChatStatus { pending, confirmed, cancelled }

class Chat {
  final String id;
  final String productImage;
  final String productName;
  final String buyerName;
  final String buyerId;
  final int unreadCount;
  ChatStatus status;

  Chat({
    required this.id,
    required this.productImage,
    required this.productName,
    required this.buyerName,
    required this.buyerId,
    required this.unreadCount,
    required this.status,
  });
}
