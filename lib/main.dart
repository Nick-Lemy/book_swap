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
import 'package:book_swap/screens/swap_history_page.dart';
import 'package:book_swap/screens/other_user_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookSwap',
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignUpPage(),
        '/browse': (context) => const BrowseListingsPage(),
        '/my-listings': (context) => const MyListingsPage(),
        '/post-book': (context) => const PostBookPage(),
        '/profile': (context) => const ProfilePage(),
        '/settings': (context) => const SettingsPage(),
        '/my-offers': (context) => const MyOffersPage(),
        '/chats': (context) => const ChatListPage(),
        // Note: ChatPage is navigated to programmatically with required parameters
        '/swap-history': (context) => const SwapHistoryPage(),
        '/other-user-profile': (context) => const OtherUserProfilePage(),
      },
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();

    return StreamBuilder(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        // Show loading while checking auth state
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Color(0xFF0B1026),
            body: Center(
              child: CircularProgressIndicator(color: Color(0xFFF1C64A)),
            ),
          );
        }

        // User is signed in, go to browse
        if (snapshot.hasData) {
          return const BrowseListingsPage();
        }

        // User is not signed in, show welcome
        return const WelcomeScreen();
      },
    );
  }
}
