import 'book.dart';

class SwapHistoryItem {
  final String id;
  final Book book;
  final String swappedWith;
  final DateTime swapDate;
  final String myBookTitle;

  SwapHistoryItem({
    required this.id,
    required this.book,
    required this.swappedWith,
    required this.swapDate,
    required this.myBookTitle,
  });
}
