import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:rivals/core/constants/constants.dart';
import 'package:rivals/core/models/clips_model.dart';

class ClipsService {
  static final _db = FirebaseFirestore.instance;

  // get all clips
  static Stream<List<ClipModel>> getAllClips() {
    return _db
        .collection('clips')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ClipModel.fromDoc).toList());
  }

  // get clips by user
  static Stream<List<ClipModel>> getClipsByUser(String userId) {
    return _db
        .collection('clips')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map(ClipModel.fromDoc).toList());
  }

  // create a clip
  // static Future<void> createClip({
  //   required String userId,
  //   required String displayName,
  //   required String profileImageUrl,
  //   required String clubId,
  //   required String clubName,
  //   required String clubColor,
  //   required String clubLeague,
  //   required String caption,
  //   required File videoFile,
  // }) async {
  //   final videoUrl = await CloudinaryService.uploadMedia(videoFile);

  //   await _db.collection('clips').add({
  //     'userId': userId,
  //     'displayName': displayName,
  //     'profileImageUrl': profileImageUrl,
  //     'clubId': clubId,
  //     'clubName': clubName,
  //     'clubColor': clubColor,
  //     'clubLeague': clubLeague,
  //     'videoUrl': videoUrl,
  //     'thumbnailUrl': '',
  //     'caption': caption,
  //     'likes': 0,
  //     'likedBy': [],
  //     'comments': 0,
  //     'views': 0,
  //     'createdAt': FieldValue.serverTimestamp(),
  //   });
  // }

  static Future<String> uploadVideo(File file) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/video/upload',
    );

    final request = http.MultipartRequest('POST', uri)
      ..fields['upload_preset'] = AppConstants.cloudinaryUploadPreset
      ..files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();
    final body = await response.stream.bytesToString();
    final json = jsonDecode(body);

    if (response.statusCode == 200) {
      return json['secure_url'] as String;
    } else {
      throw Exception(json['error']['message'] ?? 'Upload failed');
    }
  }

  // create a clip
  static Future<void> createClip({
    required String userId,
    required String displayName,
    required String profileImageUrl,
    required String clubId,
    required String clubName,
    required String clubColor,
    required String clubLeague,
    required String caption,
    required File videoFile,
  }) async {
    final videoUrl = await uploadVideo(videoFile);

    await _db.collection('clips').add({
      'userId': userId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'clubId': clubId,
      'clubName': clubName,
      'clubColor': clubColor,
      'clubLeague': clubLeague,
      'videoUrl': videoUrl,
      'thumbnailUrl': '',
      'caption': caption,
      'likes': 0,
      'likedBy': [],
      'comments': 0,
      'views': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // toggle like
  static Future<void> toggleLike(String clipId, String userId) async {
    final doc = _db.collection('clips').doc(clipId);
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

  // increment view count
  static Future<void> incrementViews(String clipId) async {
    await _db.collection('clips').doc(clipId).update({
      'views': FieldValue.increment(1),
    });
  }

  // delete a clip
  static Future<void> deleteClip(String clipId) async {
    await _db.collection('clips').doc(clipId).delete();
  }
}
