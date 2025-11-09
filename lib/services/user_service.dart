import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_profile.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'users';

  // Get user profile
  Future<UserProfile?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(userId)
          .get();
      if (doc.exists) {
        return _userProfileFromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>?,
        );
      }
      return null;
    } catch (e) {
      throw 'Error getting user profile: $e';
    }
  }

  // Get user profile stream
  Stream<UserProfile?> getUserProfileStream(String userId) {
    return _firestore.collection(_collection).doc(userId).snapshots().map((
      doc,
    ) {
      if (doc.exists) {
        return _userProfileFromFirestore(doc.id, doc.data());
      }
      return null;
    });
  }

  // Update user profile
  Future<void> updateUserProfile({
    required String userId,
    String? name,
    String? avatar,
    String? phone,
    String? location,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (name != null) updates['name'] = name;
      if (avatar != null) updates['avatar'] = avatar;
      if (phone != null) updates['phone'] = phone;
      if (location != null) updates['location'] = location;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(userId).update(updates);
    } catch (e) {
      throw 'Error updating user profile: $e';
    }
  }

  // Update user rating
  Future<void> updateUserRating(String userId, double newRating) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(userId)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double currentRating = (data['rating'] ?? 0.0).toDouble();
        int ratingsCount = data['ratingsCount'] ?? 0;

        // Calculate new average rating
        double totalRating = currentRating * ratingsCount + newRating;
        int newRatingsCount = ratingsCount + 1;
        double avgRating = totalRating / newRatingsCount;

        await _firestore.collection(_collection).doc(userId).update({
          'rating': avgRating,
          'ratingsCount': newRatingsCount,
        });
      }
    } catch (e) {
      throw 'Error updating user rating: $e';
    }
  }

  // Search users by name
  Future<List<UserProfile>> searchUsers(String query) async {
    try {
      // Note: For better search, consider using Algolia or similar
      QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .orderBy('name')
          .startAt([query])
          .endAt(['$query\uf8ff'])
          .limit(20)
          .get();

      return snapshot.docs
          .map(
            (doc) => _userProfileFromFirestore(
              doc.id,
              doc.data() as Map<String, dynamic>?,
            ),
          )
          .toList();
    } catch (e) {
      throw 'Error searching users: $e';
    }
  }

  // Helper method to convert Firestore document to UserProfile
  UserProfile _userProfileFromFirestore(
    String userId,
    Map<String, dynamic>? data,
  ) {
    if (data == null) {
      return UserProfile(
        id: userId,
        name: 'Unknown User',
        email: '',
        avatar: '',
        activeListings: 0,
        completedSwaps: 0,
        memberSince: DateTime.now(),
        rating: 0.0,
      );
    }

    return UserProfile(
      id: userId,
      name: data['name'] ?? 'Unknown User',
      email: data['email'] ?? '',
      avatar: data['avatar'] ?? '',
      activeListings: data['activeListings'] ?? 0,
      completedSwaps: data['completedSwaps'] ?? 0,
      memberSince:
          (data['memberSince'] as Timestamp?)?.toDate() ?? DateTime.now(),
      rating: (data['rating'] ?? 0.0).toDouble(),
    );
  }
}
