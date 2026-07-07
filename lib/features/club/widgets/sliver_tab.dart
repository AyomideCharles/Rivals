import 'package:flutter/material.dart';
import 'package:rivals/core/theme/app_theme.dart';

class TabsHeader extends SliverPersistentHeaderDelegate {
  final List<String> tabs;
  final int selected;
  final ValueChanged<int> onTap;
  TabsHeader({required this.tabs, required this.selected, required this.onTap});

  @override
  double get minExtent => 56;
  @override
  double get maxExtent => 56;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      height: 56,
      alignment: Alignment.centerLeft,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        itemCount: tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final on = i == selected;
          return GestureDetector(
            onTap: () => onTap(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: on
                    ? context.cs.surface
                    : context.cs.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(999),
                border: Border.all(
                  color: on ? context.cs.onSurface : context.cs.outline,
                ),
              ),
              child: Text(tabs[i], style: context.tt.titleSmall),
            ),
          );
        },
      ),
    );
  }

  @override
  bool shouldRebuild(covariant TabsHeader old) =>
      old.selected != selected || old.tabs != tabs;
}
