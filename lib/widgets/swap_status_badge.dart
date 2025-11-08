import 'package:flutter/material.dart';

enum SwapStatusType { available, pending, swapped }

class SwapStatusBadge extends StatelessWidget {
  final SwapStatusType status;

  const SwapStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getColor().withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _getColor(), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 12, color: _getColor()),
          const SizedBox(width: 4),
          Text(
            _getText(),
            style: TextStyle(
              color: _getColor(),
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor() {
    switch (status) {
      case SwapStatusType.available:
        return Colors.green;
      case SwapStatusType.pending:
        return Colors.orange;
      case SwapStatusType.swapped:
        return Colors.grey;
    }
  }

  IconData _getIcon() {
    switch (status) {
      case SwapStatusType.available:
        return Icons.check_circle;
      case SwapStatusType.pending:
        return Icons.schedule;
      case SwapStatusType.swapped:
        return Icons.done_all;
    }
  }

  String _getText() {
    switch (status) {
      case SwapStatusType.available:
        return 'Available';
      case SwapStatusType.pending:
        return 'Pending Swap';
      case SwapStatusType.swapped:
        return 'Swapped';
    }
  }
}
