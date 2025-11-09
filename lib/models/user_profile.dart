class UserProfile {
  final String id;
  final String name;
  final String email;
  final String avatar;
  final int activeListings;
  final int completedSwaps;
  final DateTime memberSince;
  final double rating;

  UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.avatar,
    this.activeListings = 0,
    this.completedSwaps = 0,
    required this.memberSince,
    this.rating = 0.0,
  });
}
