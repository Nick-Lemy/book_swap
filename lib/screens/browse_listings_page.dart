import 'package:book_swap/widgets/book_listing_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/search_text_field.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import 'book_detail_page.dart';

class BrowseListingsPage extends StatefulWidget {
  const BrowseListingsPage({super.key});

  @override
  State<BrowseListingsPage> createState() => _BrowseListingsPageState();
}

class _BrowseListingsPageState extends State<BrowseListingsPage> {
  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  static const List<String> categories = [
    'All',
    'Fiction',
    'Non-Fiction',
    'Science',
    'History',
    'Technology',
    'Arts',
  ];

  @override
  void initState() {
    super.initState();
    // Start listening to books when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookProvider>().listenToAllBooks();
    });
  }

  void _handleCategoryChange(String category) {
    context.read<BookProvider>().setCategory(category);
  }

  void _handleSearchChange(String query) {
    context.read<BookProvider>().setSearchQuery(query);
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
              onChanged: _handleSearchChange,
            ),
          ),
          // Categories
          Consumer<BookProvider>(
            builder: (context, bookProvider, child) {
              return CategoryFilterRow(
                categories: categories,
                selectedCategory: bookProvider.selectedCategory,
                onCategorySelected: _handleCategoryChange,
              );
            },
          ),
          // Listings
          Expanded(
            child: Consumer2<BookProvider, AuthProvider>(
              builder: (context, bookProvider, authProvider, child) {
                if (bookProvider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: _accent),
                  );
                }

                if (bookProvider.error != null) {
                  return Center(
                    child: Text(
                      'Error: ${bookProvider.error}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  );
                }

                final filteredBooks = bookProvider.filteredBooks;
                final currentUser = authProvider.user;

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
                      imageUrl: book.imageUrl,
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
