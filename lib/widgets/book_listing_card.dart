import 'package:book_swap/widgets/status_chip.dart';
import 'package:book_swap/widgets/swap_status_badge.dart';
import 'package:flutter/material.dart';

class BookListingCard extends StatelessWidget {
  final String title;
  final String author;
  final String status;
  final String timePosted;
  final VoidCallback onTap;
  final SwapStatusType? swapStatus;

  const BookListingCard({
    super.key,
    required this.title,
    required this.author,
    required this.status,
    required this.timePosted,
    required this.onTap,
    this.swapStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white10,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Book cover placeholder
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Icon(Icons.book, color: Colors.white54, size: 32),
                    ),
                  ),
                  // Swap status badge overlay
                  if (swapStatus != null)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _getSwapStatusColor(),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getSwapStatusIcon(),
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      author,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        StatusChip(label: status),
                        if (swapStatus != null) ...[
                          const SizedBox(width: 8),
                          SwapStatusBadge(status: swapStatus!),
                        ],
                        const Spacer(),
                        Text(
                          timePosted,
                          style: const TextStyle(
                            color: Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getSwapStatusColor() {
    if (swapStatus == null) return Colors.transparent;
    switch (swapStatus!) {
      case SwapStatusType.available:
        return Colors.green;
      case SwapStatusType.pending:
        return Colors.orange;
      case SwapStatusType.swapped:
        return Colors.grey;
    }
  }

  IconData _getSwapStatusIcon() {
    if (swapStatus == null) return Icons.circle;
    switch (swapStatus!) {
      case SwapStatusType.available:
        return Icons.check;
      case SwapStatusType.pending:
        return Icons.schedule;
      case SwapStatusType.swapped:
        return Icons.done_all;
    }
  }
}
