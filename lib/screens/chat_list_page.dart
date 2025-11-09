import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/chat_list_tile.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  // Dummy chat data
  final List<ChatConversation> _conversations = [
    ChatConversation(
      conversationId: '1',
      otherUserId: 'user1',
      otherUserName: 'John Smith',
      otherUserAvatar: 'J',
      lastMessage: 'Is the book still available?',
      lastMessageTime: DateTime.now().subtract(const Duration(minutes: 5)),
      unreadCount: 2,
      otherUserOnline: true,
    ),
    ChatConversation(
      conversationId: '2',
      otherUserId: 'user2',
      otherUserName: 'Alice Johnson',
      otherUserAvatar: 'A',
      lastMessage: 'Thanks for the swap!',
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 0,
      otherUserOnline: false,
    ),
    ChatConversation(
      conversationId: '3',
      otherUserId: 'user3',
      otherUserName: 'Bob Wilson',
      otherUserAvatar: 'B',
      lastMessage: 'When can we meet for the exchange?',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 1)),
      unreadCount: 1,
      otherUserOnline: true,
    ),
    ChatConversation(
      conversationId: '4',
      otherUserId: 'user4',
      otherUserName: 'Carol Davis',
      otherUserAvatar: 'C',
      lastMessage: 'Great! I\'ll take it.',
      lastMessageTime: DateTime.now().subtract(const Duration(days: 2)),
      unreadCount: 0,
      otherUserOnline: false,
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
