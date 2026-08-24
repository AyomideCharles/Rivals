import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/story_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/core/utils/media_picker.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';

class AddToStory extends StatefulWidget {
  const AddToStory({super.key});

  @override
  State<AddToStory> createState() => _AddToStoryState();
}

class _AddToStoryState extends State<AddToStory> {
  File? _selectedMedia;
  bool _isVideo = false;

  Future<void> _pickMedia() async {
    final result = await MediaPicker.showMediaPicker(context);
    if (result != null && result.file != null) {
      setState(() {
        _selectedMedia = result.file;
        _isVideo = result.isVideo;
      });
    }
  }

  Future<void> _upload() async {
    if (_selectedMedia == null) {
      SmartDialog.showToast('Pick a photo or video first');
      return;
    }

    final auth = context.read<AuthProvider>();

    try {
      SmartDialog.showLoading(msg: 'Uploading story...');
      await StoryService.createStory(
        userId: auth.user!.uid,
        displayName: auth.displayName,
        profileImageUrl: auth.profileImageUrl,
        clubId: auth.clubId,
        clubName: auth.clubName,
        mediaFile: _selectedMedia!,
        isVideo: _isVideo,
      );
      SmartDialog.dismiss();
      SmartDialog.showToast('Story posted!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add to Story',
        actions: [
          if (_selectedMedia != null)
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: AppButton(label: 'Share', onPressed: _upload, width: 80),
            ),
        ],
      ),
      body: _selectedMedia == null
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 72,
                    color: context.cs.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add a photo or video to your story',
                    style: context.tt.bodyMedium?.copyWith(
                      color: context.cs.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    label: 'Pick Media',
                    onPressed: _pickMedia,
                    width: 160,
                  ),
                ],
              ),
            )
          : Stack(
              fit: StackFit.expand,
              children: [
                _isVideo
                    ? const Center(
                        child: Icon(
                          Icons.play_circle_outline,
                          size: 72,
                          color: Colors.white,
                        ),
                      )
                    : Image.file(_selectedMedia!, fit: BoxFit.cover),

                Positioned(
                  top: 16,
                  left: 16,
                  child: GestureDetector(
                    onTap: _pickMedia,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.swap_horiz, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
