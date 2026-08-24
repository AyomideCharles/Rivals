import 'package:cloud_firestore/cloud_firestore.dart';

class ClipModel {
  final String id;
  final String userId;
  final String displayName;
  final String profileImageUrl;
  final String clubId;
  final String clubName;
  final String clubColor;
  final String clubLeague;
  final String videoUrl;
  final String thumbnailUrl;
  final String caption;
  final int likes;
  final List<String> likedBy;
  final int comments;
  final int views;
  final DateTime createdAt;

  const ClipModel({
    required this.id,
    required this.userId,
    required this.displayName,
    required this.profileImageUrl,
    required this.clubId,
    required this.clubName,
    required this.clubColor,
    required this.clubLeague,
    required this.videoUrl,
    this.thumbnailUrl = '',
    this.caption = '',
    this.likes = 0,
    this.likedBy = const [],
    this.comments = 0,
    this.views = 0,
    required this.createdAt,
  });

  factory ClipModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ClipModel(
      id:              doc.id,
      userId:          data['userId'] ?? '',
      displayName:     data['displayName'] ?? '',
      profileImageUrl: data['profileImageUrl'] ?? '',
      clubId:          data['clubId'] ?? '',
      clubName:        data['clubName'] ?? '',
      clubColor:       data['clubColor'] ?? '',
      clubLeague:      data['clubLeague'] ?? '',
      videoUrl:        data['videoUrl'] ?? '',
      thumbnailUrl:    data['thumbnailUrl'] ?? '',
      caption:         data['caption'] ?? '',
      likes:           data['likes'] ?? 0,
      likedBy:         List<String>.from(data['likedBy'] ?? []),
      comments:        data['comments'] ?? 0,
      views:           data['views'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'userId':          userId,
    'displayName':     displayName,
    'profileImageUrl': profileImageUrl,
    'clubId':          clubId,
    'clubName':        clubName,
    'clubColor':       clubColor,
    'clubLeague':      clubLeague,
    'videoUrl':        videoUrl,
    'thumbnailUrl':    thumbnailUrl,
    'caption':         caption,
    'likes':           likes,
    'likedBy':         likedBy,
    'comments':        comments,
    'views':           views,
    'createdAt':       FieldValue.serverTimestamp(),
  };
}