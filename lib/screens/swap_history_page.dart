import 'package:flutter/material.dart';
import '../models/book.dart';
import '../constants/dummy_data.dart';
import '../widgets/empty_state_widget.dart';

class SwapHistoryItem {
  final String id;
  final Book book;
  final String swappedWith;
  final DateTime swapDate;
  final String myBookTitle;

  SwapHistoryItem({
    required this.id,
    required this.book,
    required this.swappedWith,
    required this.swapDate,
    required this.myBookTitle,
  });
}

class SwapHistoryPage extends StatelessWidget {
  const SwapHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Dummy swap history data
    final List<SwapHistoryItem> swapHistory = [
      SwapHistoryItem(
        id: '1',
        book: dummyBooks[0],
        swappedWith: 'John Smith',
        swapDate: DateTime.now().subtract(const Duration(days: 7)),
        myBookTitle: 'Computer Networks',
      ),
      SwapHistoryItem(
        id: '2',
        book: dummyBooks[1],
        swappedWith: 'Alice Johnson',
        swapDate: DateTime.now().subtract(const Duration(days: 14)),
        myBookTitle: 'Database Systems',
      ),
      SwapHistoryItem(
        id: '3',
        book: dummyBooks[3],
        swappedWith: 'Bob Wilson',
        swapDate: DateTime.now().subtract(const Duration(days: 30)),
        myBookTitle: 'Software Engineering Principles',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1026),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Swap History',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: swapHistory.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.history,
              title: 'No swap history yet',
              subtitle: 'Your completed swaps will appear here',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: swapHistory.length,
              itemBuilder: (context, index) {
                return _SwapHistoryCard(item: swapHistory[index]);
              },
            ),
    );
  }
}

class _SwapHistoryCard extends StatelessWidget {
  final SwapHistoryItem item;

  const _SwapHistoryCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Swap Date and Status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 1),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Text(
                _formatDate(item.swapDate),
                style: const TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Swap Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Received Book
              Expanded(
                child: _BookInfo(
                  label: 'Received',
                  bookTitle: item.book.title,
                  bookAuthor: item.book.author,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 20,
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: const Color(0xFFF1C64A),
                  size: 24,
                ),
              ),
              // Given Book
              Expanded(
                child: _BookInfo(
                  label: 'Given',
                  bookTitle: item.myBookTitle,
                  bookAuthor: 'Your book',
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Colors.white10),
          const SizedBox(height: 12),

          // Swapped With
          Row(
            children: [
              const Icon(Icons.person_outline, color: Colors.white60, size: 18),
              const SizedBox(width: 8),
              Text(
                'Swapped with ',
                style: const TextStyle(color: Colors.white60, fontSize: 14),
              ),
              Text(
                item.swappedWith,
                style: const TextStyle(
                  color: Color(0xFFF1C64A),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class _BookInfo extends StatelessWidget {
  final String label;
  final String bookTitle;
  final String bookAuthor;

  const _BookInfo({
    required this.label,
    required this.bookTitle,
    required this.bookAuthor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                bookTitle,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                bookAuthor,
                style: const TextStyle(color: Colors.white60, fontSize: 12),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
