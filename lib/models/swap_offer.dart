import 'book.dart';

enum SwapStatus { pending, accepted, rejected }

class SwapOffer {
  final String id;
  final Book book;
  final String fromUser;
  final String toUser;
  final SwapStatus status;
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.book,
    required this.fromUser,
    required this.toUser,
    required this.status,
    required this.createdAt,
  });
}
