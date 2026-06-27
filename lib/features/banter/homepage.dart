import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
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
          Divider(height: 16),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: context.cs.outline, width: 1),
                    color: context.cs.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  height: 200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
