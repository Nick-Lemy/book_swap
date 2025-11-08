import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../widgets/message_bubble.dart';
import '../widgets/user_avatar_with_status.dart';

class ChatPage extends StatefulWidget {
  final ChatConversation? conversation;

  const ChatPage({super.key, this.conversation});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadDummyMessages();
  }

  void _loadDummyMessages() {
    // Dummy messages for the conversation
    _messages.addAll([
      ChatMessage(
        id: '1',
        text: 'Hi! I\'m interested in your Data Structures book.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isMe: false,
      ),
      ChatMessage(
        id: '2',
        text: 'Hello! Yes, it\'s still available.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 55),
        ),
        isMe: true,
      ),
      ChatMessage(
        id: '3',
        text: 'Great! What condition is it in?',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 50),
        ),
        isMe: false,
      ),
      ChatMessage(
        id: '4',
        text: 'It\'s in Like New condition. I only used it for one semester.',
        timestamp: DateTime.now().subtract(
          const Duration(hours: 1, minutes: 45),
        ),
        isMe: true,
      ),
      ChatMessage(
        id: '5',
        text: 'Perfect! Is the book still available?',
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isMe: false,
      ),
    ]);
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      _messages.add(
        ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          text: _messageController.text.trim(),
          timestamp: DateTime.now(),
          isMe: true,
        ),
      );
    });

    _messageController.clear();

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final conversation =
        widget.conversation ??
        ChatConversation(
          id: '1',
          userName: 'User',
          userAvatar: 'U',
          lastMessage: '',
          lastMessageTime: DateTime.now(),
        );

    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1026),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            UserAvatarWithStatus(
              userInitial: conversation.userAvatar,
              isOnline: conversation.isOnline,
              radius: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (conversation.isOnline)
                    const Text(
                      'Online',
                      style: TextStyle(color: Colors.green, fontSize: 12),
                    ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Show options menu
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                final showTimestamp =
                    index == 0 ||
                    _messages[index - 1].timestamp
                            .difference(message.timestamp)
                            .inMinutes
                            .abs() >
                        30;

                return Column(
                  children: [
                    if (showTimestamp) _buildTimestamp(message.timestamp),
                    MessageBubble(
                      text: message.text,
                      isMe: message.isMe,
                      timestamp:
                          '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
                    ),
                  ],
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white10,
              border: Border(top: BorderSide(color: Colors.white10, width: 1)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.white38),
                        filled: true,
                        fillColor: Colors.white10,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF1C64A),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send),
                      color: const Color(0xFF0B1026),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimestamp(DateTime timestamp) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text(
        _formatTimestamp(timestamp),
        style: const TextStyle(color: Colors.white38, fontSize: 12),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays == 0) {
      return 'Today ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Yesterday ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}';
    } else {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    }
  }
}
