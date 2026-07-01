import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivals/core/models/post_model.dart';

class PostService {
  static final _db = FirebaseFirestore.instance;

  // All posts sorted by newest
  static Stream<List<PostModel>> getAllPosts() {
    return _db
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromDoc).toList());
  }

  // Posts by a specific club
  static Stream<List<PostModel>> getPostsByClub(String clubId) {
    return _db
        .collection('posts')
        .where('clubId', isEqualTo: clubId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(PostModel.fromDoc).toList());
  }

  // Create a post
  static Future<void> createPost({
    required String userId,
    required String displayName,
    required String clubId,
    required String clubName,
    required String clubColor,
    required String content,
  }) async {
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
    });
  }

  // Like a post
  static Future<void> likePost(String postId) async {
    await _db.collection('posts').doc(postId).update({
      'likes': FieldValue.increment(1),
    });
  }

  // Delete a post
  static Future<void> deletePost(String postId) async {
    await _db.collection('posts').doc(postId).delete();
  }
}
