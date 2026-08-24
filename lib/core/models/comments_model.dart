import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String id;
  final String userId;
  final String displayName;
  final String profileImageUrl;
  final String clubName;
  final String content;
  final DateTime createdAt;

  const CommentModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.clubName,
    required this.content,
    required this.createdAt,
  });

  factory CommentModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CommentModel(
      id:              doc.id,
      userId:          data['userId'] ?? '',
      displayName:     data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      clubName:        data['clubName'] ?? '',
      content:         data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}