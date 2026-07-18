// class MediaPicker {}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPicker {
  static final _picker = ImagePicker();

  // Pick image from gallery
  static Future<File?> pickImage() async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    return picked != null ? File(picked.path) : null;
  }

  // Pick image from camera
  static Future<File?> takePhoto() async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    return picked != null ? File(picked.path) : null;
  }

  // Pick video from gallery — max 30s
  static Future<File?> pickVideo() async {
    final picked = await _picker.pickVideo(
      source: ImageSource.gallery,
      maxDuration: const Duration(seconds: 30),
    );
    return picked != null ? File(picked.path) : null;
  }

  // Record video from camera — max 30s
  static Future<File?> recordVideo() async {
    final picked = await _picker.pickVideo(
      source: ImageSource.camera,
      maxDuration: const Duration(seconds: 30),
    );
    return picked != null ? File(picked.path) : null;
  }

  // Show bottom sheet to choose photo or video source
  static Future<({File? file, bool isVideo})?> showMediaPicker(
    BuildContext context,
  ) async {
    return showModalBottomSheet<({File? file, bool isVideo})>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.image_outlined),
              title: const Text('Photo from gallery'),
              onTap: () async {
                final file = await pickImage();
                if (context.mounted) {
                  Navigator.pop(context, (file: file, isVideo: false));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Video from gallery (max 30s)'),
              onTap: () async {
                final file = await pickVideo();
                if (context.mounted) {
                  Navigator.pop(context, (file: file, isVideo: true));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () async {
                final file = await takePhoto();
                if (context.mounted) {
                  Navigator.pop(context, (file: file, isVideo: false));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record video (max 30s)'),
              onTap: () async {
                final file = await recordVideo();
                if (context.mounted) {
                  Navigator.pop(context, (file: file, isVideo: true));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
