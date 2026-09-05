import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:rivals/core/constants/constants.dart';
import 'package:rivals/core/models/story_model.dart';

class StoryService {
  static final _db = FirebaseFirestore.instance;

  // get all active stories grouped by user
  static Stream<Map<String, List<StoryModel>>> getStories() {
    return _db
        .collection('stories')
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .orderBy('expiresAt')
        .snapshots()
        .map((snap) {
          final Map<String, List<StoryModel>> grouped = {};
          for (final doc in snap.docs) {
            final story = StoryModel.fromDoc(doc);
            grouped.putIfAbsent(story.userId, () => []).add(story);
          }
          return grouped;
        });
  }

  // upload media to Cloudinary
  static Future<String> _uploadMedia(File file, {bool isVideo = false}) async {
    final resourceType = isVideo ? 'video' : 'image';
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/${AppConstants.cloudinaryCloudName}/$resourceType/upload',
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

  // create a story
  static Future<void> createStory({
    required String userId,
    required String displayName,
    required String profileImageUrl,
    required String clubId,
    required String clubName,
    required File mediaFile,
    bool isVideo = false,
  }) async {
    final mediaUrl = await _uploadMedia(mediaFile, isVideo: isVideo);

    await _db.collection('stories').add({
      'userId': userId,
      'displayName': displayName,
      'profileImageUrl': profileImageUrl,
      'clubId': clubId,
      'clubName': clubName,
      'mediaUrl': mediaUrl,
      'isVideo': isVideo,
      'viewedBy': [],
      'createdAt': FieldValue.serverTimestamp(),
      'expiresAt': Timestamp.fromDate(
        DateTime.now().add(const Duration(hours: 24)),
      ),
    });
  }

  // mark story as viewed
  static Future<void> markViewed(String storyId, String userId) async {
    await _db.collection('stories').doc(storyId).update({
      'viewedBy': FieldValue.arrayUnion([userId]),
    });
  }

  // delete a story
  static Future<void> deleteStory(String storyId) async {
    try {
      await _db.collection('stories').doc(storyId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // check if current user has an active story
  static Stream<bool> hasActiveStory(String userId) {
    return _db
        .collection('stories')
        .where('userId', isEqualTo: userId)
        .where('expiresAt', isGreaterThan: Timestamp.now())
        .snapshots()
        .map((snap) => snap.docs.isNotEmpty);
  }
}
