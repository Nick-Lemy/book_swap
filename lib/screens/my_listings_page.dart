import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/search_text_field.dart';
import '../widgets/book_listing_card.dart';
import '../constants/dummy_data.dart';
import '../models/book.dart';
import 'book_detail_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  // For now, we'll filter books by a specific user email
  // In a real app, this would come from authentication
  final String currentUserEmail = 'john.smith@university.edu';
  List<Book> myBooks = [];
  List<Book> filteredBooks = [];
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadMyBooks();
  }

  void _loadMyBooks() {
    setState(() {
      myBooks = dummyBooks
          .where((book) => book.ownerEmail == currentUserEmail)
          .toList();
      filteredBooks = myBooks;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredBooks = myBooks;
      } else {
        filteredBooks = myBooks.where((book) {
          return book.title.toLowerCase().contains(query.toLowerCase()) ||
              book.author.toLowerCase().contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  void _addNewBook() {
    Navigator.pushNamed(context, '/post-book');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'My Listings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () {
              // TODO: Add filter options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SearchTextField(
              hintText: 'Search my books...',
              onChanged: _onSearchChanged,
            ),
          ),
          // Stats bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${myBooks.length} ${myBooks.length == 1 ? 'Book' : 'Books'}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${myBooks.where((b) => b.isAvailable).length} Available',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          // Listings
          Expanded(
            child: filteredBooks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.book_outlined,
                          size: 64,
                          color: Colors.white24,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          searchQuery.isEmpty
                              ? 'No books listed yet'
                              : 'No books found',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                        if (searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          const Text(
                            'Tap the + button to add your first book',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = filteredBooks[index];
                      return BookListingCard(
                        title: book.title,
                        author: book.author,
                        status: book.condition,
                        timePosted: book.timeAgo,
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
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNewBook,
        backgroundColor: _accent,
        foregroundColor: Colors.black87,
        child: const Icon(Icons.add, size: 28),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/browse');
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
