import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/models/post_model.dart';
import 'package:rivals/core/providers/theme_providers.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/auth/widgets/onboarding.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/theme_usage.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
                AppButton(label: 'Log Out', onPressed: signOut),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('Dark mode', style: context.tt.titleMedium),
                  // subtitle: Text(
                  //   context.isDark ? 'Currently dark' : 'Currently light',
                  //   style: context.tt.bodySmall,
                  // ),
                  value: context.watch<ThemeProvider>().isDark,
                  onChanged: (_) => context.read<ThemeProvider>().toggle(),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<List<PostModel>>(
              stream: PostService.getPostsByUser(auth.user!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final posts = snapshot.data!;

                if (posts.isEmpty) {
                  return const Center(child: Text('No posts yet'));
                }

                return ListView.separated(
                  itemCount: posts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final post = posts[index];
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(post.content, style: context.tt.bodyMedium),
                          if (post.hasMedia) ...[
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: post.isVideo
                                  ? _VideoThumbnail(url: post.mediaUrl)
                                  : Image.network(
                                      post.mediaUrl,
                                      width: double.infinity,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ],
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Iconsax.heart,
                                size: 16,
                                color: context.cs.onSurface.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.likes}',
                                style: context.tt.bodySmall,
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Iconsax.message,
                                size: 16,
                                color: context.cs.onSurface.withOpacity(0.4),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${post.comments}',
                                style: context.tt.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final String url;
  const _VideoThumbnail({required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        height: 200,
        width: double.infinity,
        color: Colors.black,
        child: const Center(
          child: Icon(Icons.play_circle_outline, color: Colors.white, size: 56),
        ),
      ),
    );
  }
}
