import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rivals/features/club/my_club.dart';
import 'package:rivals/features/explore/explore.dart';
import 'package:rivals/features/profile/profile.dart';
import 'package:rivals/homepage.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      const Homepage(),
      const MyClub(),
      const Explore(),
      const Profile(),
    ];
    return Scaffold(
      body: pages[currentIndex],
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
          BottomNavigationBarItem(
            icon: Icon(Iconsax.search_favorite1),
            label: 'Explore',
          ),
          BottomNavigationBarItem(icon: Icon(Iconsax.user), label: 'Profile'),
        ],
      ),
    );
  }
}
