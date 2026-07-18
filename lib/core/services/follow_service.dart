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

  //  batch fetch user profiles for a list of IDs
  static Future<Map<String, Map<String, dynamic>>> fetchUsersByIds(
    List<String> ids,
  ) async {
    if (ids.isEmpty) return {};

    final result = <String, Map<String, dynamic>>{};

    for (var i = 0; i < ids.length; i += 10) {
      final chunk = ids.sublist(i, i + 10 > ids.length ? ids.length : i + 10);

      final snap = await _db
          .collection('users')
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      for (final doc in snap.docs) {
        result[doc.id] = doc.data();
      }
    }

    return result;
  }
}
