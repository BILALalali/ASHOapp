import 'chat_model.dart';
import 'message_model.dart';

// خدمة إدارة المحادثات
class ChatsService {
  static final List<Chat> _chats = [];
  static final Map<String, List<Message>> _messages = {};

  // تهيئة البيانات التجريبية
  static void _initializeSampleData() {
    if (_chats.isNotEmpty) return;

    final now = DateTime.now();

    _chats.addAll([
      Chat(
        id: '1',
        productImage: 'https://via.placeholder.com/150',
        productName: 'هاتف سامسونج جالكسي S23',
        buyerName: 'أحمد محمد',
        buyerId: 'buyer1',
        sellerName: 'محمد عبدالله',
        sellerId: 'seller1',
        unreadCount: 2,
        lastMessageTime: now.subtract(const Duration(minutes: 5)),
        lastMessage: 'هل يمكنني رؤية المزيد من الصور؟',
        lastMessageSender: 'buyer',
        status: ChatStatus.pending,
      ),
      Chat(
        id: '2',
        productImage: 'https://via.placeholder.com/150/0000FF',
        productName: 'لابتوب HP Pavilion',
        buyerName: 'فاطمة علي',
        buyerId: 'buyer2',
        sellerName: 'علي حسن',
        sellerId: 'seller2',
        unreadCount: 0,
        lastMessageTime: now.subtract(const Duration(hours: 2)),
        lastMessage: 'تم تأكيد الطلب بنجاح',
        lastMessageSender: 'admin',
        status: ChatStatus.confirmed,
      ),
      Chat(
        id: '3',
        productImage: 'https://via.placeholder.com/150/00FF00',
        productName: 'كنزة شتوية',
        buyerName: 'سارة أحمد',
        buyerId: 'buyer3',
        sellerName: 'خالد محمود',
        sellerId: 'seller3',
        unreadCount: 1,
        lastMessageTime: now.subtract(const Duration(hours: 1)),
        lastMessage: 'السعر النهائي 80000 ليرة',
        lastMessageSender: 'seller',
        status: ChatStatus.pending,
        isBuyerBlocked: true,
      ),
      Chat(
        id: '4',
        productImage: 'https://via.placeholder.com/150/FF0000',
        productName: 'طابعة كانون',
        buyerName: 'عمر يوسف',
        buyerId: 'buyer4',
        sellerName: 'نور الدين',
        sellerId: 'seller4',
        unreadCount: 0,
        lastMessageTime: now.subtract(const Duration(days: 1)),
        lastMessage: 'تم إلغاء الطلب من قبل المشتري',
        lastMessageSender: 'buyer',
        status: ChatStatus.cancelled,
      ),
    ]);

    // إضافة رسائل تجريبية
    _messages['1'] = [
      Message(
        id: '1',
        text: 'السلام عليكم، أود شراء هذا الهاتف',
        senderId: 'buyer1',
        senderName: 'أحمد محمد',
        senderType: 'buyer',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
      Message(
        id: '2',
        text: 'أهلاً وسهلاً، الهاتف متوفر وبحالة ممتازة',
        senderId: 'seller1',
        senderName: 'محمد عبدالله',
        senderType: 'seller',
        timestamp: now.subtract(const Duration(minutes: 45)),
      ),
      Message(
        id: '3',
        text: 'هل يمكنني رؤية المزيد من الصور؟',
        senderId: 'buyer1',
        senderName: 'أحمد محمد',
        senderType: 'buyer',
        timestamp: now.subtract(const Duration(minutes: 5)),
      ),
    ];

    _messages['2'] = [
      Message(
        id: '1',
        text: 'السلام عليكم، هل اللابتوب متوفر؟',
        senderId: 'buyer2',
        senderName: 'فاطمة علي',
        senderType: 'buyer',
        timestamp: now.subtract(const Duration(hours: 3)),
      ),
      Message(
        id: '2',
        text: 'نعم متوفر وبحالة ممتازة',
        senderId: 'seller2',
        senderName: 'علي حسن',
        senderType: 'seller',
        timestamp: now.subtract(const Duration(hours: 2, minutes: 30)),
      ),
      Message(
        id: '3',
        text: 'تم تأكيد الطلب بنجاح',
        senderId: 'admin',
        senderName: 'إدارة أشو ماركت',
        senderType: 'admin',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
    ];

    _messages['3'] = [
      Message(
        id: '1',
        text: 'السلام عليكم، هل الكنزة متوفرة بالمقاس M؟',
        senderId: 'buyer3',
        senderName: 'سارة أحمد',
        senderType: 'buyer',
        timestamp: now.subtract(const Duration(hours: 2)),
      ),
      Message(
        id: '2',
        text: 'نعم متوفرة، السعر النهائي 80000 ليرة',
        senderId: 'seller3',
        senderName: 'خالد محمود',
        senderType: 'seller',
        timestamp: now.subtract(const Duration(hours: 1)),
      ),
    ];
  }

  // جلب جميع المحادثات
  static Future<List<Chat>> getAllChats() async {
    _initializeSampleData();
    await Future.delayed(const Duration(milliseconds: 500));
    return List.unmodifiable(_chats);
  }

  // جلب محادثة واحدة
  static Future<Chat?> getChatById(String chatId) async {
    _initializeSampleData();
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _chats.firstWhere((chat) => chat.id == chatId);
    } catch (e) {
      return null;
    }
  }

  // جلب رسائل محادثة
  static Future<List<Message>> getChatMessages(String chatId) async {
    _initializeSampleData();
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_messages[chatId] ?? []);
  }

  // إرسال رسالة من المشرف
  static Future<Message> sendAdminMessage(String chatId, String text) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      senderId: 'admin',
      senderName: 'إدارة أشو ماركت',
      senderType: 'admin',
      timestamp: DateTime.now(),
    );

    if (!_messages.containsKey(chatId)) {
      _messages[chatId] = [];
    }
    _messages[chatId]!.add(message);

    // تحديث آخر رسالة في المحادثة
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      _chats[chatIndex] = _chats[chatIndex].copyWith(
        lastMessage: text,
        lastMessageSender: 'admin',
        lastMessageTime: DateTime.now(),
        unreadCount: 0,
      );
    }

    return message;
  }

  // حظر/إلغاء حظر المستخدم
  static Future<bool> toggleUserBlock(String chatId, String userType) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) return false;

    final chat = _chats[chatIndex];
    if (userType == 'buyer') {
      _chats[chatIndex] = chat.copyWith(isBuyerBlocked: !chat.isBuyerBlocked);
    } else if (userType == 'seller') {
      _chats[chatIndex] = chat.copyWith(isSellerBlocked: !chat.isSellerBlocked);
    }

    return true;
  }

  // تحديث حالة المحادثة
  static Future<bool> updateChatStatus(String chatId, ChatStatus status) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex == -1) return false;

    _chats[chatIndex] = _chats[chatIndex].copyWith(status: status);
    return true;
  }

  // البحث في المحادثات
  static Future<List<Chat>> searchChats(String query) async {
    _initializeSampleData();
    await Future.delayed(const Duration(milliseconds: 300));

    return _chats
        .where((chat) =>
            chat.productName.toLowerCase().contains(query.toLowerCase()) ||
            chat.buyerName.toLowerCase().contains(query.toLowerCase()) ||
            chat.sellerName.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  // فلترة المحادثات حسب الحالة
  static Future<List<Chat>> filterChatsByStatus(ChatStatus? status) async {
    _initializeSampleData();
    await Future.delayed(const Duration(milliseconds: 300));

    if (status == null) return List.unmodifiable(_chats);

    return _chats.where((chat) => chat.status == status).toList();
  }
}
