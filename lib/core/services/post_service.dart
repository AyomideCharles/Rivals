import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:rivals/core/constants.dart';
import 'package:rivals/core/models/post_model.dart';

class PostService {
  static final _db = FirebaseFirestore.instance;
  static final _picker = ImagePicker();

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
    File? mediaFile,
    bool isVideo = false,
  }) async {
    String mediaUrl = '';
    if (mediaFile != null) {
      mediaUrl = await uploadMedia(mediaFile, isVideo: isVideo);
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

  // Pick image
  static Future<File?> pickImage({bool fromCamera = false}) async {
    final picked = await _picker.pickImage(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      imageQuality: 80,
    );
    return picked != null ? File(picked.path) : null;
  }

  // Pick video — max 30 seconds
  static Future<File?> pickVideo({bool fromCamera = false}) async {
    final picked = await _picker.pickVideo(
      source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    return picked != null ? File(picked.path) : null;
  }

  // Upload to Cloudinary via REST API
  static Future<String> uploadMedia(File file, {bool isVideo = false}) async {
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
}
