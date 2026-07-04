import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String id;
  final String userId;
  final String displayName;
  final String clubId;
  final String clubName;
  final String clubColor;
  final String content;
  final String mediaUrl;
  final bool isVideo;
  final int likes;
  final int comments;
  final DateTime createdAt;

  const PostModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.clubId,
    required this.clubName,
    required this.clubColor,
    required this.content,
    this.mediaUrl = '',
    this.isVideo = false,
    this.likes = 0,
    this.comments = 0,
    required this.createdAt,
  });

  bool get hasMedia => mediaUrl.isNotEmpty;

  factory PostModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PostModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      displayName: data['displayName'] ?? '',
      clubId: data['clubId'] ?? '',
      clubName: data['clubName'] ?? '',
      clubColor: data['clubColor'] ?? '',
      content: data['content'] ?? '',
      mediaUrl: data['mediaUrl'] ?? '',
      isVideo: data['isVideo'] ?? false,
      likes: data['likes'] ?? 0,
      comments: data['comments'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId': userId,
    'displayName': displayName,
    'clubId': clubId,
    'clubName': clubName,
    'clubColor': clubColor,
    'content': content,
    'mediaUrl': mediaUrl,
    'isVideo': isVideo,
    'likes': likes,
    'comments': comments,
    'createdAt': FieldValue.serverTimestamp(),
  };
}
