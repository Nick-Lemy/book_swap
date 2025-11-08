import 'package:flutter/material.dart';
import '../widgets/app_bottom_nav_bar.dart';

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
              _SettingTile(
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
              _SettingTile(
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
              _InfoTile(title: 'Version', value: '1.0.0'),
              const SizedBox(height: 12),
              _InfoTile(
                title: 'Terms & Conditions',
                hasArrow: true,
                onTap: () {
                  // TODO: Navigate to terms
                },
              ),
              const SizedBox(height: 12),
              _InfoTile(
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

class _SettingTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white60, fontSize: 14),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFF1C64A),
            activeTrackColor: const Color(0xFFF1C64A).withOpacity(0.5),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final String title;
  final String? value;
  final bool hasArrow;
  final VoidCallback? onTap;

  const _InfoTile({
    required this.title,
    this.value,
    this.hasArrow = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final content = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          if (value != null)
            Text(
              value!,
              style: const TextStyle(color: Colors.white60, fontSize: 16),
            ),
          if (hasArrow) ...[
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white60,
              size: 16,
            ),
          ],
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: content,
      );
    }

    return content;
  }
}
