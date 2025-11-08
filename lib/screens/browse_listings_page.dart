import 'package:book_swap/widgets/book_listing_card.dart';
import 'package:flutter/material.dart';
import '../widgets/search_text_field.dart';
import '../widgets/category_filter_row.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../constants/dummy_data.dart';
import '../models/book.dart';
import 'book_detail_page.dart';

class BrowseListingsPage extends StatefulWidget {
  const BrowseListingsPage({super.key});

  @override
  State<BrowseListingsPage> createState() => _BrowseListingsPageState();
}

class _BrowseListingsPageState extends State<BrowseListingsPage> {
  static const Color _bg = Color(0xFF0B1026);

  String selectedCategory = 'All';
  List<Book> filteredBooks = dummyBooks;
  String searchQuery = '';

  void _filterBooks() {
    setState(() {
      filteredBooks = getBooksByCategory(selectedCategory);
      if (searchQuery.isNotEmpty) {
        filteredBooks = filteredBooks.where((book) {
          return book.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
              book.author.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();
      }
    });
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
      _filterBooks();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
      _filterBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
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
            categories: getAllCategories(),
            selectedCategory: selectedCategory,
            onCategorySelected: _onCategorySelected,
          ),
          // Listings
          Expanded(
            child: filteredBooks.isEmpty
                ? const Center(
                    child: Text(
                      'No books found',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
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
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
            Navigator.pushNamed(context, '/my-listings');
          }
        },
      ),
    );
  }
}
