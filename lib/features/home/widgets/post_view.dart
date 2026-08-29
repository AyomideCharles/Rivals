import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/home/widgets/users_profile.dart';
import 'package:rivals/features/post/provider/post_provider.dart';
import 'package:rivals/features/post/views/comments.dart';
import 'package:rivals/shared/app_video_player.dart';

class PostsView extends StatelessWidget {
  final PostModel post;
  const PostsView({super.key, required this.post});

  bool get _isImagePost => post.hasMedia && !post.isVideo;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: _isImagePost
          ? _ImageBackgroundPost(post: post)
          : _StandardPost(post: post),
    );
  }
}

class _Avatar extends StatelessWidget {
  final PostModel post;
  final Color? borderColor;
  const _Avatar({required this.post, this.borderColor});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UsersProfile(
                userId: post.userId,
                displayName: post.displayName,
                clubName: post.clubName,
                clubLeague: post.clubName,
                profileImageUrl: post.profileImageUrl,
              ),
            ),
          );
        },
        child: post.profileImageUrl.isEmpty
            ? Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: borderColor ?? context.cs.outline,
                    width: 1,
                  ),
                  color: context.cs.surface,
                ),
                child: Icon(Iconsax.user, color: context.cs.onSurfaceVariant),
              )
            : Image.network(
                post.profileImageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: borderColor ?? context.cs.outline,
                        width: 1,
                      ),
                      color: context.cs.surface,
                    ),
                    child: Icon(
                      Iconsax.user,
                      color: context.cs.onSurfaceVariant,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class _PostMenu extends StatelessWidget {
  final PostModel post;
  final Color? iconColor;
  const _PostMenu({required this.post, this.iconColor});

  @override
  Widget build(BuildContext context) {
    final postProvider = context.read<PostProvider>();
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.more_vert,
        color: iconColor ?? context.cs.onSurfaceVariant,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        switch (value) {
          case 'report':
            break;
          case 'delete':
            postProvider.deletePost(post.id);
            break;
          case 'copy':
            break;
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'copy',
          child: Row(
            children: [
              Icon(Iconsax.copy, size: 18),
              SizedBox(width: 10),
              Text('Copy text'),
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'report',
          child: Row(
            children: [
              Icon(Iconsax.flag_2, size: 18),
              SizedBox(width: 10),
              Text('Report'),
            ],
          ),
        ),
        if (post.userId == context.read<AuthProvider>().user?.uid)
          PopupMenuItem(
            value: 'delete',
            child: Row(
              children: [
                Icon(Iconsax.trash, size: 18, color: context.cs.error),
                const SizedBox(width: 10),
                Text('Delete', style: TextStyle(color: context.cs.error)),
              ],
            ),
          ),
      ],
    );
  }
}

class _ActionsRow extends StatelessWidget {
  final PostModel post;
  final Color? color;
  const _ActionsRow({required this.post, this.color});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isLiked = post.likedBy.contains(auth.user?.uid);
    final textStyle = context.tt.bodySmall?.copyWith(
      color: color,
      fontWeight: FontWeight.w600,
    );
    final iconColor = color ?? context.cs.onSurfaceVariant;

    return Row(
      children: [
        _ActionTap(
          onTap: () =>
              context.read<PostProvider>().toggleLike(post.id, auth.user!.uid),
          child: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            size: 18,
            color: isLiked ? AppTheme.accent : iconColor,
          ),
        ),
        const SizedBox(width: 6),
        Text('${post.likes}', style: textStyle),
        const SizedBox(width: 20),
        _ActionTap(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => CommentsScreen(post: post)),
            );
          },
          child: Icon(Iconsax.message, size: 18, color: iconColor),
        ),
        const SizedBox(width: 6),
        Text('${post.comments}', style: textStyle),
      ],
    );
  }
}

class _ActionTap extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  const _ActionTap({required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(padding: const EdgeInsets.all(4), child: child),
      ),
    );
  }
}

class _StandardPost extends StatelessWidget {
  final PostModel post;
  const _StandardPost({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.cs.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.cs.outlineVariant, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Avatar(post: post),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '@${post.displayName}',
                            style: context.tt.titleMedium,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            post.clubName,
                            style: context.tt.bodySmall,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    _PostMenu(post: post),
                  ],
                ),
                if (post.content.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(post.content, style: context.tt.bodyLarge),
                ],
                if (post.hasMedia && post.isVideo) ...[
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AppVideoPlayer(url: post.mediaUrl),
                  ),
                ],
                const SizedBox(height: 12),
                _ActionsRow(post: post),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageBackgroundPost extends StatelessWidget {
  final PostModel post;
  const _ImageBackgroundPost({required this.post});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 340,
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              post.mediaUrl,
              fit: BoxFit.cover,
              loadingBuilder: (_, child, progress) => progress == null
                  ? child
                  : Container(
                      color: context.cs.surface,
                      child: const Center(child: CircularProgressIndicator()),
                    ),
              errorBuilder: (_, __, ___) => Container(
                color: context.cs.surface,
                child: Icon(
                  Icons.image_not_supported_outlined,
                  color: context.cs.onSurfaceVariant,
                ),
              ),
            ),

            const DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0x99000000),
                    Colors.transparent,
                    Colors.transparent,
                    Color(0xCC000000),
                  ],
                  stops: [0.0, 0.25, 0.6, 1.0],
                ),
              ),
            ),

            Positioned(
              top: 14,
              left: 14,
              right: 8,
              child: Row(
                children: [
                  _Avatar(post: post, borderColor: Colors.white70),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '@${post.displayName}',
                          style: context.tt.titleMedium?.copyWith(
                            color: Colors.white,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          post.clubName,
                          style: context.tt.bodySmall?.copyWith(
                            color: Colors.white70,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  _PostMenu(post: post, iconColor: Colors.white),
                ],
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (post.content.isNotEmpty) ...[
                    Text(
                      post.content,
                      style: context.tt.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 10),
                  ],
                  _ActionsRow(post: post, color: Colors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
