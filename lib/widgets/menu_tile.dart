import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;

  const MenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
    this.isDestructive = false,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? Colors.red : Colors.white,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? Colors.red : Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                Icon(
                  Icons.arrow_forward_ios,
                  color: isDestructive ? Colors.red : Colors.white60,
                  size: 16,
                ),
          ],
        ),
      ),
    );
  }
}
