class Book {
  final String id;
  final String title;
  final String author;
  final String owner;
  final String ownerEmail;
  final String category;
  final String condition;
  final String? description;
  final DateTime datePosted;
  final String? imageUrl;
  final bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.owner,
    required this.ownerEmail,
    required this.category,
    required this.condition,
    this.description,
    required this.datePosted,
    this.imageUrl,
    this.isAvailable = true,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(datePosted);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }

  // Create a copy of the book with updated fields
  Book copyWith({
    String? id,
    String? title,
    String? author,
    String? owner,
    String? ownerEmail,
    String? category,
    String? condition,
    String? description,
    DateTime? datePosted,
    String? imageUrl,
    bool? isAvailable,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      author: author ?? this.author,
      owner: owner ?? this.owner,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      category: category ?? this.category,
      condition: condition ?? this.condition,
      description: description ?? this.description,
      datePosted: datePosted ?? this.datePosted,
      imageUrl: imageUrl ?? this.imageUrl,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
