// شاشة إدارة المحادثات
import 'package:flutter/material.dart';
import 'chat_model.dart';
import 'chats_service.dart';
import 'chat_details_screen.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({super.key});

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen> {
  List<Chat> _chats = [];
  List<Chat> _filteredChats = [];
  bool _isLoading = true;
  String? _error;
  String _searchQuery = '';
  ChatStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _loadChats();
  }

  Future<void> _loadChats() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final chats = await ChatsService.getAllChats();
      setState(() {
        _chats = chats;
        _filteredChats = chats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _filterChats() {
    List<Chat> filtered = _chats;

    // تطبيق البحث
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((chat) =>
              chat.productName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              chat.buyerName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              chat.sellerName
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // تطبيق فلتر الحالة
    if (_selectedStatus != null) {
      filtered =
          filtered.where((chat) => chat.status == _selectedStatus).toList();
    }

    setState(() {
      _filteredChats = filtered;
    });
  }

  void _openChatDetails(Chat chat) {
    Navigator.of(context)
        .push(
      MaterialPageRoute(
        builder: (context) => ChatDetailsScreen(chat: chat),
      ),
    )
        .then((_) {
      // إعادة تحميل المحادثات عند العودة
      _loadChats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // العنوان والإحصائيات
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'المحادثات والطلبات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF193A6B),
                ),
              ),
              IconButton(
                onPressed: _loadChats,
                icon: const Icon(Icons.refresh),
                tooltip: 'تحديث',
              ),
            ],
          ),
          const SizedBox(height: 16),

          // الإحصائيات
          Row(
            children: [
              _buildStatCard(
                'إجمالي المحادثات',
                _chats.length.toString(),
                Icons.chat,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'قيد التفاوض',
                _chats
                    .where((c) => c.status == ChatStatus.pending)
                    .length
                    .toString(),
                Icons.hourglass_empty,
                color: Colors.orange,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'مؤكدة',
                _chats
                    .where((c) => c.status == ChatStatus.confirmed)
                    .length
                    .toString(),
                Icons.check_circle,
                color: Colors.green,
              ),
              const SizedBox(width: 16),
              _buildStatCard(
                'ملغية',
                _chats
                    .where((c) => c.status == ChatStatus.cancelled)
                    .length
                    .toString(),
                Icons.cancel,
                color: Colors.red,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // البحث والفلترة
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'البحث في المحادثات...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    _searchQuery = value;
                    _filterChats();
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<ChatStatus?>(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  value: _selectedStatus,
                  items: [
                    const DropdownMenuItem(
                        value: null, child: Text('كل الحالات')),
                    ...ChatStatus.values.map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(_getStatusText(status)),
                        )),
                  ],
                  onChanged: (value) {
                    _selectedStatus = value;
                    _filterChats();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // قائمة المحادثات
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
                              onPressed: _loadChats,
                              child: const Text('إعادة المحاولة'),
                            ),
                          ],
                        ),
                      )
                    : _filteredChats.isEmpty
                        ? const Center(
                            child: Text(
                              'لا توجد محادثات',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          )
                        : ListView.separated(
                            itemCount: _filteredChats.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final chat = _filteredChats[index];
                              return _ChatCard(
                                chat: chat,
                                onTap: () => _openChatDetails(chat),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon,
      {Color? color}) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 32, color: color ?? const Color(0xFF193A6B)),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF193A6B),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
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

class _ChatCard extends StatelessWidget {
  final Chat chat;
  final VoidCallback onTap;

  const _ChatCard({
    required this.chat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // صورة المنتج
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  chat.productImage,
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
              const SizedBox(width: 16),

              // تفاصيل المحادثة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chat.productName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.person, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          '${chat.buyerName} - ${chat.sellerName}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.message, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            chat.lastMessage,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // معلومات إضافية
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // الوقت
                  Text(
                    _formatTime(chat.lastMessageTime),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                  const SizedBox(height: 8),

                  // حالة المحادثة
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(chat.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(chat.status)),
                    ),
                    child: Text(
                      _getStatusText(chat.status),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getStatusColor(chat.status),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // عدد الرسائل غير المقروءة
                  if (chat.unreadCount > 0) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        chat.unreadCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],

                  // مؤشر الحظر
                  if (chat.isBuyerBlocked || chat.isSellerBlocked) ...[
                    const SizedBox(height: 8),
                    Icon(
                      Icons.block,
                      color: Colors.red,
                      size: 20,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
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
