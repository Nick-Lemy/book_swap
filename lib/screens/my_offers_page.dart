import 'package:flutter/material.dart';
import '../models/swap_offer.dart';
import '../constants/dummy_data.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/empty_state_widget.dart';
import '../widgets/offer_card.dart';

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
      bookId: dummyBooks[0].id,
      bookTitle: dummyBooks[0].title,
      bookAuthor: dummyBooks[0].author,
      bookImageUrl: dummyBooks[0].imageUrl,
      fromUserId: 'user1',
      fromUserName: 'John Smith',
      toUserId: 'current_user',
      toUserName: 'Me',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    SwapOffer(
      id: '2',
      bookId: dummyBooks[2].id,
      bookTitle: dummyBooks[2].title,
      bookAuthor: dummyBooks[2].author,
      bookImageUrl: dummyBooks[2].imageUrl,
      fromUserId: 'user2',
      fromUserName: 'Alice Johnson',
      toUserId: 'current_user',
      toUserName: 'Me',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<SwapOffer> _outgoingOffers = [
    SwapOffer(
      id: '3',
      bookId: dummyBooks[1].id,
      bookTitle: dummyBooks[1].title,
      bookAuthor: dummyBooks[1].author,
      bookImageUrl: dummyBooks[1].imageUrl,
      fromUserId: 'current_user',
      fromUserName: 'Me',
      toUserId: 'user3',
      toUserName: 'Bob Wilson',
      status: SwapStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    SwapOffer(
      id: '4',
      bookId: dummyBooks[3].id,
      bookTitle: dummyBooks[3].title,
      bookAuthor: dummyBooks[3].author,
      bookImageUrl: dummyBooks[3].imageUrl,
      fromUserId: 'current_user',
      fromUserName: 'Me',
      toUserId: 'user4',
      toUserName: 'Carol Davis',
      status: SwapStatus.accepted,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    SwapOffer(
      id: '5',
      bookId: dummyBooks[4].id,
      bookTitle: dummyBooks[4].title,
      bookAuthor: dummyBooks[4].author,
      bookImageUrl: dummyBooks[4].imageUrl,
      fromUserId: 'current_user',
      fromUserName: 'Me',
      toUserId: 'user5',
      toUserName: 'David Brown',
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
        content: Text('Accepted swap offer for "${offer.bookTitle}"'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _handleReject(SwapOffer offer) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Rejected swap offer for "${offer.bookTitle}"'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
