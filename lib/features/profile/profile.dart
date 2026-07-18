import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/services/follow_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/core/utils/media_picker.dart';
import 'package:rivals/features/auth/widgets/onboarding.dart';
import 'package:rivals/core/services/auth_service.dart';
import 'package:rivals/features/profile/widgets/clips_tab.dart';
import 'package:rivals/features/profile/widgets/follow_list.dart';
import 'package:rivals/features/profile/widgets/post_tab.dart';
import 'package:rivals/features/profile/widgets/replies_tab.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  late TabController tabController;

  Future<void> signOut() async {
    try {
      SmartDialog.showLoading();
      final auth = context.read<AuthProvider>();
      await auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Onboarding()),
        );
      }
    } catch (e) {
      SmartDialog.showToast(e.toString());
    } finally {
      SmartDialog.dismiss();
    }
  }

  Future<void> updatePhoto() async {
    final result = await MediaPicker.showMediaPicker(context);
    if (result == null || result.file == null || result.isVideo) return;

    try {
      SmartDialog.showLoading(msg: 'Updating photo...');
      await context.read<AuthProvider>().updateProfilePhoto(result.file!);
      SmartDialog.dismiss();
      SmartDialog.showToast('Photo updated!');
    } catch (e) {
      SmartDialog.dismiss();
      SmartDialog.showToast(e.toString());
    }
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (auth.user == null) {
      return const Scaffold(body: SizedBox.shrink());
    }

    return Scaffold(
      appBar: CustomAppBar(
        backButton: false,
        showLogo: true,
        actions: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.notification),
          ),
          SizedBox(width: 15),
          Container(
            margin: EdgeInsets.only(right: 20),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: context.cs.outline, width: 1),
              color: context.cs.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(Iconsax.search_favorite_1),
          ),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: updatePhoto,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 36,
                            backgroundImage: auth.profileImageUrl.isNotEmpty
                                ? NetworkImage(auth.profileImageUrl)
                                : null,
                            child: auth.profileImageUrl.isEmpty
                                ? Text(
                                    auth.displayName.isNotEmpty
                                        ? auth.displayName[0].toUpperCase()
                                        : '?',
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border.all(color: context.cs.outline),
                                color: context.cs.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Iconsax.user_edit4, size: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text('@${auth.displayName}', style: context.tt.titleMedium),
                    Text(auth.email, style: context.tt.bodySmall),
                    const SizedBox(height: 4),
                    Text(
                      '${auth.clubName} · ${auth.clubLeague}',
                      style: context.tt.bodySmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        StreamBuilder<int>(
                          stream: FollowService.followersCount(auth.user!.uid),
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowList(
                                      userId: auth.user!.uid,
                                      type: FollowListType.followers,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Text('${snapshot.data ?? 0}'),
                                  Text('Followers'),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 40),
                        StreamBuilder<int>(
                          stream: FollowService.followingCount(auth.user!.uid),
                          builder: (context, snapshot) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FollowList(
                                      userId: auth.user!.uid,
                                      type: FollowListType.following,
                                    ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Text('${snapshot.data ?? 0}'),
                                  Text('Following'),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    AppButton(label: 'Log Out', onPressed: signOut),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text('Dark mode', style: context.tt.titleMedium),
                      value: context.watch<ThemeProvider>().isDark,
                      onChanged: (_) => context.read<ThemeProvider>().toggle(),
                    ),
                  ],
                ),
              ),
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: TabHeader(
                TabBar(
                  controller: tabController,
                  indicatorColor: AppTheme.accent,
                  labelColor: context.cs.onSurface,
                  unselectedLabelColor: context.cs.onSurface,
                  dividerColor: context.cs.outline,
                  labelStyle: context.tt.labelMedium,
                  tabs: const [
                    Tab(text: 'Post'),
                    Tab(text: 'Clips'),
                    Tab(text: 'Replies'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: tabController,
          children: [PostTab(), ClipsTab(), RepliesTab()],
        ),
      ),
    );
  }
}

class TabHeader extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const TabHeader(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(color: context.bgColor, child: tabBar);
  }

  @override
  bool shouldRebuild(covariant TabHeader old) => false;
}
