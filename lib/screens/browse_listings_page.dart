import 'package:book_swap/widgets/book_listing_card.dart';
import 'package:flutter/material.dart';
import '../widgets/search_text_field.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/book.dart';
import '../services/book_service.dart';
import '../services/auth_service.dart';
import 'book_detail_page.dart';

class BrowseListingsPage extends StatefulWidget {
  const BrowseListingsPage({super.key});

  @override
  State<BrowseListingsPage> createState() => _BrowseListingsPageState();
}

class _BrowseListingsPageState extends State<BrowseListingsPage> {
  final BookService _bookService = BookService();
  final AuthService _authService = AuthService();

  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  String selectedCategory = 'All';
  String searchQuery = '';

  static const List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Technology',
    'Arts',
  ];

  Stream<List<Book>> _getBooksStream() {
    if (selectedCategory == 'All') {
      return _bookService.getAllBooks();
    } else {
      return _bookService.getBooksByCategory(selectedCategory);
    }
  }

  List<Book> _filterBooks(List<Book> books) {
    if (searchQuery.isEmpty) return books;

    return books.where((book) {
      return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          book.author.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;

    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Browse Listings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchTextField(
              hintText: 'Search books...',
              onChanged: _onSearchChanged,
            ),
          ),
          // Categories
          CategoryFilterRow(
            categories: categories,
            selectedCategory: selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          // Listings
          Expanded(
            child: StreamBuilder<List<Book>>(
              stream: _getBooksStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: _accent),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final allBooks = snapshot.data ?? [];
                final filteredBooks = _filterBooks(allBooks);

                if (filteredBooks.isEmpty) {
                  return const Center(
                    child: Text(
                      'No books found',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredBooks.length,
                  itemBuilder: (context, index) {
                    final book = filteredBooks[index];
                    // Don't show user's own books in browse
                    if (currentUser != null &&
                        book.ownerId == currentUser.uid) {
                      return const SizedBox.shrink();
                    }

                    return BookListingCard(
                      title: book.title,
                      author: book.author,
                      status: book.condition,
                      timePosted: _getTimeAgo(book.datePosted),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailPage(book: book),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/my-listings');
          } else if (index == 2) {
            Navigator.pushNamed(context, '/chats');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }
}
