import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/menu_tile.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  // Mock user data - in real app, this would come from authentication
  static const String userName = 'John Smith';
  static const String userEmail = 'john.smith@university.edu';
  static const int booksListed = 3;
  static const int booksSwapped = 12;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
            onPressed: () {
              // TODO: Navigate to edit profile
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Profile Avatar
              CircleAvatar(
                radius: 60,
                backgroundColor: _accent,
                child: Text(
                  userName[0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // User Name
              Text(
                userName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // User Email
              Text(
                userEmail,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 40),

              // Stats Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatCard(
                    label: 'Books Listed',
                    value: booksListed.toString(),
                  ),
                  _StatCard(
                    label: 'Books Swapped',
                    value: booksSwapped.toString(),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Menu Options
              MenuTile(
                icon: Icons.library_books_outlined,
                title: 'My Listings',
                onTap: () {
                  Navigator.pushNamed(context, '/my-listings');
                },
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.swap_horiz,
                title: 'My Offers',
                onTap: () {
                  Navigator.pushNamed(context, '/my-offers');
                },
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.history,
                title: 'Swap History',
                onTap: () {
                  Navigator.pushNamed(context, '/swap-history');
                },
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
              const SizedBox(height: 12),
              MenuTile(
                icon: Icons.logout,
                title: 'Logout',
                isDestructive: true,
                onTap: () {
                  // TODO: Implement logout
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: const Color(0xFF1A1F3A),
                      title: const Text(
                        'Logout',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: const Text(
                        'Are you sure you want to logout?',
                        style: TextStyle(color: Colors.white70),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            // TODO: Perform logout
                          },
                          child: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/browse');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/my-listings');
          } else if (index == 4) {
            Navigator.pushNamed(context, '/settings');
          }
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFF1C64A),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
