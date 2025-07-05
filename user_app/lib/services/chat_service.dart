import '../models/chat.dart';

class ChatService {
  static final ChatService _instance = ChatService._internal();
  factory ChatService() => _instance;
  ChatService._internal();

  final List<Chat> _chats = [];

  List<Chat> get chats => List.unmodifiable(_chats);

  void addChat(Chat chat) {
    _chats.add(chat);
  }
}
