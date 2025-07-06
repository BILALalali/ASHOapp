import 'package:flutter/material.dart';
import 'chat_model.dart';
import 'message_model.dart';
import 'chats_service.dart';

class ChatDetailsScreen extends StatefulWidget {
  final Chat chat;

  const ChatDetailsScreen({super.key, required this.chat});

  @override
  State<ChatDetailsScreen> createState() => _ChatDetailsScreenState();
}

class _ChatDetailsScreenState extends State<ChatDetailsScreen> {
  List<Message> _messages = [];
  bool _isLoading = true;
  String? _error;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final messages = await ChatsService.getChatMessages(widget.chat.id);
      setState(() {
        _messages = messages;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;

    final text = _messageController.text.trim();
    _messageController.clear();

    try {
      final message = await ChatsService.sendAdminMessage(widget.chat.id, text);
      setState(() {
        _messages.add(message);
      });
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('فشل في إرسال الرسالة: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _toggleUserBlock(String userType) async {
    final userTypeText = userType == 'buyer' ? 'المشتري' : 'البائع';
    final userName =
        userType == 'buyer' ? widget.chat.buyerName : widget.chat.sellerName;
    final isCurrentlyBlocked = userType == 'buyer'
        ? widget.chat.isBuyerBlocked
        : widget.chat.isSellerBlocked;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isCurrentlyBlocked ? 'إلغاء حظر المستخدم' : 'حظر المستخدم'),
        content: Text(isCurrentlyBlocked
            ? 'هل تريد إلغاء حظر $userTypeText "$userName"؟'
            : 'هل تريد حظر $userTypeText "$userName"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrentlyBlocked ? Colors.green : Colors.red,
            ),
            child: Text(isCurrentlyBlocked ? 'إلغاء الحظر' : 'حظر'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ChatsService.toggleUserBlock(widget.chat.id, userType);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(isCurrentlyBlocked
                  ? 'تم إلغاء حظر $userTypeText'
                  : 'تم حظر $userTypeText'),
              backgroundColor: Colors.green,
            ),
          );
        }
        // إعادة تحميل المحادثة لتحديث حالة الحظر
        Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في تحديث حالة الحظر: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _updateChatStatus(ChatStatus status) async {
    final statusText = _getStatusText(status);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث حالة المحادثة'),
        content: Text('هل تريد تغيير حالة المحادثة إلى "$statusText"؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ChatsService.updateChatStatus(widget.chat.id, status);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('تم تحديث حالة المحادثة إلى $statusText'),
              backgroundColor: Colors.green,
            ),
          );
        }
        Navigator.of(context).pop();
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('فشل في تحديث حالة المحادثة: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('محادثة ${widget.chat.productName}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              switch (value) {
                case 'confirm':
                  _updateChatStatus(ChatStatus.confirmed);
                  break;
                case 'cancel':
                  _updateChatStatus(ChatStatus.cancelled);
                  break;
                case 'block_buyer':
                  _toggleUserBlock('buyer');
                  break;
                case 'block_seller':
                  _toggleUserBlock('seller');
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'confirm',
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('تأكيد الطلب'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text('إلغاء الطلب'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              PopupMenuItem(
                value: 'block_buyer',
                child: Row(
                  children: [
                    Icon(
                      widget.chat.isBuyerBlocked
                          ? Icons.lock_open
                          : Icons.block,
                      color: widget.chat.isBuyerBlocked
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.chat.isBuyerBlocked
                        ? 'إلغاء حظر المشتري'
                        : 'حظر المشتري'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'block_seller',
                child: Row(
                  children: [
                    Icon(
                      widget.chat.isSellerBlocked
                          ? Icons.lock_open
                          : Icons.block,
                      color: widget.chat.isSellerBlocked
                          ? Colors.green
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Text(widget.chat.isSellerBlocked
                        ? 'إلغاء حظر البائع'
                        : 'حظر البائع'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // معلومات المنتج والمستخدمين
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        widget.chat.productImage,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 60,
                          height: 60,
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
                          Text(
                            widget.chat.productName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(widget.chat.status)
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color:
                                          _getStatusColor(widget.chat.status)),
                                ),
                                child: Text(
                                  _getStatusText(widget.chat.status),
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getStatusColor(widget.chat.status),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildUserInfo(
                        'المشتري',
                        widget.chat.buyerName,
                        widget.chat.isBuyerBlocked,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildUserInfo(
                        'البائع',
                        widget.chat.sellerName,
                        widget.chat.isSellerBlocked,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _error!,
                              style: const TextStyle(color: Colors.red),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: _loadMessages,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _messages.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد رسائل بعد',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.all(16),
                            itemCount: _messages.length,
                            itemBuilder: (context, index) {
                              final message = _messages[index];
                              return _MessageBubble(message: message);
                            },
                          ),
          ),

          // حقل إرسال الرسالة
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالتك هنا...',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: null,
                    textInputAction: TextInputAction.send,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, color: Color(0xFF193A6B)),
                  tooltip: 'إرسال',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(String type, String name, bool isBlocked, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                type == 'المشتري' ? Icons.shopping_cart : Icons.store,
                color: color,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 12,
                ),
              ),
              if (isBlocked) ...[
                const SizedBox(width: 4),
                const Icon(Icons.block, color: Colors.red, size: 16),
              ],
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ChatStatus status) {
    switch (status) {
      case ChatStatus.pending:
        return Colors.orange;
      case ChatStatus.confirmed:
        return Colors.green;
      case ChatStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(ChatStatus status) {
    switch (status) {
      case ChatStatus.pending:
        return 'قيد التفاوض';
      case ChatStatus.confirmed:
        return 'مؤكدة';
      case ChatStatus.cancelled:
        return 'ملغية';
    }
  }
}

class _MessageBubble extends StatelessWidget {
  final Message message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isAdmin = message.senderType == 'admin';
    final isMe = message.senderType == 'admin';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            // اسم المرسل
            if (!isMe) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getSenderColor(message.senderType).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  message.senderName,
                  style: TextStyle(
                    fontSize: 12,
                    color: _getSenderColor(message.senderType),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],

            // فقاعة الرسالة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isMe
                    ? const Color(0xFF193A6B)
                    : isAdmin
                        ? Colors.orange.withValues(alpha: 0.1)
                        : Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(18).copyWith(
                  bottomLeft: isMe
                      ? const Radius.circular(18)
                      : const Radius.circular(4),
                  bottomRight: isMe
                      ? const Radius.circular(4)
                      : const Radius.circular(18),
                ),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
              ),
            ),

            // الوقت
            Padding(
              padding: const EdgeInsets.only(top: 4, right: 8, left: 8),
              child: Text(
                _formatTime(message.timestamp),
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSenderColor(String senderType) {
    switch (senderType) {
      case 'admin':
        return Colors.orange;
      case 'buyer':
        return Colors.blue;
      case 'seller':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
