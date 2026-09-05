import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:rivals/core/services/story_service.dart';

class FeedProvider extends ChangeNotifier {
  Future<void> deletePost(String storyId, context) async {
    try {
      notifyListeners();
      SmartDialog.showLoading(msg: 'Deleting post...');

      await StoryService.deleteStory(storyId);
      if (context.mounted) Navigator.pop(context);
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
