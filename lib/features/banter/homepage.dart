import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/banter/widgets/users_profile.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:video_player/video_player.dart';

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
                            child: const CircleAvatar(radius: 18),
                          ),
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
                                        ? MediaPlayer(url: post.mediaUrl)
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

class MediaPlayer extends StatefulWidget {
  final String url;
  const MediaPlayer({super.key, required this.url});

  @override
  State<MediaPlayer> createState() => MediaPlayerState();
}

class MediaPlayerState extends State<MediaPlayer> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..initialize().then((_) {
        if (mounted) setState(() => _initialized = true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const SizedBox(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          _controller.value.isPlaying
              ? _controller.pause()
              : _controller.play();
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          AnimatedOpacity(
            opacity: _controller.value.isPlaying ? 0.0 : 1.0,
            duration: const Duration(milliseconds: 200),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Colors.black45,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              colors: VideoProgressColors(
                playedColor: AppTheme.accent,
                bufferedColor: Colors.white30,
                backgroundColor: Colors.black26,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
