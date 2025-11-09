import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/search_text_field.dart';
import '../widgets/book_listing_card.dart';
import '../providers/book_provider.dart';
import '../providers/auth_provider.dart';
import 'book_detail_page.dart';

class MyListingsPage extends StatefulWidget {
  const MyListingsPage({super.key});

  @override
  State<MyListingsPage> createState() => _MyListingsPageState();
}

class _MyListingsPageState extends State<MyListingsPage> {
  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  @override
  void initState() {
    super.initState();
    // Start listening to user's books when page loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = context.read<AuthProvider>().user?.uid;
      if (userId != null) {
        context.read<BookProvider>().listenToMyBooks(userId);
      }
    });
  }

  void _handleSearchChange(String query) {
    context.read<BookProvider>().setSearchQuery(query);
  }

  void _addNewBook() {
    Navigator.pushNamed(context, '/post-book');
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
    return Consumer2<BookProvider, AuthProvider>(
      builder: (context, bookProvider, authProvider, child) {
        final currentUser = authProvider.user;

        if (currentUser == null) {
          return Scaffold(
            backgroundColor: _bg,
            body: const Center(
              child: Text(
                'Please log in to view your listings',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

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
          body: bookProvider.isLoading
              ? const Center(child: CircularProgressIndicator(color: _accent))
              : bookProvider.error != null
              ? Center(
                  child: Text(
                    'Error: ${bookProvider.error}',
                    style: const TextStyle(color: Colors.white70),
                  ),
                )
              : () {
                  final myBooks = bookProvider.myBooks;
                  // Filter books based on search query
                  final searchQuery = bookProvider.searchQuery;
                  final filteredBooks = searchQuery.isEmpty
                      ? myBooks
                      : myBooks.where((book) {
                          return book.title.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              ) ||
                              book.author.toLowerCase().contains(
                                searchQuery.toLowerCase(),
                              );
                        }).toList();

                  return Column(
                    children: [
                      // Search bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: SearchTextField(
                          hintText: 'Search my books...',
                          onChanged: _handleSearchChange,
                        ),
                      ),
                      // Stats bar
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
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
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
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
                                    const Icon(
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
                                    timePosted: _getTimeAgo(book.datePosted),
                                    imageUrl: book.imageUrl,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookDetailPage(book: book),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  );
                }(),
          floatingActionButton: FloatingActionButton(
            onPressed: _addNewBook,
            backgroundColor: _accent,
            foregroundColor: Colors.black87,
            child: const Icon(Icons.add),
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
      },
    );
  }
}
