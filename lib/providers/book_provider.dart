import 'package:flutter/material.dart';
import '../models/book.dart';
import '../services/book_service.dart';

class BookProvider with ChangeNotifier {
  final BookService _bookService = BookService();

  List<Book> _allBooks = [];
  List<Book> _filteredBooks = [];
  List<Book> _myBooks = [];
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = 'All';
  String _searchQuery = '';

  List<Book> get allBooks => _allBooks;
  List<Book> get filteredBooks => _filteredBooks;
  List<Book> get myBooks => _myBooks;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  // Listen to all books
  void listenToAllBooks() {
    _bookService.getAllBooks().listen(
      (books) {
        _allBooks = books;
        _applyFilters();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Listen to user's books
  void listenToMyBooks(String userId) {
    _bookService
        .getUserBooks(userId)
        .listen(
          (books) {
            _myBooks = books;
            notifyListeners();
          },
          onError: (error) {
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  // Set category filter
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  // Set search query
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  // Apply filters to books
  void _applyFilters() {
    _filteredBooks = _allBooks.where((book) {
      // Category filter
      final categoryMatch =
          _selectedCategory == 'All' || book.category == _selectedCategory;

      // Search filter
      final searchMatch =
          _searchQuery.isEmpty ||
          book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(_searchQuery.toLowerCase());

      return categoryMatch && searchMatch;
    }).toList();
  }

  // Create book
  Future<String?> createBook({
    required String title,
    required String author,
    required String description,
    required String category,
    required String condition,
    required String? imageUrl,
    required String ownerId,
    required String ownerName,
    required String ownerEmail,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookService.createBook(
        title: title,
        author: author,
        description: description,
        category: category,
        condition: condition,
        imageUrl: imageUrl,
        ownerId: ownerId,
        ownerName: ownerName,
        ownerEmail: ownerEmail,
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

  // Update book
  Future<String?> updateBook({
    required String bookId,
    required String title,
    required String author,
    required String description,
    required String category,
    required String condition,
    String? imageUrl,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookService.updateBook(
        bookId: bookId,
        title: title,
        author: author,
        description: description,
        category: category,
        condition: condition,
        imageUrl: imageUrl,
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

  // Delete book
  Future<String?> deleteBook(String bookId, String ownerId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _bookService.deleteBook(bookId, ownerId);
      return null; // Success
    } catch (e) {
      _error = e.toString();
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Get book by ID (one-time fetch)
  Future<Book?> getBookById(String bookId) async {
    try {
      return await _bookService.getBookById(bookId);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
