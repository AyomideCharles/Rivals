import 'package:cloud_firestore/cloud_firestore.dart';

class FollowService {
  static final _db = FirebaseFirestore.instance;

  // this is to follow a user
  static Future<void> follow(String followerId, String followingId) async {
    final docId = '${followerId}_$followingId';
    await _db.collection('follows').doc(docId).set({
      'followerId': followerId,
      'followingId': followingId,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // this is to unfollow a user
  static Future<void> unfollow(String followerId, String followingId) async {
    final docId = '${followerId}_$followingId';
    await _db.collection('follows').doc(docId).delete();
  }

  // ths is to check following
  static Stream<bool> isFollowing(String followerId, String followingId) {
    final docId = '${followerId}_$followingId';
    return _db
        .collection('follows')
        .doc(docId)
        .snapshots()
        .map((doc) => doc.exists);
  }

  // get followers count
  static Stream<int> followersCount(String userId) {
    return _db
        .collection('follows')
        .where('followingId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  // get following count
  static Stream<int> followingCount(String userId) {
    return _db
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .snapshots()
        .map((snap) => snap.docs.length);
  }

  // get list of userIds the current user follows
  static Stream<List<String>> getFollowingIds(String userId) {
    return _db
        .collection('follows')
        .where('followerId', isEqualTo: userId)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => doc.data()['followingId'] as String)
              .toList(),
        );
  }
}
