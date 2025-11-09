import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/chat.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _conversationsCollection = 'conversations';
  final String _messagesCollection = 'messages';

  // Create or get conversation between two users
  Future<String> getOrCreateConversation(
    String userId1,
    String userId2,
    String userName1,
    String userName2,
    String userAvatar1,
    String userAvatar2,
  ) async {
    try {
      // Create a consistent conversation ID
      List<String> userIds = [userId1, userId2]..sort();
      String conversationId = '${userIds[0]}_${userIds[1]}';

      DocumentSnapshot doc = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .get();

      if (!doc.exists) {
        // Create new conversation
        await _firestore
            .collection(_conversationsCollection)
            .doc(conversationId)
            .set({
              'id': conversationId,
              'participants': [userId1, userId2],
              'participantNames': {userId1: userName1, userId2: userName2},
              'participantAvatars': {
                userId1: userAvatar1,
                userId2: userAvatar2,
              },
              'lastMessage': '',
              'lastMessageTime': FieldValue.serverTimestamp(),
              'unreadCount': {userId1: 0, userId2: 0},
              'createdAt': FieldValue.serverTimestamp(),
            });
      }

      return conversationId;
    } catch (e) {
      throw 'Error creating conversation: $e';
    }
  }

  // Send a message
  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      // Add message to subcollection
      await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .collection(_messagesCollection)
          .add({
            'senderId': senderId,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
            'isRead': false,
          });

      // Update conversation with last message
      DocumentSnapshot conversationDoc = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .get();

      Map<String, dynamic> data =
          conversationDoc.data() as Map<String, dynamic>;
      Map<String, dynamic> unreadCount = Map<String, dynamic>.from(
        data['unreadCount'] ?? {senderId: 0, receiverId: 0},
      );

      // Increment unread count for receiver
      unreadCount[receiverId] = (unreadCount[receiverId] ?? 0) + 1;

      await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .update({
            'lastMessage': message,
            'lastMessageTime': FieldValue.serverTimestamp(),
            'unreadCount': unreadCount,
          });
    } catch (e) {
      throw 'Error sending message: $e';
    }
  }

  // Get messages stream for a conversation
  Stream<List<ChatMessage>> getMessages(String conversationId) {
    return _firestore
        .collection(_conversationsCollection)
        .doc(conversationId)
        .collection(_messagesCollection)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data();
            Timestamp? timestamp = data['timestamp'] as Timestamp?;

            return ChatMessage(
              messageId: doc.id,
              conversationId: conversationId,
              senderId: data['senderId'] ?? '',
              senderName: data['senderName'] ?? '',
              message: data['message'] ?? '',
              timestamp: timestamp?.toDate() ?? DateTime.now(),
              isRead: data['isRead'] ?? false,
            );
          }).toList();
        });
  }

  // Get all conversations for a user
  Stream<List<ChatConversation>> getUserConversations(String userId) {
    print('🔍 Fetching conversations for user: $userId');
    return _firestore
        .collection(_conversationsCollection)
        .where('participants', arrayContains: userId)
        .snapshots()
        .map((snapshot) {
          print('📊 Found ${snapshot.docs.length} conversation documents');
          // Sort in memory instead of in the query to avoid index requirement
          final conversations = snapshot.docs
              .map((doc) => _conversationFromFirestore(doc, userId))
              .toList();

          // Sort by lastMessageTime in descending order
          conversations.sort(
            (a, b) => b.lastMessageTime.compareTo(a.lastMessageTime),
          );

          print('✅ Returning ${conversations.length} sorted conversations');
          return conversations;
        });
  }

  // Mark messages as read
  Future<void> markMessagesAsRead(String conversationId, String userId) async {
    try {
      // Reset unread count for this user
      await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .update({'unreadCount.$userId': 0});

      // Mark all unread messages as read
      QuerySnapshot unreadMessages = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .collection(_messagesCollection)
          .where('isRead', isEqualTo: false)
          .where('senderId', isNotEqualTo: userId)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in unreadMessages.docs) {
        batch.update(doc.reference, {'isRead': true});
      }
      await batch.commit();
    } catch (e) {
      throw 'Error marking messages as read: $e';
    }
  }

  // Delete a conversation
  Future<void> deleteConversation(String conversationId) async {
    try {
      // Delete all messages first
      QuerySnapshot messages = await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .collection(_messagesCollection)
          .get();

      WriteBatch batch = _firestore.batch();
      for (var doc in messages.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();

      // Delete conversation
      await _firestore
          .collection(_conversationsCollection)
          .doc(conversationId)
          .delete();
    } catch (e) {
      throw 'Error deleting conversation: $e';
    }
  }

  // Helper method to convert Firestore document to ChatConversation
  ChatConversation _conversationFromFirestore(
    DocumentSnapshot doc,
    String currentUserId,
  ) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    List<String> participants = List<String>.from(data['participants'] ?? []);
    String otherUserId = participants.firstWhere(
      (id) => id != currentUserId,
      orElse: () => '',
    );

    Map<String, dynamic> participantNames = Map<String, dynamic>.from(
      data['participantNames'] ?? {},
    );
    Map<String, dynamic> participantAvatars = Map<String, dynamic>.from(
      data['participantAvatars'] ?? {},
    );
    Map<String, dynamic> unreadCount = Map<String, dynamic>.from(
      data['unreadCount'] ?? {},
    );

    Timestamp? timestamp = data['lastMessageTime'] as Timestamp?;

    return ChatConversation(
      conversationId: doc.id,
      otherUserId: otherUserId,
      otherUserName: participantNames[otherUserId] ?? 'Unknown',
      otherUserAvatar: participantAvatars[otherUserId] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      lastMessageTime: timestamp?.toDate() ?? DateTime.now(),
      unreadCount: unreadCount[currentUserId] ?? 0,
      otherUserOnline: false,
    );
  }
}
