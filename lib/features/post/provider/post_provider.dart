import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rivals/core/services/post_service.dart';

class PostProvider extends ChangeNotifier {
  Future<void> createPost({
    required String userId,
    required String displayName,
    required String clubId,
    required String clubName,
    required String clubColor,
    required String content,
    required String profileImageUrl,
    File? mediaFile,
    bool isVideo = false,
  }) async {
    try {
      notifyListeners();
      SmartDialog.showLoading(
        msg: mediaFile != null ? 'Uploading media...' : 'Posting...',
      );

      await PostService.createPost(
        userId: userId,
        displayName: displayName,
        clubId: clubId,
        clubName: clubName,
        clubColor: clubColor,
        content: content,
        profileImageUrl: profileImageUrl,
        mediaFile: mediaFile,
        isVideo: isVideo,
      );

      SmartDialog.dismiss();
      SmartDialog.showToast('Posted!');
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    } finally {
      notifyListeners();
    }
  }

  Future<void> deletePost(String postId) async {
    try {
      notifyListeners();
      SmartDialog.showLoading(msg: 'Deleting post...');

      await PostService.deletePost(postId);

      SmartDialog.dismiss();
      SmartDialog.showToast('Post deleted');
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
      notifyListeners();
    }
  }
}
