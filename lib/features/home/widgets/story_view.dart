

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 4, 10),
        child: Column(
          children: [
            isAddStory
                ? DottedBorder(
                    options: CircularDottedBorderOptions(
                      color: AppTheme.accent,
                      dashPattern: const [10, 5],
                    ),
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child:
                          profileImageUrl != null && profileImageUrl!.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                profileImageUrl!,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(Iconsax.add),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: hasUnviewed
                          ? LinearGradient(
                              colors: [
                                AppTheme.accent,
                                AppTheme.accent.withValues(alpha: 0.5),
                              ],
                            )
                          : null,
                      border: !hasUnviewed
                          ? Border.all(
                              color: Colors.grey.withValues(alpha: 0.4),
                              width: 2,
                            )
                          : null,
                    ),
                    child: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:
                            profileImageUrl != null &&
                                profileImageUrl!.isNotEmpty
                            ? Image.network(profileImageUrl!, fit: BoxFit.cover)
                            : Container(
                                color: Colors.grey.shade300,
                                child: const Icon(Iconsax.user),
                              ),
                      ),
                    ),
                  ),
            const SizedBox(height: 5),
            Text(
              isAddStory ? 'Your story' : (displayName ?? 'Unknown'),
              style: context.tt.labelSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
