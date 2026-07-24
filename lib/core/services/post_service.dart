import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/cloudinary_service.dart';

class PostService {
  static final _db = FirebaseFirestore.instance;
  static final _picker = ImagePicker();

  // all posts sorted by newest
  static Stream<List<PostModel>> getAllPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromDoc).toList());
  }

  // posts by a specific club
  static Stream<List<PostModel>> getPostsByClub(String clubId) {
    return _db
        .collection('posts')
        .where('clubId', isEqualTo: clubId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromDoc).toList());
  }

  // create a post
  static Future<void> createPost({
    required String userId,
    required String displayName,
    required String clubId,
    required String clubName,
    required String clubColor,
    required String content,
    File? mediaFile,
    bool isVideo = false,
    required String profileImageUrl,
  }) async {
    String mediaUrl = '';
    if (mediaFile != null) {
      mediaUrl = await CloudinaryService.uploadMedia(
        mediaFile,
        isVideo: isVideo,
      );
    }

    await _db.collection('posts').add({
      'userId': userId,
      'displayName': displayName,
      'clubId': clubId,
      'clubName': clubName,
      'clubColor': clubColor,
      'content': content,
      'likes': 0,
      'comments': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'mediaUrl': mediaUrl,
      'isVideo': isVideo,
      'profileImageUrl': profileImageUrl,
    });
  }

  // get all posts by a specific user
  static Stream<List<PostModel>> getPostsByUser(String userId) {
    return _db
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromDoc).toList());
  }

  // like post and unlike a post
  static Future<void> toggleLike(String postId, String userId) async {
    final doc = _db.collection('posts').doc(postId);
    final snapshot = await doc.get();
    final likedBy = List<String>.from(snapshot.data()?['likedBy'] ?? []);

    if (likedBy.contains(userId)) {
      await doc.update({
        'likes': FieldValue.increment(-1),
        'likedBy': FieldValue.arrayRemove([userId]),
      });
    } else {
      await doc.update({
        'likes': FieldValue.increment(1),
        'likedBy': FieldValue.arrayUnion([userId]),
      });
    }
  }

  // delete a post
  static Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }

  // pick image
  static Future<File?> pickImage({bool fromCamera = false}) async {
    final picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    return picked != null ? File(picked.path) : null;
  }

  // pick video — max 30 seconds
  static Future<File?> pickVideo({bool fromCamera = false}) async {
    final picked = await _picker.pickVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    return picked != null ? File(picked.path) : null;
  }
}
