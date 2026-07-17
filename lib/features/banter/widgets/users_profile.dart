import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/follow_service.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_follow_button.dart';
import 'package:rivals/shared/app_video_player.dart';

class UsersProfile extends StatefulWidget {
  final String userId;
  final String displayName;
  final String clubName;
  final String clubLeague;
  final String profileImageUrl;
  const UsersProfile({
    super.key,
    required this.userId,
    required this.displayName,
    required this.clubName,
    required this.clubLeague,
    required this.profileImageUrl,
  });

  @override
  State<UsersProfile> createState() => _UsersProfileState();
}

class _UsersProfileState extends State<UsersProfile>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: CustomAppBar(title: '@${widget.displayName}'),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        widget.profileImageUrl.isEmpty
                            ? CircleAvatar(radius: 36)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(40),
                                child: Image.network(
                                  widget.profileImageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              StreamBuilder<int>(
                                stream: FollowService.followersCount(
                                  widget.userId,
                                ),
                                builder: (context, snapshot) => Column(
                                  children: [
                                    Text(
                                      '${snapshot.data ?? 0}',
                                      style: context.tt.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'Followers',
                                      style: context.tt.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                              StreamBuilder<int>(
                                stream: FollowService.followingCount(
                                  widget.userId,
                                ),
                                builder: (context, snapshot) => Column(
                                  children: [
                                    Text(
                                      '${snapshot.data ?? 0}',
                                      style: context.tt.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    Text(
                                      'Following',
                                      style: context.tt.bodySmall,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    FollowButton(
                      currentUserId: auth.user!.uid,
                      targetUserId: widget.userId,
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabHeader(
                TabBar(
                  controller: tabController,
                  indicatorColor: AppTheme.accent,
                  dividerColor: context.cs.outline,
                  labelColor: context.cs.onSurface,
                  unselectedLabelColor: context.cs.onSurface,
                  labelStyle: context.tt.labelMedium,
                  tabs: const [
                    Tab(text: 'Posts'),
                    Tab(text: 'Media'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [
            // Posts
            StreamBuilder<List<PostModel>>(
              stream: PostService.getPostsByUser(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!;
                if (posts.isEmpty) {
                  return const Center(child: Text('No posts yet'));
                }
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (post.content.isNotEmpty)
                            Text(post.content, style: context.tt.bodyMedium),
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
                              Text(
                                '${post.likes}',
                                style: context.tt.bodySmall,
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Iconsax.message,
                                size: 16,
                                color: context.cs.onSurface,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.comments}',
                                style: context.tt.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            // Media
            StreamBuilder<List<PostModel>>(
              stream: PostService.getPostsByUser(widget.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }
                final posts = snapshot.data!.where((p) => p.hasMedia).toList();
                if (posts.isEmpty) {
                  return const Center(child: Text('No media yet'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(4),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                  ),
                  itemCount: posts.length,
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: post.isVideo
                          ? Container(
                              color: Colors.black,
                              child: const Center(
                                child: Icon(
                                  Icons.play_circle_outline,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            )
                          : Image.network(post.mediaUrl, fit: BoxFit.cover),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class TabHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const TabHeader(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: context.bgColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant TabHeader old) => false;
}
