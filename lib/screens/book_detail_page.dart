import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_chip.dart';

class BookDetailPage extends StatelessWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

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
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: () {
              // TODO: Implement share
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () {
              // TODO: Implement favorite
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Book Cover
            Container(
              width: double.infinity,
              height: 280,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(Icons.menu_book, size: 80, color: Colors.white30),
              ),
            ),
            const SizedBox(height: 24),

            // Book Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Condition
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusChip(label: book.condition),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Text(
                    'by ${book.author}',
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),

                  // Category Tag
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      book.category,
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 24),

                  // Owner Info Section
                  const Text(
                    'Owner',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 24,
                        backgroundColor: _accent,
                        child: Text(
                          book.owner[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.owner,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              book.ownerEmail,
                              style: const TextStyle(
                                color: Colors.white60,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 24),

                  // Description Section
                  if (book.description != null &&
                      book.description!.isNotEmpty) ...[
                    const Text(
                      'Description',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      book.description!,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Divider(color: Colors.white10, height: 1),
                    const SizedBox(height: 24),
                  ],

                  // Posted Info
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 18, color: Colors.white60),
                      const SizedBox(width: 8),
                      Text(
                        'Posted ${book.timeAgo}',
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        book.isAvailable ? Icons.check_circle : Icons.cancel,
                        size: 18,
                        color: book.isAvailable ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        book.isAvailable ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: book.isAvailable ? Colors.green : Colors.red,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _bg,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    // TODO: Implement message owner
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: _accent, width: 2),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Message',
                    style: TextStyle(
                      color: _accent,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: PrimaryButton(
                  text: 'Request Swap',
                  onPressed: () {
                    // TODO: Implement request swap
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Swap request sent!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
