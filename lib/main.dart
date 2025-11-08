import 'package:book_swap/screens/login_page.dart';
import 'package:book_swap/screens/signup_page.dart';
import 'package:book_swap/screens/welcome_page.dart';
import 'package:book_swap/screens/browse_listings_page.dart';
import 'package:book_swap/screens/my_listings_page.dart';
import 'package:book_swap/screens/post_book_page.dart';
import 'package:book_swap/screens/profile_page.dart';
import 'package:book_swap/screens/settings_page.dart';
import 'package:book_swap/screens/my_offers_page.dart';
import 'package:book_swap/screens/chat_list_page.dart';
import 'package:book_swap/screens/chat_page.dart';
import 'package:book_swap/screens/swap_history_page.dart';
import 'package:book_swap/screens/other_user_profile_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/browse': (context) => const BrowseListingsPage(),
        '/my-listings': (context) => const MyListingsPage(),
        '/post-book': (context) => const PostBookPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/my-offers': (context) => const MyOffersPage(),
        '/chats': (context) => const ChatListPage(),
        '/chat': (context) => const ChatPage(),
        '/swap-history': (context) => const SwapHistoryPage(),
        '/other-user-profile': (context) => const OtherUserProfilePage(),
      },
    );
  }
}
