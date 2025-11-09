import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/chat_list_tile.dart';
import '../services/chat_service.dart';
import '../services/auth_service.dart';
import 'chat_page.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
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
        ),
        body: const Center(
          child: Text(
            'Please sign in to view chats',
            style: TextStyle(color: Colors.white60),
          ),
        ),
        bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
      );
    }

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
              // TODO: Implement search functionality
            },
          ),
        ],
      ),
      body: StreamBuilder<List<ChatConversation>>(
        stream: _chatService.getUserConversations(currentUser.uid),
        builder: (context, snapshot) {
          print('📱 Chat List - Connection State: ${snapshot.connectionState}');
          print('📱 Chat List - Has Data: ${snapshot.hasData}');
          print('📱 Chat List - Data Length: ${snapshot.data?.length ?? 0}');
          print('📱 Chat List - Has Error: ${snapshot.hasError}');
          if (snapshot.hasError) {
            print('❌ Chat List Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading chats: ${snapshot.error}',
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          final conversations = snapshot.data ?? [];
          print('📱 Conversations found: ${conversations.length}');

          if (conversations.isEmpty) {
            return const EmptyStateWidget(
              icon: Icons.chat_bubble_outline,
              title: 'No conversations yet',
              subtitle: 'Start chatting by requesting a swap',
            );
          }

          return ListView.builder(
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final conversation = conversations[index];
              return ChatListTile(
                conversation: conversation,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        conversationId: conversation.conversationId,
                        otherUserId: conversation.otherUserId,
                        otherUserName: conversation.otherUserName,
                        otherUserAvatar: conversation.otherUserAvatar,
                      ),
                    ),
                  );
                },
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
