class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int totalListings;
  final int completedSwaps;
  final DateTime memberSince;
  final double rating;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    required this.totalListings,
    required this.completedSwaps,
    required this.memberSince,
    required this.rating,
  });
}
