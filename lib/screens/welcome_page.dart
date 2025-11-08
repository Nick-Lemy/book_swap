import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const Color _bg = Color(0xFF0B1026);
  static const Color _accent = Color(0xFFF1C64A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        height: double.infinity,
        decoration: BoxDecoration(
          color: _bg,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 6),
            // icon with subtle yellow "shadow"
            SizedBox(
              height: 96,
              child: Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // yellow shadow/book background
                    Transform.translate(
                      offset: const Offset(6, 6),
                      child: Icon(Icons.menu_book, size: 64, color: _accent),
                    ),
                    // white book on top
                    Icon(Icons.menu_book, size: 64, color: Colors.white),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 12),
            const Text(
              'BookSwap',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
            // const SizedBox(height: 18),
            const Text(
              'Swap Your Books\nWith Other Students',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Text(
              'Sign in to get started',
              style: TextStyle(color: Colors.white70, fontSize: 13),
            ),
            // const SizedBox(height: 22),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: _accent,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Sign In',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
