import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rivals/core/services/post_service.dart';
import 'package:rivals/features/auth/provider/auth_provider.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';

class Post extends StatefulWidget {
  const Post({super.key});

  @override
  State<Post> createState() => _PostState();
}

class _PostState extends State<Post> {
  TextEditingController postController = TextEditingController();

  post() async {
    final auth = context.read<AuthProvider>();

    try {
      SmartDialog.showLoading();
      await PostService.createPost(
        userId: auth.user?.uid ?? '',
        displayName: auth.displayName,
        clubId: auth.clubId,
        clubName: auth.clubName,
        clubColor: auth.clubColor,
        content: postController.text.trim(),
      );
      SmartDialog.dismiss();
      if (mounted) Navigator.pop(context);
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
        title: 'New Post',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: AppButton(
              label: 'Post',
              onPressed: () async {
                await post();
              },
              width: 80,
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(height: 16),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 30),
                    SizedBox(width: 16),
                    Column(children: [Text(auth.displayName)]),
                  ],
                ),
                SizedBox(height: 40),
                TextField(
                  controller: postController,
                  decoration: InputDecoration(
                    hintText: 'What\'s on your mind?',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
