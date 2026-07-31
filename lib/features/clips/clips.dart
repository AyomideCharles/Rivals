import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/clips_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/clips_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/clips/widgets/upload_clips.dart';
import 'package:rivals/main.dart';
import 'package:video_player/video_player.dart';

class Clips extends StatefulWidget {
  const Clips({super.key});

  @override
  State<Clips> createState() => _ClipsState();
}

class _ClipsState extends State<Clips> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ClipModel>>(
      stream: ClipsService.getAllClips(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final clips = snapshot.data!;

        if (clips.isEmpty) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.video,
                    size: 48,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 12),
                  const Text('No clips yet — be the first to upload!'),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const UploadClip()),
                    ),
                    child: const Text('Add new clip'),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: Colors.black,
          body: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: clips.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _ClipPlayer(
              clip: clips[index],
              isActive: index == _currentPage,
            ),
          ),
        );
      },
    );
  }
}

class _ClipPlayer extends StatefulWidget {
  final ClipModel clip;
  final bool isActive;
  const _ClipPlayer({required this.clip, required this.isActive});

  @override
  State<_ClipPlayer> createState() => _ClipPlayerState();
}

class _ClipPlayerState extends State<_ClipPlayer>
    with WidgetsBindingObserver, RouteAware {
  late VideoPlayerController _controller;
  bool _initialized = false;
  bool _viewCounted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller =
        VideoPlayerController.networkUrl(Uri.parse(widget.clip.videoUrl))
          ..addListener(() {
            if (mounted) setState(() {});
          })
          ..initialize().then((_) {
            if (mounted) {
              setState(() => _initialized = true);
              if (widget.isActive) {
                _controller.play();
                _controller.setLooping(true);
                _countView();
              }
            }
          });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didUpdateWidget(covariant _ClipPlayer old) {
    super.didUpdateWidget(old);
    if (widget.isActive != old.isActive) {
      widget.isActive ? _controller.play() : _controller.pause();
      if (widget.isActive) _countView();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller.pause();
    } else if (state == AppLifecycleState.resumed && widget.isActive) {
      _controller.play();
    }
  }

  @override
  void didPushNext() => _controller.pause();

  @override
  void didPopNext() {
    if (widget.isActive) _controller.play();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    WidgetsBinding.instance.removeObserver(this);
    _controller.dispose();
    super.dispose();
  }

  void _countView() {
    if (!_viewCounted) {
      _viewCounted = true;
      ClipsService.incrementViews(widget.clip.id);
    }
  }

  Widget clipIcons(IconData icon, String? label, Color? color) {
    return Column(
      children: [
        ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              alignment: Alignment.center,
              width: 37,
              height: 37,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.15),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(label ?? '', style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLiked = widget.clip.likedBy.contains(auth.user?.uid);

    return GestureDetector(
      onTap: () {
        _controller.value.isPlaying ? _controller.pause() : _controller.play();
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          _initialized
              ? FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                )
              : const ColoredBox(
                  color: Colors.black,
                  child: Center(child: CircularProgressIndicator()),
                ),

          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black54],
              ),
            ),
          ),

          if (_initialized && !_controller.value.isPlaying)
            const Center(
              child: Icon(Icons.play_arrow, color: Colors.white54, size: 72),
            ),

          if (_initialized)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: VideoProgressIndicator(
                _controller,
                allowScrubbing: true,
                colors: const VideoProgressColors(
                  playedColor: Colors.white,
                  bufferedColor: Colors.white30,
                  backgroundColor: Colors.white10,
                ),
              ),
            ),

          Positioned(
            right: 16,
            top: 70,
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const UploadClip()),
              ),
              child: clipIcons(Icons.add, '', Colors.white),
            ),
          ),

          Positioned(
            right: 16,
            bottom: 120,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () =>
                      ClipsService.toggleLike(widget.clip.id, auth.user!.uid),
                  child: clipIcons(
                    isLiked ? Icons.thumb_up_alt : Icons.thumb_up_alt_outlined,
                    '${widget.clip.likes}',
                    isLiked ? AppTheme.accent : Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {},
                  child: clipIcons(
                    Iconsax.message,
                    '${widget.clip.comments}',
                    Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                clipIcons(
                  Icons.remove_red_eye_outlined,
                  '${widget.clip.views}',
                  Colors.white,
                ),
                const SizedBox(height: 24),
                if (widget.clip.userId == auth.user?.uid)
                  GestureDetector(
                    onTap: () => ClipsService.deleteClip(widget.clip.id),
                    child: clipIcons(Icons.delete_outline, '', Colors.white),
                  ),
              ],
            ),
          ),

          Positioned(
            left: 16,
            right: 80,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    widget.clip.profileImageUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              widget.clip.profileImageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => CircleAvatar(
                                radius: 20,
                                child: Text(
                                  widget.clip.displayName.isNotEmpty
                                      ? widget.clip.displayName[0].toUpperCase()
                                      : '?',
                                ),
                              ),
                            ),
                          )
                        : CircleAvatar(
                            radius: 20,
                            child: Text(
                              widget.clip.displayName.isNotEmpty
                                  ? widget.clip.displayName[0].toUpperCase()
                                  : '?',
                            ),
                          ),
                    const SizedBox(width: 10),
                    Text(
                      '@${widget.clip.displayName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
                if (widget.clip.caption.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.clip.caption,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.clip.clubName,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
