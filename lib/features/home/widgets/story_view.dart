import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/theme/app_theme.dart';

class StoryView extends StatelessWidget {
  final bool isAddStory;
  final VoidCallback? onTap;
  const StoryView({super.key, this.isAddStory = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 10, 10, 10),
        child: Column(
          children: [
            DottedBorder(
              options: CircularDottedBorderOptions(
                color: AppTheme.accent,
                dashPattern: const [10, 5],
              ),
              child: Center(
                child: SizedBox(
                  width: 50,
                  height: 50,
                  child: Icon(isAddStory ? Iconsax.add : Iconsax.user),
                ),
              ),
            ),
            SizedBox(height: 5),
            Text(
              isAddStory ? 'Add to story' : 'Username',
              style: context.tt.titleSmall,
            ),
          ],
        ),
      ),
    );
  }
}
