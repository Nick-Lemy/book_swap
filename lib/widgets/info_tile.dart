import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  final String title;
  final String? value;
  final bool hasArrow;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
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
              style: const TextStyle(
                color: Colors.white60,
                fontSize: 16,
              ),
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
