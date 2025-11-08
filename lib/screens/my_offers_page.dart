import 'package:flutter/material.dart';
import '../models/book.dart';
import '../constants/dummy_data.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/offer_card.dart';

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
      return EmptyStateWidget(
        icon: isIncoming ? Icons.inbox_outlined : Icons.send_outlined,
        title: isIncoming ? 'No incoming offers' : 'No outgoing offers',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        return OfferCard(
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
