import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rivals/core/models/club_model.dart';

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

  // Fetch a single club by shortName
  static Stream<ClubModel?> getClub(String shortName) {
    return _db
        .collection('clubs')
        .doc(shortName)
        .snapshots()
        .map((doc) => doc.exists ? ClubModel.fromMap(doc.data()!) : null);
  }

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
}
