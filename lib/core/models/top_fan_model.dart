class TopFanModel {
  final String userId;
  final String displayName;
  final String profileImageUrl;
  final String clubName;
  final int posts;
  final int likesReceived;

  const TopFanModel({
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.clubName,
    required this.posts,
    required this.likesReceived,
  });

  // score = posts * 2 + likes received
  int get score => (posts * 2) + likesReceived;

  factory TopFanModel.fromMap(Map<String, dynamic> map) {
    return TopFanModel(
      userId:          map['userId'] ?? '',
      displayName:     map['displayName'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      clubName:        map['clubName'] ?? '',
      posts:           map['posts'] ?? 0,
      likesReceived:   map['likesReceived'] ?? 0,
    );
  }
}