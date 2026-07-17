import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/banter/widgets/add_to_story.dart';
import 'package:rivals/features/banter/widgets/post_view.dart';
import 'package:rivals/features/banter/widgets/story_view.dart';
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
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Divider(height: 5)),
          SliverToBoxAdapter(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: IntrinsicHeight(
                child: Row(
                  children: List.generate(21, (index) {
                    if (index == 0) {
                      return StoryView(
                        isAddStory: true,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddToStory(),
                            ),
                          );
                        },
                      );
                    }
                    return const StoryView();
                  }),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: Divider(height: 5)),
          StreamBuilder<List<PostModel>>(
            stream: PostService.getAllPosts(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              final posts = snapshot.data!;
              if (posts.isEmpty) {
                return const SliverFillRemaining(
                  child: Center(child: Text('No posts yet. Be the first!')),
                );
              }
              return SliverList.separated(
                itemCount: posts.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) => PostsView(post: posts[index]),
              );
            },
          ),
        ],
      ),
    );
  }
}
