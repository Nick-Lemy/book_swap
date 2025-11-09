class SwapHistoryItem {
  final String id;
  final String bookReceivedTitle;
  final String bookReceivedAuthor;
  final String? bookReceivedImageUrl;
  final String bookGivenTitle;
  final String bookGivenAuthor;
  final String? bookGivenImageUrl;
  final String swappedWith;
  final DateTime swapDate;
  final double? rating;

  SwapHistoryItem({
    required this.id,
    required this.bookReceivedTitle,
    required this.bookReceivedAuthor,
    this.bookReceivedImageUrl,
    required this.bookGivenTitle,
    required this.bookGivenAuthor,
    this.bookGivenImageUrl,
    required this.swappedWith,
    required this.swapDate,
    this.rating,
  });
}
