import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/models/story_model.dart';
import 'package:rivals/core/theme/app_theme.dart';

class StoryView extends StatelessWidget {
  final bool isAddStory;
  final VoidCallback? onTap;
  final String? profileImageUrl;
  final String? displayName;
  final List<StoryModel>? stories;
  final bool hasUnviewed;

  const StoryView({
    super.key,
    this.isAddStory = false,
    this.onTap,
    this.profileImageUrl,
    this.displayName,
    this.stories,
    this.hasUnviewed = false,
  });

  static const double _avatarSize = 54;
  static const double _itemWidth = 68;

  bool get _hasImage => profileImageUrl != null && profileImageUrl!.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _itemWidth,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                isAddStory ? _buildAddStory(context) : _buildRing(context),
                const SizedBox(height: 6),
                SizedBox(
                  width: _itemWidth - 4,
                  child: Text(
                    isAddStory ? 'Your story' : (displayName ?? ''),
                    style: context.tt.labelSmall,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAddStory(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        DottedBorder(
          options: CircularDottedBorderOptions(
            color: AppTheme.accent,
            dashPattern: const [8, 5],
            strokeWidth: 1.5,
          ),
          child: SizedBox(
            width: _avatarSize,
            height: _avatarSize,
            child: _hasImage
                ? ClipOval(
                    child: Image.network(profileImageUrl!, fit: BoxFit.cover),
                  )
                : Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: context.cs.surface,
                    ),
                    child: Icon(
                      Iconsax.user,
                      color: context.cs.onSurfaceVariant,
                    ),
                  ),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.accent,
              border: Border.all(color: context.cs.surface, width: 2),
            ),
            child: const Icon(Iconsax.add, size: 12, color: Colors.white),
          ),
        ),
      ],
    );
  }

  Widget _buildRing(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: hasUnviewed
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppTheme.accent, AppTheme.accentDark],
              )
            : null,
        border: !hasUnviewed
            ? Border.all(color: context.cs.outline, width: 2)
            : null,
      ),
      child: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: context.cs.surface,
        ),
        child: ClipOval(
          child: SizedBox(
            width: _avatarSize - 8,
            height: _avatarSize - 8,
            child: _hasImage
                ? Image.network(
                    profileImageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _fallbackAvatar(context),
                  )
                : _fallbackAvatar(context),
          ),
        ),
      ),
    );
  }

  Widget _fallbackAvatar(BuildContext context) {
    final initial = (displayName != null && displayName!.isNotEmpty)
        ? displayName![0].toUpperCase()
        : '?';
    return Container(
      color: AppTheme.accent.withValues(alpha: 0.15),
      alignment: Alignment.center,
      child: Text(
        initial,
        style: context.tt.titleMedium?.copyWith(color: AppTheme.accent),
      ),
    );
  }
}
