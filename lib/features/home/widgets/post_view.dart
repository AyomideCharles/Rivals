// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:rivals/core/models/post_model.dart';
// import 'package:rivals/core/services/auth_service.dart';
// import 'package:rivals/core/theme/app_theme.dart';
// import 'package:rivals/features/home/widgets/users_profile.dart';
// import 'package:rivals/features/post/provider/post_provider.dart';
// import 'package:rivals/shared/app_video_player.dart';

// class PostsView extends StatelessWidget {
//   final PostModel post;
//   const PostsView({super.key, required this.post});

//   @override
//   Widget build(BuildContext context) {
//     final postProvider = context.read<PostProvider>();

//     return Padding(
//       padding: const EdgeInsets.all(20),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           GestureDetector(
//             onTap: () {
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => UsersProfile(
//                     userId: post.userId,
//                     displayName: post.displayName,
//                     clubName: post.clubName,
//                     clubLeague: post.clubName,
//                     profileImageUrl: post.profileImageUrl,
//                   ),
//                 ),
//               );
//             },
//             child: post.profileImageUrl.isEmpty
//                 ? Container(
//                     width: 45,
//                     height: 45,
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       border: Border.all(color: context.cs.outline, width: 1),
//                       color: context.cs.surface,
//                     ),
//                     child: Icon(Iconsax.user),
//                   )
//                 : ClipRRect(
//                     borderRadius: BorderRadius.circular(40),
//                     child: Image.network(
//                       post.profileImageUrl,
//                       width: 45,
//                       height: 45,
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//           ),
//           const SizedBox(width: 10),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           '@${post.displayName}',
//                           style: context.tt.titleMedium,
//                         ),
//                         Text(post.clubName, style: context.tt.bodySmall),
//                       ],
//                     ),
//                     PopupMenuButton<String>(
//                       icon: const Icon(Icons.more_vert),
//                       onSelected: (value) {
//                         switch (value) {
//                           case 'report':
//                             // handle report
//                             break;
//                           case 'delete':
//                             // deletePost();
//                             postProvider.deletePost(post.id);
//                             break;
//                           case 'copy':
//                             // handle copy
//                             break;
//                         }
//                       },
//                       itemBuilder: (context) => [
//                         const PopupMenuItem(
//                           value: 'copy',
//                           child: Row(
//                             children: [
//                               Icon(Iconsax.copy, size: 18),
//                               SizedBox(width: 10),
//                               Text('Copy text'),
//                             ],
//                           ),
//                         ),
//                         const PopupMenuItem(
//                           value: 'report',
//                           child: Row(
//                             children: [
//                               Icon(Iconsax.flag_2, size: 18),
//                               SizedBox(width: 10),
//                               Text('Report'),
//                             ],
//                           ),
//                         ),
//                         if (post.userId ==
//                             context.read<AuthProvider>().user?.uid)
//                           const PopupMenuItem(
//                             value: 'delete',
//                             child: Row(
//                               children: [
//                                 Icon(
//                                   Iconsax.trash,
//                                   size: 18,
//                                   color: Colors.red,
//                                 ),
//                                 SizedBox(width: 10),
//                                 Text(
//                                   'Delete',
//                                   style: TextStyle(color: Colors.red),
//                                 ),
//                               ],
//                             ),
//                           ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 8),
//                 if (post.content.isNotEmpty)
//                   Text(post.content, style: context.tt.titleMedium),

//                 if (post.hasMedia) ...[
//                   const SizedBox(height: 10),
//                   ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: post.isVideo
//                         ? AppVideoPlayer(url: post.mediaUrl)
//                         : Image.network(
//                             post.mediaUrl,
//                             width: double.infinity,
//                             height: 200,
//                             fit: BoxFit.cover,
//                             loadingBuilder: (_, child, progress) =>
//                                 progress == null
//                                 ? child
//                                 : const SizedBox(
//                                     height: 200,
//                                     child: Center(
//                                       child: CircularProgressIndicator(),
//                                     ),
//                                   ),
//                             errorBuilder: (_, __, ___) => const SizedBox(
//                               height: 200,
//                               child: Center(child: Icon(Icons.broken_image)),
//                             ),
//                           ),
//                   ),
//                 ],

//                 const SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Icon(Icons.thumb_up_alt_outlined, size: 16),
//                     const SizedBox(width: 4),
//                     Text('${post.likes}', style: context.tt.bodySmall),
//                     const SizedBox(width: 16),
//                     Icon(Iconsax.message, size: 16),
//                     const SizedBox(width: 4),
//                     Text('${post.comments}', style: context.tt.bodySmall),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/home/widgets/users_profile.dart';
import 'package:rivals/features/post/provider/post_provider.dart';
import 'package:rivals/shared/app_video_player.dart';

class PostsView extends StatelessWidget {
  final PostModel post;
  const PostsView({super.key, required this.post});

  bool get _isImagePost => post.hasMedia && !post.isVideo;

  @override
  Widget build(BuildContext context) {
    if (_isImagePost) {
      return _ImageBackgroundPost(post: post);
    }
    return _StandardPost(post: post);
  }
}

class _Avatar extends StatelessWidget {
  final PostModel post;
  final Color? borderColor;
  const _Avatar({required this.post, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UsersProfile(
              userId: post.userId,
              displayName: post.displayName,
              clubName: post.clubName,
              clubLeague: post.clubName,
              profileImageUrl: post.profileImageUrl,
            ),
          ),
        );
      },
      child: post.profileImageUrl.isEmpty
          ? Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: borderColor ?? context.cs.outline,
                  width: 1,
                ),
                color: context.cs.surface,
              ),
              child: const Icon(Iconsax.user),
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Image.network(
                post.profileImageUrl,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
            ),
    );
  }
}

class _PostMenu extends StatelessWidget {
  final PostModel post;
  final Color? iconColor;
  const _PostMenu({required this.post, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.read<PostProvider>();
    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert, color: iconColor),
      onSelected: (value) {
        switch (value) {
          case 'report':
            break;
          case 'delete':
            postProvider.deletePost(post.id);
            break;
          case 'copy':
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Iconsax.copy, size: 18),
              SizedBox(width: 10),
              Text('Copy text'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'report',
          child: Row(
            children: [
              Icon(Iconsax.flag_2, size: 18),
              SizedBox(width: 10),
              Text('Report'),
            ],
          ),
        ),
        if (post.userId == context.read<AuthProvider>().user?.uid)
          const PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Iconsax.trash, size: 18, color: Colors.red),
                SizedBox(width: 10),
                Text('Delete', style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final PostModel post;
  final Color? color;
  const _ActionsRow({required this.post, this.color});

  @override
  Widget build(BuildContext context) {
    final textStyle = context.tt.bodySmall?.copyWith(color: color);
    final iconColor = color ?? context.cs.onSurface;
    return Row(
      children: [
        Icon(Icons.thumb_up_alt_outlined, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text('${post.likes}', style: textStyle),
        const SizedBox(width: 16),
        Icon(Iconsax.message, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text('${post.comments}', style: textStyle),
      ],
    );
  }
}

class _StandardPost extends StatelessWidget {
  final PostModel post;
  const _StandardPost({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(post: post),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@${post.displayName}',
                          style: context.tt.titleMedium,
                        ),
                        Text(post.clubName, style: context.tt.bodySmall),
                      ],
                    ),
                    _PostMenu(post: post),
                  ],
                ),
                const SizedBox(height: 8),
                if (post.content.isNotEmpty)
                  Text(post.content, style: context.tt.titleMedium),

                if (post.hasMedia && post.isVideo) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppVideoPlayer(url: post.mediaUrl),
                  ),
                ],

                const SizedBox(height: 10),
                _ActionsRow(post: post),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBackgroundPost extends StatelessWidget {
  final PostModel post;
  const _ImageBackgroundPost({required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 330,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // background image
              Image.network(
                post.mediaUrl,
                fit: BoxFit.cover,
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : Container(
                        color: context.cs.surface,
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                errorBuilder: (_, __, ___) => Container(
                  color: context.cs.surface,
                  child: const Center(child: Icon(Icons.broken_image)),
                ),
              ),

              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0x99000000),
                      Colors.transparent,
                      Colors.transparent,
                      Color(0xCC000000),
                    ],
                    stops: [0.0, 0.25, 0.6, 1.0],
                  ),
                ),
              ),

              Positioned(
                top: 14,
                left: 14,
                right: 8,
                child: Row(
                  children: [
                    _Avatar(post: post, borderColor: Colors.white70),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '@${post.displayName}',
                            style: context.tt.titleMedium?.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            post.clubName,
                            style: context.tt.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _PostMenu(post: post, iconColor: Colors.white),
                  ],
                ),
              ),

              Positioned(
                left: 14,
                right: 14,
                bottom: 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (post.content.isNotEmpty) ...[
                      Text(
                        post.content,
                        style: context.tt.titleMedium?.copyWith(
                          color: Colors.white,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                    ],
                    _ActionsRow(post: post, color: Colors.white),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
