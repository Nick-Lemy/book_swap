import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/setting_tile.dart';
import '../widgets/info_tile.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  static const Color _bg = Color(0xFF0B1026);

  bool notificationUpdates = true;
  bool emailReminders = false;

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
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Notifications',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // Notification Updates Toggle
              SettingTile(
                title: 'Notification Updates',
                subtitle: 'Receive notifications about new book listings',
                value: notificationUpdates,
                onChanged: (value) {
                  setState(() {
                    notificationUpdates = value;
                  });
                },
              ),
              const SizedBox(height: 12),

              // Email Reminders Toggle
              SettingTile(
                title: 'Email Reminders',
                subtitle: 'Get email reminders for your swap requests',
                value: emailReminders,
                onChanged: (value) {
                  setState(() {
                    emailReminders = value;
                  });
                },
              ),
              const SizedBox(height: 32),

              const Text(
                'About',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              // About Items
              InfoTile(title: 'Version', value: '1.0.0'),
              const SizedBox(height: 12),
              InfoTile(
                title: 'Terms & Conditions',
                hasArrow: true,
                onTap: () {
                  // TODO: Navigate to terms
                },
              ),
              const SizedBox(height: 12),
              InfoTile(
                title: 'Privacy Policy',
                hasArrow: true,
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 4,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/browse');
          } else if (index == 1) {
            Navigator.pushNamed(context, '/my-listings');
          } else if (index == 3) {
            Navigator.pushNamed(context, '/profile');
          }
        },
      ),
    );
  }
}
