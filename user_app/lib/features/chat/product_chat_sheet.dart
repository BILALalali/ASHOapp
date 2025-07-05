import 'package:flutter/material.dart';
import '../../models/chat.dart';
import '../../models/message.dart';

class ProductChatSheet extends StatefulWidget {
  final Chat chat;
  const ProductChatSheet({Key? key, required this.chat}) : super(key: key);

  @override
  State<ProductChatSheet> createState() => _ProductChatSheetState();
}

class _ProductChatSheetState extends State<ProductChatSheet> {
  final List<Message> messages = [
    Message(
      id: '1',
      text: 'السلام عليكم، أود شراء هذا المنتج: ${'هاتف ذكي'}',
      senderId: 'me',
      timestamp: DateTime.now().subtract(Duration(minutes: 30)),
      isMe: true,
    ),
    Message(
      id: '2',
      text: 'أهلاً وسهلاً، المنتج متوفر. هل تريد التفاصيل؟',
      senderId: 'seller',
      timestamp: DateTime.now().subtract(Duration(minutes: 20)),
      isMe: false,
    ),
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              Text('محادثة ${widget.chat.productName}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              _buildProductHeader(widget.chat),
              const Divider(),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[messages.length - 1 - index];
                    return Align(
                      alignment: msg.isMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: msg.isMe ? Colors.blue[100] : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: msg.isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(msg.text,
                                style: const TextStyle(fontSize: 16)),
                            Text(
                              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: 'اكتب رسالتك هنا...',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.send, color: Colors.blue),
                      onPressed: () {
                        if (_controller.text.trim().isNotEmpty) {
                          setState(() {
                            messages.add(
                              Message(
                                id: DateTime.now()
                                    .millisecondsSinceEpoch
                                    .toString(),
                                text: _controller.text.trim(),
                                senderId: 'me',
                                timestamp: DateTime.now(),
                                isMe: true,
                              ),
                            );
                            _controller.clear();
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductHeader(Chat chat) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(chat.productImage,
                width: 60, height: 60, fit: BoxFit.cover),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(chat.productName,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                Text('${chat.buyerName} - بائع 1'),
                _buildStatus(chat.status),
              ],
            ),
          ),
          Column(
            children: [
              ElevatedButton(
                onPressed: chat.status == ChatStatus.confirmed
                    ? null
                    : () {
                        Navigator.of(context).pop(ChatStatus.confirmed);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('تأكيد الطلب'),
              ),
              const SizedBox(height: 4),
              ElevatedButton(
                onPressed: chat.status == ChatStatus.cancelled
                    ? null
                    : () {
                        Navigator.of(context).pop(ChatStatus.cancelled);
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('إلغاء الطلب'),
              ),
            ],
          ),
        ],
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
