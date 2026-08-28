// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:provider/provider.dart';
// import 'package:rivals/core/models/post_model.dart';
// import 'package:rivals/core/models/story_model.dart';
// import 'package:rivals/core/services/auth_service.dart';
// import 'package:rivals/core/services/post_service.dart';
// import 'package:rivals/core/services/story_service.dart';
// import 'package:rivals/core/theme/app_theme.dart';
// import 'package:rivals/features/home/widgets/add_to_story.dart';
// import 'package:rivals/features/home/widgets/post_view.dart';
// import 'package:rivals/features/home/widgets/story_view.dart';
// import 'package:rivals/features/home/widgets/story_viewer.dart';
// import 'package:rivals/shared/app_bar.dart';

// class Homepage extends StatelessWidget {
//   const Homepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final auth = context.watch<AuthProvider>();

//     return Scaffold(
//       appBar: CustomAppBar(
//         backButton: false,
//         showLogo: true,
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 20),
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               border: Border.all(color: context.cs.outline, width: 1),
//               color: context.cs.surface,
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(Iconsax.notification),
//           ),
//         ],
//       ),
//       body: CustomScrollView(
//         slivers: [
//           const SliverToBoxAdapter(child: Divider(height: 5)),
//           SliverToBoxAdapter(
//             child: StreamBuilder<Map<String, List<StoryModel>>>(
//               stream: StoryService.getStories(),
//               builder: (context, snapshot) {
//                 final grouped = snapshot.data ?? {};
//                 final userIds = grouped.keys.toList();

//                 return SingleChildScrollView(
//                   scrollDirection: Axis.horizontal,
//                   child: Row(
//                     children: [
//                       // add story button
//                       // StoryView(
//                       //   isAddStory: true,
//                       //   profileImageUrl: auth.profileImageUrl,
//                       //   onTap: () => Navigator.push(
//                       //     context,
//                       //     MaterialPageRoute(builder: (_) => const AddToStory()),
//                       //   ),
//                       // ),
//                       // In Homepage story bar
//                       StreamBuilder<bool>(
//                         stream: StoryService.hasActiveStory(auth.user!.uid),
//                         builder: (context, snapshot) {
//                           final hasStory = snapshot.data ?? false;

//                           return StoryView(
//                             isAddStory: !hasStory,
//                             profileImageUrl: auth.profileImageUrl,
//                             hasUnviewed: false,
//                             onTap: () {
//                               if (hasStory) {
//                                 // view your own story
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => StoryViewer(
//                                       stories: grouped[auth.user!.uid] ?? [],
//                                       currentUserId: auth.user!.uid,
//                                     ),
//                                   ),
//                                 );
//                               } else {
//                                 // add new story
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (_) => const AddToStory(),
//                                   ),
//                                 );
//                               }
//                             },
//                           );
//                         },
//                       ),

//                       // other users stories
//                       ...userIds.where((id) => id != auth.user?.uid).map((
//                         userId,
//                       ) {
//                         final stories = grouped[userId] ?? [];
//                         if (stories.isEmpty) return const SizedBox.shrink();

//                         final firstStory = stories.first;
//                         final currentUid = auth.user?.uid ?? '';
//                         final hasUnviewed = stories.any(
//                           (s) => !s.viewedBy.contains(currentUid),
//                         );

//                         return StoryView(
//                           profileImageUrl: firstStory.profileImageUrl,
//                           displayName: firstStory.displayName,
//                           stories: stories,
//                           hasUnviewed: hasUnviewed,
//                           onTap: () => Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (_) => StoryViewer(
//                                 stories: stories,
//                                 currentUserId: auth.user!.uid,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),

//           const SliverToBoxAdapter(child: Divider(height: 5)),
//           StreamBuilder<List<PostModel>>(
//             stream: PostService.getAllPosts(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const SliverFillRemaining(
//                   child: Center(child: CircularProgressIndicator()),
//                 );
//               }
//               final posts = snapshot.data!;
//               if (posts.isEmpty) {
//                 return const SliverFillRemaining(
//                   child: Center(child: Text('No posts yet. Be the first!')),
//                 );
//               }
//               return SliverList.separated(
//                 itemCount: posts.length,
//                 separatorBuilder: (_, __) => const Divider(height: 1),
//                 itemBuilder: (context, index) => PostsView(post: posts[index]),
//               );
//             },
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

  static const double _storyBarHeight = 106;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          _AppBarIconButton(icon: Iconsax.notification, onTap: () {}),
          const SizedBox(width: 4),
        ],
      ),
      body: RefreshIndicator(
        color: AppTheme.accent,
        onRefresh: () async {
          // Feed data is stream-driven and already live; this just gives
          // the pull gesture a moment of visual feedback.
          await Future.delayed(const Duration(milliseconds: 400));
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: _storyBarHeight,
                child: StreamBuilder<Map<String, List<StoryModel>>>(
                  stream: StoryService.getStories(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const _StoryBarSkeleton();
                    }

                    final grouped = snapshot.data!;
                    final otherUserIds = grouped.keys
                        .where((id) => id != auth.user?.uid)
                        .toList();

                    return ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      children: [
                        StreamBuilder<bool>(
                          stream: StoryService.hasActiveStory(auth.user!.uid),
                          builder: (context, hasStorySnap) {
                            final hasStory = hasStorySnap.data ?? false;

                            return StoryView(
                              isAddStory: !hasStory,
                              profileImageUrl: auth.profileImageUrl,
                              hasUnviewed: false,
                              onTap: () {
                                if (hasStory) {
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

                        ...otherUserIds.map((userId) {
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
                    );
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: Divider(height: 1)),

            StreamBuilder<List<PostModel>>(
              stream: PostService.getAllPosts(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _FeedMessage(
                      icon: Icons.error_outline,
                      title: 'Something went wrong',
                      subtitle: 'Pull down to try again.',
                    ),
                  );
                }

                if (!snapshot.hasData) {
                  return const _PostsSkeletonList();
                }

                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return const SliverFillRemaining(
                    hasScrollBody: false,
                    child: _FeedMessage(
                      icon: Icons.photo_library_outlined,
                      title: 'No posts yet',
                      subtitle: 'Be the first to share something.',
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.only(top: 4, bottom: 24),
                  sliver: SliverList.separated(
                    itemCount: posts.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 2),
                    itemBuilder: (context, index) =>
                        PostsView(post: posts[index]),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _AppBarIconButton({required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Material(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: context.cs.onSurface),
          ),
        ),
      ),
    );
  }
}

class _StoryBarSkeleton extends StatelessWidget {
  const _StoryBarSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 6,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(right: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.cs.outline.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 8,
              decoration: BoxDecoration(
                color: context.cs.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PostsSkeletonList extends StatelessWidget {
  const _PostsSkeletonList();

  @override
  Widget build(BuildContext context) {
    return SliverList.builder(
      itemCount: 3,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            color: context.cs.outline.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
    );
  }
}

class _FeedMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _FeedMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: context.cs.onSurface.withValues(alpha: 0.25),
            ),
            const SizedBox(height: 16),
            Text(title, style: context.tt.titleMedium),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: context.tt.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
