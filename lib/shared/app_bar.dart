import 'package:flutter/material.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_logo_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final bool showLogo;
  final List<Widget>? actions;
  final VoidCallback? onBackPressed;
  final bool centerTitle;
  final bool backButton;

  const CustomAppBar({
    super.key,
    this.title,
    this.showLogo = false,
    this.actions,
    this.onBackPressed,
    this.centerTitle = false,
    this.backButton = true,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centerTitle,
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      actions: actions,
      title: showLogo
          ? const RivalsLogo()
          : title != null
          ? Text(title!, style: context.tt.titleLarge)
          : null,
      leading: backButton
          ? Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: context.cs.outline, width: 1),
                color: context.cs.surface,
                borderRadius: BorderRadius.circular(4),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.navigate_before, color: context.cs.onSurface),
                onPressed: onBackPressed ?? () => Navigator.pop(context),
              ),
            )
          : null,
    );
  }
}
