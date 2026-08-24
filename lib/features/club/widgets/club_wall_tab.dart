import 'package:flutter/material.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/home/widgets/post_view.dart';

class ClubWallTab extends StatelessWidget {
  final ClubModel club;
  const ClubWallTab({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<PostModel>>(
      stream: PostService.getPostsByClub(club.shortName),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = snapshot.data!;
        if (posts.isEmpty) {
          return Center(
            child: Text(
              'No posts from ${club.nickname} yet',
              style: context.tt.bodyMedium?.copyWith(
                color: context.cs.onSurface.withOpacity(0.5),
              ),
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: posts.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) => PostsView(post: posts[index]),
        );
      },
    );
  }
}
