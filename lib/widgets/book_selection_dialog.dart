import 'package:flutter/material.dart';
import '../models/book.dart';

class BookSelectionDialog extends StatelessWidget {
  final List<Book> userBooks;
  final String title;
  final String subtitle;

  const BookSelectionDialog({
    super.key,
    required this.userBooks,
    this.title = 'Select Your Book',
    this.subtitle = 'Choose which book you want to offer in exchange',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1A1F3A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600, maxWidth: 500),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.white60, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const Divider(color: Colors.white24, height: 1),

            // Books List
            Flexible(
              child: userBooks.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(48),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.menu_book_outlined,
                            size: 64,
                            color: Colors.white30,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No books available',
                            style: TextStyle(
                              color: Colors.white60,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Post a book first to offer in swap',
                            style: TextStyle(
                              color: Colors.white38,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: userBooks.length,
                      itemBuilder: (context, index) {
                        final book = userBooks[index];
                        return InkWell(
                          onTap: () => Navigator.pop(context, book),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white24,
                                width: 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Book Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child:
                                      (book.imageUrl != null &&
                                          book.imageUrl!.isNotEmpty)
                                      ? Image.network(
                                          book.imageUrl!,
                                          width: 60,
                                          height: 80,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (context, error, stack) {
                                                return Container(
                                                  width: 60,
                                                  height: 80,
                                                  color: const Color(
                                                    0xFFF1C64A,
                                                  ),
                                                  child: const Icon(
                                                    Icons.book,
                                                    color: Color(0xFF0B1026),
                                                  ),
                                                );
                                              },
                                        )
                                      : Container(
                                          width: 60,
                                          height: 80,
                                          color: const Color(0xFFF1C64A),
                                          child: const Icon(
                                            Icons.book,
                                            color: Color(0xFF0B1026),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 12),

                                // Book Details
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        book.title,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        book.author,
                                        style: const TextStyle(
                                          color: Colors.white60,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.white10,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                        ),
                                        child: Text(
                                          book.condition,
                                          style: const TextStyle(
                                            color: Color(0xFFF1C64A),
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const Icon(
                                  Icons.chevron_right,
                                  color: Colors.white38,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

            const Divider(color: Colors.white24, height: 1),

            // Cancel Button
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.white60),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
