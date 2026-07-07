import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';

class PostTab extends StatelessWidget {
  const PostTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return StreamBuilder<List<PostModel>>(
      stream: PostService.getPostsByUser(auth.user!.uid),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final posts = snapshot.data!;

        if (posts.isEmpty) {
          return const Center(child: Text('No posts yet'));
        }

        return ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final post = posts[index];
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(post.content, style: context.tt.bodyMedium),
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
                            ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Icon(
                        Iconsax.heart,
                        size: 16,
                        color: context.cs.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text('${post.likes}', style: context.tt.bodySmall),
                      const SizedBox(width: 16),
                      Icon(
                        Iconsax.message,
                        size: 16,
                        color: context.cs.onSurface,
                      ),
                      const SizedBox(width: 4),
                      Text('${post.comments}', style: context.tt.bodySmall),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

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
