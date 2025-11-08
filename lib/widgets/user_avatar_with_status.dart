import 'package:flutter/material.dart';

class UserAvatarWithStatus extends StatelessWidget {
  final String userInitial;
  final bool isOnline;
  final double radius;
  final Color backgroundColor;
  final Color textColor;

  const UserAvatarWithStatus({
    super.key,
    required this.userInitial,
    this.isOnline = false,
    this.radius = 28,
    this.backgroundColor = const Color(0xFFF1C64A),
    this.textColor = const Color(0xFF0B1026),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircleAvatar(
          radius: radius,
          backgroundColor: backgroundColor,
          child: Text(
            userInitial,
            style: TextStyle(
              color: textColor,
              fontSize: radius * 0.7,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        if (isOnline)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: radius * 0.57,
              height: radius * 0.57,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF0B1026), width: 2),
              ),
            ),
          ),
      ],
    );
  }
}
