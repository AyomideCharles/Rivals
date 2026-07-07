import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/services/follow_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/onboarding.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/features/profile/widgets/clips_tab.dart';
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

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CircleAvatar(radius: 36),
                const SizedBox(height: 12),
                Text(auth.displayName, style: context.tt.titleMedium),
                Text(auth.email, style: context.tt.bodySmall),
                const SizedBox(height: 4),
                Text(
                  '${auth.clubName} · ${auth.clubLeague}',
                  style: context.tt.bodySmall,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StreamBuilder<int>(
                      stream: FollowService.followersCount(auth.user!.uid),
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text('${snapshot.data ?? 0}'),
                            Text('Followers'),
                          ],
                        );
                      },
                    ),
                    SizedBox(width: 20),
                    StreamBuilder<int>(
                      stream: FollowService.followingCount(auth.user!.uid),
                      builder: (context, snapshot) {
                        return Column(
                          children: [
                            Text('${snapshot.data ?? 0}'),
                            Text('Following'),
                          ],
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
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [PostTab(), ClipsTab(), RepliesTab()],
            ),
          ),
        ],
      ),
    );
  }
}
