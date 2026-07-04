import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.notification),
          ),
          const SizedBox(width: 15),
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.search_favorite_1),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(height: 16),
          Expanded(
            child: StreamBuilder<List<PostModel>>(
              stream: PostService.getAllPosts(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return const Center(
                    child: Text('No posts yet. Be the first!'),
                  );
                }
                return ListView.separated(
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  padding: EdgeInsets.zero,
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(radius: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '@${post.displayName}',
                                  style: context.tt.titleMedium,
                                ),
                                Text(
                                  post.clubName,
                                  style: context.tt.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                if (post.content.isNotEmpty)
                                  Text(
                                    post.content,
                                    style: context.tt.titleMedium,
                                  ),

                                // media
                                if (post.hasMedia) ...[
                                  const SizedBox(height: 10),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: post.isVideo
                                        ? _VideoThumbnail(url: post.mediaUrl)
                                        : Image.network(
                                            post.mediaUrl,
                                            width: double.infinity,
                                            height: 200,
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (
                                                  _,
                                                  child,
                                                  progress,
                                                ) => progress == null
                                                ? child
                                                : const SizedBox(
                                                    height: 200,
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(),
                                                    ),
                                                  ),
                                            errorBuilder: (_, __, ___) =>
                                                const SizedBox(
                                                  height: 200,
                                                  child: Center(
                                                    child: Icon(
                                                      Icons.broken_image,
                                                    ),
                                                  ),
                                                ),
                                          ),
                                  ),
                                ],

                                const SizedBox(height: 10),
                                // actions
                                Row(
                                  children: [
                                    Icon(Iconsax.heart, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.likes}',
                                      style: context.tt.bodySmall,
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(Iconsax.message, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${post.comments}',
                                      style: context.tt.bodySmall,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// simple video placeholder — tap to play
class _VideoThumbnail extends StatelessWidget {
  final String url;
  const _VideoThumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 56),
        ),
      ),
    );
  }
}
