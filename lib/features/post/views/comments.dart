import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/comments_model.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/post/provider/post_provider.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:iconsax/iconsax.dart';

class CommentsScreen extends StatefulWidget {
  final PostModel post;
  const CommentsScreen({super.key, required this.post});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController commentController = TextEditingController();
  bool _posting = false;

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  // Future<void> _addComment() async {
  //   final auth = context.read<AuthProvider>();
  //   final content = commentController.text.trim();
  //   if (content.isEmpty) return;

  //   setState(() => _posting = true);
  //   try {
  //     await PostService.addComment(
  //       postId: widget.post.id,
  //       userId: auth.user!.uid,
  //       displayName: auth.displayName,
  //       profileImageUrl: auth.profileImageUrl,
  //       clubName: auth.clubName,
  //       content: content,
  //     );
  //     commentController.clear();
  //   } finally {
  //     setState(() => _posting = false);
  //   }
  // }
  Future<void> addComment() async {
    final auth = context.read<AuthProvider>();
    final content = commentController.text.trim();

    if (content.isEmpty) return;
    await context.read<PostProvider>().addComment(
      postId: widget.post.id,
      userId: auth.user!.uid,
      displayName: auth.displayName,
      profileImageUrl: auth.profileImageUrl,
      clubName: auth.clubName,
      content: content,
    );
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Comments'),
      body: Column(
        children: [
          // comments list
          Expanded(
            child: StreamBuilder<List<CommentModel>>(
              stream: PostService.getComments(widget.post.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final comments = snapshot.data!;

                if (comments.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Iconsax.message,
                          size: 48,
                          color: context.cs.onSurface.withOpacity(0.3),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No comments yet — be the first!',
                          style: context.tt.bodyMedium?.copyWith(
                            color: context.cs.onSurface.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: comments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return _CommentTile(
                      comment: comment,
                      postId: widget.post.id,
                      isOwner: comment.userId == auth.user?.uid,
                    );
                  },
                );
              },
            ),
          ),

          // input bar
          const Divider(height: 1),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  // avatar
                  auth.profileImageUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.network(
                            auth.profileImageUrl,
                            width: 36,
                            height: 36,
                            fit: BoxFit.cover,
                          ),
                        )
                      : CircleAvatar(
                          radius: 18,
                          child: Text(
                            auth.displayName.isNotEmpty
                                ? auth.displayName[0].toUpperCase()
                                : '?',
                          ),
                        ),
                  const SizedBox(width: 10),

                  // text field
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Add a comment...',
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        isDense: true,
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => addComment(),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // send button
                  GestureDetector(
                    onTap: _posting ? null : addComment,
                    child: _posting
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Icon(
                            Iconsax.send_1,
                            color: AppTheme.accent,
                            size: 24,
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Comment tile ──────────────────────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  final String postId;
  final bool isOwner;
  const _CommentTile({
    required this.comment,
    required this.postId,
    required this.isOwner,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // avatar
        comment.profileImageUrl.isNotEmpty
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  comment.profileImageUrl,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              )
            : CircleAvatar(
                radius: 18,
                child: Text(
                  comment.displayName.isNotEmpty
                      ? comment.displayName[0].toUpperCase()
                      : '?',
                ),
              ),
        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    '@${comment.displayName}',
                    style: context.tt.labelMedium,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    comment.clubName,
                    style: context.tt.bodySmall?.copyWith(
                      color: context.cs.onSurface.withOpacity(0.5),
                    ),
                  ),
                  const Spacer(),
                  if (isOwner)
                    GestureDetector(
                      onTap: () => PostService.deleteComment(
                        postId: postId,
                        commentId: comment.id,
                      ),
                      child: Icon(
                        Iconsax.trash,
                        size: 14,
                        color: context.cs.onSurface.withOpacity(0.4),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(comment.content, style: context.tt.bodyMedium),
            ],
          ),
        ),
      ],
    );
  }
}
