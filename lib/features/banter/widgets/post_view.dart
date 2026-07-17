import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/banter/widgets/users_profile.dart';
import 'package:rivals/shared/app_video_player.dart';

class PostsView extends StatelessWidget {
  final PostModel post;
  const PostsView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UsersProfile(
                    userId: post.userId,
                    displayName: post.displayName,
                    clubName: post.clubName,
                    clubLeague: post.clubName,
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
                      border: Border.all(color: context.cs.outline, width: 1),
                      color: context.cs.surface,
                    ),
                    child: Icon(Iconsax.user),
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
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('@${post.displayName}', style: context.tt.titleMedium),
                Text(post.clubName, style: context.tt.bodySmall),
                const SizedBox(height: 8),
                if (post.content.isNotEmpty)
                  Text(post.content, style: context.tt.titleMedium),

                // media
                if (post.hasMedia) ...[
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: post.isVideo
                        ? AppVideoPlayer(url: post.mediaUrl)
                        : Image.network(
                            post.mediaUrl,
                            width: double.infinity,
                            height: 200,
                            fit: BoxFit.cover,
                            loadingBuilder: (_, child, progress) =>
                                progress == null
                                ? child
                                : const SizedBox(
                                    height: 200,
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  ),
                            errorBuilder: (_, __, ___) => const SizedBox(
                              height: 200,
                              child: Center(child: Icon(Icons.broken_image)),
                            ),
                          ),
                  ),
                ],

                const SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: context.tt.bodySmall),
                    const SizedBox(width: 16),
                    Icon(Iconsax.message, size: 16),
                    const SizedBox(width: 4),
                    Text('${post.comments}', style: context.tt.bodySmall),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
