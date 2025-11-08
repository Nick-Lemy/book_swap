import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/chat_list_tile.dart';

class ChatMessage {
  final String id;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  ChatMessage({
    required this.id,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

class ChatConversation {
  final String id;
  final String userName;
  final String userAvatar;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;
  final bool isOnline;

  ChatConversation({
    required this.id,
    required this.userName,
    required this.userAvatar,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
    this.isOnline = false,
  });
}

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // Dummy chat data
  final List<ChatConversation> _conversations = [
    ChatConversation(
      id: '1',
      userName: 'John Smith',
      userAvatar: 'J',
      lastMessage: 'Is the book still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      isOnline: true,
    ),
    ChatConversation(
      id: '2',
      userName: 'Alice Johnson',
      userAvatar: 'A',
      lastMessage: 'Thanks for the swap!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      isOnline: false,
    ),
    ChatConversation(
      id: '3',
      userName: 'Bob Wilson',
      userAvatar: 'B',
      lastMessage: 'When can we meet for the exchange?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      isOnline: true,
    ),
    ChatConversation(
      id: '4',
      userName: 'Carol Davis',
      userAvatar: 'C',
      lastMessage: 'Great! I\'ll take it.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      isOnline: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1026),
        elevation: 0,
        title: const Text(
          'Chats',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search functionality
            },
          ),
        ],
      ),
      body: _conversations.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'No conversations yet',
              subtitle: 'Start chatting by requesting a swap',
            )
          : ListView.builder(
              itemCount: _conversations.length,
              itemBuilder: (context, index) {
                return ChatListTile(
                  conversation: _conversations[index],
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/chat',
                      arguments: _conversations[index],
                    );
                  },
                );
              },
            ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/browse');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/my-listings');
          } else if (index == 2) {
            // Already on Chats
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }
}
