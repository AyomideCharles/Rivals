import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/models/story_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/services/story_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/home/widgets/add_to_story.dart';
import 'package:rivals/features/home/widgets/post_view.dart';
import 'package:rivals/features/home/widgets/story_view.dart';
import 'package:rivals/features/home/widgets/story_viewer.dart';
import 'package:rivals/shared/app_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Iconsax.notification),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          const SliverToBoxAdapter(child: Divider(height: 5)),
          SliverToBoxAdapter(
            child: StreamBuilder<Map<String, List<StoryModel>>>(
              stream: StoryService.getStories(),
              builder: (context, snapshot) {
                final grouped = snapshot.data ?? {};
                final userIds = grouped.keys.toList();

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      // add story button
                      // StoryView(
                      //   isAddStory: true,
                      //   profileImageUrl: auth.profileImageUrl,
                      //   onTap: () => Navigator.push(
                      //     context,
                      //     MaterialPageRoute(builder: (_) => const AddToStory()),
                      //   ),
                      // ),
                      // In Homepage story bar
                      StreamBuilder<bool>(
                        stream: StoryService.hasActiveStory(auth.user!.uid),
                        builder: (context, snapshot) {
                          final hasStory = snapshot.data ?? false;

                          return StoryView(
                            isAddStory: !hasStory, 
                            profileImageUrl: auth.profileImageUrl,
                            hasUnviewed: false,
                            onTap: () {
                              if (hasStory) {
                                // view your own story
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoryViewer(
                                      stories: grouped[auth.user!.uid] ?? [],
                                      currentUserId: auth.user!.uid,
                                    ),
                                  ),
                                );
                              } else {
                                // add new story
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const AddToStory(),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      ),

                      // other users stories
                      ...userIds.where((id) => id != auth.user?.uid).map((
                        userId,
                      ) {
                        final stories = grouped[userId] ?? [];
                        if (stories.isEmpty) return const SizedBox.shrink();

                        final firstStory = stories.first;
                        final currentUid = auth.user?.uid ?? '';
                        final hasUnviewed = stories.any(
                          (s) => !s.viewedBy.contains(currentUid),
                        );

                        return StoryView(
                          profileImageUrl: firstStory.profileImageUrl,
                          displayName: firstStory.displayName,
                          stories: stories,
                          hasUnviewed: hasUnviewed,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StoryViewer(
                                stories: stories,
                                currentUserId: auth.user!.uid,
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
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
