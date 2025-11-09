import 'package:flutter/material.dart';
import '../models/swap_offer.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/offer_card.dart';
import '../services/swap_service.dart';
import '../services/auth_service.dart';
import '../services/book_service.dart';

class MyOffersPage extends StatefulWidget {
  const MyOffersPage({super.key});

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final SwapService _swapService = SwapService();
  final AuthService _authService = AuthService();
  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = _authService.currentUser;

    if (currentUser == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0B1026),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0B1026),
          elevation: 0,
          title: const Text(
            'My Offers',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: const Center(
          child: Text(
            'Please sign in to view offers',
            style: TextStyle(color: Colors.white60),
          ),
        ),
        bottomNavigationBar: AppBottomNavBar(
          currentIndex: 2,
          onTap: (index) {
            if (index == 0) {
              Navigator.pushReplacementNamed(context, '/browse');
            } else if (index == 1) {
              Navigator.pushReplacementNamed(context, '/my-listings');
            } else if (index == 3) {
              Navigator.pushReplacementNamed(context, '/profile');
            } else if (index == 4) {
              Navigator.pushReplacementNamed(context, '/settings');
            }
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0B1026),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1026),
        elevation: 0,
        title: const Text(
          'My Offers',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFF1C64A),
          labelColor: const Color(0xFFF1C64A),
          unselectedLabelColor: Colors.white60,
          tabs: const [
            Tab(text: 'Incoming'),
            Tab(text: 'Outgoing'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildIncomingOffers(currentUser.uid),
          _buildOutgoingOffers(currentUser.uid),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 2,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(context, '/browse');
          } else if (index == 1) {
            Navigator.pushReplacementNamed(context, '/my-listings');
          } else if (index == 2) {
            // Already on My Offers
          } else if (index == 3) {
            Navigator.pushReplacementNamed(context, '/profile');
          } else if (index == 4) {
            Navigator.pushReplacementNamed(context, '/settings');
          }
        },
      ),
    );
  }

  Widget _buildIncomingOffers(String userId) {
    return StreamBuilder<List<SwapOffer>>(
      stream: _swapService.getReceivedOffers(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF1C64A)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading offers: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final offers = snapshot.data ?? [];

        if (offers.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.inbox_outlined,
            title: 'No incoming offers',
            subtitle: 'When someone requests your books, they will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return OfferCard(
              offer: offers[index],
              isIncoming: true,
              onAccept: () => _handleAccept(offers[index]),
              onReject: () => _handleReject(offers[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildOutgoingOffers(String userId) {
    return StreamBuilder<List<SwapOffer>>(
      stream: _swapService.getSentOffers(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFFF1C64A)),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error loading offers: ${snapshot.error}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }

        final offers = snapshot.data ?? [];

        if (offers.isEmpty) {
          return const EmptyStateWidget(
            icon: Icons.send_outlined,
            title: 'No outgoing offers',
            subtitle: 'Offers you make will appear here',
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            return OfferCard(
              offer: offers[index],
              isIncoming: false,
              onAccept: null,
              onReject: null,
            );
          },
        );
      },
    );
  }

  void _handleAccept(SwapOffer offer) async {
    try {
      // Update offer status to accepted
      await _swapService.updateOfferStatus(offer.id, 'accepted');

      // Mark the book as unavailable
      await _bookService.updateBook(bookId: offer.bookId, isAvailable: false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Accepted swap offer for "${offer.bookTitle}"'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error accepting offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _handleReject(SwapOffer offer) async {
    try {
      // Update offer status to rejected
      await _swapService.updateOfferStatus(offer.id, 'rejected');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Rejected swap offer for "${offer.bookTitle}"'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error rejecting offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
