import 'package:cloud_firestore/cloud_firestore.dart';

class StoryModel {
  final String id;
  final String userId;
  final String displayName;
  final String profileImageUrl;
  final String clubId;
  final String clubName;
  final String mediaUrl;
  final bool isVideo;
  final DateTime createdAt;
  final DateTime expiresAt;
  final List<String> viewedBy;

  const StoryModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.clubId,
    required this.clubName,
    required this.mediaUrl,
    this.isVideo = false,
    required this.createdAt,
    required this.expiresAt,
    this.viewedBy = const [],
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
  bool get isVideo_ => isVideo;

  factory StoryModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StoryModel(
      id:              doc.id,
      userId:          data['userId'] ?? '',
      displayName:     data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      clubId:          data['clubId'] ?? '',
      clubName:        data['clubName'] ?? '',
      mediaUrl:        data['mediaUrl'] ?? '',
      isVideo:         data['isVideo'] ?? false,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      expiresAt: (data['expiresAt'] as Timestamp?)?.toDate() ??
          DateTime.now().add(const Duration(hours: 24)),
      viewedBy: List<String>.from(data['viewedBy'] ?? []),
    );
  }
}