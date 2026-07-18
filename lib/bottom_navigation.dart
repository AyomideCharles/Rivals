import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/features/club/views/my_club.dart';
import 'package:rivals/features/clips/clips.dart';
import 'package:rivals/features/post/post.dart';
import 'package:rivals/features/profile/profile.dart';
import 'package:rivals/features/banter/homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;
  late final List<Widget> pages = [
    const Homepage(),
    const MyClub(),
    const Clips(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // body: pages[currentIndex],
      body: IndexedStack(index: currentIndex, children: pages),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (_) => const Post()));
        },
        backgroundColor: AppTheme.accent,
        child: Icon(Iconsax.add, color: Colors.black),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Iconsax.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Iconsax.shield), label: 'My Club'),
          BottomNavigationBarItem(icon: Icon(Iconsax.play), label: 'Clips'),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
