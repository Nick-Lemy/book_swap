import 'package:flutter/material.dart';
import '../models/book.dart';
import '../constants/dummy_data.dart';
import '../widgets/app_bottom_nav_bar.dart';

enum SwapStatus { pending, accepted, rejected }

class SwapOffer {
  final String id;
  final Book book;
  final String fromUser;
  final String toUser;
  final SwapStatus status;
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.book,
    required this.fromUser,
    required this.toUser,
    required this.status,
    required this.createdAt,
  });
}

class MyOffersPage extends StatefulWidget {
  const MyOffersPage({super.key});

  @override
  State<MyOffersPage> createState() => _MyOffersPageState();
}

class _MyOffersPageState extends State<MyOffersPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Dummy data for swap offers
  final List<SwapOffer> _incomingOffers = [
    SwapOffer(
      id: '1',
      book: dummyBooks[0],
      fromUser: 'John Smith',
      toUser: 'Me',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SwapOffer(
      id: '2',
      book: dummyBooks[2],
      fromUser: 'Alice Johnson',
      toUser: 'Me',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<SwapOffer> _outgoingOffers = [
    SwapOffer(
      id: '3',
      book: dummyBooks[1],
      fromUser: 'Me',
      toUser: 'Bob Wilson',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    SwapOffer(
      id: '4',
      book: dummyBooks[3],
      fromUser: 'Me',
      toUser: 'Carol Davis',
      status: SwapStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SwapOffer(
      id: '5',
      book: dummyBooks[4],
      fromUser: 'Me',
      toUser: 'David Brown',
      status: SwapStatus.rejected,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

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
          _buildOffersList(_incomingOffers, isIncoming: true),
          _buildOffersList(_outgoingOffers, isIncoming: false),
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

  Widget _buildOffersList(List<SwapOffer> offers, {required bool isIncoming}) {
    if (offers.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              isIncoming ? Icons.inbox_outlined : Icons.send_outlined,
              size: 80,
              color: Colors.white24,
            ),
            const SizedBox(height: 16),
            Text(
              isIncoming ? 'No incoming offers' : 'No outgoing offers',
              style: const TextStyle(color: Colors.white60, fontSize: 18),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return _OfferCard(
          offer: offers[index],
          isIncoming: isIncoming,
          onAccept: isIncoming ? () => _handleAccept(offers[index]) : null,
          onReject: isIncoming ? () => _handleReject(offers[index]) : null,
        );
      },
    );
  }

  void _handleAccept(SwapOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted swap offer for "${offer.book.title}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleReject(SwapOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected swap offer for "${offer.book.title}"'),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final SwapOffer offer;
  final bool isIncoming;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const _OfferCard({
    required this.offer,
    required this.isIncoming,
    this.onAccept,
    this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getStatusColor().withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Book Cover
              Container(
                width: 60,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.book, color: Colors.white60, size: 30),
              ),
              const SizedBox(width: 16),
              // Book Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      offer.book.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      offer.book.author,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isIncoming
                          ? 'From: ${offer.fromUser}'
                          : 'To: ${offer.toUser}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              // Status Badge
              _StatusBadge(status: offer.status),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _getTimeAgo(offer.createdAt),
            style: const TextStyle(color: Colors.white38, fontSize: 12),
          ),
          // Action Buttons for Incoming Pending Offers
          if (isIncoming && offer.status == SwapStatus.pending) ...[
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onReject,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Reject'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF1C64A),
                      foregroundColor: const Color(0xFF0B1026),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (offer.status) {
      case SwapStatus.pending:
        return Colors.orange;
      case SwapStatus.accepted:
        return Colors.green;
      case SwapStatus.rejected:
        return Colors.red;
    }
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

class _StatusBadge extends StatelessWidget {
  final SwapStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _getColor(), width: 1),
      ),
      child: Text(
        _getText(),
        style: TextStyle(
          color: _getColor(),
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case SwapStatus.pending:
        return Colors.orange;
      case SwapStatus.accepted:
        return Colors.green;
      case SwapStatus.rejected:
        return Colors.red;
    }
  }

  String _getText() {
    switch (status) {
      case SwapStatus.pending:
        return 'Pending';
      case SwapStatus.accepted:
        return 'Accepted';
      case SwapStatus.rejected:
        return 'Rejected';
    }
  }
}
