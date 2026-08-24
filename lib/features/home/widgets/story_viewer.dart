import 'package:flutter/material.dart';
import 'package:rivals/core/models/story_model.dart';
import 'package:rivals/core/services/story_service.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryModel> stories;
  final String currentUserId;

  const StoryViewer({
    super.key,
    required this.stories,
    required this.currentUserId,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  int _currentIndex = 0;
  bool _loading = true;

  static const _storyDuration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    _progressController =
        AnimationController(vsync: this, duration: _storyDuration)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) _next();
          });
    _startStory();
  }

  void _startStory() {
    _progressController.reset();
    setState(() => _loading = true);
    final story = widget.stories[_currentIndex];
    StoryService.markViewed(story.id, widget.currentUserId);
  }

  void _onImageLoaded() {
    setState(() => _loading = false);
    _progressController.forward();
  }

  void _next() {
    if (_currentIndex < widget.stories.length - 1) {
      setState(() => _currentIndex++);
      _startStory();
    } else {
      Navigator.pop(context);
    }
  }

  void _previous() {
    if (_currentIndex > 0) {
      setState(() => _currentIndex--);
      _startStory();
    }
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final story = widget.stories[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          if (_loading) return;
          final width = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < width / 2) {
            _previous();
          } else {
            _next();
          }
        },
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              story.mediaUrl,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_loading) _onImageLoaded();
                  });
                  return child;
                }
                return child;
              },
              errorBuilder: (_, __, ___) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (_loading) _onImageLoaded();
                });
                return const ColoredBox(
                  color: Colors.black,
                  child: Center(
                    child: Icon(Icons.broken_image, color: Colors.white),
                  ),
                );
              },
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black87, Colors.transparent],
                ),
              ),
            ),

            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),

            SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children: widget.stories.asMap().entries.map((entry) {
                        final index = entry.key;
                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 2),
                            child: AnimatedBuilder(
                              animation: _progressController,
                              builder: (context, _) {
                                double value = 0;
                                if (index < _currentIndex) {
                                  value = 1;
                                } else if (index == _currentIndex) {
                                  value = _progressController.value;
                                }
                                return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.white30,
                                  valueColor: const AlwaysStoppedAnimation(
                                    Colors.white,
                                  ),
                                  minHeight: 3,
                                  borderRadius: BorderRadius.circular(4),
                                );
                              },
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: story.profileImageUrl.isNotEmpty
                              ? Image.network(
                                  story.profileImageUrl,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                )
                              : CircleAvatar(
                                  radius: 18,
                                  child: Text(
                                    story.displayName.isNotEmpty
                                        ? story.displayName[0].toUpperCase()
                                        : '?',
                                  ),
                                ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          story.displayName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        const Spacer(),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            if (story.userId == widget.currentUserId)
              Positioned(
                bottom: 40,
                right: 16,
                child: GestureDetector(
                  onTap: () async {
                    await StoryService.deleteStory(story.id);
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black45,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
