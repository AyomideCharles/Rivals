import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/models/top_fan_model.dart';

class ClubService {
  static final _db = FirebaseFirestore.instance;

  // Fetch all leagues
  static Stream<List<Map<String, dynamic>>> getLeagues() {
    return _db
        .collection('leagues')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  // Fetch all clubs for a league
  static Stream<List<ClubModel>> getClubsByLeague(String league) {
    return _db
        .collection('clubs')
        .where('league', isEqualTo: league)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => ClubModel.fromMap(doc.data())).toList(),
        );
  }

  // // Fetch a single club by shortName
  // static Stream<ClubModel?> getClub(String shortName) {
  //   return _db
  //       .collection('clubs')
  //       .doc(shortName)
  //       .snapshots()
  //       .map((doc) => doc.exists ? ClubModel.fromMap(doc.data()!) : null);
  // }

  // Fetch all clubs
  static Stream<List<ClubModel>> getAllClubs() {
    return _db
        .collection('clubs')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => ClubModel.fromMap(doc.data())).toList(),
        );
  }

  static Future<List<TopFanModel>> getTopFans(String clubId) async {
    print('🏆 Fetching top fans for: $clubId');

    // get all posts for this club
    final postsSnap = await _db
        .collection('posts')
        .where('clubId', isEqualTo: clubId)
        .get();

    print('📦 Posts found: ${postsSnap.docs.length}');

    // group by userId and accumulate score
    final Map<String, Map<String, dynamic>> userStats = {};

    for (final doc in postsSnap.docs) {
      print('📄 Post: ${doc.data()}');

      final data = doc.data();
      final userId = data['userId'] as String;

      if (!userStats.containsKey(userId)) {
        userStats[userId] = {
          'userId': userId,
          'displayName': data['displayName'] ?? '',
          'profileImageUrl': data['profileImageUrl'] ?? '',
          'clubName': data['clubName'] ?? '',
          'posts': 0,
          'likesReceived': 0,
        };
      }

      userStats[userId]!['posts'] += 1;
      userStats[userId]!['likesReceived'] += (data['likes'] ?? 0) as int;
    }

    // convert to model and calculate score
    final fans = userStats.values.map((s) => TopFanModel.fromMap(s)).toList();

    // sort by score descending
    fans.sort((a, b) => b.score.compareTo(a.score));

    // return top 20
    return fans.take(20).toList();
  }
}
