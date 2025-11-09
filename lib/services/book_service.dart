import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/book.dart';

class BookService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'books';

  // Create a new book listing
  Future<String> createBook({
    required String title,
    required String author,
    required String category,
    required String condition,
    required String description,
    required String ownerId,
    required String ownerName,
    required String ownerEmail,
    String? imageUrl,
  }) async {
    try {
      DocumentReference docRef = await _firestore.collection(_collection).add({
        'title': title,
        'author': author,
        'category': category,
        'condition': condition,
        'description': description,
        'ownerId': ownerId,
        'ownerName': ownerName,
        'ownerEmail': ownerEmail,
        'imageUrl': imageUrl,
        'isAvailable': true,
        'datePosted': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Update user's total listings count
      await _firestore.collection('users').doc(ownerId).update({
        'totalListings': FieldValue.increment(1),
      });

      return docRef.id;
    } catch (e) {
      throw 'Error creating book: $e';
    }
  }

  // Get all available books
  Stream<List<Book>> getAllBooks() {
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('datePosted', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _bookFromFirestore(doc);
          }).toList();
        });
  }

  // Get books by category
  Stream<List<Book>> getBooksByCategory(String category) {
    return _firestore
        .collection(_collection)
        .where('category', isEqualTo: category)
        .where('isAvailable', isEqualTo: true)
        .orderBy('datePosted', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _bookFromFirestore(doc);
          }).toList();
        });
  }

  // Get books by user
  Stream<List<Book>> getUserBooks(String userId) {
    return _firestore
        .collection(_collection)
        .where('ownerId', isEqualTo: userId)
        .orderBy('datePosted', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return _bookFromFirestore(doc);
          }).toList();
        });
  }

  // Get a single book by ID
  Future<Book?> getBookById(String bookId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collection)
          .doc(bookId)
          .get();
      if (doc.exists) {
        return _bookFromFirestore(doc);
      }
      return null;
    } catch (e) {
      throw 'Error getting book: $e';
    }
  }

  // Update book
  Future<void> updateBook({
    required String bookId,
    String? title,
    String? author,
    String? category,
    String? condition,
    String? description,
    String? imageUrl,
    bool? isAvailable,
  }) async {
    try {
      Map<String, dynamic> updates = {};
      if (title != null) updates['title'] = title;
      if (author != null) updates['author'] = author;
      if (category != null) updates['category'] = category;
      if (condition != null) updates['condition'] = condition;
      if (description != null) updates['description'] = description;
      if (imageUrl != null) updates['imageUrl'] = imageUrl;
      if (isAvailable != null) updates['isAvailable'] = isAvailable;

      updates['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore.collection(_collection).doc(bookId).update(updates);
    } catch (e) {
      throw 'Error updating book: $e';
    }
  }

  // Delete book
  Future<void> deleteBook(String bookId, String ownerId) async {
    try {
      await _firestore.collection(_collection).doc(bookId).delete();

      // Decrement user's total listings count
      await _firestore.collection('users').doc(ownerId).update({
        'totalListings': FieldValue.increment(-1),
      });
    } catch (e) {
      throw 'Error deleting book: $e';
    }
  }

  // Search books
  Stream<List<Book>> searchBooks(String query) {
    // Note: For better search, consider using Algolia or similar
    // This is a basic implementation
    return _firestore
        .collection(_collection)
        .where('isAvailable', isEqualTo: true)
        .orderBy('title')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => _bookFromFirestore(doc))
              .where(
                (book) =>
                    book.title.toLowerCase().contains(query.toLowerCase()) ||
                    book.author.toLowerCase().contains(query.toLowerCase()),
              )
              .toList();
        });
  }

  // Helper method to convert Firestore document to Book object
  Book _bookFromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    Timestamp? timestamp = data['datePosted'] as Timestamp?;

    return Book(
      id: doc.id,
      title: data['title'] ?? '',
      author: data['author'] ?? '',
      owner: data['ownerName'] ?? '',
      ownerEmail: data['ownerEmail'] ?? '',
      category: data['category'] ?? '',
      condition: data['condition'] ?? '',
      description: data['description'],
      datePosted: timestamp?.toDate() ?? DateTime.now(),
      imageUrl: data['imageUrl'],
      isAvailable: data['isAvailable'] ?? true,
    );
  }
}
