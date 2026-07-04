// import 'package:flutter/material.dart';
// import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// import 'package:provider/provider.dart';
// import 'package:rivals/core/services/post_service.dart';
// import 'package:rivals/features/auth/provider/auth_provider.dart';
// import 'package:rivals/shared/app_bar.dart';
// import 'package:rivals/shared/app_button.dart';

// class Post extends StatefulWidget {
//   const Post({super.key});

//   @override
//   State<Post> createState() => _PostState();
// }

// class _PostState extends State<Post> {
//   TextEditingController postController = TextEditingController();

//   post() async {
//     final auth = context.read<AuthProvider>();

//     try {
//       SmartDialog.showLoading();
//       await PostService.createPost(
//         userId: auth.user?.uid ?? '',
//         displayName: auth.displayName,
//         clubId: auth.clubId,
//         clubName: auth.clubName,
//         clubColor: auth.clubColor,
//         content: postController.text.trim(),
//       );
//       SmartDialog.dismiss();
//       if (mounted) Navigator.pop(context);
//     } catch (e) {
//       SmartDialog.showToast(e.toString());
//     } finally {
//       SmartDialog.dismiss();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     return Scaffold(
//       appBar: CustomAppBar(
//         title: 'New Post',
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 20),
//             child: AppButton(
//               label: 'Post',
//               onPressed: () async {
//                 await post();
//               },
//               width: 80,
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Divider(height: 16),
//           Padding(
//             padding: EdgeInsets.all(20.0),
//             child: Column(
//               children: [
//                 Row(
//                   children: [
//                     CircleAvatar(radius: 30),
//                     SizedBox(width: 16),
//                     Column(children: [Text(auth.displayName)]),
//                   ],
//                 ),
//                 SizedBox(height: 40),
//                 TextField(
//                   controller: postController,
//                   decoration: InputDecoration(
//                     hintText: 'What\'s on your mind?',
//                     border: InputBorder.none,
//                   ),
//                   maxLines: null,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
// // import 'package:provider/provider.dart';
// // import 'package:rivals/core/services/post_service.dart';
// // import 'package:rivals/features/auth/provider/auth_provider.dart';
// // import 'package:rivals/shared/app_bar.dart';
// // import 'package:rivals/shared/app_button.dart';

// // class Post extends StatefulWidget {
// //   const Post({super.key});

// //   @override
// //   State<Post> createState() => _PostState();
// // }

// // class _PostState extends State<Post> {
// //   final TextEditingController _postController = TextEditingController();
// //   File? _selectedMedia;
// //   bool _isVideo = false;

// //   @override
// //   void dispose() {
// //     _postController.dispose();
// //     super.dispose();
// //   }

// //   Future<void> _pickImage({bool fromCamera = false}) async {
// //     final file = await PostService.pickImage(fromCamera: fromCamera);
// //     if (file != null)
// //       setState(() {
// //         _selectedMedia = file;
// //         _isVideo = false;
// //       });
// //   }

// //   Future<void> _pickVideo({bool fromCamera = false}) async {
// //     final file = await PostService.pickVideo(fromCamera: fromCamera);
// //     if (file != null)
// //       setState(() {
// //         _selectedMedia = file;
// //         _isVideo = true;
// //       });
// //   }

// //   void _showCameraOptions() {
// //     showModalBottomSheet(
// //       context: context,
// //       builder: (_) => SafeArea(
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           children: [
// //             ListTile(
// //               leading: const Icon(Icons.camera_alt_outlined),
// //               title: const Text('Take photo'),
// //               onTap: () {
// //                 Navigator.pop(context);
// //                 _pickImage(fromCamera: true);
// //               },
// //             ),
// //             ListTile(
// //               leading: const Icon(Icons.videocam_outlined),
// //               title: const Text('Record video (max 30s)'),
// //               onTap: () {
// //                 Navigator.pop(context);
// //                 _pickVideo(fromCamera: true);
// //               },
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }

// //   Future<void> _post() async {
// //     final auth = context.read<AuthProvider>();
// //     final content = _postController.text.trim();

// //     if (content.isEmpty && _selectedMedia == null) {
// //       SmartDialog.showToast('Add some text or a photo/video');
// //       return;
// //     }

// //     try {
// //       SmartDialog.showLoading(msg: 'Posting...');
// //       await PostService.createPost(
// //         userId: auth.user?.uid ?? '',
// //         displayName: auth.displayName,
// //         clubId: auth.clubId,
// //         clubName: auth.clubName,
// //         clubColor: auth.clubColor,
// //         content: content,
// //         mediaFile: _selectedMedia,
// //         isVideo: _isVideo,
// //       );
// //       SmartDialog.dismiss();
// //       if (mounted) Navigator.pop(context);
// //     } catch (e) {
// //       SmartDialog.dismiss();
// //       SmartDialog.showToast(e.toString());
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     final auth = context.watch<AuthProvider>();

// //     return Scaffold(
// //       appBar: CustomAppBar(
// //         title: 'New Post',
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 20),
// //             child: AppButton(label: 'Post', onPressed: _post, width: 80),
// //           ),
// //         ],
// //       ),
// //       body: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           const Divider(height: 16),
// //           Expanded(
// //             child: SingleChildScrollView(
// //               padding: const EdgeInsets.all(20),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Row(
// //                     children: [
// //                       const CircleAvatar(radius: 20),
// //                       const SizedBox(width: 12),
// //                       Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text(auth.displayName),
// //                           Text(
// //                             auth.clubName,
// //                             style: const TextStyle(
// //                               fontSize: 12,
// //                               color: Colors.grey,
// //                             ),
// //                           ),
// //                         ],
// //                       ),
// //                     ],
// //                   ),
// //                   const SizedBox(height: 16),
// //                   TextField(
// //                     controller: _postController,
// //                     autofocus: true,
// //                     decoration: const InputDecoration(
// //                       hintText: "What's on your mind?",
// //                       border: InputBorder.none,
// //                     ),
// //                     maxLines: null,
// //                     maxLength: 280,
// //                   ),

// //                   // media preview
// //                   if (_selectedMedia != null) ...[
// //                     const SizedBox(height: 12),
// //                     Stack(
// //                       children: [
// //                         ClipRRect(
// //                           borderRadius: BorderRadius.circular(12),
// //                           child: _isVideo
// //                               ? Container(
// //                                   height: 200,
// //                                   width: double.infinity,
// //                                   color: Colors.black,
// //                                   child: const Center(
// //                                     child: Icon(
// //                                       Icons.play_circle_outline,
// //                                       color: Colors.white,
// //                                       size: 48,
// //                                     ),
// //                                   ),
// //                                 )
// //                               : Image.file(
// //                                   _selectedMedia!,
// //                                   width: double.infinity,
// //                                   height: 200,
// //                                   fit: BoxFit.cover,
// //                                 ),
// //                         ),
// //                         // remove button
// //                         Positioned(
// //                           top: 8,
// //                           right: 8,
// //                           child: GestureDetector(
// //                             onTap: () => setState(() => _selectedMedia = null),
// //                             child: Container(
// //                               padding: const EdgeInsets.all(4),
// //                               decoration: const BoxDecoration(
// //                                 color: Colors.black54,
// //                                 shape: BoxShape.circle,
// //                               ),
// //                               child: const Icon(
// //                                 Icons.close,
// //                                 color: Colors.white,
// //                                 size: 16,
// //                               ),
// //                             ),
// //                           ),
// //                         ),
// //                         if (_isVideo)
// //                           const Positioned(
// //                             bottom: 8,
// //                             left: 8,
// //                             child: Text(
// //                               'Max 30s',
// //                               style: TextStyle(
// //                                 color: Colors.white70,
// //                                 fontSize: 11,
// //                               ),
// //                             ),
// //                           ),
// //                       ],
// //                     ),
// //                   ],
// //                 ],
// //               ),
// //             ),
// //           ),

// //           // bottom toolbar
// //           const Divider(height: 1),
// //           Padding(
// //             padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
// //             child: Row(
// //               children: [
// //                 IconButton(
// //                   onPressed: () => _pickImage(),
// //                   icon: const Icon(Icons.image_outlined),
// //                   tooltip: 'Photo from gallery',
// //                 ),
// //                 IconButton(
// //                   onPressed: () => _pickVideo(),
// //                   icon: const Icon(Icons.videocam_outlined),
// //                   tooltip: 'Video from gallery',
// //                 ),
// //                 IconButton(
// //                   onPressed: _showCameraOptions,
// //                   icon: const Icon(Icons.camera_alt_outlined),
// //                   tooltip: 'Camera',
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  final TextEditingController _postController = TextEditingController();
  File? _selectedMedia;
  bool _isVideo = false;

  @override
  void dispose() {
    _postController.dispose();
    super.dispose();
  }

  Future<void> _pickImage({bool fromCamera = false}) async {
    final file = await PostService.pickImage(fromCamera: fromCamera);
    if (file != null)
      setState(() {
        _selectedMedia = file;
        _isVideo = false;
      });
  }

  Future<void> _pickVideo({bool fromCamera = false}) async {
    final file = await PostService.pickVideo(fromCamera: fromCamera);
    if (file != null)
      setState(() {
        _selectedMedia = file;
        _isVideo = true;
      });
  }

  void _showCameraOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Take photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(fromCamera: true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.videocam_outlined),
              title: const Text('Record video (max 30s)'),
              onTap: () {
                Navigator.pop(context);
                _pickVideo(fromCamera: true);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _post() async {
    final auth = context.read<AuthProvider>();
    final content = _postController.text.trim();

    if (content.isEmpty && _selectedMedia == null) {
      SmartDialog.showToast('Add some text or a photo/video');
      return;
    }

    try {
      SmartDialog.showLoading(
        msg: _selectedMedia != null ? 'Uploading media...' : 'Posting...',
      );

      await PostService.createPost(
        userId: auth.user?.uid ?? '',
        displayName: auth.displayName,
        clubId: auth.clubId,
        clubName: auth.clubName,
        clubColor: auth.clubColor,
        content: content,
        mediaFile: _selectedMedia,
        isVideo: _isVideo,
      );

      SmartDialog.dismiss();
      if (mounted) Navigator.pop(context);
    } catch (e) {
      print(e.toString());
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'New Post',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AppButton(label: 'Post', onPressed: _post, width: 80),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(height: 16),

          // content area
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // user info
                  Row(
                    children: [
                      const CircleAvatar(radius: 20),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(auth.displayName, style: context.tt.labelMedium),
                          Text(
                            auth.clubName,
                            style: context.tt.bodySmall?.copyWith(
                              color: context.cs.onSurface.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // text field
                  TextField(
                    controller: _postController,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: "What's on your mind?",
                      border: InputBorder.none,
                    ),
                    maxLines: null,
                    maxLength: 280,
                  ),

                  // media preview
                  if (_selectedMedia != null) ...[
                    const SizedBox(height: 12),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: _isVideo
                              ? Container(
                                  height: 200,
                                  width: double.infinity,
                                  color: Colors.black,
                                  child: const Center(
                                    child: Icon(
                                      Icons.play_circle_outline,
                                      color: Colors.white,
                                      size: 48,
                                    ),
                                  ),
                                )
                              : Image.file(
                                  _selectedMedia!,
                                  width: double.infinity,
                                  height: 200,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        // remove button
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedMedia = null),
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.black54,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                        if (_isVideo)
                          const Positioned(
                            bottom: 8,
                            left: 8,
                            child: Text(
                              'Max 30s',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 11,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),

          // bottom toolbar
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _pickImage(),
                    icon: const Icon(Icons.image_outlined),
                    tooltip: 'Photo from gallery',
                  ),
                  IconButton(
                    onPressed: () => _pickVideo(),
                    icon: const Icon(Icons.videocam_outlined),
                    tooltip: 'Video from gallery',
                  ),
                  IconButton(
                    onPressed: _showCameraOptions,
                    icon: const Icon(Icons.camera_alt_outlined),
                    tooltip: 'Camera',
                  ),
                  const Spacer(),
                  // character count
                  ValueListenableBuilder(
                    valueListenable: _postController,
                    builder: (context, value, _) => Text(
                      '${280 - value.text.length}',
                      style: context.tt.bodySmall?.copyWith(
                        color: value.text.length > 260
                            ? Colors.red
                            : context.cs.onSurface.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
