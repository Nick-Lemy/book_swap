enum SwapStatus { pending, accepted, rejected, cancelled }

class SwapOffer {
  final String id;
  final String bookId;
  final String bookTitle;
  final String bookAuthor;
  final String? bookImageUrl;
  final String fromUserId;
  final String fromUserName;
  final String toUserId;
  final String toUserName;
  final SwapStatus status;
  final DateTime createdAt;

  SwapOffer({
    required this.id,
    required this.bookId,
    required this.bookTitle,
    required this.bookAuthor,
    this.bookImageUrl,
    required this.fromUserId,
    required this.fromUserName,
    required this.toUserId,
    required this.toUserName,
    required this.status,
    required this.createdAt,
  });
}
