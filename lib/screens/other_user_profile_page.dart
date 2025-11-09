import 'package:flutter/material.dart';
import '../models/user_profile.dart';
import '../models/book.dart';
import '../services/user_service.dart';
import '../services/book_service.dart';
import '../widgets/book_listing_card.dart';
import 'book_detail_page.dart';

class OtherUserProfilePage extends StatelessWidget {
  final String? userId;
  final UserProfile? userProfile;

  const OtherUserProfilePage({super.key, this.userId, this.userProfile});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final BookService bookService = BookService();

    // If userId is provided, fetch from Firebase, otherwise use provided profile
    if (userId != null) {
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
            'User Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: StreamBuilder<UserProfile?>(
          stream: userService.getUserProfileStream(userId!),
          builder: (context, profileSnapshot) {
            if (profileSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Color(0xFFF1C64A)),
              );
            }

            if (profileSnapshot.hasError || !profileSnapshot.hasData) {
              return const Center(
                child: Text(
                  'Error loading profile',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final profile = profileSnapshot.data!;

            return StreamBuilder<List<Book>>(
              stream: bookService.getUserBooks(userId!),
              builder: (context, booksSnapshot) {
                final userBooks = booksSnapshot.data ?? [];

                return _buildProfileContent(context, profile, userBooks);
              },
            );
          },
        ),
      );
    }

    // Fallback to provided profile or dummy data
    final profile =
        userProfile ??
        UserProfile(
          id: '1',
          name: 'User',
          email: 'user@example.com',
          avatar: 'U',
          activeListings: 0,
          completedSwaps: 0,
          memberSince: DateTime.now(),
          rating: 0.0,
        );

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
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildProfileContent(context, profile, []),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    UserProfile profile,
    List<Book> userBooks,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 24),

          // User Avatar and Info
          CircleAvatar(
            radius: 50,
            backgroundColor: const Color(0xFFF1C64A),
            child: Text(
              profile.avatar,
              style: const TextStyle(
                color: Color(0xFF0B1026),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            profile.name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),

          Text(
            profile.email,
            style: const TextStyle(color: Colors.white60, fontSize: 14),
          ),
          const SizedBox(height: 16),

          // Rating
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ...List.generate(5, (index) {
                return Icon(
                  index < profile.rating.floor()
                      ? Icons.star
                      : Icons.star_border,
                  color: const Color(0xFFF1C64A),
                  size: 20,
                );
              }),
              const SizedBox(width: 8),
              Text(
                profile.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Stats
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: _StatCard(
                    value: '${profile.activeListings}',
                    label: 'Active Listings',
                    icon: Icons.menu_book,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _StatCard(
                    value: '${profile.completedSwaps}',
                    label: 'Completed Swaps',
                    icon: Icons.swap_horiz,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _StatCard(
              value: _formatMemberSince(profile.memberSince),
              label: 'Member Since',
              icon: Icons.calendar_today,
            ),
          ),
          const SizedBox(height: 32),

          // Action Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/chat', arguments: profile);
                    },
                    icon: const Icon(Icons.message),
                    label: const Text('Message'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1C64A),
                      foregroundColor: const Color(0xFF0B1026),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // User's Listings
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Listings',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // View all listings
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(color: Color(0xFFF1C64A), fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Books List
          if (userBooks.isEmpty)
            const Padding(
              padding: EdgeInsets.all(48),
              child: Text(
                'No active listings',
                style: TextStyle(color: Colors.white60, fontSize: 16),
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: userBooks.length,
              itemBuilder: (context, index) {
                final book = userBooks[index];
                final timeAgo = _getTimeAgo(book.datePosted);
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: BookListingCard(
                    title: book.title,
                    author: book.author,
                    status: book.condition,
                    timePosted: timeAgo,
                    imageUrl: book.imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailPage(book: book),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  String _formatMemberSince(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.year}';
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
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFFF1C64A), size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white60, fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
