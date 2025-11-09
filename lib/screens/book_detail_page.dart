import 'package:flutter/material.dart';
import '../models/book.dart';
import '../widgets/primary_button.dart';
import '../widgets/status_chip.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';
import '../services/swap_service.dart';

class BookDetailPage extends StatefulWidget {
  final Book book;

  const BookDetailPage({super.key, required this.book});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();
  final SwapService _swapService = SwapService();
  bool _isDeleting = false;
  bool _isSendingRequest = false;

  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  Future<void> _handleDelete() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F3A),
        title: const Text('Delete Book', style: TextStyle(color: Colors.white)),
        content: Text(
          'Are you sure you want to delete "${widget.book.title}"? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.white60),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() => _isDeleting = true);

    try {
      await _bookService.deleteBook(widget.book.id, currentUser.uid);
      if (mounted) {
        Navigator.pop(context); // Go back to previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Book deleted successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting book: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  Future<void> _handleRequestSwap() async {
    final currentUser = _authService.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please sign in to request a swap'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Check if user is trying to swap their own book
    if (currentUser.uid == widget.book.ownerId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You cannot swap your own book'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: In a full implementation, we would show a dialog to let the user
    // select which of their books they want to offer in exchange.
    // For now, we'll just create a simple swap request.

    setState(() => _isSendingRequest = true);

    try {
      // Note: This is a simplified version. In reality, the user should select
      // a book they want to offer in exchange. For now, we're using placeholder values.
      await _swapService.createSwapOffer(
        requesterId: currentUser.uid,
        requesterName: currentUser.displayName ?? 'Unknown User',
        ownerId: widget.book.ownerId,
        ownerName: widget.book.owner,
        requestedBookId: widget.book.id,
        requestedBookTitle: widget.book.title,
        offeredBookId: 'placeholder', // TODO: User should select their book
        offeredBookTitle:
            'To be selected', // TODO: User should select their book
        requestedBookImage: widget.book.imageUrl,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Swap request sent!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, '/my-offers');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending request: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSendingRequest = false);
      }
    }
  }

  bool _isOwner() {
    final currentUser = _authService.currentUser;
    return currentUser != null && currentUser.uid == widget.book.ownerId;
  }

  void _viewOwnerProfile() {
    // TODO: Update OtherUserProfilePage to accept userId parameter
    // For now, just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Owner profile view will be implemented next'),
      ),
    );
    /*
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OtherUserProfilePage(userId: widget.book.ownerId),
      ),
    );
    */
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
              child: widget.book.imageUrl != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        widget.book.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Icon(
                              Icons.menu_book,
                              size: 80,
                              color: Colors.white30,
                            ),
                          );
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                        loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                  : Center(
                      child: Icon(
                        Icons.menu_book,
                        size: 80,
                        color: Colors.white30,
                      ),
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
                          widget.book.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      StatusChip(label: widget.book.condition),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Author
                  Text(
                    'by ${widget.book.author}',
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
                      widget.book.category,
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
                  GestureDetector(
                    onTap: _isOwner() ? null : _viewOwnerProfile,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundColor: _accent,
                          child: Text(
                            widget.book.owner[0].toUpperCase(),
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
                                widget.book.owner,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.book.ownerEmail,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!_isOwner())
                          const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.white60,
                            size: 16,
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Divider
                  Divider(color: Colors.white10, height: 1),
                  const SizedBox(height: 24),

                  // Description Section
                  if (widget.book.description != null &&
                      widget.book.description!.isNotEmpty) ...[
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
                      widget.book.description!,
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
                        'Posted ${widget.book.timeAgo}',
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
                        widget.book.isAvailable
                            ? Icons.check_circle
                            : Icons.cancel,
                        size: 18,
                        color: widget.book.isAvailable
                            ? Colors.green
                            : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.book.isAvailable ? 'Available' : 'Not Available',
                        style: TextStyle(
                          color: widget.book.isAvailable
                              ? Colors.green
                              : Colors.red,
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
          child: _isOwner()
              ? // If owner, show delete button
                PrimaryButton(
                  text: _isDeleting ? 'Deleting...' : 'Delete Book',
                  onPressed: _isDeleting ? null : () => _handleDelete(),
                )
              : // If not owner, show message and request swap buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _viewOwnerProfile,
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: _accent, width: 2),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View Owner',
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
                        text: _isSendingRequest ? 'Sending...' : 'Request Swap',
                        onPressed: _isSendingRequest
                            ? null
                            : () => _handleRequestSwap(),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
