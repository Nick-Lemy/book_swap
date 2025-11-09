import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/swap_offer.dart';
import '../models/swap_history.dart';
import 'user_service.dart';
import 'chat_service.dart';

class SwapService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _offersCollection = 'swap_offers';
  final String _historyCollection = 'swap_history';
  final ChatService _chatService = ChatService();
  final UserService _userService = UserService();

  // Create a swap offer
  Future<String> createSwapOffer({
    required String requesterId,
    required String requesterName,
    required String ownerId,
    required String ownerName,
    required String requestedBookId,
    required String requestedBookTitle,
    required String offeredBookId,
    required String offeredBookTitle,
    String? requestedBookImage,
    String? offeredBookImage,
  }) async {
    try {
      DocumentReference docRef = await _firestore
          .collection(_offersCollection)
          .add({
            'requesterId': requesterId,
            'requesterName': requesterName,
            'ownerId': ownerId,
            'ownerName': ownerName,
            'requestedBookId': requestedBookId,
            'requestedBookTitle': requestedBookTitle,
            'offeredBookId': offeredBookId,
            'offeredBookTitle': offeredBookTitle,
            'requestedBookImage': requestedBookImage,
            'offeredBookImage': offeredBookImage,
            'status': 'pending',
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      return docRef.id;
    } catch (e) {
      throw 'Error creating swap offer: $e';
    }
  }

  // Get offers sent by user (offers I made)
  Stream<List<SwapOffer>> getSentOffers(String userId) {
    return _firestore
        .collection(_offersCollection)
        .where('requesterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _swapOfferFromFirestore(doc);
          }).toList();
        });
  }

  // Get offers received by user (offers for my books)
  Stream<List<SwapOffer>> getReceivedOffers(String userId) {
    return _firestore
        .collection(_offersCollection)
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _swapOfferFromFirestore(doc);
          }).toList();
        });
  }

  // Get all offers for a user (sent + received)
  Stream<List<SwapOffer>> getAllUserOffers(String userId) {
    // Note: Firestore doesn't support OR queries directly
    // We'll need to merge two streams or use a different approach
    // For now, we'll just get sent offers and handle received separately
    return _firestore
        .collection(_offersCollection)
        .where('requesterId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _swapOfferFromFirestore(doc);
          }).toList();
        });
  }

  // Update offer status
  Future<void> updateOfferStatus(String offerId, String status) async {
    try {
      await _firestore.collection(_offersCollection).doc(offerId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // If accepted, create swap history and mark books as unavailable
      if (status == 'accepted') {
        DocumentSnapshot offerDoc = await _firestore
            .collection(_offersCollection)
            .doc(offerId)
            .get();

        if (offerDoc.exists) {
          Map<String, dynamic> offerData =
              offerDoc.data() as Map<String, dynamic>;

          // Create swap history for both users
          await _createSwapHistory(offerData);

          // Create chat conversation between the two users
          await _createSwapChat(offerData);

          // Mark both books as unavailable
          await _firestore
              .collection('books')
              .doc(offerData['requestedBookId'])
              .update({'isAvailable': false});

          await _firestore
              .collection('books')
              .doc(offerData['offeredBookId'])
              .update({'isAvailable': false});

          // Update both users' completed swaps count
          await _firestore
              .collection('users')
              .doc(offerData['requesterId'])
              .update({'completedSwaps': FieldValue.increment(1)});

          await _firestore.collection('users').doc(offerData['ownerId']).update(
            {'completedSwaps': FieldValue.increment(1)},
          );
        }
      }
    } catch (e) {
      throw 'Error updating offer status: $e';
    }
  }

  // Create swap history
  Future<void> _createSwapHistory(Map<String, dynamic> offerData) async {
    try {
      await _firestore.collection(_historyCollection).add({
        'userId': offerData['requesterId'],
        'bookGiven': offerData['offeredBookTitle'],
        'bookReceived': offerData['requestedBookTitle'],
        'swappedWith': offerData['ownerName'],
        'date': FieldValue.serverTimestamp(),
        'rating': null,
      });

      await _firestore.collection(_historyCollection).add({
        'userId': offerData['ownerId'],
        'bookGiven': offerData['requestedBookTitle'],
        'bookReceived': offerData['offeredBookTitle'],
        'swappedWith': offerData['requesterName'],
        'date': FieldValue.serverTimestamp(),
        'rating': null,
      });
    } catch (e) {
      throw 'Error creating swap history: $e';
    }
  }

  // Create chat conversation for swap
  Future<void> _createSwapChat(Map<String, dynamic> offerData) async {
    try {
      print('🔄 Creating swap chat...');
      print('Requester ID: ${offerData['requesterId']}');
      print('Owner ID: ${offerData['ownerId']}');
      print('Requester Name: ${offerData['requesterName']}');
      print('Owner Name: ${offerData['ownerName']}');

      // Get user profiles to get avatars
      final ownerProfile = await _userService.getUserProfile(
        offerData['ownerId'],
      );

      // Create or get existing conversation
      final conversationId = await _chatService.getOrCreateConversation(
        offerData['requesterId'],
        offerData['ownerId'],
        offerData['requesterName'],
        offerData['ownerName'],
        '📚', // Could be fetched from requester profile
        ownerProfile?.avatar ?? '📚',
      );

      print('✅ Conversation created/found: $conversationId');

      // Send an automatic message about the swap
      await _chatService.sendMessage(
        conversationId: conversationId,
        senderId: offerData['requesterId'],
        receiverId: offerData['ownerId'],
        message:
            '🎉 Swap accepted! You\'re exchanging "${offerData['offeredBookTitle']}" for "${offerData['requestedBookTitle']}". Let\'s arrange the details!',
      );

      print('✅ Chat conversation created successfully: $conversationId');
    } catch (e) {
      // Don't throw error - chat creation is not critical
      print('❌ Error creating swap chat: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  }

  // Delete offer
  Future<void> deleteOffer(String offerId) async {
    try {
      await _firestore.collection(_offersCollection).doc(offerId).delete();
    } catch (e) {
      throw 'Error deleting offer: $e';
    }
  }

  // Get swap history for user
  Stream<List<SwapHistoryItem>> getUserSwapHistory(String userId) {
    return _firestore
        .collection(_historyCollection)
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _swapHistoryFromFirestore(doc);
          }).toList();
        });
  }

  // Rate a swap
  Future<void> rateSwap(String historyId, double rating) async {
    try {
      await _firestore.collection(_historyCollection).doc(historyId).update({
        'rating': rating,
      });
    } catch (e) {
      throw 'Error rating swap: $e';
    }
  }

  // Helper method to convert Firestore document to SwapOffer
  SwapOffer _swapOfferFromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp? timestamp = data['createdAt'] as Timestamp?;

    // Convert string status to SwapStatus enum
    SwapStatus status;
    switch (data['status']) {
      case 'accepted':
        status = SwapStatus.accepted;
        break;
      case 'rejected':
        status = SwapStatus.rejected;
        break;
      case 'cancelled':
        status = SwapStatus.cancelled;
        break;
      default:
        status = SwapStatus.pending;
    }

    return SwapOffer(
      id: doc.id,
      bookId: data['requestedBookId'] ?? '',
      bookTitle: data['requestedBookTitle'] ?? '',
      bookAuthor: '', // Not stored in current structure
      bookImageUrl: data['requestedBookImage'],
      fromUserId: data['requesterId'] ?? '',
      fromUserName: data['requesterName'] ?? '',
      toUserId: data['ownerId'] ?? '',
      toUserName: data['ownerName'] ?? '',
      status: status,
      createdAt: timestamp?.toDate() ?? DateTime.now(),
    );
  }

  // Helper method to convert Firestore document to SwapHistoryItem
  SwapHistoryItem _swapHistoryFromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp? timestamp = data['date'] as Timestamp?;

    return SwapHistoryItem(
      id: doc.id,
      bookReceivedTitle: data['bookReceived'] ?? '',
      bookReceivedAuthor: '', // Not stored in current structure
      bookReceivedImageUrl: null,
      bookGivenTitle: data['bookGiven'] ?? '',
      bookGivenAuthor: '', // Not stored in current structure
      bookGivenImageUrl: null,
      swappedWith: data['swappedWith'] ?? '',
      swapDate: timestamp?.toDate() ?? DateTime.now(),
      rating: data['rating']?.toDouble(),
    );
  }
}
