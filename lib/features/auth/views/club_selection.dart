import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide AuthProvider;
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rivals/bottom_navigation.dart';
import 'package:rivals/core/models/club_model.dart';
import 'package:rivals/core/services/club_service.dart';
import 'package:rivals/core/theme/app_theme.dart';
import 'package:rivals/shared/app_bar.dart';
import 'package:rivals/shared/app_button.dart';
import 'package:rivals/core/services/auth_service.dart';

class ClubSelection extends StatefulWidget {
  final String title;
  const ClubSelection({super.key, required this.title});

  @override
  State<ClubSelection> createState() => _ClubSelectionState();
}

class _ClubSelectionState extends State<ClubSelection>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  ClubModel? selectedClub;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Animation<double> _fadeAnim(int index) {
    final start = (index * 0.12).clamp(0.0, 0.8);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return CurvedAnimation(
      parent: animationController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slideAnim(int index) {
    final start = (index * 0.12).clamp(0.0, 0.8);
    final end = (start + 0.4).clamp(0.0, 1.0);
    return Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Widget _badgeFallback(ClubModel club) {
    return CircleAvatar(
      radius: 20,
      backgroundColor: club.color.withOpacity(0.15),
      child: Text(
        club.shortName,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: club.color,
        ),
      ),
    );
  }

  Future<void> confirmSelection() async {
    if (selectedClub == null) return;
    try {
      SmartDialog.showLoading(msg: 'Joining your club...');
      final uid = FirebaseAuth.instance.currentUser!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'clubId': selectedClub!.shortName,
        'clubName': selectedClub!.name,
        'clubNickname': selectedClub!.nickname,
        'clubColor':
            '#${selectedClub!.color.value.toRadixString(16).substring(2).toUpperCase()}',
        'clubLeague': widget.title,
      });

      await FirebaseFirestore.instance
          .collection('clubStats')
          .doc(selectedClub!.shortName)
          .set({
            'clubId': selectedClub!.shortName,
            'clubName': selectedClub!.name,
            'members': FieldValue.increment(1),
          }, SetOptions(merge: true));

      if (mounted) await context.read<AuthProvider>().refreshUserData();

      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BottomNav()),
          (route) => false,
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
    return Scaffold(
      appBar: CustomAppBar(title: widget.title.toUpperCase()),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select your club', style: context.tt.labelLarge),
            const SizedBox(height: 20),
            Expanded(
              // 👇 fetch from Firestore
              child: StreamBuilder<List<ClubModel>>(
                stream: ClubService.getClubsByLeague(widget.title),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No clubs found'));
                  }

                  final clubs = snapshot.data!;

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                        ),
                    itemCount: clubs.length,
                    itemBuilder: (context, index) {
                      final club = clubs[index];
                      final isSelected =
                          selectedClub?.shortName == club.shortName;

                      return FadeTransition(
                        opacity: _fadeAnim(index),
                        child: SlideTransition(
                          position: _slideAnim(index),
                          child: GestureDetector(
                            onTap: () => setState(() => selectedClub = club),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 150),
                              decoration: BoxDecoration(
                                color: context.cs.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  width: isSelected ? 2 : 1,
                                  color: isSelected
                                      ? AppTheme.accent
                                      : context.cs.outline,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  club.hasBadge
                                      ? Image.network(
                                          club.badgeUrl,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.contain,
                                          errorBuilder: (_, __, ___) =>
                                              _badgeFallback(club),
                                        )
                                      : _badgeFallback(club),
                                  const SizedBox(height: 6),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                    ),
                                    child: Text(
                                      club.name,
                                      textAlign: TextAlign.center,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: context.tt.labelSmall,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            AppButton(
              label: selectedClub == null
                  ? 'Select a club to continue'
                  : 'Continue with ${selectedClub!.name}',
              onPressed: confirmSelection,
            ),
          ],
        ),
      ),
    );
  }
}
