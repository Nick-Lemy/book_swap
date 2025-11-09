import '../models/book.dart';

final List<Book> dummyBooks = [
  Book(
    id: '1',
    title: 'Data Structures & Algorithms',
    author: 'Themali V Demon',
    ownerId: 'user1',
    owner: 'John Smith',
    ownerEmail: 'john.smith@university.edu',
    category: 'Data Structures',
    condition: 'Like New',
    description:
        'Comprehensive guide to data structures and algorithms. Barely used, no markings.',
    datePosted: DateTime.now().subtract(const Duration(days: 3)),
    isAvailable: true,
  ),
  Book(
    id: '2',
    title: 'Operating Systems',
    author: 'John Doe',
    ownerId: 'user2',
    owner: 'Sarah Johnson',
    ownerEmail: 'sarah.johnson@university.edu',
    category: 'Operating Systems',
    condition: 'Used',
    description:
        'Classic textbook on operating systems. Some highlighting and notes.',
    datePosted: DateTime.now().subtract(const Duration(days: 2)),
    isAvailable: true,
  ),
  Book(
    id: '3',
    title: 'Operating Systems: Internals and Design Principles',
    author: 'William Stallings',
    ownerId: 'user3',
    owner: 'Michael Brown',
    ownerEmail: 'michael.brown@university.edu',
    category: 'Operating Systems',
    condition: 'Good',
    description:
        'In-depth coverage of OS concepts. Good condition with minimal wear.',
    datePosted: DateTime.now().subtract(const Duration(days: 1)),
    isAvailable: true,
  ),
  Book(
    id: '4',
    title: 'Introduction to Algorithms',
    author: 'Thomas H. Cormen',
    ownerId: 'user4',
    owner: 'Emily Davis',
    ownerEmail: 'emily.davis@university.edu',
    category: 'Algorithms',
    condition: 'Like New',
    description:
        'The definitive guide to algorithms. Purchased last semester, rarely opened.',
    datePosted: DateTime.now().subtract(const Duration(days: 5)),
    isAvailable: true,
  ),
  Book(
    id: '5',
    title: 'Computer Networks',
    author: 'Andrew S. Tanenbaum',
    ownerId: 'user5',
    owner: 'David Wilson',
    ownerEmail: 'david.wilson@university.edu',
    category: 'Networking',
    condition: 'Used',
    description:
        'Great book on networking fundamentals. Has some notes in margins.',
    datePosted: DateTime.now().subtract(const Duration(days: 7)),
    isAvailable: true,
  ),
  Book(
    id: '6',
    title: 'Database System Concepts',
    author: 'Abraham Silberschatz',
    ownerId: 'user6',
    owner: 'Jessica Martinez',
    ownerEmail: 'jessica.martinez@university.edu',
    category: 'Databases',
    condition: 'Good',
    description: 'Comprehensive database textbook. Clean copy with no damage.',
    datePosted: DateTime.now().subtract(const Duration(days: 4)),
    isAvailable: true,
  ),
  Book(
    id: '7',
    title: 'Design Patterns: Elements of Reusable Object-Oriented Software',
    author: 'Gang of Four',
    ownerId: 'user7',
    owner: 'Robert Taylor',
    ownerEmail: 'robert.taylor@university.edu',
    category: 'Software Engineering',
    condition: 'Used',
    description:
        'Classic design patterns book. Well-read but in decent condition.',
    datePosted: DateTime.now().subtract(const Duration(days: 6)),
    isAvailable: true,
  ),
  Book(
    id: '8',
    title: 'Clean Code',
    author: 'Robert C. Martin',
    ownerId: 'user8',
    owner: 'Amanda Lee',
    ownerEmail: 'amanda.lee@university.edu',
    category: 'Software Engineering',
    condition: 'Like New',
    description: 'Excellent condition. A must-read for software developers.',
    datePosted: DateTime.now().subtract(const Duration(days: 8)),
    isAvailable: true,
  ),
  Book(
    id: '9',
    title: 'Artificial Intelligence: A Modern Approach',
    author: 'Stuart Russell',
    ownerId: 'user9',
    owner: 'Christopher White',
    ownerEmail: 'chris.white@university.edu',
    category: 'Artificial Intelligence',
    condition: 'Good',
    description:
        'Comprehensive AI textbook. Some wear on cover but pages are clean.',
    datePosted: DateTime.now().subtract(const Duration(days: 10)),
    isAvailable: true,
  ),
  Book(
    id: '10',
    title: 'The Pragmatic Programmer',
    author: 'Andrew Hunt',
    ownerId: 'user10',
    owner: 'Jennifer Garcia',
    ownerEmail: 'jennifer.garcia@university.edu',
    category: 'Software Engineering',
    condition: 'Used',
    description:
        'Great book with practical programming advice. Has some highlights.',
    datePosted: DateTime.now().subtract(const Duration(days: 9)),
    isAvailable: true,
  ),
];

// Get books by category
List<Book> getBooksByCategory(String category) {
  if (category == 'All') {
    return dummyBooks;
  }
  return dummyBooks.where((book) => book.category == category).toList();
}

// Get all unique categories
List<String> getAllCategories() {
  final categories = dummyBooks.map((book) => book.category).toSet().toList();
  categories.sort();
  return ['All', ...categories];
}
