import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/clips_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:video_player/video_player.dart';

class UploadClip extends StatefulWidget {
  const UploadClip({super.key});

  @override
  State<UploadClip> createState() => _UploadClipState();
}

class _UploadClipState extends State<UploadClip> {
  final TextEditingController _captionController = TextEditingController();
  File? _selectedVideo;
  VideoPlayerController? _previewController;
  bool _initialized = false;

  @override
  void dispose() {
    _captionController.dispose();
    _previewController?.dispose();
    super.dispose();
  }

  Future<void> _pickVideo() async {
    final picker = ImagePicker();
    final picked = await picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(minutes: 3), // 👈 max 3 mins
    );

    if (picked != null) {
      final file = File(picked.path);
      setState(() {
        _selectedVideo = file;
        _initialized = false;
      });

      // preview
      _previewController = VideoPlayerController.file(file)
        ..initialize().then((_) {
          if (mounted) setState(() => _initialized = true);
        });
    }
  }

  Future<void> _upload() async {
    if (_selectedVideo == null) {
      SmartDialog.showToast('Pick a video first');
      return;
    }

    final auth = context.read<AuthProvider>();
    final caption = _captionController.text.trim();

    if (caption.split(' ').length > 100) {
      SmartDialog.showToast('Caption must be 100 words or less');
      return;
    }

    try {
      SmartDialog.showLoading(msg: 'Uploading clip...');

      await ClipsService.createClip(
        userId: auth.user!.uid,
        displayName: auth.displayName,
        profileImageUrl: auth.profileImageUrl,
        clubId: auth.clubId,
        clubName: auth.clubName,
        clubColor: auth.clubColor,
        clubLeague: auth.clubLeague,
        caption: caption,
        videoFile: _selectedVideo!,
      );

      SmartDialog.dismiss();
      SmartDialog.showToast('Clip uploaded!');
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'New Clip',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AppButton(label: 'Upload', onPressed: _upload, width: 80),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // video picker
            GestureDetector(
              onTap: _pickVideo,
              child: Container(
                height: 300,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: context.cs.outline),
                ),
                child: _selectedVideo == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.videocam_outlined,
                            size: 48,
                            color: context.cs.onSurface.withOpacity(0.4),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Tap to pick a video',
                            style: context.tt.bodyMedium?.copyWith(
                              color: context.cs.onSurface.withOpacity(0.5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Max 3 minutes',
                            style: context.tt.bodySmall?.copyWith(
                              color: context.cs.onSurface.withOpacity(0.3),
                            ),
                          ),
                        ],
                      )
                    : _initialized && _previewController != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: GestureDetector(
                          onTap: () => setState(() {
                            _previewController!.value.isPlaying
                                ? _previewController!.pause()
                                : _previewController!.play();
                          }),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              AspectRatio(
                                aspectRatio:
                                    _previewController!.value.aspectRatio,
                                child: VideoPlayer(_previewController!),
                              ),
                              if (!_previewController!.value.isPlaying)
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: const BoxDecoration(
                                    color: Colors.black45,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ),
            ),

            const SizedBox(height: 20),

            // caption
            Text('Caption', style: context.tt.labelMedium),
            const SizedBox(height: 8),
            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                hintText: 'Add a caption (max 100 words)...',
              ),
              maxLines: 3,
              maxLength: 500,
            ),
          ],
        ),
      ),
    );
  }
}
