import 'package:flutter/material.dart';
import '../../models/chat.dart';
import '../../services/chat_service.dart';
import 'product_chat_sheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Chat> get chats => ChatService().chats;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('آشو شات'), centerTitle: true),
      body: chats.isEmpty
          ? const Center(child: Text('لا توجد محادثات بعد'))
          : ListView.builder(
              itemCount: chats.length,
              itemBuilder: (context, index) {
                final chat = chats[index];
                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onTap: () async {
                      final updatedStatus =
                          await showModalBottomSheet<ChatStatus>(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => ProductChatSheet(chat: chat),
                      );
                      if (updatedStatus != null &&
                          updatedStatus != chat.status) {
                        setState(() {
                          chat.status = updatedStatus;
                        });
                      }
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        chat.productImage,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        errorBuilder: (c, e, s) => Container(
                          width: 56,
                          height: 56,
                          color: Colors.grey[200],
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    title: Text(chat.productName,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${chat.buyerName} - بائع'),
                        _buildStatus(chat.status),
                      ],
                    ),
                    trailing: chat.unreadCount > 0
                        ? CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 14,
                            child: Text('${chat.unreadCount}',
                                style: const TextStyle(color: Colors.white)),
                          )
                        : null,
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatus(ChatStatus status) {
    switch (status) {
      case ChatStatus.pending:
        return Row(
          children: const [
            Icon(Icons.hourglass_empty, color: Colors.orange, size: 18),
            SizedBox(width: 4),
            Text('قيد التفاوض', style: TextStyle(color: Colors.orange)),
          ],
        );
      case ChatStatus.confirmed:
        return Row(
          children: const [
            Icon(Icons.check_box, color: Colors.green, size: 18),
            SizedBox(width: 4),
            Text('تم التأكيد', style: TextStyle(color: Colors.green)),
          ],
        );
      case ChatStatus.cancelled:
        return Row(
          children: const [
            Icon(Icons.cancel, color: Colors.red, size: 18),
            SizedBox(width: 4),
            Text('تم الإلغاء', style: TextStyle(color: Colors.red)),
          ],
        );
    }
  }
}
