import 'package:flutter/material.dart';
import 'package:rivals/core/services/follow_service.dart';
import 'package:rivals/core/theme/app_theme.dart';

class FollowButton extends StatelessWidget {
  final String currentUserId;
  final String targetUserId;
  final double? width;
  final double? height;

  const FollowButton({
    super.key,
    required this.currentUserId,
    required this.targetUserId,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    // don't show button on my own profile
    if (currentUserId == targetUserId) return const SizedBox.shrink();

    return StreamBuilder<bool>(
      stream: FollowService.isFollowing(currentUserId, targetUserId),
      builder: (context, snapshot) {
        final isFollowing = snapshot.data ?? false;
        return GestureDetector(
          onTap: () async {
            if (isFollowing) {
              await FollowService.unfollow(currentUserId, targetUserId);
            } else {
              await FollowService.follow(currentUserId, targetUserId);
            }
          },
          child: AnimatedContainer(
            width: double.infinity,
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isFollowing ? Colors.transparent : AppTheme.accent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isFollowing ? context.cs.outline : AppTheme.accent,
              ),
            ),
            child: Text(
              isFollowing ? 'Following' : 'Follow',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isFollowing ? context.cs.onSurface : AppTheme.accentInk,
              ),
            ),
          ),
        );
      },
    );
  }
}
