import 'package:flutter/material.dart';
import '../models/chat.dart';
import '../services/chat_service.dart';

class ChatProvider with ChangeNotifier {
  final ChatService _chatService = ChatService();

  List<ChatConversation> _conversations = [];
  bool _isLoading = false;
  String? _error;

  List<ChatConversation> get conversations => _conversations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Listen to user conversations
  void listenToConversations(String userId) {
    _chatService
        .getUserConversations(userId)
        .listen(
          (conversations) {
            _conversations = conversations;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  // Get messages stream for a conversation
  Stream<List<ChatMessage>> getMessages(String conversationId) {
    return _chatService.getMessages(conversationId);
  }

  // Send message
  Future<String?> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _chatService.sendMessage(
        conversationId: conversationId,
        senderId: senderId,
        receiverId: receiverId,
        message: message,
      );
      return null; // Success
    } catch (e) {
      _error = e.toString();
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Mark messages as read
  Future<void> markMessagesAsRead({
    required String conversationId,
    required String userId,
  }) async {
    try {
      await _chatService.markMessagesAsRead(conversationId, userId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
