import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/features/home/widgets/post_view.dart';

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
            return PostsView(post: post);
          },
        );
      },
    );
  }
}
