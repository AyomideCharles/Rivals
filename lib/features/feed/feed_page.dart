import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/models/story_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/services/story_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/feed/widgets/add_to_story.dart';
import 'package:rivals/features/feed/widgets/post_view.dart';
import 'package:rivals/features/feed/widgets/story_view.dart';
import 'package:rivals/features/feed/widgets/story_viewer.dart';
import 'package:rivals/shared/app_bar.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

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
      body: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        slivers: [
          SliverToBoxAdapter(
            child: StreamBuilder<Map<String, List<StoryModel>>>(
              stream: StoryService.getStories(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const _StoryBarSkeleton();
                }
                final grouped = snapshot.data!;
                final currentUid = auth.user?.uid ?? '';
                final myStories = grouped[currentUid] ?? [];
                final otherUserIds = grouped.keys
                    .where((id) => id != currentUid)
                    .toList();
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                      child: Row(
                        children: [
                          Text(
                            'Stories',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: context.cs.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.4,
                                ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'See all',
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: context.cs.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 96,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        children: [
                          StoryView(
                            isAddStory: myStories.isEmpty,
                            showAddButton: myStories.isNotEmpty,
                            profileImageUrl: auth.profileImageUrl,
                            displayName: auth.displayName,
                            hasUnviewed: false,
                            onAdd: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddToStory(),
                              ),
                            ),
                            onTap: () {
                              if (myStories.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => StoryViewer(
                                      stories: myStories,
                                      currentUserId: currentUid,
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
                          ),
                          ...otherUserIds.map((userId) {
                            final stories = grouped[userId] ?? [];
                            if (stories.isEmpty) {
                              return const SizedBox.shrink();
                            }
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
                    ),
                  ],
                );
              },
            ),
          ),

          const SliverToBoxAdapter(child: Divider(height: 1)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              child: Row(
                children: [
                  Text(
                    'Feed',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: context.cs.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Spacer(),
                  Chip(label: Text('For you')),
                  const SizedBox(width: 8),
                  Chip(label: Text('Following')),
                ],
              ),
            ),
          ),

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

              return SliverList.separated(
                itemCount: posts.length,
                separatorBuilder: (_, __) => Divider(height: 1),
                itemBuilder: (context, index) => PostsView(post: posts[index]),
              );
            },
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
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
    return SizedBox(
      height: 96,
      child: ListView.builder(
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
